#!/usr/bin/env ruby

require 'vana'

hosts 'localhost' do
  tmp = shell 'echo ok'

  puts tmp.inspect
end
