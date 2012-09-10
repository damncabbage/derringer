require 'fileutils'

namespace :smashcon do
  namespace :db do

    desc "Grab a Chiki database dump from a remote server."
    task :grab_chiki_dump, [:remote_path, :remote_user, :remote_host, :dump_path] => :environment do |t, args|
      remote_path = args[:remote_path]
      raise "remote_path is required." unless remote_path.present?

      remote_user = args[:remote_user] || `whoami`
      remote_host = args[:remote_host] || "smash.org.au"
      dump_file    = args[:dump_file] || ('/tmp/' + File.basename(remote_path))

      puts `scp "#{remote_user}@#{remote_host}:#{remote_path}" #{dump_file}`
      raise "Could not retrieve dump from server." unless File.exist?(dump_file)
    end


    desc "Imports a Chiki database dump. Relies on the DB user having CREATE/DROP permissions for everything in the database indicated by the [tmp_db] argument."
    task :import_chiki_dump, [:dump_file, :tmp_db] do |t, args|
      dump_file = args[:dump_file]
      raise "dump_file is required." unless dump_file.present?

      tmp_db = args[:tmp_db] || 'chiki'

      derringer_conf = Order.configurations[PADRINO_ENV.to_sym]
      chiki_conf = derringer_conf.clone
      chiki_conf[:database] = tmp_db

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
      puts `mysql -u #{chiki_conf[:username]} --password="#{chiki_conf[:password]}" #{tmp_db} < #{dump_file}`
      connection.execute('SET foreign_key_checks = 1')

      # Clean up.
      Order.establish_connection(derringer_conf)
    end


    desc "Takes a Chiki database and imports it into the current Derringer database."
    task :convert_from_chiki, [:tmp_db] do |t, args|
      tmp_db = args[:tmp_db] || 'chiki'
      Import::Chiki.new(Order.connection, tmp_db).import!
    end

  end
end
