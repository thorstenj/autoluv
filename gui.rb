FIRST_NAME = 'First'
LAST_NAME = 'Last'
PHONE = '5555551212'
EMAIL = 'email@domain.com'

# DON'T CHANGE ANYTHING BELOW THIS LINE
require 'tzinfo'

TIME_FORMAT = "%I:%M %p"
DATE_FORMAT = "%m/%d/%y"
LONG_DATE_FORMAT = "%a %b %d, %Y"

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
		check_in_time = DateTime.strptime("#{departure_time} #{departure_date}", [TIME_FORMAT, DATE_FORMAT].join(' '))

		puts %Q(
Is this right [Y/N]?

Departing on #{check_in_time.strftime(LONG_DATE_FORMAT)} at #{check_in_time.strftime(TIME_FORMAT)} #{departure_time_zone}
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

print 'Confirmation Number: '
confirmation_number = gets.chomp

tz = TZInfo::Timezone.get(departure_time_zone)

# in seconds
departure_offset = tz.current_period.utc_total_offset
server_offset = Time.now.utc_offset

offset_hours = (departure_offset - server_offset) / 3600



# we can check in a 1 day before departure time
check_in_time -= 1

# adjust our check in time based on server time zone
check_in_time -= Rational(offset_hours, 24)

at_command = "echo 'ruby southwest-auto-check-in.rb #{confirmation_number} #{FIRST_NAME} #{LAST_NAME} #{PHONE} #{EMAIL}' | at #{check_in_time.strftime(DATE_FORMAT)}"

exec(at_command)