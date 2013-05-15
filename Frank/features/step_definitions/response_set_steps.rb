When /^I touch the upper left of the table cell marked "(.*)"$/ do |mark|
  #  touch("tableViewCell marked:'#{mark}'")
  frankly_map( "view marked:'#{mark}'", "touchx:y:", "10", "10" )
end

When /^I touch the cell marked "(.*?)"$/ do |mark|
  touch("tableViewCell marked:'#{mark}'")
end

Then /^the cell marked "(.*)" should be (un)?(checked|dotted)/ do |cell_mark, negator, type|
  wait_for_nothing_to_be_animating
  cell_selector = "tableViewCell marked:'#{cell_mark}'"
  check_element_exists( cell_selector )
  filled = frankly_map( cell_selector, type )
  filled.should == (negator == "un" ? [false] : [true])
end

Then /^the cell marked "(.*?)" should have today as the date$/ do |mark|
  frankly_map("view marked:'#{Date.today.strftime("%m/%d/%Y")}' parent parent", "accessibilityLabel")[0].should == mark
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

When /^I scroll the table to (\d+)px$/ do |y|
  # http://code.google.com/p/uispec/source/browse/trunk/src/components/UIQueryTableView.h
  frankly_map("tableView marked:'sectionTableView'","scrollDown:", y.to_i)
  sleep 0.5
end

Then /^I should see the label marked "(.*)" in the table$/ do |label_mark|
  check_element_exists("label marked:'#{label_mark}'")
end

Then /^I should see a "([^\"]*)" label$/ do |expected_mark|
  check_element_exists("label marked:'#{expected_mark}'")
end

Then /^I should not see a "([^\"]*)" label$/ do |expected_mark|
    check_element_does_not_exist("label marked:'#{expected_mark}'")
end

When /^touch the (\d*)(?:st|nd|rd|th)? table cell marked "(.*?)"$/ do |ordinal, mark|
    total_found = frankly_map( "tableViewCell marked:'#{mark}'", 'tag' ).count
    ordinal = total_found - (ordinal.to_i) # Order is always reversed for some reason
    touch("tableViewCell marked:'#{mark}' index:#{ordinal}")
end

Then /^I touch a "(.*)" marked "(.*)"$/ do |viewClass, mark|
  touch("view:'#{viewClass}' marked:'#{mark}'")
end
When /^I use the keyboard to fill in the textfield marked "([^\\"]*)" with "([^\\"]*)"$/ do |text_field_mark, text_to_type|
  text_field_selector =  "view marked:'#{text_field_mark}'"
  check_element_exists( text_field_selector )
  touch( text_field_selector )
  sleep 0.5
  frankly_map( text_field_selector, 'setText:', text_to_type )
  frankly_map( text_field_selector, 'endEditing:', true )
  wait_for_nothing_to_be_animating
end
                                                                             

When /^I use the keyboard to fill in the textfield marked "([^\\"]*)" with "([^\\"]*)" without hitting done$/ do |text_field_mark, text_to_type|
  text_field_selector =  "view marked:'#{text_field_mark}'"
  check_element_exists( text_field_selector )
  touch( text_field_selector )
  sleep 0.5
  frankly_map( text_field_selector, 'setText:', text_to_type )
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

When /^I should see "(.*?)" labels marked "(.*?)"$/ do |count, label|
  labels = frankly_map( "label marked:'#{label}'", 'tag' )
  labels.count.should == count.to_i
end

Then /^I should see "(.*?)" buttons marked "(.*?)"$/ do |count, button|
  buttons = frankly_map( "button marked:'#{button}'", 'tag' )
  buttons.count.should == count.to_i
end

Then /^the label "(.*?)" should have a height of "(.*?)"$/ do |label_selector, expected_height|
  frame = frankly_map( "label marked:'#{label_selector}' index:0", 'frame' ).first
  frame["size"]["height"].should == expected_height.to_i
end

When(/^I touch in Done$/) do
  touch "view:'UINavigationButton' marked:'Done'"
end
                                                                             
Then(/^I should see that label with index (\d+) should match text of index with tag (\d+)$/) do |index1, index2|
  label_one_selector = "view:'UILabel' index:#{index1}"
  label_two_selector = "view:'UILabel' index:#{index2}"
  label_one_string = frankly_map(label_one_selector, 'text')
  label_two_string = frankly_map(label_two_selector, 'text')
  frankly_map(label_one_selector, 'text').should == frankly_map(label_two_selector, 'text')
end
																																																																													
Then(/^I should see that label with index (\d+) should NOT match text of index with tag (\d+)$/) do |index1, index2|
		label_one_selector = "view:'UILabel' index:#{index1}"
		label_two_selector = "view:'UILabel' index:#{index2}"
		label_one_string = frankly_map(label_one_selector, 'text')
		label_two_string = frankly_map(label_two_selector, 'text')
		frankly_map(label_one_selector, 'text').should_not == frankly_map(label_two_selector, 'text')
end
                                                                             
