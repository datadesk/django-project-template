# CAW
cookbook_file "/etc/update-motd.d/01-caw" do
  source "motd/caw.sh"
  owner "root"
  group "root"
end

bash "chmod motd" do
  user "root"
  group "root"
  code "chmod a+x /etc/update-motd.d/01-caw"
end
