#!/usr/bin/env puma

directory '/home/ext-binary/ascc/staging/current'
rackup "/home/ext-binary/ascc/staging/current/config.ru"
environment 'staging'

tag ''

pidfile "/home/ext-binary/ascc/staging/shared/tmp/pids/puma.pid"
state_path "/home/ext-binary/ascc/staging/shared/tmp/pids/puma.state"
stdout_redirect '/home/ext-binary/ascc/staging/shared/log/puma_access.log', '/home/ext-binary/ascc/staging/shared/log/puma_error.log', true


threads 0,16



bind 'unix:///home/ext-binary/ascc/staging/shared/tmp/sockets/puma.sock'

workers 0





prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end


