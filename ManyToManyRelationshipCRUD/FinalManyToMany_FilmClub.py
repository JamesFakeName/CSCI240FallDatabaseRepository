#!/usr/bin/python3

from flask import Flask, render_template, request, redirect, url_for
import mysql.connector, os, json

with open('/home/jacob/CSCI240FallDatabaseRepository/secrets.json', 'r') as secretFile:
    creds = json.load(secretFile)['mysqlCredentials']

connection = mysql.connector.connect(**creds)
app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
     return render_template('base.html')

@app.route('/Film_List', methods=['GET']) #uhhh this goes with the Film_List.html
def get_Films():
    connection = mysql.connector.connect(**creds) #I'm going to leave this here just in case
    mycursor = connection.cursor()

    # check to see if a new film is to be added
    new_Film_ID = request.args.get('new_Film_ID')
    new_Film_Title = request.args.get('new_Film_Title')
    new_Film_Genre = request.args.get('new_Film_Genre')
    new_Film_Nationality = request.args.get('new_Film_Nationality')
    if new_Film_ID is not None and new_Film_Title is not None and new_Film_Genre is not None and new_Film_Nationality is not None:
        mycursor.execute("INSERT INTO Film (Film_ID, Title, Genre, Nationality) values (%s, %s, %s, %s)", (
            new_Film_ID, new_Film_Title, new_Film_Genre, new_Film_Nationality)) #This should be fine due to implict line continuation
        connection.commit()

    # check to see if a film needs to be deleted
    delete_Film_ID = request.args.get('delete_Film_id')
    if delete_Film_ID is not None:
        try:
            mycursor.execute("DELETE FROM Film WHERE Film_ID=%s",(delete_Film_ID,))
            connection.commit()
        except:
            return render_template("error.html", message="Error deleting Film") # more specific error if time allows
        
    # retrieve all films
    mycursor.execute("SELECT Film_ID, Title, Genre, Nationality FROM Film")
    pageTitle = "Showing all films!"
    allFilms = mycursor.fetchall()

    mycursor.close()
    connection.close()
    return render_template('Film_List.html', allFilms=allFilms, pageTitle=pageTitle)

@app.route('/1Film_info', methods=['GET']) #Goes with 1Film_info.html, double check later
def get_1Film_info():
    Film_ID = request.args.get('Film_ID')
    
    # redirect to all films if no id was provided
    if Film_ID is None:
        return redirect(url_for("get_Films"))

    connection = mysql.connector.connect(**creds) #Don't think I need this w/ connection up top. Keeping for now, in case
    mycursor = connection.cursor()

    # update film info
    Film_ID = request.args.get('Film_ID') 
    Title = request.args.get('Title')
    Genre = request.args.get('Genre')
    Nationality = request.args.get('Nationality')
    if Film_ID is not None and Title is not None and Genre is not None and Nationality is not None:
        mycursor.execute("UPDATE Film set Title=%s, Genre=%s, Nationality=%s where Film_ID=%s", (Title, Genre, Nationality, Film_ID))
        connection.commit()

    """ #Gotta move this down lower
    # retrieve film information
    mycursor.execute("SELECT Title, Genre, Nationality from Film where Film_ID=%s", (Film_ID,))
    try:
        Title, Genre, Nationality = mycursor.fetchall()[0]
    except:
        return render_template("error.html", message="Error retrieving Film - perhaps it doesn't exist?")
    """
    
    """ #All retrieves must be lower down, even if it doesn't look as nice to human eyes
    # retrieve actors for this film
    mycursor.execute("SELECT Person_ID, First_Name, Last_Name FROM Person WHERE Person_ID in (SELECT Actor_ID FROM FilmActor WHERE Film_ID=%s)", (Film_ID,))
    CreditedActors = mycursor.fetchall()
    """ 

    # functionality to add actor to a film #WHY DOES IT WORK NOW??
    add_Actor_to_Film = request.args.get('add_Actor_to_Film')
    if add_Actor_to_Film is not None:
        mycursor.execute("""INSERT into FilmActor (Film_Title, Actor_ID, Film_ID) values (%s, %s, %s)""", (Title, add_Actor_to_Film, Film_ID))
        connection.commit()

    # functionality to remove an actor from a film
    remove_Actor_ID = request.args.get('remove_Actor_ID')
    if remove_Actor_ID is not None:
        mycursor.execute("""DELETE FROM FilmActor WHERE Actor_ID=%s AND Film_ID=%s""", (remove_Actor_ID, Film_ID))
        connection.commit()

    # for add actor button, retrieve actors not in this film 
    mycursor.execute("""SELECT Person.Person_ID, Person.First_Name, Person.Last_Name FROM (
                        SELECT Person_ID FROM Actor
                        EXCEPT
                        SELECT Person_ID FROM Actor WHERE Person_ID in(SELECT Actor_ID FROM FilmActor WHERE Film_ID=%s)) as NotThisFilmActors
                     join Person on NotThisFilmActors.Person_ID=Person.Person_ID
                     """, (Film_ID,))
    RemainingActors = mycursor.fetchall()
    #print(RemainingActors)
    # IT LIVES :D THanks for all the help Jeff!

    # retrieve film information
    mycursor.execute("SELECT Title, Genre, Nationality from Film where Film_ID=%s", (Film_ID,))
    try:
        Title, Genre, Nationality = mycursor.fetchall()[0]
    except:
        return render_template("error.html", message="Error retrieving Film - perhaps it doesn't exist?")
    
    # retrieve actors for this film
    mycursor.execute("SELECT Person_ID, First_Name, Last_Name FROM Person WHERE Person_ID in (SELECT Actor_ID FROM FilmActor WHERE Film_ID=%s)", (Film_ID,))
    CreditedActors = mycursor.fetchall()
    
    
    mycursor.close()
    connection.close()

    return render_template(
        "1Film_info.html", 
        CreditedActors=CreditedActors, 
        Film_ID=Film_ID, 
        Title=Title, 
        Genre=Genre, 
        Nationality=Nationality, 
        OtherActors=RemainingActors
        )

@app.route('/Actor_List', methods=['GET']) #Goes with Actor_List
def get_Actor_List():
    connection = mysql.connector.connect(**creds) #I'm going to leave this here just in case
    mycursor = connection.cursor()

    # check to see if a new actor is to be added #WHY DO YOU WORK NOW???
    new_Person_ID = request.args.get('new_Person_ID')
    new_First_Name = (request.args.get('new_First_Name'))
    new_Last_Name = (request.args.get('new_Last_Name'))
    if new_Person_ID is not None and new_First_Name is not None and new_Last_Name is not None:
        mycursor.execute("""INSERT INTO Person (Person_ID, First_Name, Last_Name) 
                         values (%s, %s, %s)""",(new_Person_ID, new_First_Name, new_Last_Name)) #This should be fine due to implict line continuation
        connection.commit()
        mycursor.execute("INSERT INTO Actor (Person_ID) values (%s)", (new_Person_ID,))
        connection.commit()

    # check to see if an actor needs to be deleted
    delete_Person_ID = request.args.get('delete_Person_ID')
    if delete_Person_ID is not None:
        try:
            mycursor.execute("DELETE FROM Person WHERE Person_ID=%s",(delete_Person_ID,)) #should cascade delete
            connection.commit()
        except:
            return render_template("error.html", message="Error deleting this actor") # more specific error if time allows
        
    # retrieve all actors
    mycursor.execute("""SELECT Person_ID, First_Name, Last_Name FROM Person WHERE Person_ID in (
                     SELECT Person_ID FROM Actor)""")
    allActors = mycursor.fetchall()

    pageTitle = "Showing all actors in the database"

    mycursor.close()
    connection.close()
    return render_template('Actor_List.html', allActors=allActors, pageTitle=pageTitle)

@app.route('/1Actor_info', methods=['GET']) #Goes with 1Actor_info
def get_1Actor_info():
    Person_ID = request.args.get('Person_ID')
    
    # redirect to all actors if no id was provided
    if Person_ID is None:
        return redirect(url_for("get_Actor_List"))

    connection = mysql.connector.connect(**creds) #Don't think I need this w/ connection up top. Keeping for now, in case
    mycursor = connection.cursor()

    # update actor info
    Person_ID = request.args.get('Person_ID')
    First_Name = request.args.get('First_Name')
    Last_Name = request.args.get('Last_Name')
    Actor_ID = Person_ID #Real hopefully this will work the way I want
    if Person_ID is not None and First_Name is not None and Last_Name is not None:
        mycursor.execute("UPDATE Person set First_Name=%s, Last_Name=%s where Person_ID=%s", (First_Name, Last_Name, Person_ID))
        connection.commit()
    
    # functionality to add a film role to the actor on the actor's page #IT $%^&ING WORKS :D
    assign_Film_to_Actor = request.args.get('assign_Film_to_Actor')
    if assign_Film_to_Actor is not None:
        mycursor.execute("""INSERT into FilmActor (Actor_ID, Film_ID) values (%s, %s)""", (Person_ID, assign_Film_to_Actor)) 
        # ^ deal with Title later?
        connection.commit()
    
    # functionality to remove a film credit from an actor
    remove_Film_ID = request.args.get('remove_Film_ID')
    if remove_Film_ID is not None:
        mycursor.execute("""DELETE FROM FilmActor WHERE Actor_ID=%s AND Film_ID=%s""", (Person_ID, remove_Film_ID))
        connection.commit()
    
    # for add film button, to retrieve movies the actor did not star in # Please work
    mycursor.execute("""SELECT Film.Film_ID, Film.Title, Film.Genre, Film.Nationality FROM (
                        SELECT Film_ID FROM Film
                        EXCEPT
                        SELECT Film_ID FROM Film WHERE Film_ID in(SELECT Film_ID FROM FilmActor WHERE Actor_ID=%s)) as NotThisActorFilms
                     join Film on NotThisActorFilms.Film_ID=Film.Film_ID
                     """, (Person_ID,))
    RemainingFilms = mycursor.fetchall()

    # retrieve Actor information #Make sure this the second lowest subsection
    mycursor.execute("SELECT First_Name, Last_Name from Person where Person_ID=%s", (Person_ID,))
    try:
        First_Name, Last_Name = mycursor.fetchall()[0]
    except:
        return render_template("error.html", message="Error retrieving actor info - perhaps you put in the wrong ID?")

# retrieve films this actor has been in #This should be the lowest subsection with functionality I think? You know whatI mean
    mycursor.execute("SELECT Film_ID, Title, Genre, Nationality FROM Film WHERE Film_ID in (SELECT Film_ID FROM FilmActor WHERE Actor_ID=%s)", (Person_ID,))
    CreditedRoles = mycursor.fetchall()

    #pageTitle = f"Info (and Update) page for {First_Name} {Last_Name}" 

    mycursor.close()
    connection.close()

    return render_template(
        "1Actor_info.html", 
        CreditedRoles=CreditedRoles, 
        Person_ID=Person_ID, 
        First_Name=First_Name, 
        Last_Name=Last_Name, 
        OtherFilms=RemainingFilms
        )


if __name__ == '__main__':
    app.run(port=8001, debug=True, host="0.0.0.0")