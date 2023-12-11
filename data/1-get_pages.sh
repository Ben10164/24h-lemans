#!/bin/bash

mkdir -p pages

curr_year=$(date +%Y)
for i in `seq 1923 1934; seq 1937 1939; seq 1949 1975; seq 1977 ${curr_year}`; do
  echo "Downloading page for the ${i} race!";
  wget -q "https://en.wikipedia.org/wiki/${i}_24_Hours_of_Le_Mans" -O pages/results_${i}.html;
done
