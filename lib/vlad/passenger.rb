require 'vlad'

# :app should define vlad:start_app, vlad:stop_app, vlad:start_app:first_time tasks
namespace :vlad do

  remote_task :stop_app, :roles => :app do
    # Jane, how do you stop this crazy thing?
  end
  remote_task :start_app, :roles => :app do
    run "touch #{release_path}/tmp/restart.txt"
  end

  namespace :start_app do
    desc "start the applicaiton for the first time"
    remote_task :first_time, :role => :app do
      puts "Nothing to do to start the application server for the first time"
    end
  end

end