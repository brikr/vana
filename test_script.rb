#!/usr/bin/env ruby -Ilib

require 'vana'

hosts 'localhost' do
  shell 'echo ok'

  shell do |s|
    s.name = 'touch a temp file'
    s.cmd = 'touch /tmp/heyman'
  end
end
