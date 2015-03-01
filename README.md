multi_tabular
==========================
A multi table inheritance gem for Ruby on Rails.

This gem is based on Dan Chak's *Enterprise Rails*.

I provide this gem 'as is'. It has been extracted out of a WIP project with good test coverage, however the gem in itself is not currently tested. Feel free to contribute.

Compatibility
=============

multi_tabular is Rails 4.x compatible.


How to Include
==============

From your Gemfile:

    gem 'multi_tabular', git: 'git://github.com/alexJunger/multi_tabular'
    
Usage
===============

Basically, this is how your multi table inheritance setup looks like on the model-layer:

```ruby
  class Vehicle < ActiveRecord::Base
    include MultiTabular::Super
  end
  
  class Car < Vehicle
    self.table_name = 'cars'
  end
  
  class Truck < Vehicle
    self.table_name = 'trucks'
  end
```

Migrations
------------------

The superclass will not be represented in the database. Every subclass stores all of it's data in it's own
atable. This means that shared parts of the schema (e.g. `wheels:integer`) need to be placed separately in each subclass's table.

```ruby
  class CreateMtiTables < ActiveRecord::Migration
    def change
      create_table :cars do |c|
        c.integer :wheels
        c.integer :max_passengers
      end
      
      create_table :trucks do |c|
        c.integer :wheels
        c.integer :freight_capacity
      end
    end
  end
```

Additionally, each table refering to the MTI construct needs a foreign key for to each subclass table (in our example,
`car` and `truck`. In a production environment, we also want to ensure that only one foreign key column is used at a
time. An engine should not belong to a car and a vehicle. The example below shows a way to do this for Postgres.


```ruby
# This migration creates an engine table.
# For each vehicle subclass, we will create a foreign key.
class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.integer :horsepower
      
      t.integer :car_id, index: true
      t.integer :truck_id, index: true
    end

    # Now we create a constraint that checks that only one column is set at a time.
    # (This statement will vary from DB to DB.)
    execute "alter table engines drop constraint if exists engines_xor"
    execute "alter table engines add constraint engines_xor check(
              (car_id is not null)::integer +
              (truck_id is not null)::integer <= 1
            );"
  end
end
```

Classes
---------------

Let's start with a basic example of class inheritance: A superclass `Vehicle` with two subclasses `Car`, `Truck`.
```ruby
# This class won't need any representation in the database.
# It can be used for shared logic of it's subclasses.

class Vehicle < ActiveRecord::Base
  include MultiTabular::Super
  
  def can_drive?
   true
  end
end

require_relative 'car'
require_relative 'truck'
```

```ruby
# This class will assume ownership of a 'cars' table in the database.

class Car < Vehicle
  include MultiTabular::Sub
  
  # wheels:integer
  # max_passengers:integer
end
```

```ruby
# This class will assume ownership of a 'trucks' table in the database.

class Truck < Vehicle
  include MultiTabular::Sub
  
  # wheels:integer
  # freight_capacity:integer
end
```

Associations
----------------
#### belongs_to_mti
Provides a getter and setter method (`vehicle`, `vehicle=`) that handles the dynamic type of `:vehicle`.
```ruby
class Engine < ActiveRecord::Base
  belongs_to_mti :vehicle, base_class: 'Vehicle'
  belongs_to :car, class_name: 'Car', foreign_key: 'car_id'
  belongs_to :truck, class_name: 'Truck', foreign_key: 'truck_id'
  
  # horsepower:integer
end
```

#### has_one
```ruby
class Vehicle
  def self.inherited_associations(child)
    child.has_one :engine, foreign_key: child.to_foreign_key
  end
end
```

#### has_many
```ruby
class Vehicle
  def self.inherited_associations(child)
    child.has_many :engines, foreign_key: child.to_foreign_key
  end
end
```

Record creation
----------------

```ruby
  car   = Car.create(wheels: 4, max_passengers: 6)
  truck = Truck.create(wheels: 4, freight_capacity: 9001)
  
  engine = Engine.create(horsepower: 150, vehicle: car)
  # engine.car == engine.vehicle == car
```

Further information
-----------------
multi_tabular makes a lot of assumptions about the names of your tables, models etc. - please use the conventions provided here, or you might experience problems.
