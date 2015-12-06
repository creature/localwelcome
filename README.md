# Local Welcome

[![Build Status](https://travis-ci.org/creature/localwelcome.svg)](https://travis-ci.org/creature/localwelcome)

Local Welcome is a project to help new refugees meet people in their community. The big goal is to help people get back into their industry - for instance, introducing a Syrian dentist to a British dentist. Meetups are held around the country on the first Sunday of each month. 

At the moment, all the meetups have been organised "by hand" using a combination of Eventbrite, Google Docs, and human co-ordinators. This project is a prototype to see if some custom software would help save time, allow other people to run local chapters independently, and give them their own permanent web presence. **It is a prototype**, so I don't know if it will ever hit production. 

I've been experimenting with [livestreaming my work on Twitch](http://twitch.tv/acotn). Feedback is welcomed! 


## Getting started

Local Welcome is a standard Rails app. As long as you have Ruby and Bundler installed, running the app should be as simple as:

```
bundle install
bundle exec rake db:setup
bundle exec rails server
```

## Running tests

I'm using RSpec as a test framework. You can run the test suite with the following command: 

```
bundle exec rake spec
```

The [Thoughtbot article about Rails testing](https://robots.thoughtbot.com/how-we-test-rails-applications) is my preferred crib sheet for Rails tests.
