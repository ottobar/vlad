require 'vlad'

##
# used by update, out here so we can ensure all threads have the same value
def now
  @now ||= Time.now.utc.strftime("%Y%m%d%H%M.%S")
end

namespace :vlad do
  desc "Show the vlad setup.  This is all the default variables for vlad
    tasks.".cleanup

  task :debug do
    require 'yaml'

    # force them into values
    Rake::RemoteTask.env.keys.each do |key|
      next if key =~ /_release|releases|sudo_password/
      Rake::RemoteTask.fetch key
    end

    puts "# Environment:"
    puts
    y Rake::RemoteTask.env
    puts "# Roles:"
    y Rake::RemoteTask.roles
  end

  desc "Setup your servers. Before you can use any of the deployment
    tasks with your project, you will need to make sure all of your
    servers have been prepared with 'rake vlad:setup'. It is safe to
    run this task on servers that have already been set up; it will
    not destroy any deployed revisions or data.".cleanup

  task :setup do
    Rake::Task['vlad:setup_app'].invoke
  end

  desc "Prepares application servers for deployment.".cleanup

  remote_task :setup_app, :roles => :app do
    dirs = [deploy_to, releases_path, scm_path, shared_path]
    dirs += %w(config system log pids).map { |d| File.join(shared_path, d) }
    run "umask 02 && mkdir -p #{dirs.join(' ')}"
  end

  desc "Updates your application server to the latest revision.  Syncs
    a copy of the repository, exports it as the latest release, fixes
    up your symlinks, symlinks the latest revision to current, logs
    the update and updates the framework.".cleanup

  remote_task :update, :roles => :app do
    Rake::Task['vlad:update_source_code'].invoke
    Rake::Task['vlad:update_symlink'].invoke
    Rake::Task['vlad:update_framework'].invoke
  end

  desc "Updates the source code on the application servers and exports it as the latest release"
  remote_task :update_source_code, :roles => :app do
    begin
      run [ "cd #{scm_path}",
            "#{source.checkout revision, '.'}",
            "#{source.export ".", release_path}",
            "chmod -R g+w #{latest_release}"
          ].join(" && ")
    rescue => e
      run "rm -rf #{release_path}"
      raise e
    end
  end

  desc "Updates the current symlink to the latest release"
  remote_task :update_symlink, :roles => :app do
    begin
      run "rm -f #{current_path} && ln -s #{latest_release} #{current_path}"
      run "echo #{now} $USER #{revision} #{File.basename release_path} >> #{deploy_to}/revisions.log"
    rescue => e
      run "rm -f #{current_path} && ln -s #{previous_release} #{current_path}"
      raise e
    end
  end

  desc "Invoke a single command on every remote server. This is useful for
    performing one-off commands that may not require a full task to be written
    for them.  Simply specify the command to execute via the COMMAND
    environment variable.  To execute the command only on certain roles,
    specify the ROLES environment variable as a comma-delimited list of role
    names.

      $ rake vlad:invoke COMMAND='uptime'".cleanup

  remote_task :invoke do
    command = ENV["COMMAND"]
    abort "Please specify a command to execute on the remote servers (via the COMMAND environment variable)" unless command
    puts run(command)
  end

  desc "Copy arbitrary files to the currently deployed version using
    FILES=a,b,c. This is useful for updating files piecemeal when you
    need to quickly deploy only a single file.

    To use this task, specify the files and directories you want to copy as a
    comma-delimited list in the FILES environment variable. All directories
    will be processed recursively, with all files being pushed to the
    deployment servers. Any file or directory starting with a '.' character
    will be ignored.

      $ rake vlad:upload FILES=templates,controller.rb".cleanup

  remote_task :upload do
    file_list = (ENV["FILES"] || "").split(",")

    files = file_list.map do |f|
      f = f.strip
      File.directory?(f) ? Dir["#{f}/**/*"] : f
    end.flatten

    files = files.reject { |f| File.directory?(f) || File.basename(f)[0] == ?. }

    abort "Please specify at least one file to update (via the FILES environment variable)" if files.empty?

    files.each do |file|
      rsync file, File.join(current_path, file)
    end
  end

  desc "Rolls back to a previous version and restarts. This is handy if you
    ever discover that you've deployed a lemon; 'rake vlad:rollback' and
    you're right back where you were, on the previously deployed
    version.".cleanup

  remote_task :rollback do
    if releases.length < 2 then
      abort "could not rollback the code because there is no prior release"
    else
      run "rm #{current_path}; ln -s #{previous_release} #{current_path} && rm -rf #{current_release}"
    end

    Rake::Task['vlad:start'].invoke
  end

  desc "Clean up old releases. By default, the last 5 releases are kept on
    each server (though you can change this with the keep_releases variable).
    All other deployed revisions are removed from the servers.".cleanup
  
  remote_task :cleanup do
    max = keep_releases
    if releases.length <= max then
      puts "no old releases to clean up #{releases.length} <= #{max}"
    else
      puts "keeping #{max} of #{releases.length} deployed releases"

      directories = (releases - releases.last(max)).map { |release|
        File.join(releases_path, release)
      }.join(" ")

      run "rm -rf #{directories}"
    end
  end

  desc <<-DESC
    Copy configuration files to the shared/config directory using FILES=a,b,c.
    To use this task, specify the files and directories you want to copy as a
    comma-delimited list in the FILES environment variable. All directories
    will be processed recursively, with all files being pushed to the
    deployment servers. Any file or directory starting with a '.' character
    will be ignored.

      $ rake vlad:upload FILES=templates,controller.rb".cleanupE.g. rake vlad:upload_config FILES=database.yml,s3.yml
  DESC
  remote_task :upload_config do
    file_list = (ENV["FILES"] || "").split(",")

    files = file_list.map do |f|
      f.strip
    end.flatten

    files = files.reject { |f| File.directory?(f) || File.basename(f)[0] == ?. }

    abort "Please specify at least one file to update (via the FILES environment variable)" if files.empty?

    files.each do |file|
      rsync File.join('config', file), File.join(shared_path, 'config', file)
    end
  end

  desc "Restart the web and application servers"
  remote_task :start do
    Rake::Task['vlad:start_app'].invoke
    Rake::Task['vlad:start_web'].invoke
  end

  desc "Stop the web and application servers"
  remote_task :stop do
    Rake::Task['vlad:stop_web'].invoke
    Rake::Task['vlad:stop_app'].invoke
  end

  desc "Deploy the application and cleanup old versions"
  remote_task :deploy => [ 'vlad:stop', 'vlad:update', 'vlad:start', 'vlad:cleanup']

  namespace :deploy do
    desc "Deploy the application with migrations and cleanup old versions"
    remote_task :migrations => [ 'vlad:stop', 'vlad:update', 'vlad:migrate', 'vlad:start', 'vlad:cleanup']
  end

end # namespace vlad
