
/obj/item/chems/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/items/chem/beakers/beaker.dmi'
	icon_state = ICON_STATE_WORLD
	center_of_mass = @"{'x':15,'y':10}"
	material = /decl/material/solid/glass
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	material_force_multiplier = 0.25
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	presentation_flags = PRESENTATION_FLAG_NAME
	var/lid_color = COLOR_BEASTY_BROWN

/obj/item/chems/glass/beaker/examine(mob/user, distance)
	. = ..()
	to_chat(user, " It can hold up to [volume] units.")

/obj/item/chems/glass/beaker/on_picked_up(mob/user)
	. = ..()
	update_icon()

/obj/item/chems/glass/beaker/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/chems/glass/beaker/attack_hand()
	. = ..()
	update_icon()

/obj/item/chems/glass/beaker/on_update_icon()
	. = ..()
	cut_overlays()

	if(reagents?.total_volume)
		var/image/filling = mutable_appearance(icon, "[icon_state]1", reagents.get_color())
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)			filling.icon_state = "[icon_state]1"
			if(10 to 24) 		filling.icon_state = "[icon_state]10"
			if(25 to 49)		filling.icon_state = "[icon_state]25"
			if(50 to 74)		filling.icon_state = "[icon_state]50"
			if(75 to 79)		filling.icon_state = "[icon_state]75"
			if(80 to 90)		filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"
		add_overlay(filling)

		var/image/overglass = mutable_appearance(icon, "[icon_state]_over", color)
		overglass.alpha = alpha * ((alpha/255) ** 3)
		add_overlay(overglass)

	if(material.reflectiveness >= MAT_VALUE_SHINY)
		var/mutable_appearance/shine = mutable_appearance(icon, "[icon_state]_shine", adjust_brightness(color, 20 + material.reflectiveness))
		shine.alpha = material.reflectiveness * 3
		add_overlay(shine)

	if (!ATOM_IS_OPEN_CONTAINER(src))
		add_overlay(mutable_appearance(icon, "[icon_state]_lid", lid_color))

	compile_overlays()

/obj/item/chems/glass/beaker/throw_impact(atom/hit_atom)
	. = ..()
	if(ATOM_IS_OPEN_CONTAINER(src))
		reagents.splash(hit_atom, rand(reagents.total_volume*0.25,reagents.total_volume), min_spill = 60, max_spill = 100)
	take_damage(rand(4,8))

/obj/item/chems/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon = 'icons/obj/items/chem/beakers/large.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60,120]"
	material_force_multiplier = 0.5
	w_class = ITEM_SIZE_LARGE

/obj/item/chems/glass/beaker/bowl
	name = "mixing bowl"
	desc = "A large mixing bowl."
	icon = 'icons/obj/items/chem/mixingbowl.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60,180]"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = 0
	material = /decl/material/solid/metal/steel
	material_force_multiplier = 0.2

/obj/item/chems/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon = 'icons/obj/items/chem/beakers/stasis.dmi'
	center_of_mass = @"{'x':16,'y':8}"
	volume = 60
	amount_per_transfer_from_this = 10
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
	presentation_flags = PRESENTATION_FLAG_NAME
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_NONE
	origin_tech = "{'materials':2}"
	lid_color = COLOR_PALE_BLUE_GRAY

/obj/item/chems/glass/beaker/advanced
	name = "advanced beaker"
	desc = "An advanced beaker, powered by experimental technology."
	icon = 'icons/obj/items/chem/beakers/advanced.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60,120,150,200,250,300]"
	material_force_multiplier = 2.5
	material_alteration = MAT_FLAG_ALTERATION_NONE
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	origin_tech = "{'exoticmatter':2,'materials':6}"
	lid_color = COLOR_CYAN_BLUE

/obj/item/chems/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon = 'icons/obj/items/chem/vial.dmi'
	center_of_mass = @"{'x':15,'y':8}"
	volume = 30
	w_class = ITEM_SIZE_TINY //half the volume of a bottle, half the size
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,30]"
	material_force_multiplier = 0.1

/obj/item/chems/glass/beaker/vial/throw_impact(atom/hit_atom)
	. = ..()
	if(material?.is_brittle())
		shatter()

/obj/item/chems/glass/beaker/insulated
	name = "insulated beaker"
	desc = "A glass beaker surrounded with black insulation."
	icon = 'icons/obj/items/chem/beakers/insulated.dmi'
	center_of_mass = @"{'x':15,'y':8}"
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT)
	possible_transfer_amounts = @"[5,10,15,30]"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	presentation_flags = PRESENTATION_FLAG_NAME
	temperature_coefficient = 1
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_NONE
	lid_color = COLOR_GRAY40

/obj/item/chems/glass/beaker/insulated/large
	name = "large insulated beaker"
	icon = 'icons/obj/items/chem/beakers/insulated_large.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT)
	volume = 120

/obj/item/chems/glass/beaker/sulphuric/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/acid, reagents.maximum_volume)
