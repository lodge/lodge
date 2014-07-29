@rake_log = Logger.new(STDOUT)
@rake_log.level = Logger::INFO
@rake_log.formatter = proc { |severity, datetime, progname, msg|
    "%s  %5s  %s\n" % [datetime.strftime('%Y-%m-%d %H:%M:%S,%L'), severity, msg]
  }

def log_task_start(task_name)
  @rake_log.info("Task `#{task_name}' started")
end

def log_task_end(task_name)
  @rake_log.info("Task `#{task_name}' succeeded")
end

def log_task_failed(task_name)
  @rake_log.error("Task `#{task_name}' failed")
end
