# Vlad configuration for a multistage deployment scenario.
#
# For a new deployment:
# - rake [environment] vlad:setup
# - rake [environment] vlad:upload_config FILES=database.yml
# - rake [environment] vlad:update
# - rake [environment] vlad:migrate
# - rake [environment] vlad:start:first_time
#
# For redeploys:
# - rake [environment] vlad:deploy
#   (runs vlad:stop, vlad:update, vlad:start, vlad:cleanup)
# - rake [environment] vlad:deploy:migrations
#   (runs vlad:stop, vlad:update, vlad:migrate, vlad:start, vlad:cleanup)