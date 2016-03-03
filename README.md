# LaunchGate

[![CI Status](http://img.shields.io/travis/dtrenz/LaunchGate.svg?style=flat)](https://travis-ci.org/detroit-labs/LaunchGate)
[![Version](https://img.shields.io/cocoapods/v/LaunchGate.svg?style=flat)](http://cocoapods.org/pods/LaunchGate)
[![License](https://img.shields.io/cocoapods/l/LaunchGate.svg?style=flat)](http://cocoapods.org/pods/LaunchGate)
[![Platform](https://img.shields.io/cocoapods/p/LaunchGate.svg?style=flat)](http://cocoapods.org/pods/LaunchGate)
[![codecov.io](https://codecov.io/github/dtrenz/LaunchGate/coverage.svg?branch=develop)](https://codecov.io/github/dtrenz/LaunchGate?branch=develop)
[![Sponsored by Detroit Labs](https://img.shields.io/badge/sponsor-Detroit%20Labs-000000.svg?style=flat)](http://www.detroitlabs.com)

LaunchGate makes it easy to let users know when an update
to your app is available.

You can also block access to the app for older versions,
which is useful in the event of a severe bug or security
issue that requires users to update the app.

Additionally, you can use LaunchGate to display a remotely
configured message to users at launch which can also be
used to temporarily block access to the app (i.e. during
back-end maintenance).

#### Need an Android version?
You're in luck! LaunchGate was built in parallel with its Android counterpart,
[Gandalf](http://btkelly.github.io/gandalf/).


## Installation

LaunchGate is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LaunchGate"
```


## Usage

LaunchGate downloads & parses a remotely hosted JSON configuration file at launch,
then takes appropriate action.

By default, LaunchGate expects a configuration file that looks something like this:

```json
{
  "ios": {
    "requiredUpdate": {
      "minimumVersion": "1.1",
      "message": "An update is required to continue using this app."
    }
  }
}
```

If you want to use a different configuration structure than the default, you can!
See the section below, for instructions on [how to provide a custom parser](#custom-configuration-parser).

#### Enabling LaunchGate

1. Import it into your `AppDelegate`.
2. Instantiate it, passing in the location of your configuration file and the
App Store URI of your app.
3. Lastly, call `launchGate?.check()` in `applicationDidBecomeActive`.

```swift
import LaunchGate


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  lazy var launchGate = LaunchGate(
    configURI: "https://www.example.com/config.json",
    appStoreURI: "itms-apps://itunes.apple.com/us/app/yourapp/id123456789"
  )

  func applicationDidBecomeActive(application: UIApplication) {
    launchGate?.check()
  }

}
```


## The Configuration File

The JSON configuration file is loaded by LaunchGate when `check()` is called.
Using this file you can trigger a few different behaviors in your app.

> _**"What's with the top-level `ios` object in the JSON? Why is that necessary?"**_
>
> The top level `"ios"` object exists because LaunchGate was created in parallel
with [Gandalf](http://btkelly.github.io/gandalf/), its Android counterpart project.
As [cross-platform mobile developers](http://www.detroitlabs.com), we understand
how annoying it can be to get two completely separate iOS & Android libraries
satisfy the same feature requirements. By developing an LaunchGate (iOS) &
[Gandalf](http://btkelly.github.io/gandalf/) (Android) together, we are able to
provide teams that build & maintained cross-platform apps a solution that should
work similarly on both iOS & Android:
>
>
> Example cross-platform configuration:
>
> ```json
{
  "android": {
    "requiredUpdate": {
      "minimumVersion": "1.1",
      "message": "An update is required to continue using this app."
    }
  },
  "ios": {
    "requiredUpdate": {
      "minimumVersion": "1.1",
      "message": "An update is required to continue using this app."
    }
  }
}
```

### Required Update

By including a `requiredUpdate` object you can specify a minimum app
version and a message that will be displayed to users that have a version that
is too old. Users with an older version will be locked out of app until they
update.

> **Scenario:** A previous version of your app had a critical bug or security
vulnerability that you have patched in the current version of the app, but you
still need to prevent users from continuing to use the older compromised version.



In this example, users with a version of the app less than "1.1" will see an
alert dialog when the app is opened, with an "Update" button that will take them
to the App Store so that they can download the latest version.

![Required Update Screenshot](https://raw.githubusercontent.com/dtrenz/LaunchGate/develop/Screenshots/required-update.png)


### Optional Update

By including an `optionalUpdate` object you can specify the current version of
the app in the App Store and a message to display to the user, possibly to
encourage them to update the app.

Optional updates can be dismissed by the user and do not block the user from
using the app. Also, an optional update dialog is only showed to the user once
per version. That way users aren't nagged relentlessly every time they open the app.

> **Scenario:** You've released a significant update to your app and want to
encourage users that do not have automatic updates enabled to upgrade.

```json
{
  "ios": {
    "optionalUpdate": {
      "optionalVersion": "1.2",
      "message": "A new version of the app is available."
    }
  }
}
```

![Optional Update Screenshot](https://raw.githubusercontent.com/dtrenz/LaunchGate/develop/Screenshots/optional-update.png)


### Alert Messages

Lastly, besides providing features related to specific app versions and updates,
you can also use LaunchGate to display an informative message to your users when
they open the app.

#### Blocking Alert

A "blocking" alert (`"blocking": true`) is an alert that is displayed to the
user when they open the app but does not give the user any option to proceed
into the app.

_**IMPORTANT** &rarr; As long as you have `blocking` set to `true` users will
be prevented from using your app, so make sure to remove or disable the blocking
alert as soon as possible._

> **Scenario:** Your app relies on a back-end web service that is temporarily down
for maintenance, and you don't want users of the app to be affected.

```json
{
  "ios": {
    "alert": {
      "message": "We are currently performing server maintenance. Please try again later.",
      "blocking": true
    }
  }
}
```

![Blocking Alert Screenshot](https://raw.githubusercontent.com/dtrenz/LaunchGate/develop/Screenshots/alert-blocking.png)


#### Non-Blocking Alert

Like the optional update dialog, non-blocking alert messages are only displayed once per message.

> **Scenario:** Your app relies on a back-end web service that is experiencing
intermittent connectivity issues and you want to warn users that they the app
experience may be degraded.

```json
{
  "ios": {
    "alert": {
      "message": "We are currently working to resolve intermittent web service issues. We apologize if your app experience is affected.",
      "blocking": false
    }
  }
}
```

![Non-Blocking Alert Screenshot](https://raw.githubusercontent.com/dtrenz/LaunchGate/develop/Screenshots/alert-nonblocking.png)


## Custom Configuration Parser

If you need to use something other than the default configuration JSON object,
you can write your own parser that conforms to the `LaunchGateParser` protocol,
and set it on the LaunchGate instance before calling `check()`.

See the [example project](https://github.com/dtrenz/LaunchGate/blob/master/Example/Example/AppDelegate.swift#L24-L27).


## Author

Dan Trenz ([@dtrenz](http://www.twitter.com/dtrenz)) c/o [Detroit Labs](http://www.detroitlabs.com)


## License

LaunchGate is available under the Apache License, Version 2.0. See the LICENSE file for more info.
