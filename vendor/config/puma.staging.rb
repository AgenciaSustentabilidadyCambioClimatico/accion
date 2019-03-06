#!/usr/bin/env puma

directory '/home/ext-binarybag/ascc/staging/current'
rackup "/home/ext-binarybag/ascc/staging/current/config.ru"
environment 'staging'

tag ''

pidfile "/home/ext-binarybag/ascc/staging/shared/tmp/pids/puma.pid"
state_path "/home/ext-binarybag/ascc/staging/shared/tmp/pids/puma.state"
stdout_redirect '/home/ext-binarybag/ascc/staging/shared/log/puma_access.log', '/home/ext-binarybag/ascc/staging/shared/log/puma_error.log', true


threads 0,16



bind 'unix:///home/ext-binarybag/ascc/staging/shared/tmp/sockets/puma.sock'

workers 0





prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end


