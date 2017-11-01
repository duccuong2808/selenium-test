require "json"
require "selenium-webdriver"
require "rspec"
require 'rspec_junit_formatter'
include RSpec::Expectations
Selenium::WebDriver::Chrome.driver_path='/usr/local/bin/chromedriver'
describe "Demo01Guru99" do

  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @base_url = "http://demo.guru99.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_demo01_guru99" do
    @driver.get(@base_url + "/")
    @driver.find_element(:name, "emailid").clear
    @driver.find_element(:name, "emailid").send_keys "biendond@gmail.com"
    @driver.find_element(:name, "btnLogin").click
  end
  
  def element_present?(how, what)
    $receiver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    $receiver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = $receiver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
