require 'net/ssh'
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

      def action(host, *_args)
        if host == 'localhost'
          stdout, stderr, status = Open3.capture3(@opts[:cmd])
          {
            cmd: @opts[:cmd],
            stdout: stdout,
            stderr: stderr,
            success: status.success?,
            status: status.exitstatus,
            pid: status.pid
          }
        else
          Net::SSH.start(host) do |ssh|
            output = {
              cmd: @opts[:cmd],
              stdout: '',
              stderr: ''
            }

            ssh.open_channel do |channel|
              channel.exec(@opts[:cmd]) do |_ch, _success|
                # stdout
                channel.on_data { |_ch, data| output[:stdout] << data }

                # stderr
                channel.on_extended_data { |_ch, data| output[:stderr] << data }

                # exit status
                channel.on_request('exit-status') do |_ch, data|
                  output[:status] = data.read_long
                  output[:success] = output[:status].zero?
                end
              end
            end

            ssh.loop

            output
          end
        end
      end
    end
  end
end
