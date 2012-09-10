
# Initial production setup; grabs the codebase, installs
# ruby, CouchDB, MySQL and nginx, and creates the configuration
# to serve the site.
#
# Note: This should be followed by `padrino rake dev:setup` to
#       get Derringer's own configuration set up.
#
# TODO: CouchDB, MySQL and nginx.

dep 'production.prepare' do
  username = `whoami`
  derringer_path = '~#{username}/derringer'
  requires 'production.derringer.src'.with(username, derringer_path)
end

dep 'production.tools', :username, :derringer_path do
  requires 'benhoskings:git.managed',
           'benhoskings:1.9.2.rvm',
           'benhoskings:bundler.gem'

           # TODO: Sane deps for setting up the couchdb
           #'dgoodlad:couchdb',
           #'benhoskings:mysql.managed',
           #'benhoskings:vhost configured.nginx'.with('unicorn', 'localhost', derringer_path)
end

# TODO: Switch over to capistrano instead.
dep 'production.derringer.src', :username, :derringer_path do
  requires 'production.tools'.with(username, derringer_path)
  meet do
    if File.exist?("#{derringer_path}/.git")
      cd derringer_path do
        shell("git checkout master && git reset --hard && git pull")
      end
    else
      shell("git clone git@github.com:smashcon/derringer.git #{derringer_path}")
    end
  end
end
