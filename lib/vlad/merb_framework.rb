require 'vlad'

# :framework should define vlad:db:create, vlad:db:migrate and vlad:update_framework tasks
namespace :vlad do
  set :framework_configs_setup_via, :symlink
  set :framework_migrate_via, :migrate # can be :migrate, :autoupgrade or :automigrate
  # :migrate => Runs migrations in the db/migrations directory
  # :autoupgrade => Performs non destructive automigration
  # :automigrate => Drops and recreates the repository upwards to match model definitions

  namespace :db do
    desc "Migrate the database to the latest version"
    remote_task :create, :roles => :app do
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first

      run "cd #{current_path}; #{rake_cmd} MERB_ENV=#{app_env} db:create"
    end

    desc "Drops and recreates the repository upwards to match model definitions"
    remote_task :automigrate, :roles => :app do
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first

      run migrate_command("automigrate")
    end

    desc "Performs non destructive automigration"
    remote_task :autoupgrade, :roles => :app do
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first

      run migrate_command("autoupgrade")
    end

    desc "Runs any migrations in the schema/migrations directory"
    remote_task :framework_migrate, :roles => :app do
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first

      run migrate_command("migrate")
    end

    desc "Migrate the database to the latest version"
    remote_task :migrate, :roles => :app do
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first

      run migrate_command(framework_migrate_via)
    end

    desc "Load seed data into application database"
    remote_task :seed, :roles => :app do
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first

      run "cd #{current_path}; #{rake_cmd} MERB_ENV=#{app_env} db:seed"
    end

    def migrate_command(migrate_via)
      directory = case migrate_target.to_sym
                  when :current then current_path
                  when :latest  then current_release
                  else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
                  end

      "cd #{directory}; #{rake_cmd} MERB_ENV=#{app_env} db:#{migrate_via}"
    end

  end # namspace :db

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
