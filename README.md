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

cd southwest-auto-check-in
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
1. If more than one person is attached to your confirmation number, you will _not_ get a text message. You will still be checked-in, however, you will need to print your boarding passes when you get to the airport. 
1. You can view/remove pending check-ins using the `atq` and `atrm` commands respectively. 

### Example Session

Below is an example session. It's fairly straightforward, but I want to highlight one thing. 

Notice I type `10` when asked for the Departure Airport Time Zone. That number represents the Chicago time zone in the list. 

You'll most commonly use:

* `0` - Eastern 
* `10` - Central 
* `17` - Mountain 
* `20` - Pacific 

```
alextran@luigi:~/code/southwest-auto-check-in$ ruby gui.rb
Confirmation Number: ABCDEF
Departure Time: (6:05 pm): 12:15 pm
Departure Date (9/4/15): 10/2/15

0 - America/New_York
1 - America/Detroit
2 - America/Kentucky/Louisville
3 - America/Kentucky/Monticello
4 - America/Indiana/Indianapolis
5 - America/Indiana/Vincennes
6 - America/Indiana/Winamac
7 - America/Indiana/Marengo
8 - America/Indiana/Petersburg
9 - America/Indiana/Vevay
10 - America/Chicago
11 - America/Indiana/Tell_City
12 - America/Indiana/Knox
13 - America/Menominee
14 - America/North_Dakota/Center
15 - America/North_Dakota/New_Salem
16 - America/North_Dakota/Beulah
17 - America/Denver
18 - America/Boise
19 - America/Phoenix
20 - America/Los_Angeles
21 - America/Metlakatla
22 - America/Anchorage
23 - America/Juneau
24 - America/Sitka
25 - America/Yakutat
26 - America/Nome
27 - America/Adak
28 - Pacific/Honolulu

Departure Airport Time Zone: 10

warning: commands will be executed using /bin/sh
job 18 at Thu Oct  1 13:15:00 2015
alextran@luigi:~/code/southwest-auto-check-in$
```