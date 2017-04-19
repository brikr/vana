#!/usr/bin/env ruby -Ilib

require 'vana'

hosts 'localhost' do
  shell 'echo ok'

  shell do |s|
    s.name = 'touch a temp file'
    s.cmd = 'touch /tmp/heyman'
  end

  copy '/tmp/heyman', '/tmp/heyman2'
end

hosts 'butthole.tv', 'localhost' do
  shell 'whoami'

  shell do |s|
    s.name = 'this element should fail'
    s.cmd = 'false'
  end
end

hosts 'butthole.tv' do
  copy '/tmp/heyman', '/tmp/heyman'

  copy do |c|
    c.name = 'remote source copy'
    c.remote_src = true
    c.src = '/tmp/heyman'
    c.dest = '/tmp/heyman2'
  end

  copy do |c|
    c.name = 'bad copy'
    c.src = '/tmp/heyman'
    c.dest = '/tmsp/heyman2'
    c.preserve_time = true
  end
end
