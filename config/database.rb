##### ActiveRecord #####

##
# You can use other adapters like:
#
#   ActiveRecord::Base.configurations[:development] = {
#     :adapter   => 'mysql',
#     :encoding  => 'utf8',
#     :reconnect => true,
#     :database  => 'your_database',
#     :pool      => 5,
#     :username  => 'root',
#     :password  => '',
#     :host      => 'localhost',
#     :socket    => '/tmp/mysql.sock'
#   }
#

mysql_base = {
  :adapter => 'mysql2',
  :encoding  => 'utf8',
  :reconnect => true,
  :pool      => 5,
  :username  => 'smashcon',
  :host      => 'localhost'
}

ActiveRecord::Base.configurations[:development] = mysql_base.merge({
  :database => 'derringer_development',
  :password  => 'smashcon',
})

ActiveRecord::Base.configurations[:production] = mysql_base.merge({
  :database => 'derringer',
  :password  => ENV['MYSQL_PASSWORD'],
})

ActiveRecord::Base.configurations[:test] = mysql_base.merge({
  :database => 'derringer_test',
  :password  => 'smashcon',
})

# Setup our logger
ActiveRecord::Base.logger = logger

# Raise exception on mass assignment protection for Active Record models
ActiveRecord::Base.mass_assignment_sanitizer = :strict

# Log the query plan for queries taking more than this (works
# with SQLite, MySQL, and PostgreSQL)
ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper.
# if you're including raw json in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Now we can estabilish connection with our db
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])


##### CouchREST #####
db_config = case Padrino.env
            when :development
              {
                :name => 'scans_development',
                :username => 'smashcon',
                :password => 'smashcon'
              }
            when :test
              {
                :name => 'scans_test',
                :username => 'smashcon',
                :password => 'smashcon'
              }
            when :production
              {
                :name => 'scans',
                :username => 'smashcon',
                :password => ENV['COUCHDB_PASSWORD']
              }
            end

CouchRest::Model::Base.configure do |conf|
  conf.model_type_key = 'type' # compatibility with CouchModel 1.1
  conf.database = CouchRest.database!(db_config[:name])
  conf.environment = Padrino.env
  conf.connection = {
    :protocol => 'http',
    :host     => 'localhost',
    :port     => '5984',
    :prefix   => nil, #'padrino',
    :suffix   => nil,
    :join     => '_',
    :username => db_config[:username],
    :password => db_config[:password]
  }
end
