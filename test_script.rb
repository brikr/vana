#!/usr/bin/env ruby -Ilib

require 'vana'

hosts 'localhost' do
  shell 'echo ok'

  shell do |s|
    s.name = 'touch a temp file'
    s.cmd = 'touch /tmp/heyman'
  end
end

hosts '10.141.21.149', 'localhost' do
  shell 'whoami'

  shell do |s|
    s.name = 'this element should fail'
    s.cmd = 'false'
  end
end
