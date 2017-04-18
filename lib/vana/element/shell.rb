require 'open3'

module Vana
  # vana/main.rb
  class Hosts
    def shell(*args, &block)
      Vana::Element::Shell.new(@hosts, *args, &block).execute
    end
  end

  module Element
    # shell element
    class Shell < BaseElement
      def setup(*args)
        @opts[:cmd] ||= args.first
        @element_opts[:name] ||= @opts[:cmd]
      end

      def cmd=(cmd)
        @opts[:cmd] = cmd
      end

      def action(*_args)
        stdout, stderr, status = Open3.capture3(@opts[:cmd])
        {
          cmd: @opts[:cmd],
          stdout: stdout,
          stderr: stderr,
          success: status.success?,
          status: status.exitstatus,
          pid: status.pid
        }
      end
    end
  end
end
