
dep 'import', :remote_user, :remote_host, :remote_path, :dump_file, :temp_db do
  dump_file.default('/tmp/chiki_latest.sql')
  temp_db.default('chiki')

  requires 'import.chiki.grab_dump'.with(remote_user, remote_host, remote_path, dump_file),
           'import.chiki.import_dump'.with(dump_file, temp_db),
           'import.chiki.convert_to_derringer'.with(temp_db)
end

dep 'import.chiki.grab_dump', :remote_user, :remote_host, :remote_path, :dump_file do
  shell "bundle exec padrino rake smashcon:db:grab_chiki_dump[#{remote_path},#{remote_user},#{remote_host},#{dump_file}] --trace"
end

dep 'import.chiki.import_dump', :dump_file, :to_db_name do
  shell "bundle exec padrino rake smashcon:db:import_chiki_dump[#{dump_file},#{to_db_name}] --trace"
end

dep 'import.chiki.convert_to_derringer', :from_db_name do
  shell "bundle exec padrino rake smashcon:db:convert_from_chiki[#{from_db_name}] --trace"
end
