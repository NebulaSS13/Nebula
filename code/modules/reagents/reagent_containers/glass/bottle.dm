
//Not to be confused with /obj/item/chems/drinks/bottle

/obj/item/chems/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = null
	item_state = "atoxinbottle"
	randpixel = 7
	center_of_mass = @"{'x':15,'y':10}"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60]"
	w_class = ITEM_SIZE_SMALL
	item_flags = 0
	obj_flags = 0
	volume = 60

/obj/item/chems/glass/bottle/pickup(mob/user)
	..()
	update_icon()

/obj/item/chems/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/chems/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/chems/glass/bottle/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "bottle-[rand(1,4)]"

/obj/item/chems/glass/bottle/on_update_icon()
	overlays.Cut()

	if(reagents.total_volume && (icon_state == "bottle-1" || icon_state == "bottle-2" || icon_state == "bottle-3" || icon_state == "bottle-4"))
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]--10"
			if(10 to 24) 	filling.icon_state = "[icon_state]-10"
			if(25 to 49)	filling.icon_state = "[icon_state]-25"
			if(50 to 74)	filling.icon_state = "[icon_state]-50"
			if(75 to 79)	filling.icon_state = "[icon_state]-75"
			if(80 to 90)	filling.icon_state = "[icon_state]-80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]-100"

		filling.color = reagents.get_color()
		overlays += filling

	if (!ATOM_IS_OPEN_CONTAINER(src))
		var/image/lid = image(icon, src, "lid_bottle")
		overlays += lid


/obj/item/chems/glass/bottle/stabilizer
	name = "stabilizer bottle"
	desc = "A small bottle. Contains stabilizer - used to stabilize patients."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/stabilizer/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/stabilizer, 60)
	update_icon()

/obj/item/chems/glass/bottle/bromide
	name = "bromide bottle"
	desc = "A small bottle of bromide. Do not drink, it is poisonous."
	icon_state = "bottle-3"

/obj/item/chems/glass/bottle/bromide/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/bromide, 60)
	update_icon()

/obj/item/chems/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon_state = "bottle-3"

/obj/item/chems/glass/bottle/cyanide/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/cyanide, 30) //volume changed to match chloral
	update_icon()


/obj/item/chems/glass/bottle/sedatives
	name = "sedatives bottle"
	desc = "A small bottle of soporific medication. Just the fumes make you sleepy."
	icon_state = "bottle-3"

/obj/item/chems/glass/bottle/sedatives/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/sedatives, 60)
	update_icon()


/obj/item/chems/glass/bottle/antitoxin
	name = "antitoxins bottle"
	desc = "A small bottle of antitoxins. Counters poisons, and repairs damage. A wonder drug."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/antitoxins, 60)
	update_icon()


/obj/item/chems/glass/bottle/mutagenics
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon_state = "bottle-1"

/obj/item/chems/glass/bottle/mutagenics/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/mutagenics, 60)
	update_icon()


/obj/item/chems/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon_state = "bottle-1"

/obj/item/chems/glass/bottle/ammonia/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/gas/ammonia, 60)
	update_icon()


/obj/item/chems/glass/bottle/eznutrient
	name = "\improper EZ NUtrient bottle"
	desc = "A small bottle."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/eznutrient/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/fertilizer, 60)
	update_icon()

/obj/item/chems/glass/bottle/left4zed
	name = "\improper Left-4-Zed bottle"
	desc = "A small bottle."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/left4zed/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/fertilizer, 50)
	reagents.add_reagent(/decl/material/liquid/mutagenics, 10)
	update_icon()


/obj/item/chems/glass/bottle/robustharvest
	name = "\improper Robust Harvest"
	desc = "A small bottle."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/robustharvest/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/fertilizer, 50)
	reagents.add_reagent(/decl/material/gas/ammonia, 10)
	update_icon()

/obj/item/chems/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/pacid/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/acid/polyacid, 60)
	update_icon()


/obj/item/chems/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"


/obj/item/chems/glass/bottle/adminordrazine/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/adminordrazine, 60)
	update_icon()


/obj/item/chems/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/capsaicin/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/capsaicin, 60)
	update_icon()


/obj/item/chems/glass/bottle/frostoil
	name = "Chilly Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	icon_state = "bottle-4"

/obj/item/chems/glass/bottle/frostoil/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/frostoil, 60)
	update_icon()
