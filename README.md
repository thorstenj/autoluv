# autoluv

```
bundle install --deployment
ruby bin/autoluv --help
```

### Example

Schedule your check ins automatically and get boarding passes sent to you via text.

```
ruby bin/autoluv schedule -c ABCDEF -f Alex -l Tran -b text -p 555-555-1212
````

### Disclaimer

This was really written for me. Your mileage may vary. I did hardcode my email address into bin/autoluv so if you're going to use this, you should probably update that. ;)