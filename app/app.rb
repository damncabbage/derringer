class Derringer < Padrino::Application
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register CompassInitializer

  enable :sessions

  # Application configuration options
  set :raise_errors, true       # Raise exceptions (will stop application) (default for test)

  configure :development do
    # Logging in STDOUT for development and file for production (default only for development)
    set :logging, true
    disable :asset_stamp # no asset timestamping for dev
  end

  configure :production do
    set :logging, true
  end

  # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
  # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
  # set :public_folder, "foo/bar" # Location for static assets (default root/public)
  # set :reload, false            # Reload application files (default in development)
  # set :default_builder, "foo"   # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"       # Set path for I18n translations (default your_app/locales)
  # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
  # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)

  # error 404 do
  #   render 'errors/404'
  # end
  # error 505 do
  #   render 'errors/505'
  # end

end
