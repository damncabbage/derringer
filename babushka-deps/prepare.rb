
dep 'prepare' do
  username = `whoami`
  derringer_path = '~#{username}/derringer'
  requires 'derringer.src'.with(username, derringer_path)
end


dep 'tools', :username, :derringer_path do
  requires 'benhoskings:git.managed',
           'benhoskings:coffeescript.src',
           'benhoskings:1.9.2.rvm',
           'dgoodlad:couchdb',
           'benhoskings:mysql.managed',
           'benhoskings:bundler.gem',
           'benhoskings:vhost configured.nginx'.with('unicorn', 'localhost', derringer_path)
end

dep 'derringer.src', :username, :derringer_path do
  requires 'tools'.with(username, derringer_path)
  meet do
    if File.exist?("#{derringer_path}/.git")
      cd derringer_pather do
        shell("git reset --hard && git pull")
      end
    else
      shell("git clone git@github.com:smashcon/derringer.git #{derringer_path}")
    end
  end
end
