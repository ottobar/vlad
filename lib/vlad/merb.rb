require 'vlad'

# :framework should define vlad:migrate and vlad:update_framework tasks
namespace :vlad do
  set :framework_configs_setup_via, :symlink
  
  desc "Migrate the application database"
  remote_task :migrate, :roles => :app do
    puts "Merb migrate task not yet implemented"
  end

  desc "Updates the framework configuration and working directories after a new release has been exported"
  remote_task :update_framework, :roles => :app do
    commands = ["rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids",
                "mkdir -p #{latest_release}/tmp",
                "ln -s #{shared_path}/log #{latest_release}/log",
                "ln -s #{shared_path}/system #{latest_release}/public/system",
                "ln -s #{shared_path}/pids #{latest_release}/tmp/pids"]

    case framework_configs_setup_via
    when :symlink
      commands << "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
    when :copy
      commands << "cp #{current_path}/config/database_#{app_env}.yml #{current_path}/config/database.yml"
    end

    run commands.join(" && ")
  end

end
