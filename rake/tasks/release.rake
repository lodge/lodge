require 'bundler/cli'

desc 'Make a release'
task :release do
  log_task_start :release

  gemfile_path = File.expand_path('Gemfile', @root_path)
  replaced_gemfile_contents = File.read(gemfile_path).gsub(/~>\s*/, '')
  File.open(gemfile_path, 'w') do |f|
    f << replaced_gemfile_contents
  end

  log_task_end :release
end
