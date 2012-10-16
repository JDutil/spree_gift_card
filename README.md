SpreeGiftCard
=============

This extension adds gift card functionality to spree.  It is based off the original [spree_gift_cards](http://github.com/spree/spree_gift_cards)
extension, but differs in that it does not require a user to have an account.  Gift cards may be redeemed by
entering a unique gift card code during checkout rather than applying store credits to the customers account.

Installation
============

1. Add `spree_gift_card` to Gemfile
1. Run `rails g spree_gift_card:install`
1. Run `rails g spree_gift_card:seed`

Testing
=======

1. bundle exec rake test_app
1. bundle exec rspec spec

Copyright (c) 2012 Jeff Dutil, released under the New BSD License
