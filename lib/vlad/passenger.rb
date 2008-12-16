require 'vlad'

namespace :vlad do
  set :web_command, "apache2ctl"

  desc "(Re)Start the web and app servers"
  remote_task :start do
    Rake::Task['vlad:start_app'].invoke
    #Rake::Task['vlad:start_web'].invoke # do not have to restart apache with passenger
  end

  desc "Stop the web and app servers"
  remote_task :stop do
    Rake::Task['vlad:stop_app'].invoke
    Rake::Task['vlad:stop_web'].invoke
  end

  desc "(Re)Start the web servers"
  remote_task :start_web, :roles => :web  do
    run "#{web_command} restart"
  end

  desc "Stop the web servers"
  remote_task :stop_web, :roles => :web  do
    run "#{web_command} stop"
  end

  desc "Stop the app servers"
  remote_task :stop_app, :roles => [:app] do
    # Jane, how do you stop this crazy thing?
  end

  desc "(Re)start the app servers"
  remote_task :start_app, :roles => [:app] do
    run "touch #{release_path}/tmp/restart.txt"
  end

end