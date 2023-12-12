# 24 Hours of Le Mans

## How to run

### 0. Update data (optional / not recommended)

1. `cd data/`
2. `make`
3. Wait for this Makefile to finish downloading and running the scripts.
4. This will result in a new file `data/results_in_generated.csv` to be created, but most likely it will include processing errors. Because of this, I recommend using the existing `data/results_in.csv`.

### 1. Creating the database

1. Start your MySQL/Mariadb server in a terminal: `mysql` or `mariadb`.
2. Create a new database `CREATE DATABASE lemans24;` (you can name it anything, but in this example I named it `lemans24`).

### 2. Importing data into the database

1. Use your newly created database: `USE lemans24;`.
2. Run the 4 following scripts:
    * `SOURCE 0-results_in.sql`
    * `SOURCE 1-create_tables.sql`
    * `SOURCE 2-create_procedures.sql`
    * `SOURCE 3-insert_data.sql`
3. If everything works, you should have the output `Query OK, 59416 rows affected`.

### Run streamlit

1. Make sure you have all the packages installed: `pip install -r requirements.txt`.

2. In the directory `.streamlit/`, create a new file named `secrets.toml`. It is already added to the git ignore.

    ```toml
    # .streamlit/secrets.toml

    [connections.mysql]
    dialect = "mysql"
    host = "localhost" # whatever your sql host is (localhost)
    port = 3306 # your sql host post
    database = "lemans24" # whatever you named your newly created database
    username = "BensRealSqlUsername" # your mysql username
    password = "" # your MySQL password (can be blank if none)
    ```

3. Run the streamlit app in the base repo directory: `streamlit run Home.py`.
