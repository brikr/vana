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
        if host == 'localhost'
          begin
            FileUtils.cp_r(@opts[:src], @opts[:dest], preserve: @opts[:preserve_time])
            success = true
          rescue Errno::ENOENT
            success = false
          end
          {
            src: @opts[:src],
            dest: @opts[:dest],
            success: success
          }
        elsif @opts[:remote_src]
          # TODO
        else
          begin
            Net::SCP.start(host, nil) do |scp|
              scp.upload!(@opts[:src], @opts[:dest], recursive: true, preserve: @opts[:preserve_time])
            end
            success = true
          rescue Net::SCP::Error
            success = false
          end
          {
            src: @opts[:src],
            dest: @opts[:dest],
            success: success
          }
        end
      end
    end
  end
end
