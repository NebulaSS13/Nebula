/obj/item/clothing/jumpsuit/orange
	name = "orange jumpsuit"
	desc = "It's standardised prisoner-wear. Its suit sensor controls are permanently set to the \"Fully On\" position."
	icon = 'icons/clothing/jumpsuits/jumpsuit_prisoner.dmi'

/obj/item/clothing/jumpsuit/orange/Initialize()
	. = ..()
	var/obj/item/clothing/sensor/vitals/sensor = new(src)
	sensor.set_sensors_locked(TRUE)
	sensor.set_sensor_mode(VITALS_SENSOR_TRACKING)
	attach_accessory(null, sensor)

/obj/item/clothing/jumpsuit/blackjumpshorts
	name = "black jumpsuit shorts"
	desc = "The latest in space fashion, in a ladies' cut with shorts."
	icon = 'icons/clothing/jumpsuits/jumpsuit_shorts.dmi'

/obj/item/clothing/jumpsuit/white
	name = "white jumpsuit"
	color = "#ffffff"

/obj/item/clothing/jumpsuit/black
	name = "black jumpsuit"
	color = "#3d3d3d"

/obj/item/clothing/jumpsuit/grey
	name = "grey jumpsuit"
	color = "#c4c4c4"

/obj/item/clothing/jumpsuit/blue
	name = "blue jumpsuit"
	color = "#0066ff"

/obj/item/clothing/jumpsuit/lightblue
	name = "light blue jumpsuit"
	color = COLOR_LIGHT_CYAN

/obj/item/clothing/jumpsuit/pink
	name = "pink jumpsuit"
	color = "#df20a6"

/obj/item/clothing/jumpsuit/red
	name = "red jumpsuit"
	color = "#ee1511"

/obj/item/clothing/jumpsuit/green
	name = "green jumpsuit"
	color = "#42a345"

/obj/item/clothing/jumpsuit/yellow
	name = "yellow jumpsuit"
	color = "#ffee00"

/obj/item/clothing/jumpsuit/lightpurple
	name = "light purple jumpsuit"
	color = "#c600fc"

/obj/item/clothing/jumpsuit/brown
	name = "brown jumpsuit"
	color = "#c08720"
