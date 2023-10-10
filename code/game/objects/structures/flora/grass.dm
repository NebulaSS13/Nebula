////////////////////////////////////////
// Grass
////////////////////////////////////////
/obj/structure/flora/grass
	name    = "grass"
	icon    = 'icons/obj/flora/snowflora.dmi'

/obj/structure/flora/grass/get_material_health_modifier()
	return 0.03

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/init_appearance()
	icon_state = "snowgrass[rand(1, 3)]bb"

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/init_appearance()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/init_appearance()
	icon_state = "snowgrassall[rand(1, 3)]"
