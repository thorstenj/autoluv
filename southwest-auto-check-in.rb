require 'mechanize'
require 'pony'

class SouthwestAutoCheckIn
  CHECK_IN_PAGE = 'https://www.southwest.com/flight/retrieveCheckinDoc.html'

  def initialize(args)
    @confirmation_number = args[0]
    @first_name = args[1]
    @last_name = args[2]

    # remove non-digits from phone number
    @phone_number = args[3].gsub(/\D/, '')

    @email_address = args[4]

    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac FireFox'
  end

  def check_in()
    # i don't know how well my server's clock is synced with southwest's, 
    # so i'm going to try to check-in every 15 seconds (up to two minutes). 
    8.times do |x|
      @errors = []

      retrieve_itinerary

      if @errors.size == 0
        # no errors must mean we can actually check-in
        confirm_itinerary

        if @page.search('#printButton').size == 0
          # if we don't see a print button, that means we're checking in an individual
          # and we have one more step: selecting how we want our boarding pass. 
          text_boarding_pass
        end        

        @attempts = x + 1

        break
      end

      # try again in 15 seconds
      sleep(15)
    end

    email_results

    return @errors
  end

  private

  def retrieve_itinerary()
    @page = @agent.get(CHECK_IN_PAGE)

    itinerary = @page.form('retrieveItinerary')

    itinerary.confirmationNumber = @confirmation_number
    itinerary.firstName = @first_name
    itinerary.lastName = @last_name

    @page = @agent.submit(itinerary)

    # using .list_errors instead of #errors because #errors is also used on the success page
    errors = @page.search('.list_errors li') 

    if errors.size > 0
      errors.each {|e| @errors.push(e.inner_html) }
    end
  end

  def confirm_itinerary()
    confirm = @page.form('checkinOptions')

    # have to explicitly specify which button to click (since mimicking hitting return won't submit this form)
    @page = @agent.submit(confirm, confirm.button_with(:name => 'printDocuments'))
  end

  def text_boarding_pass()
    options = @page.form_with(:id => 'mobileBoardingPassOptionsForm')
    
    options.radiobutton_with(:id => 'optionText').check
    
    options.phoneArea = @phone_number[0, 3]
    options.phonePrefix = @phone_number[3, 3]
    options.phoneNumber = @phone_number[6, 4]

    @page = @agent.submit(options)
  end

  def email_results()
    subject = "[Southwest] Check-in succeeded after #{@attempts} attempt(s)"
    body = ''

    if @errors.size > 0
      subject = '[Southwest] Check-in failed'
      @errors.each {|e| body += e + "\n" }
    end

    Pony.mail(:to => @email_address, :from => 'southwest-auto-check-in@localhost', :subject => subject, :body => body)
  end
end

swa = SouthwestAutoCheckIn.new(ARGV)
swa.check_in