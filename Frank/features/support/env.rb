require 'frank-cucumber'

# TODO: set this constant to the full path for your Frankified target's app bundle.
# See the "Given I launch the app" step definition in launch_steps.rb for more details
# APP_BUNDLE_PATH = nil

app_name = "NUSurveyorExample"
simulator_version = "5.0"
APP_BUNDLE_PATH = Dir.glob("#{ENV['HOME']}/Library/Developer/Xcode/DerivedData/#{app_name}*/Build/Products/Debug-iphonesimulator/#{app_name} copy.app").first || Dir.glob("#{ENV['HOME']}/Library/Application Support/iPhone Simulator/#{simulator_version}/Applications/**/#{app_name} copy.app").first

