class Vehicle < ActiveRecord::Base
  include MultiTabular::Super
  child_has_one :engine, define_inverse: true
end

class Car < Vehicle
end

class Truck < Vehicle
end

class Engine < ActiveRecord::Base
end

module SpaceAir
  class Craft < ActiveRecord::Base
    include MultiTabular::Super
    child_has_one :propulsion_engine
  end

  class Rocket < Craft
  end

  class Jet < Craft
  end
end

module Sport
  module Device
    class Bike < ActiveRecord::Base
      include MultiTabular::Super
      child_has_many :tires
    end

    class MountainBike < Bike
    end

    class RacingBike < Bike
    end
  end
end

class Tire < ActiveRecord::Base
end