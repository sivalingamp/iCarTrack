# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


def rx_swift
    pod 'RxSwift'
end

def rx_cocoa
    pod 'RxCocoa'
end

target 'iCarTrack' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for iCarTrack
  rx_swift
  rx_cocoa


  target 'iCarTrackTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'iCarTrackUITests' do
    # Pods for testing
  end

end

target 'DataPlatform' do
  use_frameworks!
  rx_swift
  rx_cocoa
  pod 'Moya'
  pod 'QueryKit'
  pod 'MagicalRecord', '2.3.0'
  
  target 'DataPlatformTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'Domain' do
  use_frameworks!
  rx_swift
  rx_cocoa
  
  target 'DomainTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
