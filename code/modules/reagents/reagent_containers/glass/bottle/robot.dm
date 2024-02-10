
/obj/item/chems/glass/bottle/robot
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,50,100]"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 60

/obj/item/chems/glass/bottle/robot/Initialize()
	. = ..()
	update_icon()

/obj/item/chems/glass/bottle/robot/stabilizer
	name = "internal stabilizer bottle"
	desc = "A small bottle. Contains stabilizer - used to stabilize patients."

/obj/item/chems/glass/bottle/robot/stabilizer/populate_reagents()
	add_to_reagents(/decl/material/liquid/stabilizer, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of broad-spectrum antitoxins, used to neutralize poisons before they can do significant harm."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/robot/antitoxin/populate_reagents()
	add_to_reagents(/decl/material/liquid/antitoxins, reagents.maximum_volume)
	. = ..()
