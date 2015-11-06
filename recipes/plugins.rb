ruby_block "dokku-plugin-install" do
  block do
    list = Chef::ShellOut.new('dokku', 'plugin', user: 'root')
    list.run_command
    list.error!
    installed_plugins = list.stdout.split("\n").map do |line|
      line.split('  ').map(&:strip).reject(&:empty?).first
    end

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
          code "dokku plugin:#{list.include?(name) ? 'update' : 'install'} #{url}"
        end
      end
    end
  end
end
