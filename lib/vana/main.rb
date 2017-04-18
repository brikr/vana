# vana, approved by servers everywhere
module Vana
  # hosts block
  class Hosts
    def initialize(*a, &b)
      @hosts = *a
      @b = b
    end

    def execute
      instance_eval(&@b)
    end
  end

  def hosts(*a, &b)
    h = Hosts.new(*a, &b)
    h.execute
  end
end
