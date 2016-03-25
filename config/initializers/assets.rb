Rails.application.assets.context_class.class_eval do
  include Rails.application.routes.url_helpers
end

assets = Rails.application.config.assets
assets.precompile += %w(ignore/*.css)
assets.precompile += %w(externals/*.js)
