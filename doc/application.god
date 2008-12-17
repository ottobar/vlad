APPLICATION = "some-application"
APP_ROOT = "/path/to/#{APPLICATION}/current"
APP_ENVIRONMENT = 'production'
PROCESS_USER = 'someuser'
PROCESS_GROUP = 'somegroup'

%w{3720}.each do |port|
  God.watch do |w|
    pid_path = File.join(APP_ROOT, 'log', "merb.#{port}.pid")

    w.name = "#{APPLICATION}-#{port}"
    w.interval = 30.seconds # default
    w.start = "cd #{APP_ROOT}; merb -p #{port} -e #{APP_ENVIRONMENT} -d -u #{PROCESS_USER} -G #{PROCESS_GROUP}"
    w.log = "#{APP_ROOT}/log/godmerb.log"
    w.stop = "cd #{APP_ROOT}; merb -k #{port}"
    w.restart = "(cd #{APP_ROOT}; merb -k #{port}); sleep 1; cd #{APP_ROOT}; merb -p #{port} -e #{APP_ENVIRONMENT} -d -u #{PROCESS_USER} -G #{PROCESS_GROUP}"
    w.start_grace = 5.seconds
    w.restart_grace = 20.seconds
    w.pid_file = File.join(APP_ROOT, "log/merb.#{port}.pid")
    w.group = "#{APPLICATION}"
    w.behavior(:clean_pid_file)

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 10.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 51.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end

      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end
    end

    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 5.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end

  end
end