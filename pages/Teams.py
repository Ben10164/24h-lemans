import streamlit as st
import utils

st.set_page_config(
    page_title="24h of Le Mans Database Teams",
    page_icon="👨‍👩‍👧‍👦",
    initial_sidebar_state="collapsed",
)

st.markdown("## Teams")
utils.switch_page_button("Goto Home", "Home")

# Initialize connection.
conn = st.connection("mysql", type="sql")
query = "SELECT team_name FROM Team;"
teams = conn.query(query)

st.markdown(
    "I mentioned it in an optional note in the Winners page, but you'll notice that there are many seemingly *duplicate* teams i.e. Scuderia Ferrari vs SEFAC Ferrari vs Ferrari AF Corsa. This is intentional because this means that the registered team is different. The AF Corsa team and Scuderia team are two separate entities. You can start typing a team name, and all variations and subentities will appear in the dropdown."
)

team = st.selectbox("Team", options=teams, index=None, placeholder="Select a team")

query = f"""
SELECT 
    TeamResult.race_id AS Year,
    TeamResult.car_number AS Number,
    Result.pos AS Result
FROM
    Team
JOIN
    TeamResult ON TeamResult.team_name = Team.team_name
JOIN 
    Result ON (
        (TeamResult.race_id = Result.race_id) 
        AND 
        (TeamResult.car_number = Result.car_number)
    )
WHERE
    Team.team_name = '{team}'
;
"""
results = conn.query(query)
results["Year"] = results["Year"].astype("str")
results = results.set_index("Year")
st.dataframe(results, use_container_width=True)

if st.toggle("View SQL statement"):
    st.markdown(
        f"""
```sql
{query}
```
"""
    )
