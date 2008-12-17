# For a new deployment:
# - $ rake vlad:setup
# - $ rake vlad:upload_config FILES=database.yml
# - $ rake vlad:update
# - $ rake vlad:db:create
# - $ rake vlad:db:migrate 
# - $ rake vlad:db:seed 
# - $ rake vlad:start_app:first_time
# - configure the web server(s) as needed
# - $ rake vlad:start_web:first_time
#
# For redeploys:
# - $ rake vlad:deploy
#   (runs vlad:stop, vlad:update, vlad:start, vlad:cleanup)
# - $ rake vlad:deploy:migrations
#   (runs vlad:stop, vlad:update, vlad:db:migrate, vlad:start, vlad:cleanup)
#
set :application, "some-application"
set :code_repo, "ssh://some.domain.com/path/to/#{application}.git"
set :deploy_to, "/path/to/#{application}"
set :domain, 'some.domain.com'
