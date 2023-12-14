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
    connection.commit()
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
    check_query = f"SELECT * FROM ParentTeam WHERE child_name='{team}';"
    res = conn.query(check_query)
    parent = res["parent_name"].get(0)

    if parent is None:
        st.write(
            "It looks like this team is not affiliated with any parent team! If possible, it would be great if you could help by registering it!!"
        )

        user_input_team = st.text_input(
            "What is their parent company?",
        )
        insert_query = """
-- ParentTeam(child_name, parent_name)
-- This SQL statement uses functions that make SQL injections impossible.
-- However, for markdown syntax highlighting purposes, they will appear
-- as if they are affecting the statement.
INSERT INTO 
    ParentTeam (child_name, parent_name) 
VALUES 
    (:child_team, :parent_team)
;
"""
        # statement = text(insert_query).bindparams(child_team=team, parent_team=user_input_team)
        st.markdown(
            f"""
```sql
{insert_query.replace(":child_team", "'"+team+"'").replace(":parent_team", "'"+user_input_team+"'")}
```
"""
        )
        if st.button("Submit SQL Code"):
            with conn.connect() as connection:
                connection.execute(
                    text(insert_query).bindparams(
                        child_team=team, parent_team=user_input_team
                    )
                )
                connection.commit()
                st.cache_data.clear()
                st.rerun()
    else:
        st.write(team, "is registered to be a child team of", parent)
        correct = st.selectbox(
            "Is this correct? (To your knowledge)", options=["Yes", "No"], index=None, key='correct'
        )
        if correct == "Yes":
            st.write("Yay! Thanks!")
        elif correct == "No":
            st.write("Uh oh, lets fix that.")
            st.write(
                "So we have two options here. We can update this to be accurate or we can delete this record and let someone else who does know add it in the future."
            )
            revise = st.selectbox(
                "So we have two options here. We can update this to be accurate or we can delete this record and let someone else who does know add it in the future.",
                options=["Update", "Delete"],
                index=None,
            )
            if revise == "Update":
                user_input_team = st.text_input(
                    "What is their parent company?",
                )
                update_query = f"""
-- ParentTeam(child_name, parent_name)
-- This SQL statement uses functions that make SQL injections impossible.
-- However, for markdown syntax highlighting purposes, they will appear
-- as if they are affecting the statement.
UPDATE ParentTeam
    SET parent_name = :parent_team
WHERE
    child_name = '{team}'
;
"""
                # statement = text(insert_query).bindparams(child_team=team, parent_team=user_input_team)
                st.markdown(
                    f"""
```sql
{update_query.replace(":parent_team", "'"+user_input_team+"'")}
```
"""
                )
                if st.button("Submit SQL Code"):
                    with conn.connect() as connection:
                        connection.execute(
                            text(update_query).bindparams(
                                parent_team=user_input_team
                            )
                        )
                        connection.commit()
                        st.session_state.clear()
                        st.cache_data.clear()
                        st.rerun()
            elif revise == "Delete":
                if st.button(
                    "Press to confirm the deletion of "
                    + team
                    + "'s parent team relation."
                ):
                    query = f"""
DELETE FROM ParentTeam WHERE child_name = '{team}';
"""
                    with conn.connect() as connection:
                        connection.execute(text(query))
                        connection.commit()
                    st.cache_data.clear()
                    st.rerun()


# 2 sql sections
# 1st easy
# 2nd a lil bit MemoryError
# question on ER stuff

# straightfroward
