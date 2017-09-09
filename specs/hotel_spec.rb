# require_relative 'spec_helper'
#
# describe "Testing Hotel class" do
#   let(:hotel) { Hotel::Hotel.new }
#
#   describe "#initialize" do
#
#     it "Creates a hotel class with a hash of rooms" do
#       hotel.must_be_instance_of Hotel::Hotel
#       hotel.rooms.must_be_kind_of Hash
#
#       rooms.each do |room_num, room|
#         room.must_be_instance_of Hotel::Room
#       end
#     end
#
#     it "Creates a hotel with NUM_ROOMS num of rooms as the default" do
#       hotel.rooms.length.must_equal Hotel::Hotel::NUM_ROOMS
#     end
#
#     it "Creates a hotel with the specified number of rooms" do
#       num_rooms = 17
#       new_hotel = Hotel::Hotel.new(num_rooms)
#       new_hotel.rooms.length.must_equal num_rooms
#     end
#
#     it "Raises an error if not passed a valid number for num of rooms" do
#       proc { Hotel::Hotel.new(-1) }.must_raise ArgumentError
#       proc { Hotel::Hotel.new(0) }.must_raise ArgumentError
#     end
#
#     it "Creates rooms with room nums between 1 & specified number of rooms" do
#       num_rooms = 25
#       big_hotel = Hotel::Hotel.new(num_rooms)
#       num_big_hotel_rooms = big_hotel.rooms.length
#
#       big_hotel.rooms.each do |room_num, room|
#         room_num.must_be :>=, 1
#         room_num.must_be :<=, num_big_hotel_rooms
#       end
#     end
#
#   end
#
#   describe "#reserve" do
#     let(:hotel) { Hotel::Hotel.new }
#     let(:room1) { hotel.rooms[1] }
#     let(:check_in) { Date.today }
#     let(:check_out) { Date.today + 3 }
#
#     it "Reserves the given room for the given dates" do
#       room1.reservations.must_equal []
#
#       hotel.reserve(Date.today + 4, Date.today + 6, room1)
#       new_res = Hotel::Reservation.new(Date.today + 4, Date.today + 6, room1)
#       room1.reservations[0].must_equal new_res
#     end
#
#     it "Raises error when it tries to reserve a room that's already reserved" do
#
#       hotel.reserve(check_in, check_out, room1)
#
#       proc { hotel.reserve(check_in + 2, check_out, room1) }.must_raise ArgumentError
#
#     end
#
#     it "Raises error when it tries to reserve a room that's in a block" do
#
#       Hotel::Block.new(check_out, check_out + 3, 0.2, [room1])
#
#       proc { hotel.reserve(check_out, check_out + 1, room1) }.must_raise ArgumentError
#
#     end
#
#   end
#
#   describe "#find_reservations_by_date" do
#     before do
#       @hotel = Hotel::Hotel.new
#
#       # res that doesn't conflict with 9/5/18
#       5.times do |num|
#         room = @hotel.rooms[1 + num]
#         @hotel.reserve(Date.new(2018,9,1), Date.new(2018,9,4), room)
#       end
#
#       # res that does conflict with 9/5/18
#       5.times do |num|
#         room = @hotel.rooms[6 + num]
#         @hotel.reserve(Date.new(2018,9,4), Date.new(2018,9,9), room)
#       end
#
#       # res with start date conflicting with 9/5/18
#       5.times do |num|
#         room = @hotel.rooms[11 + num]
#         @hotel.reserve(Date.new(2018,9,5), Date.new(2018,9,9), room)
#       end
#
#       # res with end date not conflicting with 9/5/18
#       5.times do |num|
#         room = @hotel.rooms[16 + num]
#         @hotel.reserve(Date.new(2018,9,3), Date.new(2018,9,5), room)
#       end
#
#       @date_to_check = Date.new(2018,9,5)
#       @res_list = @hotel.find_reservations_by_date(@date_to_check)
#     end
#
#     it "Returns a list of reservations for that date" do
#       @res_list.must_be_kind_of Array
#     end
#
#     it "Doesn't include reservations w/a check-out date matching date" do
#       @res_list.length.must_equal 10
#
#       room3 = @hotel.rooms[2]
#       @hotel.reserve(Date.new(2018,9,4), Date.new(2018,9,5), room3)
#
#       updated_res = @hotel.find_reservations_by_date(@date_to_check)
#       updated_res.length.must_equal 10
#
#       @hotel.reserve(Date.new(2018,9,5), Date.new(2018,9,6), room3)
#       updated_res = @hotel.find_reservations_by_date(@date_to_check)
#       updated_res.length.must_equal 11
#     end
#   end
#
#   describe "#find_avail_rooms" do
#     before do
#       @hotel = Hotel::Hotel.new
#
#       # res that doesn't conflict with 9/5/18 - 9/7/18
#       5.times do |num|
#         room = @hotel.rooms[1 + num]
#         @hotel.reserve(Date.new(2018,9,1), Date.new(2018,9,4), room)
#       end
#
#       # res that does conflict with 9/5/18-9/7/18
#       5.times do |num|
#         room = @hotel.rooms[6 + num]
#         @hotel.reserve(Date.new(2018,9,4), Date.new(2018,9,9), room)
#       end
#
#       # res conflicting with 9/5/18-9/7/18
#       5.times do |num|
#         room = @hotel.rooms[11 + num]
#         @hotel.reserve(Date.new(2018,9,5), Date.new(2018,9,9), room)
#       end
#
#       # res not conflicting with 9/5/18-9/7/18
#       5.times do |num|
#         room = @hotel.rooms[16 + num]
#         @hotel.reserve(Date.new(2018,9,3), Date.new(2018,9,5), room)
#       end
#
#       @start_date = Date.new(2018,9,5)
#       @end_date = Date.new(2018,9,7)
#
#     end
#
#     it "Returns a hash of rooms available for the given date range" do
#       avail_rooms = @hotel.find_avail_rooms(@start_date, @end_date)
#       avail_rooms.must_be_kind_of Hash
#
#       avail_rooms.each do |room_num, room|
#         room.must_be_instance_of Hotel::Room
#       end
#     end
#
#     it "Counts rooms as available if check_out date equals start_date of another reservation" do
#       expected_availability = 10
#       avail_rooms = @hotel.find_avail_rooms(@start_date, @end_date)
#       avail_rooms.length.must_equal expected_availability
#
#       room1 = @hotel.rooms[1]
#       @hotel.reserve(Date.new(2018,9,4), @start_date, room1)
#       @hotel.find_avail_rooms(@start_date, @end_date).must_equal avail_rooms
#
#       @hotel.reserve(@start_date, Date.new(2018,9,6), room1)
#       updated_avail_rooms = @hotel.find_avail_rooms(@start_date, @end_date)
#       updated_avail_rooms.length.must_equal expected_availability - 1
#       updated_avail_rooms.wont_include room1
#
#       room_block = (@hotel.rooms.select { |room_num, room| room_num > 15 }).values
#       Hotel::Block.new(@start_date, @end_date, 0.2, room_block)
#       updated_avail = @hotel.find_avail_rooms(@start_date, @end_date)
#
#       updated_avail.length.must_equal expected_availability - 6
#       room_block.each do |room|
#         updated_avail.wont_include room
#       end
#
#     end
#
#     it "Raises ArgumentError if start date is later than end date" do
#       room1 = @hotel.rooms[1]
#       proc { @hotel.find_avail_rooms(@end_date, @start_date, room1) }.must_raise ArgumentError
#
#       proc { @hotel.find_avail_rooms(@end_date, @end_date, room1) }.must_raise ArgumentError
#     end
#   end
#
#
# end
