require 'vlad'

# :web should define vlad:start_web, vlad:stop_web and vlad:start_web:first_time tasks
namespace :vlad do
  desc "Restart the web servers"
  remote_task :start_web, :roles => :web do
    puts "Nothing to do to restart the web server"
  end

  desc "Stop the web servers"
  remote_task :stop_web, :roles => :web do
    puts "Nothing to do to stop the web server"
  end

  namespace :start_web do
    desc "Start the web servers for the first time"
    remote_task :first_time, :roles => :web do
      puts "Nothing to do to start the web server for the first time"
    end
  end
  
end
