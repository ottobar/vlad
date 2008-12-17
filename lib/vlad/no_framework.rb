require 'vlad'

# :framework should define vlad:db:create, vlad:db:migrate, vlad:db:seed and vlad:update_framework tasks
namespace :vlad do
  
  namespace :db do
    desc "Create the application database"
    remote_task :create, :roles => :app do
      puts "Nothing to do to create the database"
    end

    desc "Migrate the database to the latest version"
    remote_task :migrate, :roles => :app do
      puts "Nothing to do to migrate the database"
    end

    desc "Load seed data into application database"
    remote_task :seed, :roles => :app do
      puts "Nothing to do to seed the database"
    end
  end

  desc "Updates the framework configuration and working directories after a new release has been exported"
  remote_task :update_framework, :roles => :app do
    puts "Nothing to do to update the framework"
  end
  
end
