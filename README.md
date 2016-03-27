# Local Welcome

[![Build Status](https://travis-ci.org/creature/localwelcome.svg)](https://travis-ci.org/creature/localwelcome)

Local Welcome is a project to help new refugees meet people in their community. The big goal is to help people get back into their industry - for instance, introducing a Syrian dentist to a British dentist. Meetups are held around the country on the first Sunday of each month. 

Previously, all the meetups were organised "by hand" using a combination of Eventbrite, Google Docs, and human co-ordinators. The aim of this webapp is to save time, allow other people to run local chapters independently, give the project its own permanent web presence, and remove the bottleneck/single point of failure of having a single overall co-ordinator. 

The app is live at http://www.local-welcome.org/ now.

## Videos

I've been experimenting with [livestreaming my work on Twitch](http://twitch.tv/acotn). Feedback is welcomed! 

I've also made a [screencast to show chapter organisers how to add & announce events](https://www.youtube.com/watch?v=YKF--Cfc_3U).


## Getting started

Local Welcome is a standard Rails app. As long as you have Ruby and Bundler installed, running the app should be as simple as:

```
bundle install
bundle exec rake db:setup
bundle exec rails server
```

You can login as an admin with the username "admin@example.com" and the password "password".


## Running tests

I'm using RSpec as a test framework. You can run the test suite with the following command: 

```
bundle exec rake spec
```

The [Thoughtbot article about Rails testing](https://robots.thoughtbot.com/how-we-test-rails-applications) is my preferred crib sheet for Rails tests.
