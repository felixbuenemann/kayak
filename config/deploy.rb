require "bundler/capistrano"
require 'fast_git_deploy'

set :application, "kayak"
set :repository,  "https://github.com/felixbuenemann/kayak.git"
set :deploy_to, "/u/apps/#{application}"
set :scm, :git

set :user, "vagrant"
set :branch, "master"
set :deploy_type, 'deploy'
set :use_sudo, false

set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".vagrant.d", "insecure_private_key")]

role :app, "kayak.test"
role :web, "kayak.test"
role :db,  "kayak.test", :primary => true

namespace :deploy do
  desc "Start unicorn for this application"
  task :start do
    run "unicorn -c /etc/unicorn/#{application}.conf.rb -D"
  end
  desc "Stop unicorn for this application"
  task :stop do
    run "test -f #{unicorn_pid} && kill -QUIT `cat #{unicorn_pid}`"
  end
  desc "Restart unicorn for this application"
  task :restart do
    run "(test -f #{unicorn_pid} && kill -HUP `cat #{unicorn_pid}`) || unicorn -c /etc/unicorn/#{application}.conf.rb -D"
  end
end