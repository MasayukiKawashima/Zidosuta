# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'Zidosuta' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Zidosuta
   pod 'Charts'
   pod 'RealmSwift'
   pod 'Google-Mobile-Ads-SDK'

  target 'ZidosutaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ZidosutaUITests' do
    # Pods for testing
  end
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'Realm'
        create_symlink_phase = target.shell_script_build_phases.find { |x| x.name == 'Create Symlinks to Header Folders' }
        create_symlink_phase.always_out_of_date = "1"
      end
    end
  end
end
