import streamlit as st
import utils

st.set_page_config(
    page_title="24h of Le Mans Database Winners",
    page_icon="𐃃",
    initial_sidebar_state="collapsed",
)

st.markdown("## Winners")
st.markdown("If you want a more detailed exploration of the drivers, use the drivers page.")
utils.switch_page_button('Goto Home', 'Home')

# Initialize connection.
conn = st.connection("mysql", type="sql")

col1, col2= st.columns(2)
with col1:
    query = """
    SELECT 
        Driver.driver_name AS Name, 
        COUNT(*) AS Wins,
        MIN(Result.race_id) AS 'First Win',
        Driver.country
    FROM 
        Driver
    JOIN 
        DriverResult ON Driver.id = DriverResult.driver_id
    JOIN 
        Result ON (
            DriverResult.race_id = Result.race_id 
            AND DriverResult.car_number = Result.car_number
        )
    WHERE 
        Result.pos = 1
    GROUP BY 
        Driver.id
    ORDER BY 
        Wins DESC,
        MIN(Result.race_id);
    """
    names = conn.query(query)
    names['First Win'] = names['First Win'].astype('str') # theres a stupid comma in the year even though its datatype is YEAR(4)
    st.write("Teams who have won at least once.")
    st.dataframe(names.set_index("Name"))
with col2:
    query = """
    SELECT 
        Team.team_name AS Name, 
        COUNT(*) AS Wins,
        MIN(Result.race_id) AS 'First Win',
        Team.country
    FROM 
        Team
    JOIN
        TeamResult ON Team.team_name = TeamResult.team_name
    JOIN 
        Result ON (
            TeamResult.race_id = Result.race_id 
            AND TeamResult.car_number = Result.car_number
        )
    WHERE 
        Result.pos = 1
    GROUP BY 
        Team.team_name
    ORDER BY 
        Wins DESC,
        MIN(Result.race_id);
    """
    names = conn.query(query)
    names['First Win'] = names['First Win'].astype('str') # theres a stupid comma in the year even though its datatype is YEAR(4)
    st.markdown("Teams who have won at least once.", help="This counts different variations of teams as seperate teams entirely (Scuderia Ferrari vs SEFAC Ferrari vs Ferrari AF Corsa). This is because the official team they are entered under is different.")
    st.dataframe(names.set_index("Name"), use_container_width=True)
