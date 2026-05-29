
platform :ios, '15.0'

source '<https://github.com/CocoaPods/Specs.git>'

target 'TJJupiterSample' do
  use_frameworks!
  pod 'TJJupiterSDK', '2.0.2'
  #pod 'TJJupiterSDK', :path => '/Users/leo/SwiftProjects/TJJupiterSDK'

  target 'TJJupiterSampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TJJupiterSampleUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
