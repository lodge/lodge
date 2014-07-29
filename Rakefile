# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

require File.expand_path('../rake/common.rb', __FILE__)

Dir.glob('rake/tasks/*.rake').each do |r|
  load r
end
