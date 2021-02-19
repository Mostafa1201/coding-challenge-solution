Localytics Hands-on Coding Test
===============================

You can complete this coding test in any programming language you choose.
We recommend using a scripting language, such as Ruby, Python, or JavaScript (node).
You can use any standard or third party libraries; just be sure to include instructions on how to run your code.

**Use of Google/Stack Overflow/The Internet is strongly encouraged.**

See the following files:
 * `data/users.json` - a clean well structured JSON blob of user profile data. This data maps a user's ID to his/her gender, age, and device.
 * `data/events.json` - a clean well structured JSON blob of a time series of events (timestamped actions that users took). Each event has a `name`, an associated `user_id`, and a `timestamp` in Unix time.

You can ignore every other file and folder (`lib/`, `Gemfile`, `Rakefile`, etc.). They just contain utilities for us to clean up after the test.

Given the above data, answer the following questions in order:

 1. How many events were recorded?
 2. What is the average age of all distinct users who visited the home page?
 3. What is the overall conversion rate of a user visiting the home page and then purchasing an item? Note: if a user purchases multiple times, only count him/her once.  Note 2: The events are unordered.
 4. After a user visits the home page, what are the 3 most frequent things s/he would do next?
 5. After a user visits a blog post, what is the most frequent path of events s/he will follow to purchase the items in his/her cart? State any assumptions that you make.

Phone # of Interviewer:  555 555 5555
