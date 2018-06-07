# Uncomment the next line to define a global platform for your project
# platform :ios, ’9.0’

target 'Mutadawel' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for Mutadawel
    pod ‘GraphKit’
    pod use_frameworks! 'SDWebImage'
    
    

    pod 'Alamofire'
    pod 'AlamofireImage'
    pod 'SwiftyJSON'
    pod 'SKPhotoBrowser'
    pod 'TOCropViewController'
    pod 'Firebase'
    pod 'Firebase/Messaging'
    pod 'KILabel'
    pod 'GoogleConversionTracking'
    pod ‘Charts’
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
   

end

