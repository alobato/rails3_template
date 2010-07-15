# http://yardoc.org/docs/jnicklas-capybara/Capybara/Session
# http://wiki.github.com/dchelimsky/rspec/custom-matchers

def s(string)
  Capybara::XPath.escape(string)
end

RSpec::Matchers.define :have_form_to do |expected|
  match do |actual|
    actual.has_xpath?("//form[@action=#{s(expected)}]")
  end
end

RSpec::Matchers.define :current_path_to do |expected|
  match do |actual|
    actual.current_path == expected
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
