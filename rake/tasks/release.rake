require 'bundler'
require 'bundler/cli'

namespace :lodge do

  namespace :release do

    desc 'Lock gemfile version to release'
    task :prepare do
      LodgeRake.log_task_start :release

      Dir.chdir(LodgeRake.root_path) do
        git_status = `git status -s 2>&1`
        if $?.exitstatus != 0 or not git_status.empty?
          raise "git status failed: #{git_status}"
        end

        bundle_install = `bundle install 2>&1`
        if $?.exitstatus != 0
          raise "bundle install failed: #{bundle_install}"
        else
          puts bundle_install
        end
      end

      lockfile_path = File.expand_path('Gemfile.lock', LodgeRake.root_path)
      lockfile = Bundler::LockfileParser::new(Bundler.read_file(lockfile_path))
      gems = {}
      lockfile.specs.each do |s|
        gems[s.name] = s.version.to_s
      end

      gemfile_path = File.expand_path('Gemfile', LodgeRake.root_path)

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

      LodgeRake.log_task_end :release
    end

  end

end
