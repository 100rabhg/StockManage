# Setup deployment Environment
## Install `ruby-3.2.2`

    # update your package list
    sudo apt update

    # install the dependencies required to install Ruby
    sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev

    # install rbenv
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

    # setup rbenv to run and load
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc

    # install ruby
    rbenv install 3.2.2
    rbenv global 3.2.2
    ruby -v

## Install bundler and rails

    gem install bundler
    gem install rails
    rails -v

## Install postgress dependencies

    sudo apt-get install libpq-dev
    sudo apt install postgresql
    sudo apt install postgresql-client

## Install mini_magick for image processing

    sudo apt-get install imagemagick

## Now move to project directory

    # Install gem

    bundle
    # rails assets:precompile

    # migrate
    rails db:create
    rails db:migrate
    rails db:seed

### Install redis for Active-Storage

    # install
    sudo apt install redis-server

    # start server
    redis-server

### Now run Server

    rails s
