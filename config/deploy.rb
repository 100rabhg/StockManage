# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application, "StockManage"
set :repo_url, "https://100rabhg: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@github.com/100rabhg/StockManage.git"

set :branch, :master
set :use_sudo, false
set :deploy_to, '/home/ubuntu/StockManage'
set :pty, true

set :bundle_jobs, 2
set :rbenv_ruby, '3.0.0'
set :deploy_via, :remote_cache

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse 100rabhg/master`
        puts "WARNING: HEAD is not the same as 100rabhg/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      within release_path do
        execute "ruby $HOME/StockManage/start_server.rb #{ fetch(:rails_env) } #{ '-d' }"
      end
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
