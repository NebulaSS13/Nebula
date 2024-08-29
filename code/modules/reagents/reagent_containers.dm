/obj/item/chems
	name = "container"
	desc = "..."
	icon = 'icons/obj/items/chem/container.dmi'
	icon_state = null
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic
	obj_flags = OBJ_FLAG_HOLLOW
	abstract_type = /obj/item/chems

	var/base_desc
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = @"[5,10,15,25,30]"
	var/volume = 30
	var/label_text
	var/presentation_flags = 0
	var/show_reagent_name = FALSE
	var/detail_color
	var/detail_state

/obj/item/chems/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/chems/verb/set_amount_per_transfer_from_this

/obj/item/chems/set_custom_name(var/new_name)
	base_name = new_name
	update_container_name()

/obj/item/chems/set_custom_desc(var/new_desc)
	base_desc = new_desc
	update_container_desc()

/obj/item/chems/proc/cannot_interact(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(usr, SPAN_WARNING("You're in no condition to do that!"))
		return TRUE
	if(ismob(loc) && loc != user)
		to_chat(usr, SPAN_WARNING("You can't set transfer amounts while \the [src] is being held by someone else."))
		return TRUE
	return FALSE

/obj/item/chems/proc/get_base_name()
	if(!base_name)
		base_name = initial(name)
	. = base_name

/obj/item/chems/on_update_icon()
	. = ..()
	if(detail_state)
		add_overlay(overlay_image(icon, "[initial(icon_state)][detail_state]", detail_color || COLOR_WHITE, RESET_COLOR))

/obj/item/chems/proc/update_container_name()
	var/newname = get_base_name()
	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		newname = "[material.solid_name] [newname]"
	if(presentation_flags & PRESENTATION_FLAG_NAME)
		var/decl/material/R = reagents?.get_primary_reagent_decl()
		if(R)
			newname += " of [R.get_presentation_name(src)]"
	if(length(label_text))
		newname += " ([label_text])"
	if(newname != name)
		SetName(newname)

/obj/item/chems/proc/get_base_desc()
	if(!base_desc)
		base_desc = initial(desc)
	. = base_desc

/obj/item/chems/proc/update_container_desc()
	var/list/new_desc_list = list(get_base_desc())
	if(presentation_flags & PRESENTATION_FLAG_DESC)
		var/decl/material/R = reagents?.get_primary_reagent_decl()
		if(R)
			new_desc_list += R.get_presentation_desc(src)
	desc = new_desc_list.Join("\n")

/obj/item/chems/on_reagent_change()
	if((. = ..()))
		update_container_name()
		update_container_desc()
		update_icon()

/obj/item/chems/verb/set_amount_per_transfer_from_this()
	set name = "Set Transfer Amount"
	set category = "Object"
	set src in range(1)
	if(cannot_interact(usr))
		return
	var/N = input("How much do you wish to transfer per use?", "Set Transfer Amount") as null|anything in cached_json_decode(possible_transfer_amounts)
	if(N && !cannot_interact(usr))
		amount_per_transfer_from_this = N

/obj/item/chems/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

/obj/item/chems/attackby(obj/item/used_item, mob/user)
	if(used_item.user_can_attack_with(user, silent = TRUE))
		if(IS_PEN(used_item))
			var/tmp_label = sanitize_safe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
			if(length(tmp_label) > 10)
				to_chat(user, SPAN_NOTICE("The label can be at most 10 characters long."))
			else
				to_chat(user, SPAN_NOTICE("You set the label to \"[tmp_label]\"."))
				label_text = tmp_label
				update_container_name()
			return TRUE
	return ..()

/obj/item/chems/standard_pour_into(mob/user, atom/target, amount = 5)
	amount = amount_per_transfer_from_this
	// We'll be lenient: if you lack the dexterity for proper pouring you get a random amount.
	if(!user_can_attack_with(user, silent = TRUE))
		amount = rand(1, floor(amount_per_transfer_from_this * 1.5))
	return ..(user, target, amount)

/obj/item/chems/do_surgery(mob/living/M, mob/living/user)
	if(user.get_target_zone() != BP_MOUTH) //in case it is ever used as a surgery tool
		return ..()

/obj/item/chems/examine(mob/user)
	. = ..()
	if(!reagents)
		return
	if(hasHUD(user, HUD_SCIENCE))
		var/prec = user.skill_fail_chance(SKILL_CHEMISTRY, 10)
		to_chat(user, SPAN_NOTICE("The [src] contains: [reagents.get_reagents(precision = prec)]."))
	else if((loc == user) && user.skill_check(SKILL_CHEMISTRY, SKILL_EXPERT))
		to_chat(user, SPAN_NOTICE("Using your chemistry knowledge, you identify the following reagents in \the [src]: [reagents.get_reagents(!user.skill_check(SKILL_CHEMISTRY, SKILL_PROF), 5)]."))

/obj/item/chems/shatter(consumed)
	//Skip splashing if we are in nullspace, since splash isn't null guarded
	if(loc)
		reagents.splash(get_turf(src), reagents.total_volume)
	. = ..()

/obj/item/chems/initialize_reagents(populate = TRUE)
	if(!reagents)
		create_reagents(volume)
	else
		reagents.maximum_volume = max(reagents.maximum_volume, volume)
	. = ..()

/obj/item/chems/proc/set_detail_color(var/new_color)
	if(new_color != detail_color)
		detail_color = new_color
		update_icon()
		return TRUE
	return FALSE

// TODO: merge beakers etc down into this proc.
/obj/item/chems/proc/get_reagents_overlay()

	if(reagents?.total_volume <= 0)
		return

	var/decl/material/primary_reagent = reagents.get_primary_reagent_decl()
	if(!primary_reagent)
		return

	var/reagents_state
	if(primary_reagent.reagent_overlay_base)
		reagents_state = primary_reagent.reagent_overlay_base
	else
		reagents_state = "reagent_base"

	if(!reagents_state || !check_state_in_icon(reagents_state, icon))
		return

	var/image/reagent_overlay = overlay_image(icon, reagents_state, reagents.get_color(), RESET_COLOR | RESET_ALPHA)
	if(primary_reagent.reagent_overlay)
		reagent_overlay.overlays += overlay_image(icon, primary_reagent.reagent_overlay, primary_reagent.color, RESET_COLOR | RESET_ALPHA)
	else
		for(var/reagent_type in reagents.reagent_volumes)
			var/decl/material/reagent = GET_DECL(reagent_type)
			if(reagent != primary_reagent && reagent.reagent_overlay && check_state_in_icon(reagent.reagent_overlay, icon))
				reagent_overlay.overlays += overlay_image(icon, reagent.reagent_overlay, reagent.color, RESET_COLOR | RESET_ALPHA)
	return reagent_overlay

//
// Interactions
//
/obj/item/chems/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/set_transfer/chems)

/decl/interaction_handler/set_transfer/chems
	expected_target_type = /obj/item/chems

/decl/interaction_handler/set_transfer/chems/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/item/chems/C = target
		return !!C.possible_transfer_amounts

/decl/interaction_handler/set_transfer/chems/invoked(var/atom/target, var/mob/user)
	var/obj/item/chems/C = target
	C.set_amount_per_transfer_from_this()

///Empty a container onto the floor
/decl/interaction_handler/empty/chems
	name                 = "Empty On Floor"
	expected_target_type = /obj/item/chems
	interaction_flags    = INTERACTION_NEEDS_INVENTORY | INTERACTION_NEEDS_PHYSICAL_INTERACTION

/decl/interaction_handler/empty/chems/invoked(obj/item/chems/target, mob/user)
	var/turf/T = get_turf(user)
	if(T)
		to_chat(user, SPAN_NOTICE("You empty \the [target] onto the floor."))
		target.reagents.trans_to(T, target.reagents.total_volume)
