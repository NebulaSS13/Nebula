
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
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

	var/label_color
	var/lid_color = COLOR_GRAY80
	var/autolabel = TRUE  		// if set, will add label with the name of the first initial reagent

/obj/item/chems/glass/bottle/on_picked_up(mob/user)
	. = ..()
	update_icon()

/obj/item/chems/glass/bottle/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/chems/glass/bottle/attack_hand()
	. = ..()
	update_icon()

/obj/item/chems/glass/bottle/on_update_icon()
	. = ..()
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
	update_icon()

/obj/item/chems/glass/bottle/populate_reagents()
	. = ..()
	SHOULD_CALL_PARENT(TRUE)
	if((reagents.total_volume > 0) && autolabel && !label_text) // don't override preset labels
		label_text = reagents.get_primary_reagent_name()

/obj/item/chems/glass/bottle/stabilizer
	desc = "A small bottle. Contains stabilizer - used to stabilize patients."

/obj/item/chems/glass/bottle/stabilizer/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/stabilizer, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/bromide
	desc = "A small bottle of bromide. Do not drink, it is poisonous."

/obj/item/chems/glass/bottle/bromide/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/bromide, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/cyanide
	desc = "A small bottle of cyanide. Bitter almonds?"

/obj/item/chems/glass/bottle/cyanide/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/cyanide, reagents.maximum_volume / 2) //volume changed to match chloral
	. = ..()

/obj/item/chems/glass/bottle/sedatives
	desc = "A small bottle of soporific medication. Just the fumes make you sleepy."

/obj/item/chems/glass/bottle/sedatives/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/sedatives, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/antitoxin
	desc = "A small bottle of antitoxins. Counters poisons, and repairs damage. A wonder drug."

/obj/item/chems/glass/bottle/antitoxin/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antitoxins, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/mutagenics
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."

/obj/item/chems/glass/bottle/mutagenics/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/mutagenics, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/ammonia/populate_reagents()
	reagents.add_reagent(/decl/material/gas/ammonia, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/eznutrient
	label_text = "EZ NUtrient"
	autolabel = FALSE
	label_color = COLOR_PALE_BTL_GREEN
	lid_color = COLOR_PALE_BTL_GREEN
	material = /decl/material/solid/plastic

/obj/item/chems/glass/bottle/eznutrient/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/fertilizer, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/left4zed
	label_text = "Left-4-Zed"
	autolabel = FALSE
	label_color = COMMS_COLOR_SCIENCE
	lid_color = COMMS_COLOR_SCIENCE
	material = /decl/material/solid/plastic

/obj/item/chems/glass/bottle/left4zed/populate_reagents()
	var/mutagen_amount = round(reagents.maximum_volume / 6)
	reagents.add_reagent(/decl/material/liquid/fertilizer, reagents.maximum_volume - mutagen_amount)
	reagents.add_reagent(/decl/material/liquid/mutagenics, mutagen_amount)
	. = ..()

/obj/item/chems/glass/bottle/robustharvest
	label_text = "Robust Harvest"
	autolabel = FALSE
	label_color = COLOR_ASSEMBLY_GREEN
	lid_color = COLOR_ASSEMBLY_GREEN
	material = /decl/material/solid/plastic

/obj/item/chems/glass/bottle/robustharvest/populate_reagents()
	var/amonia_amount = round(reagents.maximum_volume / 6)
	reagents.add_reagent(/decl/material/liquid/fertilizer, reagents.maximum_volume - amonia_amount)
	reagents.add_reagent(/decl/material/gas/ammonia,       amonia_amount)
	. = ..()

/obj/item/chems/glass/bottle/pacid/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/acid/polyacid, reagents.maximum_volume)
	. = ..()
/obj/item/chems/glass/bottle/adminordrazine
	desc = "A small bottle. Contains the liquid essence of the gods."
	material = /decl/material/solid/metal/gold
	lid_color = COLOR_CYAN_BLUE
	label_color = COLOR_CYAN_BLUE

/obj/item/chems/glass/bottle/adminordrazine/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/adminordrazine, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/capsaicin
	desc = "A small bottle. Contains hot sauce."

/obj/item/chems/glass/bottle/capsaicin/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/capsaicin, reagents.maximum_volume)
	. = ..()

/obj/item/chems/glass/bottle/frostoil
	desc = "A small bottle. Contains cold sauce."

/obj/item/chems/glass/bottle/frostoil/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/frostoil, reagents.maximum_volume)
	. = ..()
