worker_processes 2
timeout 15
preload_app true
listen "0.0.0.0:3000", :tcp_nopush => true

working_directory "."

pid "tmp/unicorn.pid"

environment = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'production'

log = Logger.new("log/unicorn.#{environment}.log")
log.level = Logger::INFO
logger log

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_fork do |server, worker|
  Signal.trap 'USR2' do
    Thread.new do
      old_pid = "#{server.config[:pid]}.oldbin"
      if File.exists?(old_pid) && server.pid != old_pid then
        begin
          pid_num = File.read(server.pid).to_i
          old_pid_num = File.read(old_pid).to_i
          log.warn "Both current master (pid=#{pid_num}) and old master (pid=#{old_pid_num}) are running, so sending QUIT signal to the old"
          Process.kill 'QUIT', old_pid_num
        rescue Errno::ENOENT, Errno::ESRCH
          # ignore
        end
      end
    end
  end

  Signal.trap 'TERM' do
    Thread.new do
      log.warn 'Unicorn master intercepting TERM and sending myself QUIT instead'
      Process.kill 'QUIT', Process.pid
    end
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    Thread.new do
      log.warn 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
    end
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
