
namespace :smashcon do
  namespace :db do

    task :grab_dump_from_source => :environment do

    end

    desc "Take a Chiki database dump, imports it, and converts it to a format Derringer can understand. Relies on the DB user having CREATE permissions."
    task :convert_from_chiki, [:sql_dump_path] do |t, args|
      raise "Must provide SQL Dump Path as an argument, eg. rake smashcon:db:convert_from_chiki[/tmp/foo/bar.sql]"
      source_db = 'chiki'
      Import::Chiki.new(Order.connection, source_db).import!
    end

#    task :import_sql, [:sql_path,:target_db] => :environment do |t, args|
#      
#    end
#
#    task :convert_from_chiki_db => :import_sql do |t, args|
#
#    end

  end
end
