require 'vlad'

# :web should define vlad:start_web and vlad:stop_web tasks
namespace :vlad do
  desc "Restart the web and app servers"
  remote_task :start_web, :roles => :web do
    run "echo 'Nothing to do to restart the web server'"
  end

  desc "Stop the web servers"
  remote_task :stop_web, :roles => :web do
    run "echo 'Nothing to do to stop the web server'"
  end
  
end
