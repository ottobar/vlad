namespace :vlad do
  desc "Remove the maintenance page"
  remote_task :start_web, :roles => [:web] do
    run "if [ -f #{shared_path}/system/maintenance.html ]; then rm -f #{shared_path}/system/maintenance.html; fi"
  end
  
  desc "Put the maintenance page in place"
  remote_task :stop_web, :roles => [:web] do
    run "cp -f #{shared_path}/config/maintenance.html #{shared_path}/system/"
  end
  
end