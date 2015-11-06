node[:dokku][:plugins].each do |name, url|
  if url.to_s == "remove"
    if plugin_list.include?(name)
      bash 'dokku-plugin-uninstall' do
        user 'root'
        code "dokku plugin:uninstall #{name}"
      end
    end
  else
    ## install plugin
    bash "dokku-plugin-install-#{name}" do
      user 'root'
      code "dokku plugin:install #{url}"
      not_if "dokku plugin | grep #{name}", user: "root"
    end

    # Disable plugin update as updating plugins is currently broken in plugn itself
    # See: https://github.com/progrium/dokku/issues/1531
    # bash "dokku-plugin-update-#{name}" do
    #   code "dokku plugin:update #{url}"
    #   only_if "dokku plugin | grep #{name}", user: "root"
    # end
  end
end
