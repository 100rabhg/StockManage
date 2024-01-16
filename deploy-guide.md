Deploy using Capistrano

we can use `rvm` else `rbenv` here using rbenv

require gem in development environment

    gem 'capistrano'
    gem 'capistrano-bundler'
    gem 'capistrano-passenger', '>= 0.1.1'
    gem 'capistrano-rails'
    gem 'capistrano-rbenv'

run this command 

    bundle exec cap install

This will create `Capfile` and `config/deploy.rb` and `config/deploy/production.rb`

EDIT the `CapFile`

    require "capistrano/setup"
    require "capistrano/deploy"
    require "capistrano/scm/git"
    install_plugin Capistrano::SCM::Git
    require "capistrano/rbenv"
    require "capistrano/bundler"
    require "capistrano/rails/assets"
    require "capistrano/rails/migrations"
    require "capistrano/passenger"
    Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

Now EDIT `config/deploy.rb`
   
    set :application, "[YOUR-APPLICATION-NAME]"
    set :repo_url, "git@github.com:[your-github-username]/[your-github-reponame].git"
    set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
    set :rbenv_ruby, '[your-ruby-version]'
    set :passenger_restart_with_touch, true

Now EDIT `config/deploy/production.rb`

    server '[your_ec2_public_DNS]', user: '[instance_username]', roles: %w{web app db}

    set :ssh_options, {
    keys: %w([absolute-path-to-your-ec2-key-pair-file]),
    forward_agent: false,
    auth_methods: %w(publickey password)
    }


Now connect with your ec2 with SSH
    
    `SSH -i [path-to-key-pair] unbuntu@[ec2-public-ip]`

Install Rbnev

Install ruby, rails and bundler with a required version

Ruby should install rvm or rbnev specified in `config/deploy.rb`

Install Passenger and Nginx

    sudo apt-get install -y dirmngr gnupg
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    sudo apt-get install -y apt-transport-https ca-certificates

    sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger [your-ubuntu-codename] main > /etc/apt/sources.list.d/passenger.list'
    sudo apt-get update
    sudo apt-get install -y nginx-extras passenger libnginx-mod-http-passenger

CREATE Deploy Directory

    mkdir [YOUR-APPLICATION-NAME]

Set up Github Credentials
    Run the following commands

    ssh-keygen -t rsa -C "[your-email-address]"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub

Take the output from the last command and <a href="https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/"> add the SSH key to your Github account. </a>


Setup Nginx

Run the following command

    passenger-config about ruby-command

The output will look something like the following

    passenger-config was invoked through the following Ruby interpreter:
    Command: /usr/local/rvm/gems/ruby-2.3.3/wrappers/ruby
    Version: ruby 2.3.3p85 (2015-02-26 revision 49769) [x86_64-linux]
    ...

Copy the value shown as the command to your clipboard, e.g.:  /usr/local/rvm/gems/ruby-2.3.3/wrappers/ruby

EDIT sites-enabled file

Run this command to edit

    sudo nano /etc/nginx/sites-enabled/default

change file with this

    server {
        listen 80;
        server_name [insert-your-ec2-public-dns];

        root /home/[username]/[YOUR-APPLICATION-NAME]/current/public;

        passenger_enabled on;
        passenger_ruby <path-output-from-previous-command>;
        passenger_preload_bundler on;
    }

Now run this command 

    sudo service nginx restart

    # this will give execute permission to nginx
    sudo chmod g+x,o+x /home/[username]/[YOUR-APPLICATION-NAME]/current
    sudo chmod g+x,o+x /home/[username]/[YOUR-APPLICATION-NAME]/
    sudo chmod g+x,o+x /home/[username]/

Deploy the app using Capistrano

Return to directory of your app on your local machine

Then, deploy your app from your local machine with the following:

    cap production deploy

Navigate to the public DNS address of your EC2 instance, and you should see your app


If any issue run the command for log

    cat /var/log/nginx/error.log


for more details <a herf="https://medium.com/@KerrySheldon/ec2-exercise-1-6-deploy-a-rails-app-to-an-ec2-instance-using-capistrano-3485238e4a4a">visit</a>






