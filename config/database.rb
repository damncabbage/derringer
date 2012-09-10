# We're going a little off the Padrino beaten path here; we
# have two different types of models, and Padrino doesn't
# seem to like using .yml configs by default; pull them
# in manually instead.

# ActiveRecord
ActiveRecord::Base.logger = logger
ActiveRecord::Base.mass_assignment_sanitizer = :strict
ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5
ActiveRecord::Base.include_root_in_json = false
ActiveRecord::Base.store_full_sti_class = true
ActiveRecord::Base.schema_format = :sql # Dump to .sql for search index support
ActiveSupport.use_standard_json_time_format = true
ActiveSupport.escape_html_entities_in_json = false

ar_config = YAML.load_file(Padrino.root('config','database.yml')).with_indifferent_access
ActiveRecord::Base.configurations = ar_config
ActiveRecord::Base.establish_connection(ar_config[Padrino.env])


# CouchREST
couch_config = YAML.load_file(Padrino.root('config','couch.yml')).with_indifferent_access
CouchRest::Model::Base.configure do |conf|
  conf.model_type_key = 'type' # compatibility with CouchModel 1.1
  conf.environment = Padrino.env
  conf.connection = couch_config[Padrino.env]
end
