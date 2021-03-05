# -*- mode: ruby -*-
# vi: set ft=ruby :
domain   = 'acme.es'

nodes = [
  { :hostname => 'master',   :ip => '192.168.2.110', :box => 'centos/8', :ram => 2000, :dns => 'master master.acme.es'},
  { :hostname => 'worker01',      :ip => '192.168.2.111', :box => 'centos/8', :ram => 1000 , :dns => 'worker01 worker01.acme.es' },
  { :hostname => 'worker02',    :ip => '192.168.2.112', :box => 'centos/8' , :ram => 1000,  :dns => 'worker02 worker02.acme.es5' },
  { :hostname => 'nfs',    :ip => '192.168.2.115', :box => 'centos/8' , :ram => 1000 ,  :dns => 'nfs nfs.acme.es' },
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.disk :disk, size: "20GB", primary: true
      memory = node[:ram] ? node[:ram] : 256;
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "50",
          "--memory", memory.to_s,
          "--cpus", "2",
        ]

      end

    end

   

  end

  nodes.each do | node  |
   case  node[:hostname] 
   when  "master"
        config.vm.define node[:hostname] do |nodeconfig|
              nodeconfig .vm.provision "ansible" do |ansible|
                ansible.playbook = "playbooks/master.yaml"
                ansible.verbose = "-v"
                ansible.extra_vars = {
                  nodes: nodes,
                  node: node[:hostname],
                  stage: "local"
                }
              end
          end
     when  "nfs"
          config.vm.define node[:hostname] do |nodeconfig|
                nodeconfig.vm.disk :disk, size: "10GB", name: "extra_storage"
                nodeconfig .vm.provision "ansible" do |ansible|
                    ansible.playbook = "playbooks/nfs.yaml"
                    ansible.extra_vars = {
                      nodes: nodes,
                      node: node[:hostname],
                      stage: "local"
                    }      
                end
            end
      when  /^worker/
            config.vm.define node[:hostname] do |nodeconfig|
                  nodeconfig .vm.provision "ansible" do |ansible|
                      ansible.playbook = "playbooks/worker.yaml"
                      ansible.extra_vars = {
                        nodes: nodes,
                        node: node[:hostname],
                        stage: "local"

                      }
                  end
              end
   end
  end

end
