require 'fileutils'

namespace :smashcon do
  namespace :db do

    desc "Grab a Chiki database dump from a remote server, and import it. Relies on the DB user having CREATE/DROP permissions for everything in the database indicated by the [tmp_db] argument."
    task :grab_dump_from_source, [:remote_user, :tmp_db] => :environment do |t, args|
      remote_user = args[:remote_user] || `whoami`
      tmp_db   = args[:tmp_db] || 'chiki'
      tmp_file = "/tmp/chiki_latest.sql"

      puts `scp #{remote_user}@smash.org.au:chiki_latest.sql #{tmp_file}`
      raise "Could not retrieve dump from server." unless File.exist?(tmp_file)

      derringer_conf = Order.configurations[PADRINO_ENV.to_sym]
      chiki_conf = derringer_conf.clone
      chiki_conf[:database] = tmp_db

      #Order.connection.execute("DROP DATABASE IF EXISTS #{tmp_db}")
      #Order.connection.execute("CREATE DATABASE #{tmp_db}")

      ActiveRecord::Base.establish_connection(chiki_conf)
      connection = ActiveRecord::Base.connection
      connection.execute('SET foreign_key_checks = 0')
      %w(chiki_order chiki_ticket chiki_ticket_type).each do |table|
        connection.execute("DROP TABLE IF EXISTS `#{table}`")
      end
      # HACKITY HACK: MySQL doesn't give you any way of mass-importing
      # SQL scripts; the SOURCE command only works form the `mysql` console.
      # Yes, we're not escaping anything. This is terrible. (And also what
      # Rails::DBConsole.start does, surprisingly enough.)
      puts `mysql -u #{chiki_conf[:username]} --password="#{chiki_conf[:password]}" #{tmp_db} < #{tmp_file}`
      connection.execute('SET foreign_key_checks = 1')

      # Clean up.
      Order.establish_connection(derringer_conf)
      FileUtils.rm tmp_file
    end

    desc "Takes a Chiki database and imports it into the current Derringer database."
    task :convert_from_chiki, [:tmp_db] do |t, args|
      tmp_db = args[:tmp_db] || 'chiki'
      Import::Chiki.new(Order.connection, tmp_db).import!
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
