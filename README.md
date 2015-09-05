# Southwest Auto Check In

### Disclaimers

* There's virtually zero error checking in the code (so type out your information carefully and in the right format)
* I wrote this for me (your mileage may vary)

### Requirements

* A *nix server that will be on when you need it to check-in for you
* Ruby
* Access to the `at` command
* Git (not required, but will simplify installation)

### Installation

```
git clone https://github.com/byalextran/southwest-auto-check-in.git

gem install tzinfo
gem install mechanize
gem install pony
```

### Configuration/Usage

Open `gui.rb` and update the variables at the top with your information.

**All of those variables are required.**

Now you're ready to rock. 

Run `ruby gui.rb` and follow the prompts. 

It'll ask you for:

* Confirmation number
* Departure Time
* Departure Date
* Departure Airport Time Zone

It'll show you what format to use for the time/date. **Follow the format.**

You'll see a list of time zones prefixed with a number. Type in the number of the time zone you want to use. 

That's it. 

Your server will now check you in 24 hours before departure. 

### Things to Note

1. An email notification will be sent with the results. There's a strong chance it will land in your junk/spam folder so check there if you don't see it. 
1. If you're flying by yourself, you will get a text message with links to your boarding pass.
1. If more than one person is attached to your confirmation number, you will _not_ get a text message. You will still be checked-in, however, you will need to print your parties boarding passes when you get to the airport. 