/*| Neon Signs
   ----------------------------------------------*/

   //| Note: for a more varied range of colors, I chose not to use the
   //pre- #defined colors and instead individually converted the RGB
   //values from each sprite into hex code - Mal

/obj/structure/sign/neon/Destroy()
	set_light(0)
	return ..()

/obj/structure/sign/neon
	desc = "A glowing sign."
	icon = 'mods/content/modern_nights/icons/obj/signs.dmi'
	light_range = 4
	light_power = 2

/obj/structure/sign/neon/item
	name = "item store"
	icon_state = "item"
	light_color = "#b79f41" //copper

/obj/structure/sign/neon/motel
	name = "motel"
	icon_state = "motel"
	light_color = "#59ff9b" //teal

/obj/structure/sign/neon/hotel
	name = "hotel"
	icon_state = "hotel"
	light_color = "#59ff9b" //teal

/obj/structure/sign/neon/flashhotel
	name = "hotel"
	icon_state = "flashhotel"
	light_color = "#ff8ff8" //hot pink

/obj/structure/sign/neon/lovehotel
	name = "hotel"
	icon_state = "lovehotel"
	light_color = "#59ff9b" //teal

/obj/structure/sign/neon/sushi
	name = "sushi"
	icon_state = "sushi"
	light_color = "#7dd3ff"  //sky blue

/obj/structure/sign/neon/bakery
	name = "bakery"
	icon_state = "bakery"
	light_color = "#ff8fee" //hot pink

/obj/structure/sign/neon/beer
	name = "pub"
	icon_state = "beer"
	light_color = "#cbdc54" //yellow

/obj/structure/sign/neon/inn
	name = "inn"
	icon_state = "inn"
	light_color = "#f070ff"  //deeper hot pink

/obj/structure/sign/neon/cafe
	name = "cafe"
	icon_state = "cafe"
	light_color = "#ff8fee" //hot pink

/obj/structure/sign/neon/diner
	name = "diner"
	icon_state = "diner"
	light_color = "#39ffa4" //teal

/obj/structure/sign/neon/bar_alt
	name = "bar"
	icon_state = "bar_alt"
	light_color = "#39ffa4" //teal

/obj/structure/sign/neon/casino
	name = "casino"
	icon_state = "casino"
	light_color = "#6ce08a" //teal

/obj/structure/sign/neon/peace
	name = "peace"
	icon_state = "peace"
	light_color = "#8559ff" //a cross between the blue and purple

/obj/structure/sign/neon/sale
	name = "neon sale sign"
	icon_state = "neon_sale"
	light_color = "#6eb6ff" //sky blue

/obj/structure/sign/neon/exit
	name = "exit"
	icon_state = "exit"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/close
	name = "close"
	icon_state = "close"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/open
	name = "open"
	icon_state = "open"
	light_color = "#ffffff" //white

/obj/structure/sign/neon/disco
	name = "disco"
	icon_state = "disco"

/obj/structure/sign/neon/phone
	name = "phone"
	icon_state = "phone"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/armory
	name = "armory"
	icon_state = "armory"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/barber
	name = "\improper barber shop sign"
	desc = "A spinning sign indicating a barbershop is near."
	icon_state = "barber"
	light_color = "#6eb6ff" //sky blue

/obj/structure/sign/neon/cocktails
	name = "cocktails sign"
	desc = "The sign has has a cocktail symbol on it."
	icon_state = "cocktails"
	light_color = "#63c4d6" //light blue

/obj/structure/sign/neon/bathrooms
	name = "bathroom sign"
	desc = "A sign that indicates a unisex bathroom is here."
	icon_state = "bathroom_unisex"
	light_color = "#63c4d6" //light blue

/obj/structure/sign/neon/cryo
	name = "cryo area sign"
	desc = "A sign that indicates a cryogenic storage area is nearby."
	icon_state = "cryo"
	light_color = "#6ce08a" //teal

/obj/structure/sign/neon/heath
	name = "hospital sign"
	desc = "A neon hospital sign"
	icon_state = "medical_on"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/heath/red
	icon_state = "medicalred_on"
	light_color = "#da0205" //red

/obj/structure/sign/neon/airbus
	name = "airbus sign"
	desc = "A neon yellow airbus sign that indicates this is an airbus area."
	icon_state = "bus"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/cubed
	name = "cubed"
	desc = "That's the official emblem of the science labs run by NT."
	icon_state = "cubed"
	light_color = "#aa2799"

/obj/structure/sign/neon/vip
	name = "vip sign"
	desc = "A sign showing this is the way to the VIP room."
	icon_state = "vip"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/mayoroffice
	name = "mayor office sign"
	desc = "A sign for the city hall."
	icon_state = "mayoroffice"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/cityhall
	name = "city hall sign"
	desc = "A sign for the city hall."
	icon_state = "cityhall"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/courts
	name = "courts"
	desc = "A sign for the courts."
	icon_state = "courts"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/meetingroom
	name = "meetingroom"
	desc = "A sign for the meeting room."
	icon_state = "meetingroom"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/carpark
	name = "meetingroom"
	desc = "A sign for the car park."
	icon_state = "carpark"
	light_color = COLOR_YELLOW

/*|	                                             */
/*| Big Neon Signs
   ----------------------------------------------*/

/obj/structure/sign/neon/big
	icon = 'mods/content/modern_nights/icons/obj/signs_large.dmi'
	light_range = 6
	light_power = 8

/obj/structure/sign/neon/big/casino
	name = "casino sign"
	desc = "A neon yellow airbus sign that says CASINO in big letters."
	icon_state = "casino"
	light_color = "#ffff99"

	plane = 25

/obj/structure/sign/neon/big/aeoiu
	name = "large blue sign"
	desc = "A neon blue sign in cryptic letters."
	icon_state = "aeoiu"
	light_color = "#006fff"
	light_power = 20
	light_range = 2

/obj/structure/sign/neon/big/luckystar
	name = "luckystar sign"
	desc = "A luckystar sign in cryptic letters."
	icon_state = "luckystar"
	light_color = "#de0000"
	light_power = 8
	light_range = 3

/obj/structure/sign/neon/big/ianhi
	name = "cryptic wall sign"
	desc = "A luckystar sign in cryptic letters that is pinned to a wall."
	icon_state = "ianhi"
	light_color = "#ab00ff"
	light_power = 11
	light_range = 2

/obj/structure/sign/neon/big/inn
	name = "inn sign"
	desc = "A neon yellow airbus sign that says INN in big letters."
	icon_state = "inn"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/big/labs
	name = "laboratory sign"
	desc = "A neony purple sign with the word laboratory on it."
	icon_state = "labs"
	light_color = "#f070ff"  //deeper hot pink

/obj/structure/sign/neon/big/gym
	name = "yeka gym sign"
	desc = "A sign that represents the yekarina institute of wellness first erected by president Katya Petrovna."
	icon_state = "gym"
	light_color = "#63c4d6" //light blue

/obj/structure/sign/neon/big/police_dept
	name = "police department sign"
	desc = "A sign for the police department of Geminus City. It glows blue."
	icon_state = "police_dept"
	light_color = "#63c4d6" //light blue

/obj/structure/sign/neon/big/mall
	name = "shopping mallsign"
	desc = "A sign for the local city shopping mall."
	icon_state = "mall"
	light_color = COLOR_YELLOW

/obj/structure/sign/neon/big/court
	name = "court sign"
	desc = "A sign for the courtroom."
	icon_state = "court"
	light_color = "#63c4d6" //light blue

/obj/structure/sign/neon/big/city_hall
	name = "city hall sign"
	desc = "A sign for the city hall."
	icon_state = "city_hall"
	light_color = "#63c4d6" //light blue

/*|	                                             */
/*| Double Signs
   ----------------------------------------------*/

/obj/structure/sign/double/city
	desc = "A sign."
	pixel_y = 25
	plane = -25
	icon = 'mods/content/modern_nights/icons/obj/signs.dmi'

/obj/structure/sign/double/city/gamecenter/
	name = "Game Center"
	desc = "A flashing sign which reads 'Game Center'."
	light_color = "#ffa851" //orange
	light_range = 4
	light_power = 2

/obj/structure/sign/double/city/gamecenter/right
	icon_state = "gamecenter-right"

/obj/structure/sign/double/city/gamecenter/left
	icon_state = "gamecenter-left"

/obj/structure/sign/double/city/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/city/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/city/maltesefalcon/right
	icon_state = "maltesefalcon-right"

//Making area mapping simpler since 2240//

/obj/structure/sign/neon/drivethru
	name = "drivethru sign"
	icon_state = "drivethru1"
	light_color = "#7fea6a" //lime green

/obj/structure/sign/neon/drivethru/right
	icon_state = "drivethru2"

/obj/structure/sign/double/city/teleporter/left
	name = "teleporter"
	icon_state = "teleporter1"
/obj/structure/sign/double/city/teleporter/right
	name = "teleporter"
	icon_state = "teleporter2"

/obj/structure/sign/double/city/museum/left
	icon_state = "museum1"
/obj/structure/sign/double/museum/right
	icon_state = "museum2"

/obj/structure/sign/double/city/warden/left
	icon_state = "warden1"
/obj/structure/sign/double/city/warden/right
	icon_state = "warden2"

/obj/structure/sign/double/city/copoffice/left
	icon_state = "copoffice1"
/obj/structure/sign/double/city/copoffice/right
	icon_state = "copoffice2"

/obj/structure/sign/double/city/visit/left
	icon_state = "visit1"
/obj/structure/sign/double/city/visit/right
	icon_state = "visit2"

/obj/structure/sign/double/city/prosecution/left
	icon_state = "prosecution1"
/obj/structure/sign/double/city/prosecution/right
	icon_state = "prosecution2"

/obj/structure/sign/double/city/defense/left
	icon_state = "defense1"
/obj/structure/sign/double/city/defense/right
	icon_state = "defense2"

/obj/structure/sign/double/city/courtyard/left
	icon_state = "courtyard1"
/obj/structure/sign/double/city/courtyard/right
	icon_state = "courtyard2"

/obj/structure/sign/double/city/training/left
	icon_state = "train1"
/obj/structure/sign/double/city/training/right
	icon_state = "train2"

/obj/structure/sign/double/city/hospital/left
	icon_state = "hospital1"
/obj/structure/sign/double/city/hospital/right
	icon_state = "hospital2"

/*|	                                             */
/*| Normal Signs
   ----------------------------------------------*/

/obj/structure/sign/city
	desc = "A sign."
	icon = 'mods/content/modern_nights/icons/obj/signs.dmi'

/obj/structure/sign/city/rent
	name = "Rent sign"
	icon_state = "rent"
	desc = "A sign that says 'For Rent' on it. This house might be vacant."

/obj/structure/sign/city/coffee
	name = "Coffee And Sweets"
	desc = "A sign which reads 'Coffee and Sweets'."
	icon_state = "coffee-left"

/obj/structure/sign/city/techshop
	name = "\improper techshop"
	desc = "A sign which reads 'tech shop'."
	icon_state = "techshop"