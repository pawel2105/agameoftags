A Game of Tags
==============
This is a Ruby on Rails application created to help Instagram users find better hashtags for their images in order to help growth their accounts. Unfortunately it wasn't approved by the IG API team so I gave up because I didn't want to waste too much time for a side-project.

Setup
=====
If you clone this repository, do the usual `bundle install` and DB preparations as you would for any other rails application. Be sure to have Redis installed and running because you'll need to run Sidekiq for this. You can install redis-server using brew:

    brew install redis-server

You can then start it using:

    redis-server

Then in another tab you can run sidekiq:

    sidekiq

Tests
=====
There's a few unit and integration specs in the `/spec` folder.

Tasks
=====
There's a rake task that runs every 5 minutes to check whether all search batch queries have completed.

Git history
===========
This repository had some secret keys because it was private (and this was a quick and dirty approach). Because of this I've erased the previous git commit tree and replaced it with this single commit. Sorry about that.