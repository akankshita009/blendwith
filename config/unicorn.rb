root = "/home/deploy/blendit/current"
worker_processes 2
working_directory "/home/deploy/blendit/current" # available in 0.94.0+
listen "/tmp/unicorn.blendit.sock", :backlog => 64
listen 8083, :tcp_nopush => true
timeout 30
pid "/home/deploy/blendit/current/tmp/pids/unicorn.pid"
stderr_path "/home/deploy/blendit/current/log/unicorn.stderr.log"
stdout_path "/home/deploy/blendit/current/log/unicorn.stdout.log"
