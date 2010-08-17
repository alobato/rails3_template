# http://yardoc.org/docs/jnicklas-capybara/Capybara/Session

def s(string)
  Capybara::XPath.escape(string)
end

RSpec::Matchers.define :have_form_to do |expected|
  match do |actual|
    actual.has_xpath?("//form[@action=#{s(expected)}]")
  end

  failure_message_for_should do |actual|
    "expected that #{actual.body} have form to #{expected}"
  end
  
  failure_message_for_should_not do |actual|
    "expected that #{actual.body} have form to #{expected}"
  end
end

RSpec::Matchers.define :current_path_to do |expected|
  match do |actual|
    actual.current_path == expected
  end
  
  failure_message_for_should do |actual|
    "expected that #{actual.current_path} should #{expected}"
  end
  
  failure_message_for_should_not do |actual|
    "expected that #{actual.current_path} should not #{expected}"
  end
end

RSpec::Matchers.define :have_content do |expected|
  match do |actual|
    actual.has_content?(expected)
  end
  
  failure_message_for_should do |actual|
    "expected that #{actual.body} have content #{expected}"
  end
  
  failure_message_for_should_not do |actual|
    "expected that #{actual.body} have not content #{expected}"
  end
end

RSpec::Matchers.define :have_title do |expected|
  match do |actual|
    actual.has_xpath?("//title[contains(.,#{s(expected)})]")
  end
  
  failure_message_for_should do |actual|
    "expected that #{actual.body} have title #{expected}"
  end
  
  failure_message_for_should_not do |actual|
    "expected that #{actual.body} have not title #{expected}"
  end
end

RSpec::Matchers.define :have_h2 do |expected|
  match do |actual|    
    actual.has_xpath?("//h2[text()=#{s(expected)}]")
  end
  
  failure_message_for_should do |actual|
    "expected that #{actual.body} have h2 #{expected}"
  end
  
  failure_message_for_should_not do |actual|
    "expected that #{actual.body} have not h2 #{expected}"
  end
end