import streamlit as st
import utils
st.set_page_config(
    page_title="24h of Le Mans Database History",
    page_icon="📖",
    initial_sidebar_state="collapsed",
)
utils.switch_page_button('Goto Home', 'Home')
st.markdown(
    """## History
*All images here will be in the public domain.*

Established in 1923, the race has been a testing ground for automotive innovation and engineering prowess, pushing the boundaries of technology and performance. The event's unique format, with teams competing non-stop for 24 hours, has challenged both drivers and machines, making it a true test of endurance and skill. From the legendary events of 'Ford v Ferrari's to Ferrari's return to the top class after 50 years to win the centennial Le Mans in 2023, Le Mans has been one of the most punishing and rewarding race of all time.
    """
)


st.markdown(
    """### Early Beginnings (1923-1939)

The genesis of the 24 Hours of Le Mans can be traced back to the aftermath of World War I, when the Automobile Club de l'Ouest (ACO) sought to revive French motorsport. In 1923, the inaugural race took place on the public roads surrounding the town of Le Mans, forming the Circuit de la Sarthe, a grueling track known for its long straights and challenging corners.

The first race attracted a diverse array of entries, reflecting the spirit of innovation and experimentation that defined early 20th-century automotive engineering. The initial format featured a Le Mans start, where drivers sprinted across the track to their parked cars, adding a unique and hazardous element to the competition.

The inaugural winners, André Lagache and René Léonard, piloted a Chenard et Walcker, a French make that embodied the spirit of the event. The race's initial years witnessed a mix of French and British manufacturers dominating the field, including Bentley, Sunbeam, and Lorraine-Dietrich."""
)
st.image(
    "images/image1.jpg",
    # "images/Deux_Bugatti_(à_G),_29_Max_de_Pourtalès-_Sosthène_de_La_Rochefoucault_(10e)_et_28_René_Marie-Louis_Pichard,_et_(à_D)_la_Montier_Special_19_de_Charles_Montier_et_Albert_Ouriou.jpg",
    caption="Lineup of cars at the inaugural race in 1923. Left to right: The #29 Bugatti of de Pourtalès and de la Rochefoucauld; the #28 Bugatti of Pichard and Marie; and the #19 Montier-Ford Special of Montier and Ouriou. I wonder if they had any idea just how iconic of a race this would soon become. Picture by Agence Rol, a French photo agency.",
)

st.markdown(
    """### The Golden Age of Endurance (1920s-1930s)

The late 1920s and early 1930s marked the golden age of endurance racing at Le Mans. The Bentley Boys, a group of wealthy British gentlemen racers, became synonymous with the race, achieving victories in 1924, 1927, 1928, and 1929. Woolf Barnato, one of the Bentley Boys, gained legendary status by winning three consecutive races from 1928 to 1930.

During this era, the race became a testing ground for cutting-edge automotive technology. Supercharged engines, streamlined bodywork, and advanced suspension systems were introduced, pushing the boundaries of what was possible in the pursuit of speed and endurance.

### Interruption by World War II (1939-1949)

The outbreak of World War II brought a halt to the 24 Hours of Le Mans, as the Circuit de la Sarthe was repurposed for military use. Racing activities resumed in 1949, with the 1940s and early 1950s witnessing the resurgence of international competition. The 1950 race marked the return to a more stable and competitive environment, with Talbot-Lago securing victory.

The post-war period laid the foundation for the intense rivalries and technological innovations that would define Le Mans in the decades to come, setting the stage for the dominance of Jaguar, Ferrari, and the emergence of the Ford vs. Ferrari battles in the 1960s."""
)

st.image(
    "images/1950_Cadillac_at_LeMans.jpg",
    caption="The number 2 Cadillac raced by Briggs Cunningham at LeMans in 1950 going underneath the Dunlop bridge. I can't believe that people used to be able to stand on top of the bridge during races FOR FREE! Picture taken by John Lloyd.",
)

st.markdown(
    """
### Ferrari vs. Jaguar (1950s-1960s)

The 1950s witnessed the emergence of intense competition between Ferrari and Jaguar. Ferrari, led by the charismatic Enzo Ferrari, aimed for dominance in endurance racing. Jaguar, on the other hand, sought to make its mark with the elegant and powerful D-Type. The battle between these two iconic manufacturers produced memorable moments, including the triumph of the Jaguar D-Type in 1955 with Mike Hawthorn and Ivor Bueb at the helm.

### Ford vs. Ferrari (1960s)

The 1960s brought about one of the most celebrated rivalries in motorsports—Ford vs. Ferrari. Ford, seeking to enhance its global image, aimed to dethrone Ferrari, which had been dominating Le Mans. The result was the Ford GT40, a legendary sports car that would go on to win four consecutive Le Mans titles from 1966 to 1969. The rivalry was immortalized in the 2019 film "Ford v Ferrari," capturing the drama, engineering prowess, and human spirit that defined this era.

### Porsche's Dominance (1970s)

The 1970s marked the era of Porsche dominance at Le Mans. The Porsche 917, with its flat-12 engine, became an icon of endurance racing. Porsche secured its first overall victory in 1970, and in the subsequent years, the 917 and later the 936 continued to dominate the podium. Notable victories include the 1-2-3 finish in 1971 and the iconic Martini Racing-liveried Porsches that became synonymous with success at Le Mans.

### Mazda's Historic Win (1991)

Although outside the traditional 1950s-1970s timeline, it's essential to mention Mazda's historic victory in 1991. The Mazda 787B, powered by a rotary engine, not only marked Japan's first win at Le Mans but also remains the only victory for a car with a non-reciprocating engine. The distinctive wail of the rotary engine added a unique soundtrack to Le Mans history.
            """
)

st.image(
    "images/Le_Mans-120121-0073FP.jpg",
    "The 1991 Le Man winner Mazda 787B exiting what I believe to be the Ford Chicane, turns 18 through 21 (47.9468° N, 0.2088° E). I actually pulled up a map of the 1990-2001 layout because I was curious where the photographer was standing. This is the first Japanese car to win the 24 Hours of Le Mans. Picture taken by JPRoche~commonswiki",
)

st.markdown(
    """
### Audi's Era of Dominance (2000s-2010s)

Entering the 21st century, Audi ushered in a new era of dominance at Le Mans. Introducing cutting-edge diesel and later hybrid technology, Audi achieved unparalleled success with the R8, R10, R15, and R18 models. The battles between Audi and Peugeot, particularly in the late 2000s, showcased advancements in fuel efficiency and hybrid powertrains. Audi's strategic use of technology and a formidable driver lineup solidified its status as a modern Le Mans powerhouse.
            """
)
st.image(
    "images/Audi_wins_LM_2014.jpg",
    caption="The No. 2 and No. 1 Audi R18 e-tron quattros cross the finish line to win the 2014 24 Hours of Le Mans. Funny story, I've actually seen that Number 2 car in person. I took a wrong turn on my way through Redmond and drove past a Microsoft building that had it on display. I immediately pulled over because I thought I was hallucinating, but nope, it was right there! If it wasn't at night time and the walls being all windows, I probably would have missed it. Picture taken by Curt Smith.",
)

st.markdown(
    """
### The Centennial Race (2023)
For the 100th year race, Ferrari ended its absence of racing in the top class for 50 years at Le Mans with a fairytail win in 2023. Up against Toyota Gazoo Racing, a team who had won the previous 5 Le Mans, Ferrari stunned the world by qualifying 1st and 2nd. What followed was an action packed 24 hours, heralded as the start of the next great era in motoracing. After the number 50 Ferrari suffered a leak in the front-right brake radiator, the number 51 Ferrari and number 8 Toyota battled for hours on the same pit strategy. Suffering from a communications system failure, the number 51 Ferrari lost the lead in the final hours the number 8 Toyota due to a malfunction in the system reboot process. After struggling for every extra millisecond he could get, Alessandro Pier Guidi made the move to overtake the Toyota, resulting in Ferrari's first Le Mans win since 1965. I HIGHLY recommend watching a race recap or if you're really interested the full 24 hours of racing for free on YouTube.
            """
)

# The next era
st.image(
    "images/Ferrari_499P_-_Hybrid,_2023.jpg",
    caption="Race winning car number Ferrari 499P - Hybrid during the 24 hours of Le Mans driven by Alessandro Pier Guidi, James Calado and Antonio Giovinazzi. I can't stress enough how incredible this race was. Picture taken by Wolkenjaeger~commonswiki.",
)

st.markdown("### \"The next golden era of motorsports racing\"")
st.markdown("With BMW, Lamborghini, and Alpine joining the Hypercar class, only time will tell what the future of this historic race has in store for us.")