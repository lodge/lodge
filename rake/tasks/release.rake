require 'bundler'
require 'bundler/cli'

namespace :lodge do

  namespace :release do

    desc 'Lock gemfile version to release'
    task :prepare do
      log_task_start :release

      lockfile_path = File.expand_path('Gemfile.lock', @root_path)
      lockfile = Bundler::LockfileParser::new(Bundler.read_file(lockfile_path))
      gems = {}
      lockfile.specs.each do |s|
        gems[s.name] = s.version.to_s
      end

      gemfile_path = File.expand_path('Gemfile', @root_path)

      replaced_gemfile_contents = ''
      File.open(gemfile_path).each_line do |l|
        gem_pattern = /^(.*gem\s+["'])([^"']+)(["']\s*,\s*["'])([^"']+)(["'].*)$/
        if m = gem_pattern.match(l)
          locked_version = gems[m[2]]
          replaced_gemfile_contents << l.gsub(gem_pattern, "#{m[1]}#{m[2]}#{m[3]}#{locked_version}#{m[5]}")
        else
          replaced_gemfile_contents << l
        end
      end

      File.open(gemfile_path, 'w') do |f|
        f << replaced_gemfile_contents
      end

      log_task_end :release
    end

  end

end
