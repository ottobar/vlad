require 'vlad'

namespace :vlad do
  desc "(Re)Start the web and app servers"
  remote_task :start do
    Rake::Task['vlad:start_app'].invoke
  end

  desc "Stop the web and app servers"
  remote_task :stop do
    Rake::Task['vlad:stop_app'].invoke
  end
  
end
