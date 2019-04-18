class LodgeRake

  @@log = Logger.new(STDOUT)
  @@log.level = Logger::INFO
  @@log.formatter = proc { |severity, datetime, progname, msg|
      "%s  %5s  %s\n" % [datetime.strftime('%Y-%m-%d %H:%M:%S,%L'), severity, msg]
    }
  @@root_path = File.expand_path('../..', __FILE__)

  def self.log
    @@log
  end

  def self.root_path
    @@root_path
  end

  def self.log_task_start(task_name)
    @@log.info("Task `#{task_name}' started")
  end

  def self.log_task_end(task_name)
    @@log.info("Task `#{task_name}' succeeded")
  end

end
