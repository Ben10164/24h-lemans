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
query = ""