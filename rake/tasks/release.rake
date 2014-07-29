desc 'Make a release'
task :release do
  begin
    log_task_start :release
    log_task_end :release
  rescue => e
    log_task_failed :release, e
  end
end
