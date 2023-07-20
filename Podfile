# Uncomment the next line to define a global platform for your project

# platform :ios, '9.0'

 

target '4INSHIELD' do

  # Comment the next line if you don't want to use dynamic frameworks

  use_frameworks!

 

  # Pods for 4INSHIELD

   pod 'FLAnimatedImage', '~> 1.0'

   pod 'SDWebImage', '~> 5.0'

   pod 'DLRadioButton', '~> 1.4'

   pod 'FSCalendar'

   pod 'DGCharts'

   pod 'AlamofireImage', '~> 4.1'

 

end

 

post_install do |installer|

    installer.generated_projects.each do |project|

          project.targets.each do |target|

              target.build_configurations.each do |config|

                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'

               end

          end

   end

end