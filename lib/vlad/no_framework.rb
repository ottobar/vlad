require 'vlad'

# :framework should define vlad:migrate and vlad:update_framework tasks
namespace :vlad do
  desc "Migrate the database to the latest version"
  remote_task :migrate, :roles => :app do
    puts "Nothing to do to migrate the database"
  end

  namespace :db do
    desc "Create the application database"
    remote_task :create, :roles => :app do
      puts "Nothing to do to create the database"
    end
  end

  desc "Updates the framework configuration and working directories after a new release has been exported"
  remote_task :update_framework, :roles => :app do
    puts "Nothing to do to update the framework"
  end
  
end
