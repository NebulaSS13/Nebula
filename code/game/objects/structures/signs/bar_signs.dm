
/obj/structure/sign/double/maltesefalcon
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."
	//The sign is 64x32, so it needs two tiles. ;3
	icon = 'icons/obj/signs/bar.dmi'
	//The bar sign always faces south
	directional_offset = "{'NORTH':{'y':32}, 'SOUTH':{'y':32}, 'WEST':{'y':32}, 'EAST':{'y':32}}"
	abstract_type = /obj/structure/sign/double/maltesefalcon

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"
