require 'vlad'

namespace :vlad do
  # ubuntu uses apache2ctl rather than apachectl
  set :web_command, "apache2ctl"

  namespace :apache do

    desc "Restart the web servers"
    remote_task :restart, :roles => :web  do
      run "sudo #{web_command} restart"
    end

    desc "Stop the web servers"
    remote_task :stop, :roles => :web  do
      run "sudo #{web_command} stop"
    end

    desc "Stop the web servers"
    remote_task :start, :roles => :web  do
      run "sudo #{web_command} start"
    end

  end
end
