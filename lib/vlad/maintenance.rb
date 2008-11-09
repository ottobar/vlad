namespace :vlad do
  desc "Remove the maintenance page"
  remote_task :start_web, :roles => [:web] do
    run "if [ -f #{shared_path}/system/maintenance.html ]; then rm -f #{shared_path}/system/maintenance.html; fi"
  end
  
  desc "Put the maintenance page in place"
  remote_task :stop_web, :roles => [:web] do
    run "cp -f #{shared_path}/config/maintenance.html #{shared_path}/system/"
  end
  
  desc "(Re)Start the web and app servers"
  remote_task :start do
    Rake::Task['vlad:start_app'].invoke
    Rake::Task['vlad:start_web'].invoke
  end

  desc "Stop the web and app servers"
  remote_task :stop do
    Rake::Task['vlad:stop_app'].invoke
    Rake::Task['vlad:stop_web'].invoke
  end
end