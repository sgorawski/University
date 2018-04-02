# mdb-project
A project for the extended Python course on the University.

Requirements:
- python 3.6
- flask 0.12
- flask-wtf
- flask-sqlalchemy
- flask-migrate
- flask-login


For the best experience I recomment using a virtual environment. To create and activate one in the project folder (`mdb-project`) execute the following commands:
```
$ python3 -m venv venv
$ source venv/bin/activate
```

To start a server with the application on a local machine run:
```
$ pip install -e .
$ export FLASK_APP=mdb
$ flask db migrate
$ flask db upgrade
$ flask run
```
You will be informed about server IP address and port in the command line (it should be `localhost:5000`). To use the application, just open it in the browser.

Please be aware that all data is stored locally, therefore the application database will not contain any after cloning the repository.
