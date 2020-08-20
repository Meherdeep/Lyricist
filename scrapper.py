#!/usr / bin / env python 

from selenium import webdriver
import time
import os
import time
from selenium.webdriver.common.keys import Keys
import base64
from selenium.webdriver.chrome.options import Options
import codecs
import os

chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--window-size=1920x1080")
brower = webdriver.Chrome(options=chrome_options, executable_path="./chromedriver")
website_URL = "https://www.dcode.fr/music-sheet"


def GetNodesScrapper(SOME_RANDOM_SHIT):
    brower.get(website_URL)
    print("stage1")
    brower.find_element_by_id("convert_from_abc_to_sheet_notes_abc").send_keys(Keys.CONTROL + "a")
    print("stage2")
    brower.find_element_by_id("convert_from_abc_to_sheet_notes_abc").send_keys(Keys.DELETE)
    print("stage3")
    brower.find_element_by_id("convert_from_abc_to_sheet_notes_abc").send_keys(SOME_RANDOM_SHIT)
    print("stage4")
    brower.find_element_by_xpath('//form[@id="convert_from_abc_to_sheet"]/button[@post="notes_abc"]').click()
    print("stage5")
    time.sleep(2)
    value = brower.find_element_by_name("download").get_attribute("value")
    print("stage6")
    fvalue = base64.b64decode(value).decode("utf-8")
    return codecs.decode(fvalue, 'unicode_escape')


print(GetNodesScrapper(
    "C4, C4, B4, C4, B4, B4, B4, A#4, A#4, A#4, A#4, A#4, A4, A#4, A#4, A#4, A#4, A#4, A#4, A#4, A#4, A#4, A4, A#4, A4, A4, A4, A4, A4, A4, A4, A4, A4, A4, G#4, G#4, G#4, A4, A4, G#4, D4, A4, G#4,"))
