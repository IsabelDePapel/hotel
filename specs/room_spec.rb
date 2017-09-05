require_relative 'spec_helper'

describe "Testing Room class" do
  describe "#initialize" do
    before do
      @room = Hotel::Room.new(4)
    end

    it "Creates a Room object" do
      @room.must_be_instance_of Hotel::Room
    end

    it "Sets a default rate if no rate provided" do
      @room.rate.must_equal Hotel::Room::DEFAULT_RATE
    end

    it "Raises an error if room number isn't between 1 & 20" do
      proc { Hotel::Room.new(0) }.must_raise ArgumentError
      proc { Hotel::Room.new(-2) }.must_raise ArgumentError
      proc { Hotel::Room.new(21) }.must_raise ArgumentError
    end

    it "Raises an error if room number isn't an integer" do
      proc { Hotel::Room.new("cat") }.must_raise ArgumentError
      proc { Hotel::Room.new(4.23) }.must_raise ArgumentError
      proc { Hotel::Room.new(nil) }.must_raise ArgumentError
    end

  end

  describe "#self.all" do
    before do
      @all_rooms = Hotel::Room.all
    end

    it "Returns a list of all the rooms in the hotel" do
      @all_rooms.must_be_kind_of Array
      @all_rooms.length.must_equal Hotel::NUM_ROOMS
    end

    it "Each hotel must have a different number between 1 & NUM_ROOMS" do
      room_nums = (1..Hotel::NUM_ROOMS).to_a

      @all_rooms.each do |room|
        room_nums.delete(room.room_num)
      end

      room_nums.must_equal []
    end

  end
end
