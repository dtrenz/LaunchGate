Pod::Spec.new do |s|
  s.name             = "LaunchGate"
  s.version          = "0.1.0"
  s.summary          = <<-SUMMARY
                       LaunchGate makes it easy to let users know if there is a newer version of your app available.
                       SUMMARY
  s.description      = <<-DESC
                       LaunchGate makes it easy to let users know if there is a
                       newer version of your app available.

                       You can also block access to the app for older versions,
                       which is useful in the event of a severe bug or security
                       issue that requires users to update the app.

                       Additionally, you can use LaunchGate to display a remotely
                       configured message to users at launch which can also be
                       used to temporarily block access to the app (i.e. during
                       back-end maintenance).
                       DESC
  s.homepage         = "https://github.com/dtrenz/LaunchGate"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'Apache 2.0'
  s.author           = { "Dan Trenz" => "dtrenz@gmail.com" }
  s.source           = { :git => "https://github.com/dtrenz/LaunchGate.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dtrenz'
  s.platform         = :ios, '8.3'
  s.requires_arc     = true
  s.source_files     = 'Source/**/*'
end
