import sqlite3

connection_obj = sqlite3.connect('menu.db')
cursor_obj = connection_obj.cursor()
print('DB Init')

cursor_obj.execute("DROP TABLE IF EXISTS MENU")

# Creating table
table = """ CREATE TABLE MENU (
            Name VARCHAR(255),
            Station VARCHAR(255),
            Calories INT,
            LowCarbon BLOB,
            GlutenFree BLOB,
            Vegan BLOB,
            Vegetarian BLOB,
            WholeGrain BLOB,
            EatWell BLOB,
            PlantForward BLOB
        ); """

cursor_obj.execute(table)

connection_obj.close()
