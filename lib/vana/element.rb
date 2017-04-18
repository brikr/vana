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

      def name=(name)
        @element_opts[:name] = name
      end

      def execute(*args)
        puts "-- #{@element_opts[:name]}"
        output = action(*args)
        puts output.to_json

        raise "Execution failed on '#{@element_opts[:name]}'" unless output[:success]
      end
    end
  end
end
