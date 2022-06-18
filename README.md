# Final project for CS340

Created by Seth Weiss and Orion Junkins /n
A database of avalanche centers, forecasts, and observations in the U.S. 
Includes an ER Diagram, a Relational Schema, a database built with SQLite, example queries, and a PHP web app for accessing the data. 

## Quickstart Guide
#### 1) Build DB (Mac/Linux):

```
bash build_db.sh
```

This will delete any existing file named `test.db` and rebuild a new one.
If for some reason `test.db` is not removed, manually remove it then call the command again to create a new one. 
Follow with the command `sqlite3 test.db`.

#### 2) Run PHP Server:
```
php -S 127.0.0.1:8000
```

#### 3) Run Web App:
Open a browser and navigate
```
http://127.0.0.1:8000/web_app.php
```
A video demonstration of the Web App can be found here:

https://www.youtube.com/watch?v=hUimRLaW3Ts
