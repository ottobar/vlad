require 'vlad'

# :app should define vlad:start_app, vlad:stop_app, vlad:start_app:first_time tasks
namespace :vlad do
  set :application, 'application'
  set :app_env, 'production'
  
  remote_task :stop_app, :roles => :app do
    run "sudo /usr/bin/god stop #{application}"
  end
  remote_task :start_app, :roles => :app do
    run "sudo /usr/bin/god restart #{application}"
  end

  namespace :start_app do
    desc "start the applicaiton for the first time"
    remote_task :first_time, :role => :app do
      run "sudo /usr/bin/god start #{application} -c #{current_path}/config/#{app_env}.god"
    end
  end

end