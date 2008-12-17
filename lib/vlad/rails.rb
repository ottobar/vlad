require 'vlad'

namespace :vlad do

  desc "Run the migrate rake task for the the app. By default this is run in
    the latest app directory.  You can run migrations for the current app
    directory by setting :migrate_target to :current.  Additional environment
    variables can be passed to rake via the migrate_env variable.".cleanup

  # No application files are on the DB machine, also migrations should only be
  # run once.
  remote_task :migrate, :roles => :app do
    break unless target_host == Rake::RemoteTask.hosts_for(:app).first

    directory = case migrate_target.to_sym
                when :current then current_path
                when :latest  then current_release
                else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
                end

    run "cd #{current_path}; #{rake_cmd} RAILS_ENV=#{rails_env} db:migrate #{migrate_args}"
  end

  remote_task :setup_framework, :roles => :app do

    run ["rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids",
            "mkdir -p #{latest_release}/db #{latest_release}/tmp",
            "ln -s #{shared_path}/log #{latest_release}/log",
            "ln -s #{shared_path}/system #{latest_release}/public/system",
            "ln -s #{shared_path}/pids #{latest_release}/tmp/pids"].join(" && ")
  end
  
end