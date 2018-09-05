Pod::Spec.new do |s|
  s.name             = "LaunchGate"
  s.version          = "1.1.4"
  s.summary          = <<-SUMMARY
                       LaunchGate makes it easy to let users know when an update to your app is available.
                       SUMMARY
  s.description      = <<-DESC
                       LaunchGate makes it easy to let users know when an update
                       to your app is available.

                       You can also block access to the app for older versions,
                       which is useful in the event of a severe bug or security
                       issue that requires users to update the app.

                       Additionally, you can use LaunchGate to display a remotely
                       configured message to users at launch which can also be
                       used to temporarily block access to the app (i.e. during
                       back-end maintenance).
                       DESC
  s.homepage         = "https://github.com/dtrenz/LaunchGate"
  # s.screenshots      = "https://github.com/dtrenz/LaunchGate/Docs/Screenshots/required-update.png", "https://github.com/dtrenz/LaunchGate/Docs/Screenshots/optional-update.png", "https://github.com/dtrenz/LaunchGate/Docs/Screenshots/alert-blocking.png", "https://github.com/dtrenz/LaunchGate/Docs/Screenshots/alert-nonblocking.png"
  s.license          = 'Apache 2.0'
  s.author           = { "Dan Trenz" => "dtrenz@gmail.com" }
  s.source           = { :git => "https://github.com/dtrenz/LaunchGate.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dtrenz'
  s.platform         = :ios, '8.3'
  s.requires_arc     = true
  s.source_files     = 'Source/**/*.swift'
  s.frameworks       = 'UIKit'
  s.swift_version    = '4.1'
end
