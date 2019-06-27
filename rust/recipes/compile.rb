node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  bash "compile-rust-#{application}" do
    user deploy[:user]
    environment 'HOME' => '/home/deploy'
    cwd "#{deploy[:deploy_to]}/current/crates/assignment"
    code "~/.cargo/bin/cargo build --release"
  end
end
