import sqlite3

connection = sqlite3.connect('menu.db')                                                                               
cursor = connection.cursor() 

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

cursor.execute(table)
connection.commit()
connection.close()
