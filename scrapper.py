#!/usr / bin / env python 

from selenium import webdriver
import time
import os
import time
from selenium.webdriver.common.keys import Keys
import base64

brower = webdriver.Chrome(executable_path="./chromedriver")
website_URL = "https://www.dcode.fr/music-sheet"


def GetNodesScrapper(SOME_RANDOM_SHIT):
    brower.get(website_URL)
    brower.find_element_by_id("convert_from_abc_to_sheet_notes_abc").send_keys(Keys.CONTROL + "a")
    brower.find_element_by_id("convert_from_abc_to_sheet_notes_abc").send_keys(Keys.DELETE)
    brower.find_element_by_id("convert_from_abc_to_sheet_notes_abc").send_keys(SOME_RANDOM_SHIT)
    brower.find_element_by_xpath('//form[@id="convert_from_abc_to_sheet"]/button[@post="notes_abc"]').click()
    time.sleep(2)
    value = brower.find_element_by_name("download").get_attribute("value")
    fvalue = base64.b64decode(value).decode("utf-8")
    return fvalue.replace("\\", '')[1:][:1]
