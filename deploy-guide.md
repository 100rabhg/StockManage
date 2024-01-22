# Deploy using Capistrano

we can use `rvm` or `rbenv` here using rbenv

### require gem in development environment

    gem 'capistrano'
    gem 'capistrano-bundler'
    gem 'capistrano-passenger', '>= 0.1.1'
    gem 'capistrano-rails'
    gem 'capistrano-rbenv'

#### run this command 

    bundle exec cap install

This will create `Capfile` and `config/deploy.rb` and `config/deploy/production.rb`

## EDIT the `CapFile`

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

##  Now EDIT `config/deploy.rb`
   
    set :application, "[YOUR-APPLICATION-NAME]"
    set :repo_url, "git@github.com:[your-github-username]/[your-github-reponame].git"
    set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
    set :rbenv_ruby, '[your-ruby-version]'
    set :passenger_restart_with_touch, true

## Now EDIT `config/deploy/production.rb`

    server '[your_ec2_public_DNS]', user: '[instance_username]', roles: %w{web app db}

    set :ssh_options, {
    keys: %w([absolute-path-to-your-ec2-key-pair-file]),
    forward_agent: false,
    auth_methods: %w(publickey password)
    }


## Now connect with your ec2 with SSH
    
    `SSH -i [path-to-key-pair] unbuntu@[ec2-public-ip]`

## Install 
* Rbnev
* ruby
* rails
* bundler

### Ruby should install rvm or rbnev specified in `config/deploy.rb`

## Install Passenger and Nginx

    sudo apt-get install -y dirmngr gnupg
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    sudo apt-get install -y apt-transport-https ca-certificates

    sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger [your-ubuntu-codename] main > /etc/apt/sources.list.d/passenger.list'
    sudo apt-get update
    sudo apt-get install -y nginx-extras passenger libnginx-mod-http-passenger

## CREATE Deploy Directory

    mkdir [YOUR-APPLICATION-NAME]

## Set up Github Credentials
Run the following commands

    ssh-keygen -t rsa -C "[your-email-address]"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub

Take the output from the last command and <a href="https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/"> add the SSH key to your Github account. </a>


## Setup Nginx
Run the following command

    passenger-config about ruby-command

### The output will look something like the following

    passenger-config was invoked through the following Ruby interpreter:
    Command: /usr/local/rvm/gems/ruby-2.3.3/wrappers/ruby
    Version: ruby 2.3.3p85 (2015-02-26 revision 49769) [x86_64-linux]
    ...

Copy the value shown as the command to your clipboard, e.g.:  **/usr/local/rvm/gems/ruby-2.3.3/wrappers/ruby**

### EDIT sites-enabled file
Run this command to edit

    sudo nano /etc/nginx/sites-enabled/default

#### change file with below code

*for http(80) nginx file will be*

    server {
        listen 80;
        server_name [insert-your-ec2-public-dns];

        root /home/[username]/[YOUR-APPLICATION-NAME]/current/public;

        passenger_enabled on;
        passenger_ruby <path-output-from-previous-command>;
        passenger_preload_bundler on;
    }

*for https(443) nginx file will be*

    server {
        listen 443 ssl default_server;

        ssl_certificate /home/ubuntu/ssl/ssl-bundle.crt;
        ssl_certificate_key /home/ubuntu/ssl/[domain].key;

        server_name [insert-your-ec2-public-dns];

        root /home/[username]/[YOUR-APPLICATION-NAME]/current/public;

        passenger_enabled on;
        passenger_ruby <path-output-from-previous-command>;
        passenger_preload_bundler on;
    }

### Now restart nginx

    sudo service nginx restart

## Deploy the app using Capistrano

**Return to directory of your app on your local machine**

Then, deploy your app from your local machine with the following:

    cap production deploy


## Now give execute permission to nginx 

**On ec2 instance execute this command**

    # this will give execute permission to nginx
    sudo chmod g+x,o+x /home/[username]/[YOUR-APPLICATION-NAME]/current
    sudo chmod g+x,o+x /home/[username]/[YOUR-APPLICATION-NAME]/
    sudo chmod g+x,o+x /home/[username]/


## Now, Navigate to the public DNS address of your EC2 instance, and you should see your app


### If any issue run the command for log

    cat /var/log/nginx/error.log


for more details <a herf="https://medium.com/@KerrySheldon/ec2-exercise-1-6-deploy-a-rails-app-to-an-ec2-instance-using-capistrano-3485238e4a4a">visit</a>

#

# Setup Cloud watch

### Create an IAM Policy

1. Open the IAM console: https://console.aws.amazon.com/iam/

2. In the navigation pane, choose Policies

3. Choose Create policy and click on JSON.

4. Enter the following policy:

[//]: #

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:DescribeLogStreams"
                ],
                "Resource": [
                    "arn:aws:logs:*:*:*"
                ]
            }
        ]
    }

5. Click Next: Tags

6. Choose Review policy.

7. On the Review policy page, enter EC2-CloudWatchLogs-Policy as Name and choose Create policy.

### Create an IAM Role

1. Open the IAM console: https://console.aws.amazon.com/iam/
2. In the navigation pane, choose Roles.
3. Click on Create role
4. Select EC2 from Common use cases
5. Click Next: Permissions
6. Search and select the Policy we created, in our case EC2-CloudWatchLogs-Policy
7. Click Next: Tags
8. Click Next: Review
9. Set Role name to EC2-CloudWatchLogs-Role and click Create Role

### Attach to EC2

1. Go to EC2
2. Click on Instances
3. Right-click the EC2 of which you want to send the logs to Amazon CloudWatch Logs
4. In the menu click: Security > Modify IAM Role
5. Set the IAM Role to EC2-CloudWatchLogs-Role

## CloadWatch-agent Setup on EC2
#### Login in EC2 and run below cmd to setup agent for ubuntu

    # download cloudwatch-agent
    wget https://amazoncloudwatch-agent.s3.amazonaws.com/oracle_linux/amd64/latest/amazon-cloudwatch-agent.rpm

    # install agent
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

    # setup agent answer all asking question to setup
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

    # load and start agent
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status

for more details <a herf="https://copyprogramming.com/howto/shell-aws-cloudwatch-agent-ubuntu-code-example">visit</a>