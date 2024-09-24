/obj/item/box/bloodpacks
	name = "blood packs box"
	desc = "This box contains blood packs."
	icon_state = "sterile"

/obj/item/box/bloodpacks/WillContain()
	return list(/obj/item/chems/ivbag = 7)

/obj/item/chems/ivbag
	name = "\improper IV bag"
	desc = "Flexible bag for IV injectors."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_SMALL
	volume = 120
	possible_transfer_amounts = @"[0.2,1,2]"
	amount_per_transfer_from_this = REM
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	var/mob/living/human/attached

/obj/item/chems/ivbag/Destroy()
	STOP_PROCESSING(SSobj,src)
	attached = null
	. = ..()

/obj/item/chems/ivbag/on_reagent_change()
	if(!(. = ..()))
		return
	if(reagents?.total_volume > volume/2)
		w_class = ITEM_SIZE_NORMAL
	else
		w_class = ITEM_SIZE_SMALL

/obj/item/chems/ivbag/on_update_icon()
	. = ..()
	var/percent = round(reagents?.total_volume / volume * 100)
	if(percent)
		add_overlay(overlay_image(icon, "[round(percent,25)]", reagents.get_color()))
	add_overlay(attached? "dongle" : "top")

/obj/item/chems/ivbag/handle_mouse_drop(atom/over, mob/user, params)
	if(ismob(loc))
		if(attached)
			visible_message(SPAN_NOTICE("\The [attached] is taken off \the [src]."))
			attached = null
		else if(ishuman(over) && do_IV_hookup(over, user, src))
			attached = over
			START_PROCESSING(SSobj, src)
		update_icon()
		return TRUE
	return ..()

/obj/item/chems/ivbag/Process()
	if(!ismob(loc))
		return PROCESS_KILL

	if(attached)
		if(!loc.Adjacent(attached))
			attached = null
			visible_message("\The [attached] detaches from \the [src].")
			update_icon()
			return PROCESS_KILL
	else
		return PROCESS_KILL

	var/mob/M = loc
	if(!(src in M.get_held_items()))
		return

	if(!reagents.total_volume)
		return

	reagents.trans_to_mob(attached, amount_per_transfer_from_this, CHEM_INJECT)
	update_icon()

/obj/item/chems/ivbag/blood
	name = "blood pack"
	var/blood_fill_type = /decl/material/liquid/blood

/obj/item/chems/ivbag/blood/proc/get_initial_blood_data()
	return list(
		DATA_BLOOD_DONOR      = null,
		DATA_BLOOD_DNA        = null,
		DATA_BLOOD_TYPE       = label_text,
		DATA_BLOOD_TRACE_CHEM = null
	)

/obj/item/chems/ivbag/blood/populate_reagents()
	if(blood_fill_type)
		add_to_reagents(blood_fill_type, reagents.maximum_volume, get_initial_blood_data())

/obj/item/chems/ivbag/blood/nanoblood
	label_text = "synthetic"
	blood_fill_type = /decl/material/liquid/nanoblood

/obj/item/chems/ivbag/blood/nanoblood/get_initial_blood_data()
	return null

/obj/item/chems/ivbag/blood/aplus
	label_text = "A+"

/obj/item/chems/ivbag/blood/aminus
	label_text = "A-"

/obj/item/chems/ivbag/blood/bplus
	label_text = "B+"

/obj/item/chems/ivbag/blood/bminus
	label_text = "B-"

/obj/item/chems/ivbag/blood/oplus
	label_text = "O+"

/obj/item/chems/ivbag/blood/ominus
	label_text = "O-"
