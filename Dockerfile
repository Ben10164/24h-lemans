FROM python:3.9-slim-bullseye
EXPOSE 3306
EXPOSE 8501
EXPOSE 8080
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN apt update

COPY requirements.txt ./requirements.txt

RUN pip install --upgrade pip \
    && pip install mysqlclient \
    && pip install -r requirements.txt

RUN apt install mariadb-server -y
COPY . .
RUN /etc/init.d/mariadb start && cd data && mariadb -e "CREATE DATABASE lemans24" && mariadb  lemans24 -e "source 0-results_in.sql" && mariadb lemans24 -e "source 1-create_tables.sql" && mariadb lemans24 -e "source 2-create_procedures.sql" && mariadb lemans24 -e "source 3-insert_data.sql"
CMD  /etc/init.d/mariadb start & streamlit run Home.py --server.port=8080 --server.enableCORS false --browser.gatherUsageStats false 
# ENTRYPOINT [ "streamlit", "run", "Home.py", "--server.port=8080", "--server.address=0.0.0.0" ]
