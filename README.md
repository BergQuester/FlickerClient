# README #

A basic sample Flickr client.

### How do I get set up? ###

* Build and run with Xcode 5 or later. Requires iOS 7 or later.

### Known issues ###

* When loading the photos, Flickr server occasionally returns return data with an invalid escape sequence. The app will automatically attempt to load again, but this can cause image loading to take a few seconds.
* Currently only model objects have unit test coverage.