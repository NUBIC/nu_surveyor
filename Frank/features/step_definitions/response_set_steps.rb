When /^I touch the upper left of the table cell marked "(.*)"$/ do |mark|
  #  touch("tableViewCell marked:'#{mark}'")
  frankly_map( "view marked:'#{mark}'", "touchx:y:", "10", "10" )
end

Then /^the cell marked "(.*)" should be (un)?(checked|dotted)/ do |cell_mark, negator, type|
  wait_for_nothing_to_be_animating
  cell_selector = "tableViewCell marked:'#{cell_mark}'"
  check_element_exists( cell_selector )
  filled = frankly_map( cell_selector, type )
  filled.should == (negator == "un" ? [false] : [true])
end

# When /^the (\d*)(?:st|nd|rd|th)? cell should be (un)?(checked|dotted)$/ do |ordinal, negator, type|
#   cell_selector = ("tableViewCell index:#{ordinal.to_i - 1}")
#   check_element_exists( cell_selector )
#   checked = frankly_map( cell_selector, type )
# 	checked.should == (negator == "un" ? [false] : [true])
# end

When /^I press done on the keyboard$/ do
  sleep 0.5
%x{osascript<<APPLESCRIPT
  tell application "System Events"
  tell application "iPhone Simulator" to activate
  key code 36
  end tell
APPLESCRIPT}
  sleep 0.5
end

When /^I scroll to the bottom of the table$/ do
  frankly_map( "tableView marked:'sectionTableView'", "scrollToBottom")
  wait_for_nothing_to_be_animating
  sleep 0.5 # seems to be required even after waiting for animations to finish
end

Then /^I should see the label marked "(.*)" in the table$/ do |label_mark|
  check_element_exists("label marked:'#{label_mark}'")
end

Then /^I should see a "([^\"]*)" label$/ do |expected_mark|
  check_element_exists("label marked:'#{expected_mark}'")
end

When /^I use the keyboard to fill in the textfield marked "([^\\"]*)" with "([^\\"]*)"$/ do |text_field_mark, text_to_type|
  text_field_selector =  "view marked:'#{text_field_mark}'"
  check_element_exists( text_field_selector )
  touch( text_field_selector )
  frankly_map( text_field_selector, 'setText:', text_to_type )
  frankly_map( text_field_selector, 'endEditing:', true )
  wait_for_nothing_to_be_animating
end

Given /^I go to the "(.*)" section$/ do |section_mark|
  wait_for_nothing_to_be_animating
  touch( "button marked:'Sections'" )
  wait_for_nothing_to_be_animating
  touch("tableViewCell marked:'#{section_mark}'")
  wait_for_nothing_to_be_animating
end

Then /^there should be (\d*) response(s?)$/ do |num, plural|
  wait_for_nothing_to_be_animating
  sleep 0.5 # seems to be required even after waiting for animations to finish
  touch( "button marked:'Inspect'")
  wait_for_nothing_to_be_animating
  check_view_with_mark_exists("#{num} response#{plural}")
  sleep 0.5 # for visual inspection
  touch( "navigationItemButtonView" )
  wait_for_nothing_to_be_animating
end

Then /^I wait for animations$/ do
  wait_for_nothing_to_be_animating
end