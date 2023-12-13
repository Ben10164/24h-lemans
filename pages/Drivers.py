import streamlit as st
import utils

st.set_page_config(
    page_title="24h of Le Mans Database Drivers",
    page_icon="⚙️",
    initial_sidebar_state="collapsed",
)

st.markdown("## Drivers")
utils.switch_page_button("Goto Home", "Home")

driver_name = st.text_input(
    "Please insert the name of the driver you'd like to see information about.",
    value="Tom Kristensen",
)

# Initialize connection.
conn = st.connection("mysql", type="sql")
# ['id', 'driver_name', 'country', 'driver_id', 'race_id', 'car_number', 'driver_order', 'team_name', 'race_id', 'car_number', 'pos', 'laps', 'distance', 'racing_time', 'retirement_reason']
query = """
SELECT 
    Result.race_id AS 'Race Year', Result.pos AS 'Result', Result.laps AS 'Laps Completed', Result.distance AS 'Distance Completed', Result.retirement_reason AS 'Retirement Reason', DriverResult.car_number
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
    Driver.driver_name= :name
ORDER BY
    Result.race_id;
"""
results = conn.query(query, params={"name": driver_name})
results['Race Year'] = results["Race Year"].astype('str')
results = results.set_index('Race Year')
# names['First Win'] = names['First Win'].astype('str') # theres a stupid comma in the year even though its datatype is YEAR(4)
st.write("Drivers who have won at least once")
st.dataframe(results, use_container_width=True)

st.markdown(
    """
Here are some famous drivers so you can easily look up their stats.

Legendary Drivers:
* `Tom Kristensen`
* `Jacky Ickx`
* `Derek Bell`
* `Frank Biela`
* `Emanuele Pirro`
* `Olivier Gendebien`
* `Henri Pescarolo`
* `Yannick Dalmas`
* `Sébastien Buemi`
* `Allan McNish`

Celebrities:
* `Paul Newman`
* `Fabien Barthez`
* `Nick Mason`
* `Mark Thatcher`
* `Eddie Jordan`
* `Patrick Dempsey`

Formula 1 Drivers:
* `Nino Farina`
* `Juan Manuel Fangio`
* `Alberto Ascari`
* `Mike Hawthorn`
* `Jack Brabham`
* `Phil Hill`
* `Graham Hill`
* `Jim Clark`
* `John Surtees`
* `Denny Hulme`
* `Jackie Stewart`
* `Jochen Rindt`
* `Mario Andretti`
* `Alan Jones`
* `Nelson Piquet`
* `Keke Rosberg`
* `Nigel Mansell`
* `Michael Schumacher `
* `Damon Hill`
* `Jacques Villeneuve`
* `Fernando Alonso `
* `Jenson Button`
"""
)
