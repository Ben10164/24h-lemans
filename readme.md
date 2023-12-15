# 24 Hours of Le Mans

[![Deployment](https://github.com/Gonzaga-CPSC-321-Fall-2023/project-Ben10164/actions/workflows/deploy.yaml/badge.svg)](https://github.com/Gonzaga-CPSC-321-Fall-2023/project-Ben10164/actions/workflows/deploy.yaml)

[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)



## How to run

### Docker

* `docker build -t streamlit .`
* `docker run -p 8080:8080 streamlit`
* That should be it!

### Manual

#### 0. Update data (optional / not recommended)

1. `cd data/`
2. `make`
3. Wait for this Makefile to finish downloading and running the scripts.
4. This will result in a new file `data/results_in_generated.csv` to be created, but most likely it will include processing errors. Because of this, I recommend using the existing `data/results_in.csv`.

#### 1. Creating the database

1. Start your MySQL/MariaDB server in a terminal: `mysql` or `mariadb`.
2. Create a new database `CREATE DATABASE lemans24;` (you can name it anything, but in this example I named it `lemans24`).

#### 2. Importing data into the database

1. Use your newly created database: `USE lemans24;`.
2. Run the 4 following scripts in `data/` (`cd data`):
    * `SOURCE 0-results_in.sql`
    * `SOURCE 1-create_tables.sql`
    * `SOURCE 2-create_procedures.sql`
    * `SOURCE 3-insert_data.sql`
3. If everything works, you should have the output `Query OK, 59158 rows affected`.

#### Run streamlit

1. Make sure you have all the packages installed: `pip install -r requirements.txt`.

2. In the directory `.streamlit/`, modify the file named `secrets.toml`. It is already added to the git ignore, so the changes won't affect anything

    ```toml
    # .streamlit/secrets.toml

    [connections.mysql]
    dialect = "mysql"
    host = "localhost" # whatever your sql host is (localhost)
    port = 3306 # your sql host post
    database = "lemans24" # whatever you named your newly created database
    username = ""
    password = ""
    ```

3. Run the streamlit app in the base repo directory: `streamlit run Home.py`.
