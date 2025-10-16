#!/usr/bin/env python3
# This example uses a credentials stored in a .env file defining SQL_HOST, SQL_USER, SQL_PWD, and SQL_DB

import mysql.connector, json 
with open('secrets.json', 'r') as secretFile:
    creds = json.load(secretFile)['mysqlCredentials']

def getConnection():
    connection = mysql.connector.connect(**creds)
    return connection

def printTable():
    connection = getConnection()
    mycursor = connection.cursor()
    mycursor.execute("select * from Person")
    myresult = mycursor.fetchone()

    print("In the Person  table, we have the following items: ")
    while myresult is not None:
        print(myresult)
        myresult = mycursor.fetchone()
    connection.close()
    print()

def insertIntoTable():
    firstname = input("Please give the first name of the person: ")
    lastname = input("Please give the last name of the person: ")
    connection = getConnection()
    mycursor = connection.cursor()
    query = "insert into Person (First_Name, Last_Name) values (%s, %s);"
    mycursor.execute(query, (firstname, lastname))
    connection.commit()
    connection.close()

def deleteRowFromTable():
    rowToDelete = input("What is the id of the row to delete? Jacob for the love of God do not put any number 1 through 8 ")
    connection = getConnection()
    myCursor = connection.cursor()
    myCursor.execute("delete from Person where Person_ID=%s", (rowToDelete,))
    connection.commit()
    connection.close()

def updateRow():
    rowToUpdate = input("What is the id of the row (not 1-8) you want to update? ")
    connection = getConnection()
    myCursor = connection.cursor()
    myCursor.execute("select * from Person where Person_ID=%s", (rowToUpdate,))
    myResult = myCursor.fetchone()
    print(f"The current row has the value: {myResult}")
    firstname = input("Please give the first name of the person: ")
    lastname = input("Please give the last name of the person: ")
    myCursor.execute("update Person set First_Name=%s, Last_Name=%s where Person_ID=%s", (firstname, lastname, rowToUpdate))
    connection.commit()
    connection.close()


menuText = """Please select one of the following options:
1) Display contents of table
2) Insert new row to table
3) Update a row of the table
4) Delete a row of the table
q) Quit
"""

if __name__ == "__main__":
    menuOption = "1"
    while menuOption != 'q':
        menuOption = input(menuText)
        if menuOption == "1":
            printTable()
        elif menuOption == "2":
            insertIntoTable()
        elif menuOption == "3":
            updateRow()
        elif menuOption == "4":
            deleteRowFromTable()
