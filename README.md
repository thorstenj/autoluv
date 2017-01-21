# autoluv

Ensure you have your pick of window or aisle seat by letting `autoluv` handle your Southwest check in automatically.

### Disclaimer

* I wrote this for me (your mileage may vary)
* Works on Ubuntu 14.04 (hosted by Digital Ocean)

### Requirements

* A *nix based server that will be on when you need to check in
* Ruby installed
* The `at` package installed
* An SMTP server (recommended) or Sendmail properly configured

### Clean Install

```
git clone https://github.com/byalextran/autoluv.git
cd autoluv
bundle install --deployment
```

#### Configure SMTP settings (recommended)

Doing this step will result in more reliable notification emails. Those emails let you know the result of a scheduled check-in and are useful in the rare case a check-in fails. They serve as a reminder to check-in manually as soon as possible.

```
nano .env
```

Then copy/paste the following into the text editor:

```
FROM_EMAIL = helloworld@gmail.com
SMTP_SERVER = smtp.gmail.com
PORT = 587
USER_NAME = helloworld@gmail.com
PASSWORD = supersecurepassword
```

Replace the values with the appropriate SMTP settings for your email provider and save the file (`Ctrl+O` to save, `Ctrl+X` to exit the editor).

Here are settings for the most common ones:

* [Yahoo](https://www.lifewire.com/what-are-yahoo-smtp-settings-for-email-1170875)
* [Gmail](https://www.lifewire.com/what-are-the-gmail-smtp-settings-1170854)
* [AOL](https://www.lifewire.com/what-are-aol-mail-smtp-settings-1170849)
* [Comcast](https://customer.xfinity.com/help-and-support/internet/email-client-programs-with-xfinity-email/)
* [AT&T](https://www.att.com/esupport/article.html#!/dsl-high-speed/KM1010523)

If yours isn't listed, search Google for "EMAIL_PROVIDER_HERE SMTP server" (e.g. Outlook SMTP server, Time Warner SMTP server). The first result will typically be what you need.

**Note**: Be sure you create an app-specific password and use it above if you've enabled two-factor authentication for your email account.

### Upgrading

I pulled the Southwest check-in code into a gem called [luvwrapper](https://github.com/byalextran/luvwrapper).

You'll need to update the dependencies with the following:

```
cd autoluv
git pull origin master
bundle
```

It's also a good idea to do this periodically.

### Schedule a Check In

```
./bin/autoluv schedule -c ABCDEF -f Alex -l Tran -e hello@world.com -b text -p 555-555-1212
````

The command above schedules your check ins and sends you a text with your boarding passes. Both departing and return flights (if applicable) will be scheduled for check in.

An email address is supplied so the results of the check in can be emailed out. That way if something goes wrong, you'll know and can manually check in.

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
