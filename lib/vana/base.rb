module Vana
  module Base
    # hosts block
    class Hosts
      def initialize(*a, &b)
        @hosts = *a

        instance_eval(&b)
      end
    end

    def hosts(*a, &b)
      Hosts.new(*a, &b)
    end
  end
end
