/obj/item/storage/box/bloodpacks
	name = "blood packs box"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	startswith = list(/obj/item/chems/ivbag = 7)

/obj/item/chems/ivbag
	name = "\improper IV bag"
	desc = "Flexible bag for IV injectors."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_TINY
	volume = 120
	possible_transfer_amounts = @"[0.2,1,2]"
	amount_per_transfer_from_this = REM
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	var/mob/living/carbon/human/attached

/obj/item/chems/ivbag/Destroy()
	STOP_PROCESSING(SSobj,src)
	attached = null
	. = ..()

/obj/item/chems/ivbag/on_reagent_change()
	update_icon()
	if(reagents.total_volume > volume/2)
		w_class = ITEM_SIZE_SMALL
	else
		w_class = ITEM_SIZE_TINY

/obj/item/chems/ivbag/on_update_icon()
	overlays.Cut()
	var/percent = round(reagents.total_volume / volume * 100)
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/bloodpack.dmi', "[round(percent,25)]")
		filling.color = reagents.get_color()
		overlays += filling
	overlays += image('icons/obj/bloodpack.dmi', "top")
	if(attached)
		overlays += image('icons/obj/bloodpack.dmi', "dongle")

/obj/item/chems/ivbag/handle_mouse_drop(atom/over, mob/user)
	if(ismob(loc))
		if(attached)
			visible_message(SPAN_NOTICE("\The [attached] is taken off \the [src]."))
			attached = null
		else if(ishuman(over) && do_IV_hookup(over, user, src))
			attached = over
			START_PROCESSING(SSobj, src)
		update_icon()
		return TRUE
	. = ..()

/obj/item/chems/ivbag/Process()
	if(!ismob(loc))
		return PROCESS_KILL

	if(attached)
		if(!loc.Adjacent(attached))
			attached = null
			visible_message("\The [attached] detaches from \the [src]")
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

/obj/item/chems/ivbag/nanoblood/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nanoblood, volume)

/obj/item/chems/ivbag/blood
	name = "blood pack"
	var/blood_type = null

/obj/item/chems/ivbag/blood/Initialize()
	. = ..()
	if(blood_type)
		name = "blood pack [blood_type]"
		reagents.add_reagent(/decl/material/liquid/blood, volume, list("donor" = null, "blood_DNA" = null, "blood_type" = blood_type, "trace_chem" = null))

/obj/item/chems/ivbag/blood/APlus
	blood_type = "A+"

/obj/item/chems/ivbag/blood/AMinus
	blood_type = "A-"

/obj/item/chems/ivbag/blood/BPlus
	blood_type = "B+"

/obj/item/chems/ivbag/blood/BMinus
	blood_type = "B-"

/obj/item/chems/ivbag/blood/OPlus
	blood_type = "O+"

/obj/item/chems/ivbag/blood/OMinus
	blood_type = "O-"
