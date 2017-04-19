require 'fileutils'
require 'net/scp'

module Vana
  # vana/main.rb
  class Hosts
    def copy(*args, &block)
      Vana::Element::Copy.new(@hosts, *args, &block).execute
    end
  end

  module Element
    # copy element
    class Copy < BaseElement
      def setup(*args)
        @opts[:src] ||= args[0]
        @opts[:dest] ||= args[1]

        @element_opts[:name] ||= "copy #{@opts[:src]} to #{@opts[:dest]}"
      end

      def src=(src)
        @opts[:src] = src
      end

      def dest=(dest)
        @opts[:dest] = dest
      end

      def remote_src=(remote_src)
        @opts[:remote_src] = remote_src
      end

      def preserve_time=(preserve_time)
        @opts[:preserve_time] = preserve_time
      end

      def action(host, *_args)
        output = {
          src: @opts[:src],
          dest: @opts[:dest]
        }
        if host == 'localhost'
          begin
            FileUtils.cp_r(@opts[:src], @opts[:dest], preserve: @opts[:preserve_time])
            output[:success] = true
          rescue Errno::ENOENT
            output[:success] = false
          end
        elsif @opts[:remote_src]
          Net::SSH.start(host) do |ssh|
            ssh.open_channel do |channel|
              channel.exec("cp -rf #{@opts[:src]} #{@opts[:dest]}") do |_ch, _success|
                channel.on_request('exit-status') do |_ch, data|
                  output[:success] = data.read_long.zero?
                end
              end
            end
          end
        else
          begin
            Net::SCP.start(host, nil) do |scp|
              scp.upload!(@opts[:src], @opts[:dest], recursive: true, preserve: @opts[:preserve_time])
            end
            output[:success] = true
          rescue Net::SCP::Error
            output[:success] = false
          end
        end
        output
      end
    end
  end
end
