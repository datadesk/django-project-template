# Intended to work on Ubuntu 12.04

package "binutils" do
    :upgrade
end

package "gdal-bin" do
    :upgrade
end

package "libproj-dev" do
    :upgrade
end

package "postgresql-9.5-postgis-2.2" do
    :upgrade
end

package "postgresql-server-dev-9.5" do
    :upgrade
end

package "python-psycopg2" do
    :upgrade
end
