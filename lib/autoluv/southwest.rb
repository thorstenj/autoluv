require "rest-client"
require "fileutils"
require "json-schema"

module AutoLUV
  class Southwest
    POST_URL = "https://mobile.southwest.com/middleware/MWServlet"
    COMMON_PARAMS = { :appID => "swa", :appver => "2.17.0", :channel => "wap", :platform => "thinclient", :cacheid => "", :rcid => "spaiphone" }

    attr_reader :confirmation_number, :first_name, :last_name

    def initialize(confirmation_number, first_name, last_name)
      @confirmation_number = confirmation_number.to_s.strip
      @first_name = first_name.to_s.strip
      @last_name = last_name.to_s.strip

      raise ArgumentError, "The confirmation number must be six alphanumeric characters." if @confirmation_number !~ /^[A-Z0-9]{6}$/i
      raise ArgumentError, "First name is required." if @first_name.empty?
      raise ArgumentError, "Last name is required." if @last_name.empty?

      @cookies = {}

      # TODO: figure out how to log files from a gem
      @log_path = "~/autoluv/logs/#{@last_name}, #{@first_name}/#{@confirmation_number}"

      FileUtils.mkdir_p @log_path
    end

    def departing_flights
      get_travel_info

      hash = view_air_reservation

      results = { :success => false, :message => "", :departing_flights => [], :single_passenger => false }

      results[:message] = validate :viewairreservation, hash
      return results unless results[:message].empty?

      # TODO: handle isMultiSegment=true flights

      upcoming = hash["upComingInfo"][0]

      flight = Flight.new upcoming["Depart1"], :depart
      results[:departing_flights].push flight

      unless upcoming["Return1"].nil?
        flight = Flight.new upcoming["Return1"], :return
        results[:departing_flights].push flight
      end

      results.merge({ :success => true, :single_passenger => upcoming["passengerName1"].nil? })
    end

    def checkin(delivery_option = :print, delivery_value = nil)
      get_travel_info
      checkin_travel_alerts

      results = { :success => false, :message => "" }

      hash = flight_checkin_new
      results[:message] = validate :flightcheckin_new, hash
      return results unless results[:message].empty?

      # have to print boarding passes for multi-passenger flights
      delivery_option = :print if hash["passenger_names"].size > 1

      hash = get_all_boarding_pass
      results[:message] = validate :getallboardingpass, hash
      return results unless results[:message].empty?

      case delivery_option
      when :text
        hash = text_boarding_pass delivery_value
      when :email
        hash = email_boarding_pass delivery_value
      end

      if [:email, :text].include? delivery_option
        results[:message] = validate :viewboardingpass, hash
        return results unless results[:message].empty?

        results[:message] = hash["confirmation_text"]
      end

      results[:success] = true

      results
    end

    protected

    # used to get required cookies
    def get_travel_info
      params = { :serviceID => "getTravelInfo" }
      post params
    end

    # used to get required cookies
    def checkin_travel_alerts
      params = { :serviceID => "checkIntravelAlerts" }
      post params
    end

    def view_air_reservation
      params = { :serviceID => "viewAirReservation", :confirmationNumber => @confirmation_number, :confirmationNumberFirstName => @first_name,
        :confirmationNumberLastName => @last_name, :searchType => "ConfirmationNumber" }
      post params
    end

    def flight_checkin_new
      params = { :serviceID => "flightcheckin_new", :recordLocator => @confirmation_number, :firstName => @first_name, :lastName => @last_name }
      post params
    end

    def get_all_boarding_pass
      params = { :serviceID => "getallboardingpass" }
      post params
    end

    def email_boarding_pass(email)
      params = { :serviceID => "viewboardingpass", :optionEmail => "true", :emailAddress => email }
      post params
    end

    def text_boarding_pass(phone)
      phone = phone.to_s.gsub(/\D/, "")
      params = { :serviceID => "viewboardingpass", :optionText => "true", :phoneArea => phone[0, 3], :phonePrefix => phone[3, 3], :phoneNumber => phone[6, 4] }
      post params
    end

    def post(params)
      params.merge! COMMON_PARAMS
      response = RestClient.post(POST_URL, params, :cookies => @cookies)

      @cookies = @cookies.nil? ? response.cookies : @cookies.merge(response.cookies)

      log response, params[:serviceID]

      JSON.parse response.body
    end

    def log(response, service_id)
      File.open("#{@log_path}/#{service_id}.json", "w") do |f|
        f.write response.body
      end
    end

    def validate(service_id, hash)
      validation_error = ""

      begin
        JSON::Validator.validate!("#{__dir__}/../../schemas/schema_#{service_id}.json", hash)
      rescue JSON::Schema::ValidationError => ve
        validation_error = [hash["errmsg"].to_s.strip, "ERROR: #{ve.message}"].join(" ").strip
      end

      validation_error
    end
  end
end