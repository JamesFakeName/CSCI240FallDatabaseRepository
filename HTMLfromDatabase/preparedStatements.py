#!/usr/bin/python3

from flask import Flask, render_template, request
import mysql.connector, os
import json


app = Flask(__name__)


@app.route('/', methods=['GET'])
def showSpeakers():
    with open('/home/jacob/CSCI240FallDatabaseRepository/secrets.json', 'r') as secretFile:
        creds = json.load(secretFile)['mysqlCredentials']

    connection = mysql.connector.connect(**creds)

    mycursor = connection.cursor()

    # If there is a name and desc 'GET' variable, insert the new value into the database
    # Starting with Jeff's example, let's see if this can work well enough. 
    newFirst = request.args.get('firstname')
    newLast = request.args.get('lastname')
    if newFirst is not None and newLast is not None:
        mycursor.execute("INSERT INTO Person (First_Name, Last_Name) values (%s, %s)", (newFirst, newLast))
        connection.commit()

    # Fetch the current values of the speaker table
    # Starting w/ Jeff's example, I hope this works. Then I guess we check if he wants it more complicated.
    mycursor.execute("SELECT First_Name, Last_Name FROM Person")
    myresult = mycursor.fetchall()
    mycursor.close()
    connection.close()
    return render_template('Person-list.html', collection=myresult)


if __name__ == '__main__':
    app.run(port=8000, debug=True, host="0.0.0.0")