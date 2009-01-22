require 'vlad'

# :app should define vlad:start_app, vlad:stop_app, vlad:start_app:first_time tasks
namespace :vlad do
  set :app_env,            'production'
  set :merb_address,       "127.0.0.1"
  set :merb_adapter,       'thin'
  set :merb_command,       './bin/merb'
  set :merb_port,          4000
  set :merb_servers,       1

  def merb(cmd = '')
    "cd #{current_path} && #{merb_command} -a #{merb_adapter} -p #{merb_port} -c #{merb_servers} -e #{merb_environment} #{cmd}"
  end

  desc "Restart the application servers"
  remote_task :start_app, :roles => [:app] do
    run merb
  end

  desc "Stop the application servers"
  remote_task :stop_app, :roles => [:app] do
   run merb("-K all")
  end

  namespace :start_app do
    desc "Start the applicaiton servers for the first time"
    remote_task :first_time, :role => [:app] do
      run merb
    end
  end
  
end

