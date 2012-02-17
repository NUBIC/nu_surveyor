Then /^the cell marked "([^"]*)" should be dotted$/ do |cell_mark|
  cell_selector = "tableViewCell marked:'#{cell_mark}'"
  check_element_exists( cell_selector )
  dotted = frankly_map( cell_selector, 'dotted' )
  dotted.should == [true]
end

When /^I scroll to the bottom of the table$/ do
  frankly_map( "tableView marked:'sectionTableView'", "scrollToBottom") 
end

Then /^I should see the label marked "([^"]*)" in the table$/ do |label_mark|
  check_element_exists("label marked:'#{label_mark}'")
end