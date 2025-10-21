#This is the same menu I altered on week 7, but to work for Many-to-many
#Meant for FilmClub database, specifically FilmActor table...which I need to double check

import mysql.connector, json 
with open('secrets.json', 'r') as secretFile:
    creds = json.load(secretFile)['mysqlCredentials']

def getConnection():
    connection = mysql.connector.connect(**creds)
    return connection

def printActors(): #Prettied #1
    connection = getConnection()
    mycursor = connection.cursor()
    mycursor.execute("select First_Name, Last_Name, Person_ID AS 'Actor_ID' from Person WHERE Person_ID in (SELECT Actor_ID FROM FilmActor )")
    myresult = mycursor.fetchone()

    print("In the FilmActor table, we have the following actors: ")
    print("First Name     Last Name      Actor_ID")
    print("-"*38)
    while myresult is not None:
        print(f"{myresult[0]:15}{myresult[1]:15}{myresult[2]:3}")
        myresult = mycursor.fetchone()
    connection.close()
    print()

def printFilms(): #Pretty & Complete #2
    connection = getConnection()
    mycursor = connection.cursor()
    mycursor.execute("SELECT Title, Film_ID FROM Film WHERE Film_ID in (SELECT Film_ID from FilmActor)")
    myresult = mycursor.fetchone()

    print("In the FilmActor table, we have the following films: ")
    print("Film Title         Film_ID")
    print("-"*26)
    while myresult is not None:
        print(f"{myresult[0]:20}{myresult[1]:5}")
        myresult = mycursor.fetchone()
    connection.close()
    print()

def insertActorintoFilm():  #Works #3
    ActorToAdd = input("Please enter the Actor_ID of the actor you wish to add to a film:")
    MovieToTarget = input("Please enter the Film_ID of the film you want to insert the actor into")
    connection = getConnection()
    mycursor = connection.cursor()
    query = "insert into FilmActor (Actor_ID, Film_ID) values (%s, %s);"
    mycursor.execute(query, (ActorToAdd, MovieToTarget))
    connection.commit()
    connection.close()

def removeActorfromFilm(): #Works #6
    ActorToDelete = input("What is the Actor_ID of the actor you want to remove?:")
    MovieToTarget = input("What is the Film_ID of the film you want to remove them from?")
    connection = getConnection()
    myCursor = connection.cursor()
    query = "DELETE FROM FilmActor WHERE Actor_ID = %s AND Film_ID = %s"
    myCursor.execute(query, (ActorToDelete, MovieToTarget))
    connection.commit()
    connection.close()

def printActorsInFilm(): #Prettied #4
    rowToUpdate = input("What is the Film_ID you'd like to see the actors for?:")
    connection = getConnection()
    myCursor = connection.cursor()
    query = "SELECT First_Name, Last_Name, Person_ID AS 'Actor_ID' FROM Person where Person_ID in (SELECT Actor_ID FROM FilmActor WHERE Film_ID = %s)"
    myCursor.execute(query, (rowToUpdate,))
    myResult = myCursor.fetchone()
    print("First Name     Last Name      Actor_ID")
    print("-"*38)
    while myResult is not None:
        print(f"{myResult[0]:15}{myResult[1]:15}{myResult[2]:3}")
        myResult = myCursor.fetchone()
    connection.close()
    print()

def printFilmsActorIsIn(): #Nice Looking Now #3
    specialActor = input("Please input the Actor_ID, this will output the films they are in:")
    connection = getConnection()
    myCursor = connection.cursor()
    myCursor.execute("SELECT Title, Film_ID FROM Film WHERE Film_ID in (SELECT Film_ID FROM FilmActor WHERE Actor_ID = %s)", (specialActor,))
    myResult = myCursor.fetchone()

    print("Film Title         Film_ID")
    print("-"*26)
    while myResult is not None:
        print(f"{myResult[0]:20}{myResult[1]:5}")
        myResult = myCursor.fetchone()
    connection.close()
    print()


menuText = """Please select one of the following options:
1) Print Actors
2) Print Films
3) Print Films  that an Actor appears in
4) Print Actors in a particular Film
5) Add an Actor to a Film
6) Remove an Actor from a Film
q) Quit
"""

if __name__ == "__main__":
    menuOption = "1"
    while menuOption != 'q':
        menuOption = input(menuText)
        if menuOption == "1":
            printActors()
        elif menuOption == "2":
            printFilms()
        elif menuOption == "3":
            printFilmsActorIsIn()
        elif menuOption == "4":
            printActorsInFilm()
        elif menuOption == "5":
            insertActorintoFilm()
        elif menuOption == "6":
            removeActorfromFilm()
