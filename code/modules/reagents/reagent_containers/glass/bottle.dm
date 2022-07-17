
//Not to be confused with /obj/item/chems/drinks/bottle

/obj/item/chems/glass/bottle
	name = "bottle"
	base_name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = ICON_STATE_WORLD
	randpixel = 7
	center_of_mass = @"{'x':16,'y':15}"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60]"
	w_class = ITEM_SIZE_SMALL
	item_flags = 0
	obj_flags = 0
	volume = 60
	material = /decl/material/solid/glass
	applies_material_colour = TRUE

	var/label_color
	var/lid_color = COLOR_GRAY80
	var/autolabel = TRUE  		// if set, will add label with the name of the first initial reagent

/obj/item/chems/glass/bottle/pickup(mob/user)
	..()
	update_icon()

/obj/item/chems/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/chems/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/chems/glass/bottle/on_update_icon()
	..()
	cut_overlays()

	if(reagents?.total_volume)
		var/percent = round(reagents.total_volume / volume * 100, 25)
		add_overlay(mutable_appearance(icon, "[icon_state]_filling_[percent]", reagents.get_color()))

	var/image/overglass = mutable_appearance(icon, "[icon_state]_over", color)
	overglass.alpha = alpha * ((alpha/255) ** 3)
	add_overlay(overglass)

	if(material.reflectiveness >= MAT_VALUE_SHINY)
		var/mutable_appearance/shine = mutable_appearance(icon, "[icon_state]_shine", adjust_brightness(color, 20 + material.reflectiveness))
		shine.alpha = material.reflectiveness * 3
		add_overlay(shine)

	if(label_text)
		add_overlay(mutable_appearance(icon, "[icon_state]_label", label_color))

	if (!ATOM_IS_OPEN_CONTAINER(src))
		add_overlay(mutable_appearance(icon, "[icon_state]_lid", lid_color))

	compile_overlays()

/obj/item/chems/glass/bottle/Initialize()
	. = ..()
	if(label_text)
		update_name_label()
	update_icon()

/obj/item/chems/glass/bottle/initialize_reagents(populate = TRUE)
	. = ..()
	if(populate)
		if(LAZYLEN(starting_reagents) && autolabel && !label_text) // don't override preset labels
			label_text = reagents.get_primary_reagent_name()

/obj/item/chems/glass/bottle/stabilizer
	desc = "A small bottle. Contains stabilizer - used to stabilize patients."
	starting_reagents = list(/decl/material/liquid/stabilizer = 60)

/obj/item/chems/glass/bottle/bromide
	desc = "A small bottle of bromide. Do not drink, it is poisonous."
	starting_reagents = list(/decl/material/liquid/bromide = 60)

/obj/item/chems/glass/bottle/cyanide
	desc = "A small bottle of cyanide. Bitter almonds?"
	starting_reagents = list(/decl/material/liquid/cyanide = 30) //volume changed to match chloral

/obj/item/chems/glass/bottle/sedatives
	desc = "A small bottle of soporific medication. Just the fumes make you sleepy."
	starting_reagents = list(/decl/material/liquid/sedatives = 60)

/obj/item/chems/glass/bottle/antitoxin
	desc = "A small bottle of antitoxins. Counters poisons, and repairs damage. A wonder drug."
	starting_reagents = list(/decl/material/liquid/antitoxins = 60)

/obj/item/chems/glass/bottle/mutagenics
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	starting_reagents = list(/decl/material/liquid/mutagenics = 60)

/obj/item/chems/glass/bottle/ammonia
	starting_reagents = list(/decl/material/gas/ammonia = 60)

/obj/item/chems/glass/bottle/eznutrient
	label_text = "EZ NUtrient"
	autolabel = FALSE
	label_color = COLOR_PALE_BTL_GREEN
	lid_color = COLOR_PALE_BTL_GREEN
	material = /decl/material/solid/plastic
	starting_reagents = list(/decl/material/liquid/fertilizer = 60)

/obj/item/chems/glass/bottle/left4zed
	label_text = "Left-4-Zed"
	autolabel = FALSE
	label_color = COMMS_COLOR_SCIENCE
	lid_color = COMMS_COLOR_SCIENCE
	material = /decl/material/solid/plastic
	starting_reagents = list(
		/decl/material/liquid/fertilizer = 50,
		/decl/material/liquid/mutagenics = 10
	)

/obj/item/chems/glass/bottle/robustharvest
	label_text = "Robust Harvest"
	autolabel = FALSE
	label_color = COLOR_ASSEMBLY_GREEN
	lid_color = COLOR_ASSEMBLY_GREEN
	material = /decl/material/solid/plastic
	starting_reagents = list(
		/decl/material/liquid/fertilizer = 50,
		/decl/material/gas/ammonia = 10
	)

/obj/item/chems/glass/bottle/pacid
	starting_reagents = list(/decl/material/liquid/acid/polyacid = 60)

/obj/item/chems/glass/bottle/adminordrazine
	desc = "A small bottle. Contains the liquid essence of the gods."
	material = /decl/material/solid/metal/gold
	lid_color = COLOR_CYAN_BLUE
	label_color = COLOR_CYAN_BLUE
	starting_reagents = list(/decl/material/liquid/adminordrazine = 60)

/obj/item/chems/glass/bottle/capsaicin
	desc = "A small bottle. Contains hot sauce."
	starting_reagents = list(/decl/material/liquid/capsaicin = 60)

/obj/item/chems/glass/bottle/frostoil
	desc = "A small bottle. Contains cold sauce."
	starting_reagents = list(/decl/material/liquid/frostoil = 60)
