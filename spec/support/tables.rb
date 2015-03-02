conn = ActiveRecord::Base.connection

#########################################################
# Vehicle classes
#########################################################

conn.create_table :cars do |t|
  t.string :brand, null: false
  t.string :model, null: false
  t.integer :passengers, null: false
end

conn.create_table :trucks do |t|
  t.string :brand, null: false
  t.string :model, null: false
  t.integer :capacity, null: false
end

conn.create_table :engines do |t|
  t.string :brand, null: false
  t.string :model, null: false

  t.integer :horsepower, null: false

  t.integer :car_id
  t.integer :truck_id
end

conn.create_table :sport_device_mountain_bikes do |t|
  t.string :color, null: false
  t.string :model, null: false

  t.integer :tire_size, null: false
end

conn.create_table :sport_device_racing_bikes do |t|
  t.string :color, null: false
  t.string :model, null: false

  t.integer :weight, null: false
end