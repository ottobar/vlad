# For a new deployment:
# - $ rake [environment] vlad:setup
# - $ rake [environment] vlad:upload_config FILES=database.yml
# - $ rake [environment] vlad:update
# - $ rake [environment] vlad:db:create
# - $ rake [environment] vlad:db:migrate
# - $ rake [environment] vlad:db:seed 
# - $ rake [environment] vlad:start_app:first_time
# - configure the web server(s) as needed
# - $ rake vlad:start_web:first_time
#
# For redeploys:
# - $ rake [environment] vlad:deploy
#   (runs vlad:stop, vlad:update, vlad:start, vlad:cleanup)
# - $ rake [environment] vlad:deploy:migrations
#   (runs vlad:stop, vlad:update, vlad:db:migrate, vlad:start, vlad:cleanup)
#
set :application, "some-application"
set :code_repo, "ssh://some.domain.com/path/to/#{application}.git"

task :staging do
  set :deploy_to, "/path/to/#{application}"
  set :domain, 'some.domain.com'
  set :app_env, 'staging'
end

task :production do
  set :deploy_to, "/path/to/#{application}"
  set :domain, 'some.domain.com'
  set :app_env, 'production'
end