import time
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support.expected_conditions import visibility_of_element_located

optionsFirefox = Options()
optionsFirefox.add_argument("--headless") # don't display firefox window

browser = webdriver.Firefox(options=optionsFirefox)  # start a web browser
browser.get("https://drexel.campusdish.com/LocationsAndMenus/UrbanEatery")  # navigate to URL

WebDriverWait(driver=browser, timeout=10).until(visibility_of_element_located((By.XPATH, "//*[@class='onetrust-close-btn-handler onetrust-close-btn-ui banner-close-button ot-close-icon']")))
closeButton = browser.find_element(By.XPATH, "//*[@class='onetrust-close-btn-handler onetrust-close-btn-ui banner-close-button ot-close-icon']")
closeButton.click()

WebDriverWait(driver=browser, timeout=10).until(visibility_of_element_located((By.XPATH, "//*[@class='ReactModal__Overlay ReactModal__Overlay--after-open']")))
time.sleep(2)
closeButton = browser.find_element(By.XPATH, "//*[@class='sc-hmdomO cPVQrc']")
closeButton.click()

WebDriverWait(driver=browser, timeout=10).until(visibility_of_element_located((By.XPATH, "//*[@class='webchat-teaser-message-bubble cognigy-webchat-ghv6pu']")))
closeButton = browser.find_element(By.XPATH, "//*[@class='webchat-teaser-message-bubble cognigy-webchat-ghv6pu']")
closeButton.click()

WebDriverWait(driver=browser, timeout=10).until(visibility_of_element_located((By.XPATH, "//*[@class='webchat-header-close-button cognigy-webchat-2m7b07']")))
closeButton = browser.find_element(By.XPATH, "//*[@class='webchat-header-close-button cognigy-webchat-2m7b07']")
closeButton.click()

WebDriverWait(driver=browser, timeout=10).until(visibility_of_element_located((By.XPATH, "//*[@class='sc-aXZVg sc-eqUAAy ktDvbv gejZeh sc-fXSgeo gRMtDs HeaderItem']")))
buttons = browser.find_elements(By.XPATH, "//*[@class='sc-aXZVg sc-eqUAAy ktDvbv gejZeh sc-fXSgeo gRMtDs HeaderItem']")

menuItems = []

for button in buttons:
    try:
        menuItem = {}
        button.click()
        WebDriverWait(driver=browser, timeout=10).until(visibility_of_element_located((By.XPATH, "//*[@class='sc-krNlru jTWVjC ModalHeaderItemName']")))
        menuItem["name"] = browser.find_element(By.XPATH, "//*[@class='sc-krNlru jTWVjC ModalHeaderItemName']").text
        menuItem["description"] = browser.find_element(By.XPATH, "//*[@class='sc-fvtFIe CrMXX ModalProductDescriptionContent']").text
        menuItem["calories"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE']/span[1]").text
        menuItem["totalFat"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][2]/span[1]").text
        menuItem["saturatedFat"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][2]/ul[1]/li[1]/span[1]").text
        menuItem["transFat"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][2]/ul[1]/li[2]/span[1]").text
        menuItem["cholesterol"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][3]/span[1]").text
        menuItem["sodium"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][4]/span[1]").text
        menuItem["totalCarbohydrates"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][5]/span[1]").text
        menuItem["dietaryFiber"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][5]/ul[1]/li[1]/span[1]").text
        menuItem["totalSugars"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][5]/ul[1]/li[2]/span[1]").text
        menuItem["addedSugars"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][5]/ul[1]/li[2]/ul[1]/li[1]/span[1]").text
        menuItem["protein"] = browser.find_element(By.XPATH, "//li[@class='sc-fiCwlc gsLNwE'][6]/span[1]").text
        try:
            browser.find_element(By.XPATH, "//div[@class='sc-dLMFU jUaoIl']/div[@class='sc-kAkpmW gpcgIg ModalBodyItem']/div[@class='sc-dSCufp fUeeLo']/div[@class='sc-jxOSlx hhDekA ItemAllergens']/div[@class='sc-lcIPJg fpEabH ItemAllergen']/img[contains(@alt, 'Vegan')]")
            menuItem["vegan"] = True
        except:
            menuItem["vegan"] = False
        try:
            browser.find_element(By.XPATH, "//div[@class='sc-dLMFU jUaoIl']/div[@class='sc-kAkpmW gpcgIg ModalBodyItem']/div[@class='sc-dSCufp fUeeLo']/div[@class='sc-jxOSlx hhDekA ItemAllergens']/div[@class='sc-lcIPJg fpEabH ItemAllergen']/img[contains(@alt, 'Made Without Gluten')]")
            menuItem["glutenFree"] = True
        except:
            menuItem["glutenFree"] = False
        try:
            browser.find_element(By.XPATH, "//div[@class='sc-dLMFU jUaoIl']/div[@class='sc-kAkpmW gpcgIg ModalBodyItem']/div[@class='sc-dSCufp fUeeLo']/div[@class='sc-jxOSlx hhDekA ItemAllergens']/div[@class='sc-lcIPJg fpEabH ItemAllergen']/img[contains(@alt, 'Plant Forward')]")
            menuItem["plantForward"] = True
        except:
            menuItem["plantForward"] = False
        try:
            browser.find_element(By.XPATH, "//div[@class='sc-dLMFU jUaoIl']/div[@class='sc-kAkpmW gpcgIg ModalBodyItem']/div[@class='sc-dSCufp fUeeLo']/div[@class='sc-jxOSlx hhDekA ItemAllergens']/div[@class='sc-lcIPJg fpEabH ItemAllergen']/img[contains(@alt, 'Eat Well')]")
            menuItem["eatWell"] = True
        except:
            menuItem["eatWell"] = False
        try:
            browser.find_element(By.XPATH, "//div[@class='sc-dLMFU jUaoIl']/div[@class='sc-kAkpmW gpcgIg ModalBodyItem']/div[@class='sc-dSCufp fUeeLo']/div[@class='sc-jxOSlx hhDekA ItemAllergens']/div[@class='sc-lcIPJg fpEabH ItemAllergen']/img[contains(@alt, 'Vegetarian')]")
            menuItem["vegetarian"] = True
        except:
            menuItem["vegetarian"] = False
        try:
            browser.find_element(By.XPATH, "//div[@class='sc-dLMFU jUaoIl']/div[@class='sc-kAkpmW gpcgIg ModalBodyItem']/div[@class='sc-dSCufp fUeeLo']/div[@class='sc-jxOSlx hhDekA ItemAllergens']/div[@class='sc-lcIPJg fpEabH ItemAllergen']/img[contains(@alt, 'Low Carbon Certified')]")
            menuItem["lowCarbon"] = True
        except:
            menuItem["lowCarbon"] = False
        closeButton = browser.find_element(By.XPATH, "//*[@class='sc-eDPEul ldupur']")
        closeButton.click()
        menuItems.append(menuItem)
    except:
        pass
browser.close()

db = open("menu.json", "r+")
db.truncate(0)
db.write("{\n")
for menuItem in menuItems:
        index = menuItems.index(menuItem)
        db.write("\t\"" + str(index) + "\":\n")
        db.write("\t{\n")
        db.write("\t\t\"Name\": \"" +  menuItem["name"] + "\",\n")
        db.write("\t\t\"Description\": \""  + menuItem["description"] + "\",\n")
        db.write("\t\t\"Calories\": " + "\"" + menuItem["calories"] + "\"" + ",\n")
        db.write("\t\t\"totalFat\": " + "\"" + menuItem["totalFat"] + "\"" + ",\n")
        db.write("\t\t\"saturatedFat\": " + "\"" + menuItem["saturatedFat"] + "\"" + ",\n")
        db.write("\t\t\"transFat\": " + "\"" + menuItem["transFat"] + "\"" + ",\n")
        db.write("\t\t\"cholesterol\": " + "\"" + menuItem["cholesterol"] + "\"" + ",\n")
        db.write("\t\t\"sodium\": " + "\"" + menuItem["sodium"] + "\"" + ",\n")
        db.write("\t\t\"totalCarbohydrates\": " + "\"" + menuItem["totalCarbohydrates"] + "\"" + ",\n")
        db.write("\t\t\"dietaryFiber\": " + "\"" + menuItem["dietaryFiber"] + "\"" + ",\n")
        db.write("\t\t\"totalSugars\": " + "\"" + menuItem["totalSugars"] + "\"" + ",\n")
        db.write("\t\t\"addedSugars\": " + "\"" + menuItem["addedSugars"] + "\"" + ",\n")
        db.write("\t\t\"protein\": " + "\"" + menuItem["protein"] + "\"" + ",\n")
        db.write("\t\t\"vegan\": " + "\"" + str(menuItem["vegan"]) + "\"" + ",\n")
        db.write("\t\t\"eatWell\": " + "\"" + str(menuItem["eatWell"]) + "\"" + ",\n")
        db.write("\t\t\"plantForward\": " + "\"" + str(menuItem["plantForward"]) + "\"" + ",\n")
        db.write("\t\t\"vegetarian\": " + "\"" + str(menuItem["vegetarian"]) + "\"" + ",\n")
        db.write("\t\t\"lowCarbon\": " + "\"" + str(menuItem["lowCarbon"]) + "\"" + ",\n")
        db.write("\t\t\"glutenFree\": " + "\"" + str(menuItem["glutenFree"]) + "\"" + "\n")
        if index != (len(menuItems)-1):
            db.write("\t},\n")
db.write("\t}\n")
db.write("}")
db.close()

