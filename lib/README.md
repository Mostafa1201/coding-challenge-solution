Admin tasks for coding test
===========================

*Note: please ignore this folder if you are an interview candidate.*

All commands should be run from the parent directory (where the Rakefile is)

### Setup

```
bundle install
```

### Email solution

```
sudo postfix start
rake email_solution name="Joe Interviewee"
```

### Clean up folder for next candidate

```
rake clean
```

### Generate data for the test

The data that is checked-in should be used for all coding tests. 
In the event that you need to generate new data, run:

```
rake clean_generate
rake generate
```
