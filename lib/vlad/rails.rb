require 'vlad'

# :framework should define vlad:db:create, vlad:migrate and vlad:update_framework tasks
namespace :vlad do
  set :framework_configs_setup_via, :symlink

  desc "Migrate the database to the latest version"
  remote_task :migrate, :roles => :app do
    break unless target_host == Rake::RemoteTask.hosts_for(:app).first

    directory = case migrate_target.to_sym
                when :current then current_path
                when :latest  then current_release
                else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
                end

    run "cd #{directory}; #{rake_cmd} RAILS_ENV=#{app_env} db:migrate #{migrate_args}"
  end

  namespace :db do
    desc "Migrate the database to the latest version"
    remote_task :create, :roles => :app do
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first

      run "cd #{current_path}; #{rake_cmd} RAILS_ENV=#{app_env} db:create"
    end
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
