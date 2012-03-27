When /^I touch the upper left of the table cell marked "([^\"]*)"$/ do |mark|
  #  touch("tableViewCell marked:'#{mark}'")
  frankly_map( "view marked:'#{mark}'", "touchx:y:", "10", "10" )
end

Then /^the cell marked "([^"]*)" should be dotted$/ do |cell_mark|
  cell_selector = "tableViewCell marked:'#{cell_mark}'"
  check_element_exists( cell_selector )
  dotted = frankly_map( cell_selector, 'dotted' )
  dotted.should == [true]
end

When /^the (\d*)(?:st|nd|rd|th)? cell should be checked$/ do |ordinal|
  cell_selector = ("tableViewCell index:#{ordinal.to_i - 1}")
  check_element_exists( cell_selector )
  checked = frankly_map( cell_selector, 'checked' )
  checked.should == [true]
end

When /^the (\d*)(?:st|nd|rd|th)? cell should be unchecked$/ do |ordinal|
  cell_selector = ("tableViewCell index:#{ordinal.to_i - 1}")
  check_element_exists( cell_selector )
  checked = frankly_map( cell_selector, 'checked' )
  checked.should == [false]
end

When /^I press done on the keyboard$/ do
%x{osascript<<APPLESCRIPT
  tell application "System Events"
  tell application "iPhone Simulator" to activate
  key code 36
  end tell
APPLESCRIPT}
end

When /^I scroll to the bottom of the table$/ do
  frankly_map( "tableView marked:'sectionTableView'", "scrollToBottom") 
end

Then /^I should see the label marked "([^"]*)" in the table$/ do |label_mark|
  check_element_exists("label marked:'#{label_mark}'")
end

When /^I use the keyboard to fill in the textfield marked "([^\\"]*)" with "([^\\"]*)"$/ do |text_field_mark, text_to_type|
  text_field_selector =  "view marked:'#{text_field_mark}'"
  check_element_exists( text_field_selector )
  touch( text_field_selector )
  frankly_map( text_field_selector, 'setText:', text_to_type )
  frankly_map( text_field_selector, 'endEditing:', true )
end