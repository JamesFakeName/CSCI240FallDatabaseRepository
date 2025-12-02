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
            mycursor.execute("delete from Film where Film_ID=%s",(delete_Film_ID,))
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
    update_1Film_info = (
      request.args.get('Film_ID'), #Think this has to not be here
      request.args.get('Title'),
      request.args.get('Genre'),
      request.args.get('Nationality')
    )
    if not None in update_1Film_info:
        mycursor.execute("UPDATE Film set Title=%s, Genre=%s, Nationality=%s where Film_ID=%s", (Title, Genre, Nationality, Film_ID))
        connection.commit()

    # retrieve film information
    mycursor.execute("SELECT Title, Genre, Nationality from Film where Film_ID=%s", (Film_ID,))
    try:
        Title, Genre, Nationality = mycursor.fetchall()[0]
    except:
        return render_template("error.html", message="Error retrieving Film - perhaps it doesn't exist?")
    
    # retrieve actors for this film
    mycursor.execute("SELECT Person_ID, First_Name, Last_Name FROM Person WHERE Person_ID in (SELECT Actor_ID FROM FilmActor WHERE Film_ID=%s)", (Film_ID,))
    ActorsInFilm = mycursor.fetchall()

    # retrieve list of other films the actor is not in 
    mycursor.execute("""SELECT )


    
    mycursor.close()
    connection.close()

    return render_template(
        "1Film_info.html", 
        ActorsInFilm=ActorsInFilm, 
        Film_ID=Film_ID, 
        Title=Title, 
        Genre=Genre, 
        Nationality=Nationality, 
        CreditedActors=CreditedActors
        UncreditedActors=AllActors
        )

if __name__ == '__main__':
    app.run(port=8001, debug=True, host="0.0.0.0")