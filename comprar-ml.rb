require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

class ComprarRb < Test::Unit::TestCase

  # Al exportar de Selenium IDE:
  # Reemplazar ${receiver} por @driver
  #            :firefox por :chrome
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @base_url = "http://articulo.mercadolibre.com.ar/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_comprar_rb
    # Dueño de la publicación:
    # TETE150369
    # qatest1952
    @driver.get(@base_url + "/MLA-629000419-pc-core-i7-prueba-mercadolibre-api-no-ofertar-_JM")
    begin
      @driver.find_element(:link, "Ingresa").click
      @driver.find_element(:id, "user_id").clear
      @driver.find_element(:id, "user_id").send_keys "TT743452"
      @driver.find_element(:id, "password").clear
      @driver.find_element(:id, "password").send_keys "qatest9997"
      @driver.find_element(:id, "signInButton").click
    rescue
      puts "ya logueado"
    end
    assert !60.times{ break if (element_present?(:id, "BidButtonTop") rescue false); sleep 1 }
    @driver.find_element(:id, "BidButtonTop").click
    @driver.find_element(:name, "bid").click
    assert !60.times{ break if (element_present?(:id, "contactName") rescue false); sleep 1 }
    @driver.find_element(:id, "contactName").clear
    @driver.find_element(:id, "contactName").send_keys "AAA"
    @driver.find_element(:id, "phoneNumber").clear
    @driver.find_element(:id, "phoneNumber").send_keys "1162004545"
    @driver.find_element(:name, "bid").click
    Selenium::WebDriver::Support::Select.new(@driver.find_element(:name, "paymentMethodSelect")).select_by(:text, "Visa terminada en 3704")
    assert !60.times{ break if (element_present?(:id, "securityCode") rescue false); sleep 1 }
    @driver.find_element(:id, "securityCode").clear
    @driver.find_element(:id, "securityCode").send_keys "123"
    @driver.find_element(:xpath, "//input[starts-with(@id, \"installment_1\")]").click
    @driver.find_element(:name, "bid").click
    assert !60.times{ break if (element_present?(:id, "confirmButton") rescue false); sleep 1 }
    @driver.find_element(:id, "confirmButton").click
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
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
