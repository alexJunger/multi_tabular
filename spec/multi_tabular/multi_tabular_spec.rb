require 'spec_helper'
require 'pry'

describe MultiTabular do
  describe MultiTabular::Super do
    context 'when included' do
      subject { Vehicle }
      specify { should respond_to(:child_has_one) }
      specify { should respond_to(:child_has_many) }

      it 'should be an abstract_class' do
        Vehicle.abstract_class.should == true
      end
    end
  end

  describe MultiTabular::References do
    it 'is included in ActiveRecord::Base' do
      ActiveRecord::Base.should include(MultiTabular::References)
    end

    describe 'a class that uses it' do
      subject(:Engine) { Engine }

      it 'responds to belongs_to_mti' do
        should respond_to(:belongs_to_mti)
      end

      context 'which belongs to Vehicle' do
        before do
          Engine.belongs_to_mti :vehicle, base_class: 'Vehicle'
        end

        it 'belongs to Car < Vehicle' do
          Engine.reflect_on_association(:car).should_not be_nil
        end

        it 'belongs to Truck < Vehicle' do
          Engine.reflect_on_association(:truck).should_not be_nil
        end

        describe 'an instance' do
          subject(:engine) { Engine.new }
          let(:car) { Car.new }

          it { should respond_to(:vehicle) }
          it { should respond_to(:vehicle=) }
          it { should respond_to(:car) }
          it { should respond_to(:car=) }
          it { should respond_to(:truck) }
          it { should respond_to(:truck=) }

          context 'when a car has been assigned with vehicle=' do
            before do
              engine.vehicle = car
            end

            it 'retrieves that same car by the car method' do
              expect(engine.car).to be(car)
            end

            context 'and a truck is assigned with vehicle= afterwards' do
              before do
                engine.vehicle = Truck.new
              end

              it 'no longer has a car' do
                expect(engine.car).to be_nil
              end
            end
          end

          context 'when a car has been assigned with car=' do
            before do
              engine.vehicle = car
            end

            it 'retrieves that same car by the vehicle method' do
              expect(engine.vehicle).to be(car)
            end

            it 'retrieves no truck' do
              expect(engine.truck).to be_nil
            end
          end
        end
      end

      context 'which belongs to SpaceAir::Craft' do
        before do
          Engine.belongs_to_mti :craft, base_class: 'SpaceAir::Craft'
        end

        it 'belongs to SpaceAir::Jet < SpaceAir::Craft' do
          subject.reflect_on_association(:space_air_jet).should_not be_nil
        end

        it 'belongs to SpaceAir::Rocket < SpaceAir::Craft' do
          subject.reflect_on_association(:space_air_rocket).should_not be_nil
        end

        describe 'an instance' do
          subject(:engine) { Engine.new }
          let(:rocket) { SpaceAir::Rocket.new }

          it { should respond_to(:craft) }
          it { should respond_to(:craft=) }
          it { should respond_to(:space_air_jet) }
          it { should respond_to(:space_air_jet=) }
          it { should respond_to(:space_air_rocket) }
          it { should respond_to(:space_air_rocket=) }

          context 'when a rocket has been assigned with craft=' do
            before do
              engine.craft = rocket
            end

            it 'retrieves that same rocket by the rocket space_air_rocket method' do
              expect(engine.space_air_rocket).to be(rocket)
            end

            context 'and a jet is assigned with craft= afterwards' do
              before do
                engine.craft = SpaceAir::Jet.new
              end

              it 'no longer has a rocket' do
                expect(engine.space_air_rocket).to be_nil
              end
            end
          end

          context 'when a rocket has been assigned with space_air_rocket=' do
            before do
              engine.space_air_rocket = rocket
            end

            it 'retrieves that same car by the vehicle method' do
              expect(engine.craft).to be(rocket)
            end

            it 'retrieves no jet' do
              expect(engine.space_air_jet).to be_nil
            end
          end
        end
      end
    end

    describe 'a scoped class that uses it' do
      subject(:Tire) { Sport::Device::Tire }

      context 'with belongs_to_mti to scoped classes' do
        before do
          Tire.belongs_to_mti :bike, base_class: 'Sport::Device::Bike'
        end

        it 'belongs to every MTI subclass' do
          Tire.reflect_on_association(:sport_device_mountain_bike).should_not be_nil
          Tire.reflect_on_association(:sport_device_racing_bike).should_not be_nil
        end
      end
    end
  end
end