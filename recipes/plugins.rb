node[:dokku][:plugins].each do |name, url|
  target_dir = "/tmp/dokku-plugin-#{name}"

  if url.to_s == "remove"
    bash 'dokku-plugin-uninstall' do
      code "dokku plugin:uninstall #{name}"
    end
  else
    ## download requested plugin
    (url, rev) = url.split("#", 2) if url.include?("#")
    git target_dir do
      repository url
      revision rev if rev
      action :sync
      notifies :run, "bash[dokku-plugin-install-#{name}]"
    end
  end

  ## install plugin
  bash "dokku-plugin-install-#{name}" do
    code "dokku plugin:update #{target_dir}"
    action :nothing
  end
end
