# Adapted from deploy::rails: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails.rb

include_recipe 'deploy'


node[:deploy].each do |application, deploy|

  unless node[:sidekiq][application]
    next
  end

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping opsworks_sidekiq::deploy application #{application} as it is not an Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  Chef::Log.debug("Sidekiq quite Application: #{application}")
  execute "sidekiq quite app #{application}" do
    workers = node[:sidekiq][application].to_hash.reject {|k,v| k.to_s =~ /restart_command|syslog|timeout|require|unmonit_command/ }
    file_names = workers.map do |worker, options|
      results = []
      Chef::Log.info("process count on #{worker} #{options.inspect}")
      (options[:process_count] || 1).times do |n|
        results << "#{worker}#{n+1}"
      end
      results
    end.flatten
    file_names.map! do |file_name|
      "/bin/su - #{deploy[:user]} -c \"ps ax | grep 'bundle exec sidekiq' | " \
      "grep sidekiq_#{file_name}.yml | grep -v grep | awk '{print \\$1}' | " \
      "xargs --no-run-if-empty pgrep -P | xargs --no-run-if-empty kill#{" -#{:TSTP}"}\""
    end
    command file_names.join(' && ')
  end

  Chef::Log.debug("Running opsworks_sidekiq::setup for application #{application}")
  node.set[:opsworks][:rails_stack][:recipe] = "opsworks_sidekiq::setup"
  node.set[:opsworks][:rails_stack][:restart_command] = node[:sidekiq][application][:restart_command]

  opsworks_rails do
    deploy_data deploy
    app application
  end

  Chef::Log.debug("Deploying Sidekiq Application: #{application}")
  opsworks_deploy do
    deploy_data deploy
    app application
  end

  Chef::Log.debug("Restarting Sidekiq Application: #{application}")
  execute "restart Rails app #{application}" do
    command node[:sidekiq][application][:restart_command]
  end

end
