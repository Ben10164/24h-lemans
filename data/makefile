default: get_csv
	rm -rf temp
	rm -rf extracted_csv
	rm -rf extracted_tables
	rm -rf pages
	mariadb -e "CREATE DATABASE lemans24" && mariadb  lemans24 -e "source 0-results_in.sql" && mariadb lemans24 -e "source 1-create_tables.sql" && mariadb lemans24 -e "source 2-create_procedures.sql" && mariadb lemans24 -e "source 3-insert_data.sql"

keep: get_csv

get_csv: get_tables
	sh 3-get_csv.sh

get_tables: get_pages
	sh 2-get_tables.sh

get_pages: clone_repo
	sh 1-get_pages.sh

clone_repo:
	git clone --depth 1 https://github.com/gdsotirov/lemans24.git temp
	rm -rf temp/.git

test:
	mariadb -e "CREATE DATABASE lemans24" && mariadb  lemans24 -e "source 0-results_in.sql" && mariadb lemans24 -e "source 1-create_tables.sql" && mariadb lemans24 -e "source 2-create_procedures.sql" && mariadb lemans24 -e "source 3-insert_data.sql"