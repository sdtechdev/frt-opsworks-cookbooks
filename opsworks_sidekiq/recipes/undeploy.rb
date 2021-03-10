# Adapted from deploy::rails-undeploy: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails-undeploy.rb

include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  unless node[:sidekiq][application]
    next
  end

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping opsworks_sidekiq::undeploy application #{application} as it is not an Rails app")
    next
  end

  execute "unmonit sidekiq workers #{application}" do
    command node[:sidekiq][application][:unmonit_command]
  end

  directory deploy[:deploy_to] do
    recursive true
    action :delete
    only_if do
      File.exists?(deploy[:deploy_to])
    end
  end
end
