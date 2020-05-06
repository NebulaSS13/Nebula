
/obj/item/chems/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,50,100]"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 60
	var/reagent = ""

/obj/item/chems/glass/bottle/robot/adrenaline
	name = "internal adrenaline bottle"
	desc = "A small bottle. Contains adrenaline - used to stabilize patients."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/adrenaline

/obj/item/chems/glass/bottle/robot/adrenaline/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/adrenaline, 60)
	update_icon()

/obj/item/chems/glass/bottle/robot/antitoxin
	name = "internal anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/antitoxins

/obj/item/chems/glass/bottle/robot/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/antitoxins, 60)
	update_icon()