
/obj/item/chems/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/items/chem/beakers/beaker.dmi'
	on_mob_icon = 'icons/obj/items/chem/beakers/beaker.dmi'
	icon_state = "world"
	center_of_mass = @"{'x':15,'y':10}"
	material = MAT_GLASS
	applies_material_name = TRUE
	applies_material_colour = TRUE
	material_force_multiplier = 0.25
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_SHOW_REAGENT_NAME

/obj/item/chems/glass/beaker/Initialize()
	. = ..()
	desc += " It can hold up to [volume] units."

/obj/item/chems/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/chems/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/chems/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/chems/glass/beaker/on_update_icon()
	..()

	if(reagents?.total_volume && check_state_in_icon("[icon_state]100", icon))
		var/mutable_appearance/filling = get_mutable_overlay(icon, "[icon_state]10", reagents.get_color())

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)			filling.icon_state = "[icon_state]1"
			if(10 to 24) 		filling.icon_state = "[icon_state]10"
			if(25 to 49)		filling.icon_state = "[icon_state]25"
			if(50 to 74)		filling.icon_state = "[icon_state]50"
			if(75 to 79)		filling.icon_state = "[icon_state]75"
			if(80 to 90)		filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		overlays += filling

	if(!ATOM_IS_OPEN_CONTAINER(src))
		overlays += get_mutable_overlay(icon, "[icon_state]_lid")

/obj/item/chems/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon = 'icons/obj/items/chem/beakers/large.dmi'
	on_mob_icon = 'icons/obj/items/chem/beakers/large.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60,120]"
	material_force_multiplier = 0.5

/obj/item/chems/glass/beaker/bowl
	name = "mixing bowl"
	desc = "A large mixing bowl."
	icon = 'icons/obj/items/chem/mixingbowl.dmi'
	on_mob_icon = 'icons/obj/items/chem/mixingbowl.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60,180]"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = 0
	material = MAT_STEEL
	material_force_multiplier = 0.2

/obj/item/chems/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon = 'icons/obj/items/chem/beakers/stasis.dmi'
	on_mob_icon = 'icons/obj/items/chem/beakers/stasis.dmi'
	center_of_mass = @"{'x':16,'y':8}"
	volume = 60
	amount_per_transfer_from_this = 10
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT | ATOM_FLAG_SHOW_REAGENT_NAME
	material = MAT_STEEL
	applies_material_name = FALSE
	applies_material_colour = FALSE

/obj/item/chems/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon = 'icons/obj/items/chem/beakers/bluespace.dmi'
	on_mob_icon = 'icons/obj/items/chem/beakers/bluespace.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60,120,150,200,250,300]"
	material_force_multiplier = 2.5
	applies_material_colour = FALSE
	applies_material_name = FALSE
	material = MAT_STEEL
	matter = list(
		MAT_PHORON = MATTER_AMOUNT_REINFORCEMENT,
		MAT_DIAMOND = MATTER_AMOUNT_TRACE
	)

/obj/item/chems/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon = 'icons/obj/items/chem/vial.dmi'
	on_mob_icon = 'icons/obj/items/chem/vial.dmi'
	center_of_mass = @"{'x':15,'y':8}"
	volume = 30
	w_class = ITEM_SIZE_TINY //half the volume of a bottle, half the size
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,30]"
	material_force_multiplier = 0.1

/obj/item/chems/glass/beaker/insulated
	name = "insulated beaker"
	desc = "A glass beaker surrounded with black insulation."
	icon = 'icons/obj/items/chem/beakers/insulated.dmi'
	on_mob_icon = 'icons/obj/items/chem/beakers/insulated.dmi'
	center_of_mass = @"{'x':15,'y':8}"
	matter = list(MAT_PLASTIC = MATTER_AMOUNT_REINFORCEMENT)
	possible_transfer_amounts = @"[5,10,15,30]"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_SHOW_REAGENT_NAME
	applies_material_colour = FALSE
	temperature_coefficient = 1
	material = MAT_STEEL
	applies_material_name = FALSE
	applies_material_colour = FALSE

/obj/item/chems/glass/beaker/insulated/large
	name = "large insulated beaker"
	icon = 'icons/obj/items/chem/beakers/insulated_large.dmi'
	on_mob_icon = 'icons/obj/items/chem/beakers/insulated_large.dmi'
	center_of_mass = @"{'x':16,'y':10}"
	matter = list(MAT_PLASTIC = MATTER_AMOUNT_REINFORCEMENT)
	volume = 120

/obj/item/chems/glass/beaker/sulphuric/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/chem/acid, 60)
	update_icon()