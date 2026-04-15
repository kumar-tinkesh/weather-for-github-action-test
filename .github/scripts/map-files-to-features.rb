#!/usr/bin/env ruby
# frozen_string_literal: true

# Maps changed file paths to affected feature doc slugs.
#
# Resolution order:
#   1. Explicit pattern match from catalog.md YAML mapping
#   2. Rails convention fallbacks:
#      a. Sibling directory — file is in a subdirectory that's already mapped
#      b. Resource cross-reference — extract the resource name from the file
#         and check if a related controller/model/view/service is mapped
#      c. Namespace inference — for namespaced files (e.g. app/services/foo/bar.rb),
#         check if the namespace directory itself is mapped
#
# Usage:
#   ruby map-files-to-features.rb <file1> <file2> ...
#   echo "app/models/product.rb" | ruby map-files-to-features.rb --stdin
#
# Output modes:
#   (default)  newline-separated list of affected feature slugs
#   --json     JSON with affected features, unmapped files, and new feature suggestions
#
# Output: newline-separated list of affected feature slugs (default)
#         or JSON object (with --json flag)

require "set"
require "json"

CATALOG_PATH = File.expand_path("../../docs/features/catalog.md", __dir__)

# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

def parse_catalog_mappings(catalog_path)
  content = File.read(catalog_path)

  yaml_block = content[/```yaml\n(.+?)```/m, 1]
  abort "ERROR: Could not find YAML mapping block in #{catalog_path}" unless yaml_block

  mappings = {} # { "feature-slug" => ["path/pattern", ...] }
  current_feature = nil

  yaml_block.each_line do |line|
    line = line.rstrip
    next if line.empty?
    next if line.match?(/^\s*#/) # skip comment-only lines

    if line.match?(/^\S.*:$/)
      current_feature = line.chomp(":")
      mappings[current_feature] = []
    elsif current_feature && line.match?(/^\s+-\s+/)
      path = line.sub(/^\s+-\s+/, "").sub(/\s*#.*$/, "").strip
      mappings[current_feature] << path
    end
  end

  mappings
end

# ---------------------------------------------------------------------------
# Pattern matching (explicit)
# ---------------------------------------------------------------------------

def file_matches_pattern?(file, pattern)
  return true if file == pattern
  return true if pattern.end_with?("/") && file.start_with?(pattern)
  return true if pattern.include?("*") && File.fnmatch(pattern, file, File::FNM_PATHNAME)

  false
end

def explicit_match(file, mappings)
  matched = Set.new
  mappings.each do |feature, patterns|
    patterns.each do |pattern|
      if file_matches_pattern?(file, pattern)
        matched << feature
        break
      end
    end
  end
  matched
end

# ---------------------------------------------------------------------------
# Rails convention helpers
# ---------------------------------------------------------------------------

# Extract a "resource name" from a Rails file path.
# Examples:
#   app/controllers/products_controller.rb        → "products"
#   app/controllers/pos/products_controller.rb     → "products"
#   app/models/product.rb                          → "product"
#   app/models/concerns/product_searchable.rb      → "product"
#   app/services/stripe_payment_handler.rb         → "stripe_payment_handler"
#   app/services/sales_orders/voider.rb            → "sales_orders"
#   app/views/products/index.html.erb              → "products"
#   lib/workers/shopify/sync_products_worker.rb    → "shopify"
#   app/graphql/mutations/product_create.rb        → "product"
#   app/graphql/types/product_type.rb              → "product"
def extract_resource_names(file)
  resources = Set.new

  case file
  when %r{^app/controllers/(.+/)?(.+)_controller\.rb$}
    resources << $2  # "products", "sales_orders", etc.
  when %r{^app/models/concerns/(.+?)_\w+\.rb$}
    resources << $1  # "product" from "product_searchable"
  when %r{^app/models/(.+)\.rb$}
    resources << $1.split("/").last  # "product"
  when %r{^app/services/([^/]+)/}
    resources << $1  # "sales_orders" from "app/services/sales_orders/voider.rb"
  when %r{^app/services/(.+?)\.rb$}
    # "stripe_payment_handler" — also extract prefix: "stripe"
    name = $1
    resources << name
    resources << name.split("_").first if name.include?("_")
  when %r{^app/views/(.+?)/}
    resources << $1.split("/").last  # "products"
  when %r{^lib/workers/([^/]+)/}
    resources << $1  # "shopify" from "lib/workers/shopify/sync.rb"
  when %r{^lib/workers/(.+?)_worker\.rb$}
    resources << $1.split("/").last
  when %r{^app/graphql/mutations/(.+?)_\w+\.rb$}
    resources << $1  # "product" from "product_create.rb"
  when %r{^app/graphql/types/(.+?)_type\.rb$}
    resources << $1  # "product" from "product_type.rb"
  when %r{^app/graphql/(\w+_mutations)/}
    resources << $1  # "storefront_mutations"
  when %r{^app/policies/(.+?)_policy\.rb$}
    resources << $1.split("/").last
  when %r{^app/searches/(.+?)_search\.rb$}
    resources << $1.split("/").last
  when %r{^app/channels/(.+?)_channel\.rb$}
    resources << $1
  when %r{^app/components/(.+?)/}
    resources << $1.split("/").last
  end

  resources
end

# Given a resource name, generate related CONCRETE paths that might appear
# in the catalog mapping (controller ↔ model ↔ view ↔ service).
# These must be real-looking paths (no globs) to avoid pattern-vs-pattern matching.
def related_paths_for_resource(resource)
  singular = resource.chomp("s")                    # "products" → "product"
  plural = resource.end_with?("s") ? resource : "#{resource}s"  # "product" → "products"

  paths = []

  # Controllers
  paths << "app/controllers/#{plural}_controller.rb"
  paths << "app/controllers/#{singular}_controller.rb"

  # Models
  paths << "app/models/#{singular}.rb"
  paths << "app/models/#{plural}.rb"

  # Views (directory — will match directory patterns in catalog)
  paths << "app/views/#{plural}/index.html.erb"
  paths << "app/views/#{singular}/index.html.erb"

  # Services (file inside subdirectory — will match directory patterns)
  paths << "app/services/#{plural}/placeholder.rb"
  paths << "app/services/#{singular}/placeholder.rb"

  # Services (direct file — will match prefix globs like "app/services/stripe_*")
  paths << "app/services/#{resource}_placeholder.rb"
  paths << "app/services/#{singular}_placeholder.rb"

  # Workers
  paths << "lib/workers/#{plural}/placeholder.rb"
  paths << "lib/workers/#{singular}/placeholder.rb"

  paths.uniq
end

# ---------------------------------------------------------------------------
# Fallback strategies
# ---------------------------------------------------------------------------

# Strategy 1: Sibling directory match
# If the file is inside a subdirectory, check if any parent directory path
# (at any level) is mapped to a feature.
# e.g., "app/services/shopify/deep/new_file.rb" matches "app/services/shopify/"
def sibling_directory_match(file, mappings)
  matched = Set.new
  parts = file.split("/")

  # Build parent directory paths from most specific to least
  # e.g., ["app/services/shopify/deep/", "app/services/shopify/", "app/services/", "app/"]
  (parts.length - 1).downto(1).each do |i|
    dir = parts[0...i].join("/") + "/"
    mappings.each do |feature, patterns|
      patterns.each do |pattern|
        if pattern == dir || (pattern.end_with?("/") && dir.start_with?(pattern))
          matched << feature
        end
      end
    end
    break unless matched.empty?  # stop at the most specific match
  end

  matched
end

# Strategy 2: Resource cross-reference
# Extract the resource name from the file and look for related paths in mappings.
def resource_cross_reference(file, mappings)
  matched = Set.new
  resources = extract_resource_names(file)

  resources.each do |resource|
    related = related_paths_for_resource(resource)

    mappings.each do |feature, patterns|
      patterns.each do |catalog_pattern|
        # Check if any of the generated concrete paths match this catalog pattern
        related.each do |concrete_path|
          if file_matches_pattern?(concrete_path, catalog_pattern)
            matched << feature
            break
          end
        end
      end
    end
  end

  matched
end

# Strategy 3: Convention-based directory inference
# For common Rails directories, infer that any file belongs to certain features
# based on naming patterns even without explicit mapping.
# e.g., app/models/concerns/stripe_*.rb → payment-processing (via "stripe" prefix)
def convention_inference(file, mappings)
  matched = Set.new

  case file
  when %r{^app/models/concerns/(.+?)[_/]}
    # Model concerns — try matching the prefix to find related feature
    prefix = $1
    mappings.each do |feature, patterns|
      patterns.each do |pattern|
        if pattern.include?(prefix)
          matched << feature
          break
        end
      end
    end
  when %r{^app/controllers/concerns/(.+?)[_/]}
    prefix = $1
    mappings.each do |feature, patterns|
      patterns.each do |pattern|
        if pattern.include?(prefix)
          matched << feature
          break
        end
      end
    end
  when %r{^app/javascript/controllers/(.+?)_controller\.js$}
    # Stimulus controllers — match by name
    name = $1
    mappings.each do |feature, patterns|
      patterns.each do |pattern|
        if pattern.include?(name)
          matched << feature
          break
        end
      end
    end
  when %r{^config/initializers/(.+?)\.rb$}
    # Initializers — match by name
    name = $1
    mappings.each do |feature, patterns|
      patterns.each do |pattern|
        if pattern.include?("config/initializers/#{name}")
          matched << feature
          break
        end
      end
    end
  end

  matched
end

# ---------------------------------------------------------------------------
# Main resolution
# ---------------------------------------------------------------------------

# Directories we skip entirely (not feature-relevant)
SKIP_PATTERNS = %r{^(
  \.github/|
  docs/|
  spec/|
  test/|
  vendor/|
  node_modules/|
  public/|
  tmp/|
  log/|
  \.
)}x

def find_affected_features(changed_files, mappings)
  affected = Set.new
  unmatched = []

  # Pass 1: Explicit pattern matching
  changed_files.each do |file|
    next if file.match?(SKIP_PATTERNS)

    matches = explicit_match(file, mappings)
    if matches.empty?
      unmatched << file
    else
      affected.merge(matches)
    end
  end

  # Pass 2: Fallbacks for unmatched files
  still_unmatched = []
  unmatched.each do |file|
    matches = sibling_directory_match(file, mappings)

    if matches.empty?
      matches = resource_cross_reference(file, mappings)
    end

    if matches.empty?
      matches = convention_inference(file, mappings)
    end

    if matches.empty?
      still_unmatched << file
    else
      affected.merge(matches)
    end
  end

  # Log unmatched files for visibility in CI
  if still_unmatched.any?
    warn "Files not mapped to any feature doc (#{still_unmatched.size}):"
    still_unmatched.each { |f| warn "  #{f}" }
  end

  { affected: affected.to_a.sort, unmapped: still_unmatched }
end

# ---------------------------------------------------------------------------
# New feature detection
# ---------------------------------------------------------------------------

# Groups unmapped files into potential new features by detecting clusters of
# related files (controllers + models + services + views sharing a resource name).
#
# A group qualifies as a "potential new feature" when it has files in 2+ Rails
# layers (controller, model, service, view, worker, policy).
def detect_new_features(unmapped_files)
  # Group files by their likely resource name
  resource_files = Hash.new { |h, k| h[k] = { files: [], layers: Set.new } }

  unmapped_files.each do |file|
    resource = nil
    layer = nil

    case file
    when %r{^app/controllers/(.+/)?(.+)_controller\.rb$}
      resource = $2
      layer = :controller
    when %r{^app/models/concerns/}
      next # skip concerns — they extend existing models
    when %r{^app/models/(.+)\.rb$}
      resource = $1.split("/").last
      layer = :model
    when %r{^app/services/([^/]+)/}
      resource = $1
      layer = :service
    when %r{^app/services/(.+?)\.rb$}
      resource = $1.split("_").first
      layer = :service
    when %r{^app/views/(.+?)/}
      resource = $1.split("/").last
      layer = :view
    when %r{^lib/workers/([^/]+)/}
      resource = $1
      layer = :worker
    when %r{^app/policies/(.+?)_policy\.rb$}
      resource = $1.split("/").last
      layer = :policy
    when %r{^app/graphql/mutations/(.+?)_\w+\.rb$}
      resource = $1
      layer = :graphql
    when %r{^app/graphql/types/(.+?)_type\.rb$}
      resource = $1
      layer = :graphql
    end

    next unless resource && layer

    resource_files[resource][:files] << file
    resource_files[resource][:layers] << layer
  end

  # A potential new feature needs files in at least 2 different layers.
  # Single-layer files (e.g., just a model) are more likely additions to
  # existing features that just need their catalog mapping updated.
  suggestions = []

  resource_files.each do |resource, data|
    if data[:layers].size >= 2
      suggestions << {
        suggested_slug: resource.tr("_", "-"),
        resource: resource,
        layers: data[:layers].to_a.map(&:to_s).sort,
        files: data[:files].sort
      }
    end
  end

  # Also detect new controller namespaces — a new namespace directory with
  # multiple controllers is a strong signal of a new feature area
  namespace_controllers = Hash.new { |h, k| h[k] = [] }
  unmapped_files.each do |file|
    if file.match?(%r{^app/controllers/([^/]+)/}) && !file.match?(%r{^app/controllers/(concerns|pos|account_settings|location_settings|purchase_orders|customers)/})
      namespace = file[%r{^app/controllers/([^/]+)/}, 1]
      namespace_controllers[namespace] << file
    end
  end

  namespace_controllers.each do |namespace, files|
    next if files.size < 2 # single controller in a namespace is not a feature
    next if suggestions.any? { |s| s[:resource] == namespace }

    suggestions << {
      suggested_slug: namespace.tr("_", "-"),
      resource: namespace,
      layers: ["controller"],
      files: files.sort,
      note: "New controller namespace with #{files.size} controllers"
    }
  end

  suggestions.sort_by { |s| -s[:files].size }
end

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

json_mode = ARGV.delete("--json")
stdin_mode = ARGV.delete("--stdin")

mappings = parse_catalog_mappings(CATALOG_PATH)

changed_files = if stdin_mode
  $stdin.read.split("\n").map(&:strip).reject(&:empty?)
else
  ARGV.map(&:strip).reject(&:empty?)
end

if changed_files.empty?
  warn "No changed files provided."
  if json_mode
    puts JSON.generate({ affected_features: [], unmapped_files: [], new_feature_suggestions: [] })
  end
  exit 0
end

result = find_affected_features(changed_files, mappings)

if json_mode
  suggestions = detect_new_features(result[:unmapped])
  output = {
    affected_features: result[:affected],
    unmapped_files: result[:unmapped],
    new_feature_suggestions: suggestions
  }
  puts JSON.pretty_generate(output)
else
  if result[:affected].empty?
    warn "No feature docs affected by the changed files."
    exit 0
  end
  puts result[:affected].join("\n")
end
