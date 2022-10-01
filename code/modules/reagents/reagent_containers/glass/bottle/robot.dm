
/obj/item/chems/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,50,100]"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 60
	var/reagent

/obj/item/chems/glass/bottle/robot/stabilizer/Initialize()
	. = ..()
	if(reagent)
		reagents.add_reagent(reagent, volume)

/obj/item/chems/glass/bottle/robot/stabilizer
	name = "internal stabilizer bottle"
	desc = "A small bottle. Contains stabilizer - used to stabilize patients."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/liquid/stabilizer

/obj/item/chems/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of broad-spectrum antitoxins, used to neutralize poisons before they can do significant harm."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/liquid/antitoxins
