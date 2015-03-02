require 'spec_helper'
require 'pry'

describe 'MultiTabular' do
  describe '::Super' do
    context 'when included by an arbitrary AR class' do
      subject { Vehicle }
      specify { should respond_to(:child_has_one) }
      specify { should respond_to(:child_has_many) }

      it 'should be an abstract_class' do
        Vehicle.abstract_class.should == true
      end
    end
  end

  describe '::References' do
    it 'should be included in ActiveRecord::Base' do
      ActiveRecord::Base.should include(MultiTabular::References)
    end

    context 'when used by an arbitrary AR class' do
      subject { Engine }
      specify { should respond_to(:belongs_to_mti) }

      context 'which has a belongs_to_mti association' do
        before :each do
          @engine = Engine.new
          @car = Car.new
        end

        it 'should define a getter vehicle' do
          @engine.should respond_to(:vehicle)
        end

        it 'should define a setter vehicle' do
          @engine.should respond_to(:vehicle=)
        end

        it 'should belong_to every MTI subclass' do
          Engine.reflect_on_association(:car).should_not == nil
          Engine.reflect_on_association(:truck).should_not == nil
        end

        it 'should dynamically assign vehicles to their concrete association' do
          @engine.vehicle = @car
          @engine.car.should eql?(@car)
        end
      end

      context 'with belongs_to_mti to scoped classes' do
        before :each do
          Tire.belongs_to_mti :bike, base_class: 'Sport::Device::Bike'
        end

        it 'should belong_to every MTI subclass' do
          Tire.reflect_on_association(:sport_device_mountain_bike).should_not == nil
          Tire.reflect_on_association(:sport_device_racing_bike).should_not == nil
        end
      end
    end
  end
end