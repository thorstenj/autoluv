# autoluv

### Installation

```
git clone https://github.com/byalextran/autoluv.git
cd autoluv
bundle install --deployment
```

### Example

Schedule your check ins automatically and get boarding passes sent to you via text.

```
cd bin
ruby autoluv schedule -c ABCDEF -f Alex -l Tran -b text -p 555-555-1212 -e email@domain.com
````

The email address in the command is used to notify you of the results.

For more options you can view the built-in help.

```
ruby autoluv --help
ruby autoluv schedule --help
```

### Disclaimer

This was really written for me. Your mileage may vary.