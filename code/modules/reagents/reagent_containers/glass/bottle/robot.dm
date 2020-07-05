
/obj/item/chems/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,50,100]"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 60
	var/reagent = ""

/obj/item/chems/glass/bottle/robot/stabilizer
	name = "internal stabilizer bottle"
	desc = "A small bottle. Contains stabilizer - used to stabilize patients."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/liquid/stabilizer

/obj/item/chems/glass/bottle/robot/stabilizer/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/stabilizer, 60)
	update_icon()

/obj/item/chems/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/liquid/antitoxins

/obj/item/chems/glass/bottle/robot/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/antitoxins, 60)
	update_icon()