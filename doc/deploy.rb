# Vlad configuration for a simple deployment setup
#
# For a new deployment:
# - rake vlad:setup
# - rake vlad:upload_config FILES=database.yml
# - rake vlad:update
# - rake vlad:migrate
# - rake vlad:start:first_time
#
# For redeploys:
# - rake vlad:deploy
#   (runs vlad:stop, vlad:update, vlad:start, vlad:cleanup)
# - rake vlad:deploy:migrations
#   (runs vlad:stop, vlad:update, vlad:migrate, vlad:start, vlad:cleanup)