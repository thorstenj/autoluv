# Southwest Auto Check In

### Disclaimer

* I wrote this for me (your mileage may vary)

### Requirements

* A *nix server that will be on when you need it to check-in for you
* Ruby
* Access to the `at` command
* Git (not required, but will simplify installation)
# Able to send email using `sendmail`

### Installation

```
git clone https://github.com/byalextran/southwest-auto-check-in.git

gem install tzinfo
gem install mechanize
gem install pony

cd southwest-auto-check-in
```

### Configuration/Usage

Open `gui.rb` and update the variables at the top with your information.

**All of those variables are required.**

Now you're ready to rock. 

Run `ruby gui.rb` and follow the prompts. 

You can hit `[Enter]` to accept the default values seen in [brackets]. 

As you work through the prompts, you'll eventually see a list of time zones prefixed with a number. Type in the number of the time zone you want to use. 

That's it. 

Your server will now check you in 24 hours before departure. 

### Things to Note

1. An email notification will be sent with the results. If you don't see it, either you don't have `sendmail` installed or it's in your spam folder. 
1. If you're flying by yourself, you will get a text message with links to your boarding pass.
1. If more than one person is attached to your confirmation number, you will _not_ get a text message. You will still be checked-in, however, you will need to print your boarding passes when you get to the airport. 
1. You can view/remove pending check-ins using the `atq` and `atrm` commands respectively. 