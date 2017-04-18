# vana
ansible but ruby

## wtf
in an ideal world, this is what a script might look like:  
```ruby
#!/usr/bin/env ruby

require 'vana'

hosts 'localhost' do
  shell 'echo ok'

  shell do |s|
    s.cmd = 'touch /tmp/ok'
    s.sudo = true
  end

  file do |f|
    f.src = 'files/tmpfile'
    f.dest = '/opt/app'
  end
end

hosts 'webservers' do
  file do |f|
    f.src = Dir.glob('files/*.war')
    f.dest = '/opt/tomcat8/webapps/.'
  end

  service do |s|
    s.name = 'tomcat8'
    s.action = 'restart'
    s.sudo = true
  end
end

puts 'db pass?'
pw = gets.chomp

hosts 'databases' do
  fail if hosts.empty?

  users = sql do |s|
    s.sql = 'SELECT * FROM users'
    s.database = 'mysql'
    s.user = 'root'
    s.pass = pw
  end

  user_count = users.rows.size
  puts "Number of MySQL users: #{user_count}"
end
```
