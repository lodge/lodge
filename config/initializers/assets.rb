assets = Rails.application.config.assets
assets.precompile += %w(ignore/*.css)
assets.precompile += %w(externals/*.js)
