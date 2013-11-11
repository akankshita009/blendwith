require 'bundler/capistrano'
require 'rvm/capistrano'
require 'sidekiq/capistrano'

set :application, 'blendit'

set :whenever_identifier, "#{application}"
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :scm, :git
set :repository, 'git@github.com:AcapellaMedia/latest-blendwith.git'
set :branch, :master

server '66.228.51.151', :web, :app, :db, :primary => true

set :user, 'deploy'
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

set :deploy_via, :remote_cache

set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true


namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, :roles => :app, :except => { :no_release => true } do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end



  task :symlink_db, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  before "deploy:assets:precompile", "deploy:symlink_db"
  after "deploy:create_symlink", "deploy:symlink_db"

  task :setup_config, :roles => :app do
    run "#{sudo} ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
  end

  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  after "deploy:setup", "deploy:setup_config"

  after "deploy:symlink", "deploy:update_crontab"

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  end
end

after "deploy", "deploy:migrate"
