[ -e test.db ] && rm test.db
sqlite3 test.db < schema.sql