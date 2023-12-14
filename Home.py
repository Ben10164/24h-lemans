import streamlit as st
import utils

st.set_page_config(
    page_title="24h of Le Mans Database Home",
    page_icon="🏎️",
    initial_sidebar_state="collapsed",
)

st.markdown(
    """
    ### Hello!
    #### Welcome to my 24 Hours of Le Mans database application!"""
)
st.markdown(
    """
    The main user functionality will be the ability to navigate through all recorded race results and entries into the world famous 24 Hours of Le Mans.
    """,
    help="This app was made for my final project in CPSC 321, Database Management Systems. Thats why there might be some weird phrasing or terminology that may seem obvious or unnecessary.",
)

st.markdown("### Pages\n(Click the button to go to that specific page)")
utils.switch_page_button("History", "History")
utils.switch_page_button("Race Results", "Race_Results")
utils.switch_page_button("Winners", "Winners")
utils.switch_page_button("Drivers", "Drivers")
utils.switch_page_button("Classes", "Classes")
utils.switch_page_button("Teams", "Teams")
utils.switch_page_button("Classifying Teams", "Update")
