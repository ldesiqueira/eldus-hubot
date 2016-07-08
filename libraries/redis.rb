require 'poise'
require 'chef/resource'
require 'chef/provider'

module Redis
  class Resource < Chef::Resource
    include Poise
    provides  :redis
    actions   :install, :delete
    attribute :name, name_attribute: true
    attribute :user, default: 'root'
    attribute :group, default: 'root'
    attribute :mode, default: 0777
    attribute :cache, default: ::File.join(Chef::Config[:file_cache_path], 'eldus', 'redis')
    attribute :rpm_rui, default: 'https://s3-us-west-2.amazonaws.com/devops-packages/redis-3.2.1-2.el7.remi.x86_64.rpm'
    attribute :install_method, default: :rpm
  end
  class Provider < Chef::Provider
    include Poise
    provides :redis
    def common
      [new_resource.cache].each do |dir|
        directory dir do
          recursive true
        end
      end
      yield
    end
    def action_install
      common do
      case new_resource.install_method
      when :rpm
        remote_file new_resource.cache do
          source new_resource.rpm_uri
        end
      end
      end
    end
    def action_delete
      common do
        nil
      end
    end
  end
end
