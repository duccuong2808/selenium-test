require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "FacebookSignupTest" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://www.facebook.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_facebook_signup" do
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "u_0_g").clear
    @driver.find_element(:id, "u_0_g").send_keys "Nguyen"
    @driver.find_element(:id, "u_0_i").clear
    @driver.find_element(:id, "u_0_i").send_keys "Cuong"
    @driver.find_element(:id, "u_0_l").clear
    @driver.find_element(:id, "u_0_l").send_keys "0985641091"
    @driver.find_element(:id, "u_0_s").clear
    @driver.find_element(:id, "u_0_s").send_keys "thisispass"
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "day")).select_by(:text, "21")
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "month")).select_by(:text, "Tháng 8")
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "year")).select_by(:text, "1919")
    @driver.find_element(:id, "u_0_7").click
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
