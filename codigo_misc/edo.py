import time
import codecs
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Firefox()
driver.get("http://www.azteca.com/laislaelreality/perfil/publico/id/9000000000000000046#")
assert "Isla" in driver.title
elem = driver.find_element_by_id("btnVota")
#elem.send_keys("golden globes woody allen")
#elem.send_keys(Keys.RETURN)
#assert "Google" in driver.title
elem.click()
#time.sleep(6)
driver.close()