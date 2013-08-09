require 'fileutils'

namespace :smashcon do
  namespace :db do

    desc "Imports a Chiki database dump. Relies on the DB user having CREATE/DROP permissions for everything in the database indicated by the [tmp_db] argument."
    task :import_chiki_dump, [:dump_file, :tmp_db] => :environment do |t, args|
      dump_file = args[:dump_file]
      raise "dump_file is required." unless dump_file.present?

      tmp_db = args[:tmp_db] || 'chiki'

      derringer_conf = Order.configurations[Rails.env].with_indifferent_access
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
    task :convert_from_chiki, [:tmp_db] => :environment do |t, args|
      tmp_db = args[:tmp_db] || 'chiki'
      Import::Chiki.new(Order.connection, tmp_db).import!
    end

  end
end
