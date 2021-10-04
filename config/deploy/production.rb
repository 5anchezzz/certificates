set :port, 22
set :user, 'deployer'
set :deploy_via, :remote_cache
set :use_sudo, false

server '45.8.229.19', port: fetch(:port), user: fetch(:user), roles: %w{app db web}

set :stage, :production
set :rails_env, :production
set :unicorn_env, :production
set :unicorn_rack_env, 'production'
set :branch, 'several-marathons'