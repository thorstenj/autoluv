require "tzinfo"
require "csv"

module AutoLUV
  class Flight
    attr_reader :time, :city, :state, :airport_code

    def initialize(flight_info, segment)
      raise ArgumentError, "Flight info is required." if flight_info.nil?
      raise ArgumentError, "Segment must be :depart or :return." unless segment == :depart || segment == :return

      date = flight_info["#{segment}Date"]

      dc = flight_info["departCity"]

      # 12:15 PM Dallas (Love Field), TX (DAL)
      m = dc.match /^(?<time>\d{1,2}:\d{2} +(AM|PM)) +(?<city>.+), +(?<state>[A-Z]{2}) +\((?<airport_code>[A-Z]{3})\)$/i

      @city = m[:city]
      @state = m[:state]
      @airport_code = m[:airport_code]

      time_zone = Flight.airport_time_zone @airport_code
      tz = TZInfo::Timezone.get(time_zone)
      zone_abbreviation = tz.current_period.abbreviation

      # Monday, Oct 19, 2015 12:15 PM CDT
      @time = Time.strptime("#{date} #{m[:time]} #{zone_abbreviation}", "%A, %b %d, %Y %I:%M %p %Z")
    end

    def to_s
      # Monday, October 19, 2015 at 12:15 PM from DAL - Dallas (Love Field), TX
      "#{@time.strftime("%A, %B %d, %Y at %I:%M %p")} from #{@airport_code} - #{[@city, @state].join(', ')}"
    end

    private

    def self.airport_time_zone(airport_code)
      CSV.foreach("#{__dir__}/../../data/iata-america.tzmap", { :col_sep => "\t" }) do |row|
        return row[1] if row[0].strip.upcase == airport_code.to_s.strip.upcase
      end

      raise ArgumentError, "Unrecognized airport code: #{airport_code}."
    end
  end
end
