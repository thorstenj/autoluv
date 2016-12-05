# autoluv

Ensure you have your pick of window or aisle seat by letting `autoluv` handle your Southwest check in automatically.

### Disclaimer

* I wrote this for me (your mileage may vary)
* Works on Ubuntu 14.04 (hosted by Digital Ocean)

### Requirements

* A *nix based server that will be on when you need to check in
* Access to the `at` command
* Sendmail

### Clean Install

```
git clone https://github.com/byalextran/autoluv.git
cd autoluv
bundle install --deployment
```

### Upgrading

I pulled the Southwest check-in code into a gem called [luvwrapper](https://github.com/byalextran/luvwrapper).

You'll need to update the dependencies with the following:

```
cd autoluv
git pull
bundle
```

### Schedule a Check In

```
./bin/autoluv schedule -c ABCDEF -f Alex -l Tran -e email@domain.com -b text -p 555-555-1212
````

The command above schedules your check ins and sends you a text with your boarding passes. Both departing and return flights (if applicable) will be scheduled for check in.

An email address is supplied so the results of the check in can be emailed out. That way if something goes wrong, you'll know and can manually check in.

Note: I haven't been able to test if email and text boarding passes work with multi-passenger itineraries. With the old API it wouldn't work. Not sure if it's supported in the new API. All that to say, if you have a flight with multiple passengers and your check-in succeeded but you don't get your boarding passes emailed or texted to you, chances are it's not supported.

### Deleting a Scheduled Check In

The `at` command is used behind the scenes to check in at a specified time. Use the `atq` command to see what's scheduled and then `atrm` to delete one.

See example below.

```
$ atq
6	Fri Dec 11 08:45:00 2015 a user
5	Tue Dec 15 14:05:00 2015 a user
$ atrm 5
$ atq
6	Fri Dec 11 08:45:00 2015 a user
```

### Further Documentation

```
./bin/autoluv schedule --help
./bin/autoluv checkin --help
./bin/autoluv lookup --help
```
