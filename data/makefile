default: get_csv
	rm -rf temp
	rm -rf extracted_csv
	rm -rf extracted_tables
	rm -rf pages

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
