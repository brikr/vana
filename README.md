# vana
ansible but ruby

## wtf
in an ideal world, this is what a script might look like:  
```ruby
#!/usr/bin/env ruby

require 'vana'

hosts 'localhost' do
  # simple one-line elements
  shell 'echo ok'

  # or more commonly, complex customization
  shell do |s|
    s.cmd = 'touch /tmp/ok'
    s.sudo = true
  end

  # copy a file
  copy do |f|
    f.src = 'files/tmpfile'
    f.dest = '/opt/app'
  end
end

# can target multiple hosts
# parse IPs or keywords from a hosts file
# more gems can be written to support dynamic inventories a la Ansible
hosts 'webservers', 'databases' do
  # copy file from local to remote
  copy do |f|
    f.src = Dir.glob('files/*.war')
    f.dest = '/opt/tomcat8/webapps/.'
  end

  # specify which commands should be ran as root
  service do |s|
    s.name = 'tomcat8'
    s.action = 'restart'
    s.sudo = true
  end
end

# easily place normal ruby code throughout the vana
puts 'db pass?'
pw = gets.chomp

hosts 'databases' do
  # normal ruby control flow
  fail if hosts.empty?

  users = sql do |s|
    s.sql = 'SELECT * FROM users'
    s.database = 'mysql'
    s.user = 'root'
    s.pass = pw
  end

  # all elements return hashes of useful info
  user_count = users.rows.size
  puts "Number of MySQL users: #{user_count}"
end
```
