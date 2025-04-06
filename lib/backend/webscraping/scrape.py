import re
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.expected_conditions import visibility_of_element_located
from bs4 import BeautifulSoup as bs

optionsFirefox = Options()
optionsFirefox.add_argument("--headless") # don't display firefox window

browser = webdriver.Firefox(options=optionsFirefox)  # start a web browser
browser.get("https://drexel.campusdish.com/LocationsAndMenus/UrbanEatery")  # navigate to URL

# wait until all elements of the webpage are loaded
title = (
    WebDriverWait(driver=browser, timeout=10)
    .until(visibility_of_element_located((By.XPATH, "//*[@class='sc-kdBSHD gobkAf ProductCard']")))
    .text
)

content = browser.page_source # scrape all html
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
menuCalories = []
menuDescriptions = []
menuLowCarbon = []
menuVegetarian = []
menuGlutenFree = []
menuWholeGrain = []
menuEatWell = []
menuPlantForward = []
menuVegan = []

for stationBlock in stationBlocks: 
    stationItems = []
    stationCalories = []
    stationDescriptions = []
    stationLowCarbon = []
    stationVegetarian = []
    stationGlutenFree = []
    stationWholeGrain = []
    stationEatWell = []
    stationPlantForward = []
    stationVegan = []
    stationBlockChildren = stationBlock.findChildren()
    
    for menuItem in stationBlockChildren:
       itemTitle = re.search("<h3.*><span class=\"sc-fjvvzt kQweEp HeaderItemNameLink\" data-testid=\"product-card-header-link\">(.*)</span></h3>",  str(menuItem))
       if itemTitle == None:
           pass
       elif itemTitle and itemTitle.group(1) not in stationItems:
           stationItems.append(itemTitle.group(1))
           itemCalories = re.search(".*>(.*) Calories</span>", str(menuItem))
           if itemCalories == None:
               pass
           else:
               stationCalories.append(int(itemCalories.group(1)))
           
           precursor = str(itemCalories.group(1)) + " Calories"
           
           itemLowCarbon = re.search(precursor + ".*Low Carbon Certified", str(menuItem))
           if itemLowCarbon == None:
               stationLowCarbon.append(False)
           else:
               stationLowCarbon.append(True)
           
           itemGlutenFree = re.search(precursor + ".*Made Without.*</li>", str(menuItem))
           if itemGlutenFree == None:
               stationGlutenFree.append(False)
           else:
               stationGlutenFree.append(True)
           
           itemVegan = re.search(precursor + ".*Vegan.*</li>", str(menuItem))
           if itemVegan == None:
               stationVegan.append(False)
           else:
               stationVegan.append(True)
           
           itemVegetarian = re.search(precursor + ".*Vegetarian.*</li>", str(menuItem))
           if itemVegetarian == None:
               stationVegetarian.append(False)
           else:
               stationVegetarian.append(True)

           itemWholeGrain = re.search(precursor + ".*Made With Whole.*</li>", str(menuItem))
           if itemWholeGrain == None:
               stationWholeGrain.append(False)
           else:
               stationWholeGrain.append(True)

           itemEatWell = re.search(precursor + ".*Eat Well.*</li>", str(menuItem))
           if itemEatWell == None:
               stationEatWell.append(False)
           else:
               stationEatWell.append(True)

           itemPlantForward = re.search(precursor + ".*Plant Forward.*</li>", str(menuItem))
           if itemPlantForward == None:
               stationPlantForward.append(False)
           else:
               stationPlantForward.append(True)
       else:
           pass

    menuCalories.append(stationCalories)
    menuItems.append(stationItems)
    menuDescriptions.append(stationDescriptions)
    menuLowCarbon.append(stationLowCarbon)
    menuGlutenFree.append(stationGlutenFree)
    menuVegan.append(stationVegan)
    menuVegetarian.append(stationVegetarian)
    menuWholeGrain.append(stationWholeGrain)
    menuEatWell.append(stationEatWell)
    menuPlantForward.append(stationPlantForward)

db = open("menu.json", "r+")
db.truncate(0)
db.write("{\n")

# send all scraped items to database
counter = 0
for i in range(0, len(stationTitles)):
    for k in range(0, len(menuItems[i])):
        if counter != 0:
            db.write("\t},\n")
        db.write("\t\"" + str(counter) + "\":\n")
        db.write("\t{\n")
        db.write("\t\t\"Name\": \"" + str(menuItems[i][k]) + "\",\n")
        db.write("\t\t\"Station\": \"" +  str(stationTitles[i]) + "\",\n")
        db.write("\t\t\"Calories\": " + str(menuCalories[i][k]) + ",\n")
        db.write("\t\t\"lowCarbon\": " + str(int(menuLowCarbon[i][k])) + ",\n")
        db.write("\t\t\"glutenFree\": " + str(int(menuGlutenFree[i][k])) + ",\n")
        db.write("\t\t\"vegan\": " + str(int(menuVegan[i][k])) + ",\n")
        db.write("\t\t\"vegetarian\": " + str(int(menuVegetarian[i][k])) + ",\n")
        db.write("\t\t\"wholeGrain\": " + str(int(menuWholeGrain[i][k])) + ",\n")
        db.write("\t\t\"eatWell\": " + str(int(menuEatWell[i][k])) + ",\n")
        db.write("\t\t\"plantForward\": " + str(int(menuPlantForward[i][k])) + "\n")
        counter += 1
db.write("\t}\n")
db.write("}")
db.close()