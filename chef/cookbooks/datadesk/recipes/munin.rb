# Install munin and some extras
package "munin" do
    :upgrade
end

package "munin-node" do
    :upgrade
end

package "munin-plugins-extra" do
    :upgrade
end

# Do the basic config for the master
template "/etc/munin/munin.conf" do
  source "munin/munin.conf.erb"
  mode "777"
  owner "root"
  group "root"
  variables({
     :name => node[:munin_name]
  })
end

# Do the basic config for the node
template "/etc/munin/munin-node.conf" do
  source "munin/munin-node.conf.erb"
  mode "777"
  owner "root"
  group "root"
  variables({
     :name => node[:munin_name],
     :munin_master_ips => node[:munin_master_ips]
  })
end

script "Zero out munin apache.conf" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    echo "#nothing to see here" > /etc/munin/apache.conf
  EOH
end

# Install the framework for Python plugins
script "Install PyMunin" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    pip install PyMunin;
  EOH
end

# A postgresql plugin, first the conf...
template "/etc/munin/plugin-conf.d/pgstats" do
  source "munin/pgstats.erb"
  owner "root"
  group "root"
  variables({
     :munin_db_user => node[:munin_db_user],
     :munin_db_name => node[:munin_db_name],
     :munin_include_db_list => node[:munin_include_db_list]
  })
end

# A postgresql plugin
script "Install postgresql adaptor for python" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    pip install psycopg2;
  EOH
end

script "Install pgstats for PyMunin" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    ln -s /usr/share/munin/plugins/pgstats /etc/munin/plugins/pgstats
  EOH
  not_if do
    File.exists?("/etc/munin/plugins/pgstats")
  end
end

# Make sure we have the correct Apache plugins
script "Install Apache2 plugins" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    ln -s /usr/share/munin/plugins/apachestats /etc/munin/plugins/apachestats
  EOH
  not_if do
    File.exists?("/etc/munin/plugins/apachestats")
  end
end

# A memcached plugin
script "Install memcachedstats for PyMunin" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    ln -s /usr/share/munin/plugins/memcachedstats /etc/munin/plugins/memcachedstats
  EOH
  not_if do
    File.exists?("/etc/munin/plugins/memcachedstats")
  end
end

# Install our modified Varnish plugin for Varnish 4
cookbook_file "/usr/share/munin/plugins/varnish4_" do
  source "munin/varnish4_"
  mode 0640
  owner "root"
  group "root"
end

script "Install varnish plugin" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    chmod a+rx /usr/share/munin/plugins/varnish4_
    ln -s '/usr/share/munin/plugins/http_loadtime' '/etc/munin/plugins/http_loadtime'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_backend_traffic'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_bad'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_expunge'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_memory_usage'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_objects'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_request_rate'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_threads'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_transfer_rates'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_uptime'
    ln -s '/usr/share/munin/plugins/varnish4_' '/etc/munin/plugins/varnish4_hit_rate'
  EOH
  not_if do
    (File.exist?('/etc/munin/plugins/varnish4_backend_traffic') or File.exist?("/etc/munin/plugins/varnish4_"))
  end
end

template "/etc/munin/plugin-conf.d/varnish4_" do
  source "munin/varnish4_.erb"
  owner "root"
  group "root"
end

script "Restart Munin" do
  interpreter "bash"
  user "root"
  group "root"
  code <<-EOH
    chmod a+rx /etc/munin/plugin-conf.d/
    service munin-node restart
  EOH
end

script "restart-apache" do
  interpreter "bash"
  user "root"
  code <<-EOH
    apachectl restart
  EOH
end