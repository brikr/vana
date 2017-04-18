require 'open3'

module Vana
  module Base
    class Hosts
      def shell(cmd)
        stdout, stderr, status = Open3.capture3(cmd)
        {
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
