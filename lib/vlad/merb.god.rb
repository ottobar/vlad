require 'vlad'
namespace :vlad do
  set :merb_env, 'production'
  
  remote_task :stop_app, :roles => [:app] do
    run "sudo /usr/bin/god stop #{application}"
  end
  remote_task :start_app, :roles => [:app] do
    run "sudo /usr/bin/god restart #{application}"
  end

  namespace :start do
    desc "start the applicaiton for the first time"
    remote_task :cold, :role => [:app] do
      run "sudo /usr/bin/god start #{application} -c #{current_path}/config/application_#{merb_env}.god"
    end
  end

  remote_task :symlink_configs, :roles => [:app] do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml && mkdir -p #{release_path}/tmp/cache"
  end
  
  namespace :dm do
    remote_task :migrate, :roles => [:db] do
      run "cd #{current_path}; MERB_ENV=#{merb_env} rake dm:db:migrate"
    end
  end
end