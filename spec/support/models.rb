class Vehicle < ActiveRecord::Base
  include MultiTabular::Super
  child_has_one :engine
end

class Car < Vehicle
end

class Truck < Vehicle
end

class Engine < ActiveRecord::Base
  belongs_to_mti :vehicle, base_class: 'Vehicle'
  # belongs_to :car, class_name: 'Car'
  # belongs_to :truck, class_name: 'Truck'
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