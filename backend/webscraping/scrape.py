import re
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.expected_conditions import visibility_of_element_located
from bs4 import BeautifulSoup as bs

browser = webdriver.Firefox()  # start a web browser
browser.get("https://drexel.campusdish.com/LocationsAndMenus/UrbanEatery")  # navigate to URL

# wait until all elements of the webpage are loaded
title = (
    WebDriverWait(driver=browser, timeout=10)
    .until(visibility_of_element_located((By.XPATH, "//*[@class='sc-kdBSHD gobkAf ProductCard']")))
    .text
)

content = browser.page_source
browser.close() # close browser

soup = bs(content, "lxml") # use bs4 to parse raw HTML using the lxml parser
stationBlocks = soup.findAll("div", class_="sc-ejfMa-d flvhaP MenuStation_no-categories") # find dining stations
stationBlockChildren = stationBlocks[0].findChildren() # find all child elements of the stations
stationTitles = []

# find titles of the different dining stations
for stationBlock in stationBlocks:
    stationBlockChildren = stationBlock.findChildren()
    for title in stationBlockChildren:
        match = re.search("<h2.*>(.*)</h2>", str(title))
        if match == None:
            pass
        elif match.group(1) not in stationTitles:
            stationTitles.append(match.group(1))
        else:
            pass
# find all menu items, split up into lists based on station
menuItems = []
for stationBlock in stationBlocks:
    stationItems = []
    stationBlockChildren = stationBlock.findChildren()
    for menuItem in stationBlockChildren:
       itemTitle = re.search("",  str(menuItem))
       if itemTitle == None:
           pass
       elif itemTitle:
           stationItems.append(itemTitle.group(1))
       else:
           pass
    menuItems.append(stationItems)
print(menuItems) 
