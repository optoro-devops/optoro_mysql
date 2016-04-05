# <
# This recipe creates conditions for testing in kitchen.
# >
node.force_override['consul']['service_mode'] = 'bootstrap' # ~FC019

package 'curl'

node.set['apt']['compile_time_update'] = true
include_recipe 'apt'

user 'deploy' do
  home '/home/deploy'
  shell '/bin/bash'
end

directory '/var/optoro' do
  owner 'root'
  group 'root'
  mode '0755'
end
