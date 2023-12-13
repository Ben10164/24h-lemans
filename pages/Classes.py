import streamlit as st
import utils

st.set_page_config(
    page_title="24h of Le Mans Database Classes",
    page_icon="👨‍👩‍👧‍👦",
    initial_sidebar_state="collapsed",
)

st.markdown("## Classes")
utils.switch_page_button("Goto Home", "Home")

st.markdown("""
This page will allow you to select numerous stats relating to the car class.
""")

# Initialize connection.
conn = st.connection("mysql", type="sql")
query = "select id from CarClass WHERE CarClass.id != '';"
classes = conn.query(query)
selected_class = st.selectbox("What class would you like to see info on?", index=None, options=classes, placeholder='Choose an option')

query = f"""
SELECT 
    Distinct car_chassis
FROM 
    Car
WHERE 
    Car.car_class_id = '{selected_class}';
"""
cars = conn.query(query)
if not (selected_class==None):
    selected_car = st.selectbox("What car from this class would you like to see info on?", options=cars['car_chassis'],index=None, placeholder='Choose an option')

    # ['id', 'car_class_id', 'car_chassis', 'car_engine', 'id', 'class_desc', 'race_id', 'car_number', 'car_id', 'race_id', 'car_number', 'pos', 'laps', 'distance', 'racing_time', 'retirement_reason']

    query = f"""
    SELECT 
        Car.car_chassis AS Chassis, CarNumber.car_number AS Num, Car.car_engine AS Engine, Result.race_id AS Year, Result.pos AS Result, Tyre.tyre_name AS Tyre
    FROM 
        Car 
    JOIN 
        CarClass ON Car.car_class_id = CarClass.id
    JOIN 
        CarNumber ON Car.id = CarNumber.car_id
    JOIN 
        Result ON CarNumber.race_id = Result.race_id AND CarNumber.car_number = Result.car_number
    JOIN
        CarTyre ON Car.id = CarTyre.car_id
    JOIN 
        Tyre on CarTyre.tyre_id = Tyre.id
    WHERE 
        Car.car_chassis = '{selected_car}' AND
        Car.car_class_id = '{selected_class}'
    ORDER BY 
        Year;
    """
    info = conn.query(query)
    info = info.set_index(["Year"])
    info.index = info.index.astype('str')
    if not (selected_class==None) and not (selected_car==None):
        st.dataframe(info, use_container_width=True)