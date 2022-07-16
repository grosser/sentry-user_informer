Sentry.init do |config|
  # free trial account created by grosser, obfuscated so crawlers do not find it
  config.dsn = Base64.decode64('aHR0cHM6Ly8zZGJjYzY0MjMzZTk0ZTEwOWUwNWY2ZDkyMzI0YzA5NUBvMTMyMDg2OC5pbmdlc3Quc2VudHJ5LmlvLzY1Nzc1MTM')
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 0
end
