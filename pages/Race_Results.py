import streamlit as st
import utils

st.set_page_config(
    page_title="24h of Le Mans Results",
    page_icon="🏁",
    initial_sidebar_state="collapsed",
)

st.markdown("## Results")

utils.switch_page_button("Goto Home", "Home")

# Initialize connection.
conn = st.connection("mysql", type="sql")

# pos. car_number, laps, distance, racing_time, retirement_reasons

years = conn.query("SELECT * from Race")
race_year = st.selectbox("Race year", options=years, index=len(years) - 1)

query = f"""
SELECT 
    pos AS Result, 
    car_number AS 'Car Number', 
    laps AS 'Laps Completed', 
    distance AS 'Distance Completed', 
    racing_time AS 'Time Completed', 
    retirement_reason AS 'Retirement Reason'
FROM 
    Result
WHERE 
    race_id = {race_year}
    AND pos NOT IN ('RES', 'DNA', 'DNS', 'DNQ', 'DNP')
ORDER BY
    CASE
        WHEN pos = 'NC' THEN 100 -- Finished the race, but not classified
        WHEN pos = 'DNF' THEN 150 -- Didn't finish the race
        WHEN pos = 'DSQ' THEN 200 -- Disqualification
        ELSE CAST(pos AS SIGNED)
    END,
    pos ASC,
    distance DESC;
    """

# Perform query.
race_results = conn.query(query)
# Print results.
st.write("Results for the", race_year, "race.")
st.dataframe(race_results.set_index("Result"), use_container_width=True)

if st.toggle("View SQL statement"):
    st.markdown(
        f"""
```sql
{query}
```
"""
    )


st.markdown(
    """
#### Term Glossary

* DNF
    * *Did not finish.*
    * Commonly attributed to some sort of mechanical failure or racing incident. The car did not cross the finish line following the 24-hour time being satisfied to conclude the race.


* NC
    * *Not Classified.*
    * Although the participant may have completed the race, they are not classified in the official results. This designation is often assigned for reasons such as rule infractions, technical violations, or circumstances preventing inclusion in the final standings.

* DSQ
    * *Disqualified.*
    * The participant or team has been disqualified from the race, usually due to a breach of regulations, rule violations, or other infractions.

The following are omitted from the specific results table shown above

* DNS
    * *Did not start.*
    * The participant or team did not start the race. This could be due to technical issues, driver-related reasons, or other factors preventing the commencement of the race.

* DNA
    * *Did not arrive.*
    * The participant or team did not arrive at the event location, resulting in their absence from the race.

* DNP
    * *Did not participate.*
    * The participant or team did not take part in the race for various reasons, such as withdrawal, logistical issues, or strategic decisions.

* DNQ
    * *Did not qualify.*
    * The participant or team did not qualify for the race, often due to slower lap times during the qualifying sessions.

* RES
    * *Reserve.*
    * Typically, used to designate a reserve or backup participant who may replace an original entrant if needed. In race results, it might indicate that the participant is a substitute.
"""
)
