require 'vlad'

# :framework should define vlad:migrate and vlad:update_framework tasks
namespace :vlad do
  desc "Migrate the application database"
  remote_task :migrate, :roles => :app do
    run "echo 'Nothing to do to migrate the database'"
  end

  desc "Updates the framework configuration and working directories after a new release has been exported"
  remote_task :update_framework, :roles => :app do
    run "echo 'Nothing to do to update the framework'"
  end
  
end
