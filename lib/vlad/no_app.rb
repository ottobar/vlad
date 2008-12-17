require 'vlad'

# :app should define vlad:start_app, vlad:stop_app, vlad:start_app:first_time tasks
namespace :vlad do
  set :app_env, 'production'

  desc "Restart the application servers"
  remote_task :start_app, :roles => [:app] do
    run "echo 'Nothing to do to restart the application server'"
  end

  desc "Stop the application servers"
  remote_task :stop_app, :roles => [:app] do
    run "echo 'Nothing to do to stop the application server'"
  end

  namespace :start_app do
    desc "Start the applicaiton servers for the first time"
    remote_task :first_time, :role => [:app] do
      run "echo 'Nothing to do to start the application server for the first time'"
    end
  end
  
end
