# Final project for CS340

Created by Seth Weiss and Orion Junkins

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