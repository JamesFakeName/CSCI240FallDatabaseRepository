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
    delete_Film_ID = request.args.get('delete_Film_ID')
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
    return render_template('Film_List.html', FilmList=allFilms, pageTitle=pageTitle)

@app.route('/1Film_info', methods=['GET'])
def get_1Film_info():
    Film_ID = request.args.get('Film_ID')
    
    # redirect to all courses if no id was provided
    if Film_ID is None:
        return redirect(url_for("get_Films"))

    connection = mysql.connector.connect(**creds) #Don't think I need this w/ connection up top. Keeping for now, in case
    mycursor = connection.cursor()

    # update film info
    course_nam = request.args.get('course_name')
    course_code = request.args.get('course_code')
    if course_name is not None and course_code is not None:
        mycursor.execute("UPDATE course set course_name=%s, course_code=%s where id=%s", (course_name, course_code, course_id))
        connection.commit()

    # retrieve course information
    mycursor.execute("SELECT course_name, course_code from course where id=%s", (course_id,))
    try:
        course_name, course_code = mycursor.fetchall()[0]
    except:
        return render_template("error.html", message="Error retrieving course - perhaps it doesn't exist")
    
    # retrieve existing sections of course
    mycursor.execute("SELECT id, meeting_time, meeting_days, meeting_room from section where course_id=%s", (course_id,))
    existingSections = mycursor.fetchall()
    
    mycursor.close()
    connection.close()

    return render_template("course-info.html",
                           course_id=course_id,
                           course_name=course_name,
                           course_code=course_code,
                           existingSections=existingSections
                           )




if __name__ == '__main__':
    app.run(port=8001, debug=True, host="0.0.0.0")