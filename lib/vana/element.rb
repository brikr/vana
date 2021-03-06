require 'colorize'
require 'json'

module Vana
  module Element
    # methods for every element
    class BaseElement
      def initialize(hosts, *args)
        @hosts = hosts
        @element_opts = {}
        @opts = {}

        yield self if block_given?
        setup(*args)
      end

      def setup(*_args)
        # nop
      end

      def action(_host, *_args)
        # nop
      end

      def name=(name)
        @element_opts[:name] = name
      end

      def execute(*args)
        puts "-- #{@element_opts[:name]}"
        @hosts.each do |host|
          output = action(host, *args)
          puts "#{host}: #{output.to_json}".colorize(output[:success] ? :light_green : :light_red)

          # TODO: need a better place to handle exceptions and keep going with the script
          # raise "Execution failed on '#{@element_opts[:name]}'" unless output[:success]
        end
      end

      def self.inherited(subclass)
        # create a method in hosts with same name as class, but lowercased to match style
        Hosts.send(:define_method, subclass.name.split('::').last.downcase) do |*args, &block|
          subclass.new(@hosts, *args, &block).execute
        end
      end
    end
  end
end
