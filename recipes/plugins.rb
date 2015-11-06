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
      code "dokku plugin:install #{url}"
      only_if "dokku plugin | grep #{name}", user: "root"
    end

    bash "dokku-plugin-update-#{name}" do
      code "dokku plugin:update #{url}"
      not_if "dokku plugin | grep #{name}", user: "root"
    end
  end
end
