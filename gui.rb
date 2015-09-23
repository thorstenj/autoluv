first_name = 'First'
last_name = 'Last'
phone_number = '555-555-1212'
email = 'email@domain.com'

# DON'T CHANGE ANYTHING BELOW THIS LINE
require 'tzinfo'

TIME_FORMAT = "%I:%M %p"
DATE_FORMAT = "%m/%d/%y"
LONG_DATE_FORMAT = "%a %b %d, %Y"
FULL_FORMAT = TIME_FORMAT + ' ' + DATE_FORMAT

confirmation_number = ''

loop do
	print "Confirmation Number [#{confirmation_number}]: "
	temp = gets.chomp
	confirmation_number = temp unless temp.empty?

	print "First Name [#{first_name}]: "
	temp = gets.chomp
	first_name = temp unless temp.empty?

	print "Last Name [#{last_name}]: "
	temp = gets.chomp
	last_name = temp unless temp.empty?

	print "Phone Number [#{phone_number}]: "
	temp = gets.chomp
	phone_number = temp unless temp.empty?

	print "Email [#{email}]: "
	temp = gets.chomp
	email = temp unless temp.empty?

	puts %Q(
Confirmation Number: #{confirmation_number}
Name: #{first_name} #{last_name}
Phone Number: #{phone_number}
Email: #{email}

Is this above correct [Y/N]?
	)

	break if gets.chomp.upcase == 'Y'
end

puts

tz = nil
check_in_time = nil

loop do
	print 'Departure Time (HH:MM am/pm): '
	departure_time = gets.chomp

	print 'Departure Date (MM/DD/YY): '
	departure_date = gets.chomp

	zi = TZInfo::Country.get('US').zone_identifiers

	puts

	zi.each_with_index do |zone, index|
	  puts "#{index} - #{zone}"
	end

	puts

	print 'Departure Airport Time Zone: '

	departure_time_zone = zi[gets.chomp.to_i]

	begin
		tz = TZInfo::Timezone.get(departure_time_zone)

		check_in_time = DateTime.strptime("#{departure_time} #{departure_date}", FULL_FORMAT)

		puts %Q(
Departing on #{check_in_time.strftime(LONG_DATE_FORMAT)} at #{check_in_time.strftime(TIME_FORMAT)} #{departure_time_zone}

Is this above correct [Y/N]?
		)

		break if gets.chomp.upcase == 'Y'
	rescue
		puts %q(
******************************************************

Try again. Invalid departure time, date, or time zone.

******************************************************
			)
	end
end

puts

# offsets are in seconds
departure_offset = tz.current_period.utc_total_offset
server_offset = Time.now.utc_offset

# convert offset into hours
offset_hours = (departure_offset - server_offset) / 3600

# we can check in a 1 day before departure time
check_in_time -= 1

# adjust our check in time based on server time zone
# DateTime supports adding/subtracting months and days, but not hours. 
# the use of Rational() below is a workaround. 
# http://stackoverflow.com/questions/238684/subtract-n-hours-from-a-datetime-in-ruby
check_in_time -= Rational(offset_hours, 24)

at_command = "echo 'ruby southwest-auto-check-in.rb #{confirmation_number} #{first_name} #{last_name} #{phone_number} #{email}' | at #{check_in_time.strftime(FULL_FORMAT)}"

exec(at_command)