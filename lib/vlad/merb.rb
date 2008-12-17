require 'vlad'

namespace :vlad do
  set :framework_configs_setup_via, :symlink
  set :merb_env, 'production'

  desc "Setup configuration files for the framework"
  remote_task :setup_framework, :roles => [:app] do
    case framework_configs_setup_via
    when :symlink
      Rake::Task['vlad:symlink_configs'].invoke
    when :copy
      Rake::Task['vlad:copy_configs'].invoke
    end
  end

  remote_task :symlink_configs, :roles => [:app] do
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end

  remote_task :copy_configs, :roles => [:app] do
    run "cp #{current_path}/config/database_#{merb_env}.yml #{current_path}/config/database.yml"
  end

  remote_task :migrate, :roles => :app do
    # TODO: specifiy your ORM or migrator or something and run appropriate task
    break
  end

end
