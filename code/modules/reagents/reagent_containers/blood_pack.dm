/obj/item/storage/box/bloodpacks
	name = "blood packs box"
	desc = "This box contains blood packs."
	icon_state = "sterile"

/obj/item/storage/box/bloodpacks/WillContain()
	return list(/obj/item/chems/ivbag = 7)

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

	var/obj/item/organ/external/attached_limb

/obj/item/chems/ivbag/Destroy()
	STOP_PROCESSING(SSobj,src)
	attached_limb = null
	. = ..()

/obj/item/chems/ivbag/on_reagent_change()
	update_icon()
	if(reagents.total_volume > volume/2)
		w_class = ITEM_SIZE_SMALL
	else
		w_class = ITEM_SIZE_TINY

/obj/item/chems/ivbag/on_update_icon()
	. = ..()
	var/percent = round(reagents.total_volume / volume * 100)
	if(reagents.total_volume)
		add_overlay(overlay_image(icon, "[round(percent,25)]", reagents.get_color()))
	add_overlay(attached_limb? "dongle" : "top")

/obj/item/chems/ivbag/handle_mouse_drop(atom/over, mob/user)
	if(ismob(loc))
		if(attached_limb)
			if(attached_limb.owner)
				visible_message(SPAN_NOTICE("\The [attached_limb.owner] is taken off \the [src]."))
			attached_limb = null
		else if(ishuman(over))
			var/mob/living/carbon/human/victim = over
			var/target_zone = check_zone(user.zone_sel.selecting, victim) // deterministic, so we do it here and in do_IV_hookup
			var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(victim, target_zone)
			if(do_IV_hookup(victim, user, src))
				attached_limb = affecting
				START_PROCESSING(SSobj, src)
		update_icon()
		return TRUE
	. = ..()

/obj/item/chems/ivbag/Process()
	if(!ismob(loc))
		return PROCESS_KILL

	var/mob/living/carbon/human/attached = attached_limb?.owner

	if(attached_limb)
		if(!attached || !loc.Adjacent(attached))
			visible_message("\The [attached || attached_limb] detaches from \the [src].")
			attached_limb = null
			update_icon()
			return PROCESS_KILL
	else
		return PROCESS_KILL

	var/mob/M = loc
	if(!(src in M.get_held_items()))
		return

	if(!reagents.total_volume)
		return

	attached.inject_external_organ(attached_limb, reagents, amount_per_transfer_from_this)
	update_icon()

/obj/item/chems/ivbag/nanoblood/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/nanoblood, reagents.maximum_volume)

/obj/item/chems/ivbag/blood
	name = "blood pack"
	var/blood_type = null

/obj/item/chems/ivbag/blood/Initialize()
	. = ..()
	if(blood_type)
		name = "blood pack ([blood_type])"

/obj/item/chems/ivbag/blood/populate_reagents()
	if(blood_type)
		reagents.add_reagent(/decl/material/liquid/blood, reagents.maximum_volume, list("donor" = null, "blood_DNA" = null, "blood_type" = blood_type, "trace_chem" = null))

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
