import streamlit as st
import utils

from sqlalchemy import text

st.set_page_config(
    page_title="24h of Le Mans Database Revisions!",
    page_icon="👨‍👩‍👧‍👦",
    initial_sidebar_state="collapsed",
)

st.markdown("## Generalizing Teams")
utils.switch_page_button("Goto Home", "Home")

st.write(
    "I mentioned it on the Teams page, but there are many separate branches of teams. The purpose of this page is to create a completely new table that will contain the relations between overarching teams."
)

# Initialize connection.
conn = st.connection("mysql", type="sql")

create_query = """
CREATE TABLE IF NOT EXISTS ParentTeam(
    child_name VARCHAR(100),
    parent_name VARCHAR(100),
    PRIMARY KEY (child_name),
    FOREIGN KEY (child_name) REFERENCES Team(team_name)
);
"""
if st.toggle("View Create table SQL statement"):
    st.markdown(
        f"""
```sql
{create_query}
```
"""
    )


with conn.connect() as connection:
    connection.execute(text(create_query))

team_list_query = """
SELECT team_name 
FROM Team;
"""

teams = conn.query(team_list_query)

team = st.selectbox(
    "Lets first check to see if the team you're curious about is already registered for a parent team!",
    options=teams,
    # index=int(teams.index[teams["team_name"] == "Toyota Gazoo Racing"][0]),
    index=None,
)

if team is not None:
    check_query = f"""
    SELECT *
    FROM 
        ParentTeam
    WHERE
        child_name='{team}';
    """

    if st.toggle("View Check SQL statement"):
        st.markdown(
            f"""
    ```sql
    {check_query}
    ```
        """
        )
    parent = conn.query(check_query)["parent_name"].get(0)

    if parent is None:
        st.write(
            "It looks like this team is not affiliated with any parent team! If possible, it would be great if you could help by registering it!!"
        )

        button = st.button("Submit SQL Code")
        if button:
            with conn.connect() as connection:
                pass
    else:
        st.write(team, "is registered to be a child team of", parent)



# 2 sql sections
# 1st easy
# 2nd a lil bit MemoryError
# question on ER stuff

# straightfroward
