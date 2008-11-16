namespace :vlad do
  namespace :passenger do
    remote_task :restart, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end
  end
end