import streamlit as st
import utils

st.set_page_config(
    page_title="24h of Le Mans Database Revisions!",
    page_icon="👨‍👩‍👧‍👦",
    initial_sidebar_state="collapsed",
)

st.markdown("## Generalizing Teams")
utils.switch_page_button("Goto Home", "Home")

st.write("I mentioned it on the Teams page, but there are many separate branches of teams. The purpose of this page is to create a completely new table that will contain the relations between overarching teams.")

# Initialize connection.
conn = st.connection("mysql", type="sql")
query = "SELECT team_name FROM Team;"
teams = conn.query(query)

query = f"""

"""
results = conn.query(query)
