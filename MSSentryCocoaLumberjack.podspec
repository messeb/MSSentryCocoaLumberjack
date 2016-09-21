Pod::Spec.new do |s|
  s.name             = 'MSSentryCocoaLumberjack'
  s.version          = '0.2.0'
s .summary          = 'Custom CocoaLumberjack logger for Sentry'

  s.description      = <<-DESC
MSSentryLogger is a custom logger for CocoaLumberjack that logs to Sentry.
It contains a mapping from the CocoaLumberJack DDLogFlag to the Sentry RavenLogEvent.
You can call the CocoaLumberjack logging function and it will produce a corresponding event in Sentry.
                       DESC

  s.homepage         = 'https://github.com/messeb/MSSentryCocoaLumberjack'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'messeb'
  s.source           = { :git => 'https://github.com/messeb/MSSentryCocoaLumberjack.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MSSentryCocoaLumberjack/Classes/**/*'

  s.dependency 'CocoaLumberjack/Swift'
  s.dependency 'RavenSwift'
end
