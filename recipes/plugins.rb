plugin_list_call = Chef::ShellOut.new('dokku', 'plugin', user: 'root')
plugin_list_call.run_command
plugin_list_call.error!
plugin_list = plugin_list_call.stdout.split("\n").map { |line| line.split('  ').map(&:strip).reject(&:empty?).first }

node[:dokku][:plugins].each do |name, url|
  if url.to_s == "remove"
    if plugin_list.include?(name)
      bash 'dokku-plugin-uninstall' do
        code "dokku plugin:uninstall #{name}"
      end
    end
  else
    ## install plugin
    bash "dokku-plugin-install-#{name}" do
      code "dokku plugin:#{plugin_list.include?(name) ? 'update' : 'install'} #{url}"
    end
  end
end
