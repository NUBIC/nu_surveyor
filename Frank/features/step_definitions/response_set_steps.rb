Then /^the cell marked "([^"]*)" should be dotted$/ do |cell_mark|
  cell_selector = "tableViewCell marked:'#{cell_mark}'"
  check_element_exists( cell_selector )
  dotted = frankly_map( cell_selector, 'dotted' )
  dotted.should == [true]
end