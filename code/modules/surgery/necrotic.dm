//////////////////////////////////////////////////////////////////
//	 Necrotic organ recovery
//////////////////////////////////////////////////////////////////
/decl/surgery_step/necrotic
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT
	blood_level = 1
	shock_level = 30
	surgery_step_category = /decl/surgery_step/necrotic

//////////////////////////////////////////////////////////////////
//	 Necrotic tissue removal
//////////////////////////////////////////////////////////////////
/decl/surgery_step/necrotic/tissue
	name = "Remove necrotic tissue"
	description = "This procedure removes tissue lost to necrosis and prepares for regeneration."
	allowed_tools = list(TOOL_SCALPEL = 90)
	min_duration = 150
	max_duration = 170

/decl/surgery_step/necrotic/tissue/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.status & ORGAN_DEAD && affected.germ_level > INFECTION_LEVEL_ONE)
			return TRUE
		for(var/obj/item/organ/O in affected.internal_organs)
			if(O.status & ORGAN_DEAD && O.germ_level > INFECTION_LEVEL_ONE)
				return TRUE
		return FALSE

/decl/surgery_step/necrotic/tissue/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/list/dead_organs
	var/obj/item/organ/E = target.get_organ(target_zone)
	if(E && (E.status & ORGAN_DEAD) && E.germ_level > INFECTION_LEVEL_ONE)
		var/image/radial_button = image(icon = E.icon, icon_state = E.icon_state)
		radial_button.name = "Debride \the [E]"
		LAZYSET(dead_organs, E.organ_tag, radial_button)

	for(var/obj/item/organ/I in target.get_internal_organs())
		if(I && (I.status & ORGAN_DEAD) && I.germ_level > INFECTION_LEVEL_ONE && I.parent_organ == target_zone)
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Debride \the [I]"
			LAZYSET(dead_organs, I.organ_tag, radial_button)
	if(!LAZYLEN(dead_organs))
		to_chat(user, SPAN_WARNING("You can't find any dead tissue to remove."))
	else
		if(length(dead_organs) == 1)
			return dead_organs[1]
		return show_radial_menu(user, tool, dead_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	return FALSE

/decl/surgery_step/necrotic/tissue/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/target_organ = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
	user.visible_message("\The [user] slowly starts removing necrotic tissue from \the [target]'s [target_organ] with \the [tool].", \
	"You slowly start removing necrotic tissue from \the [target]'s [target_organ)] with \the [tool].")
	target.custom_pain("You feel sporadic spikes of pain from points around your [affected.name]!",20, affecting = affected)
	..()

/decl/surgery_step/necrotic/tissue/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/target_organ = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
	user.visible_message(
		SPAN_NOTICE("\The [user] has excised the necrotic tissue from \the [target]'s [target_organ] with \the [tool]."), \
		SPAN_NOTICE("You have excised the necrotic tissue from \the [target]'s [target_organ] with \the [tool]."))
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

	var/obj/item/organ/O = target.get_organ(LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone))
	if(!istype(O)) //Blergh
		O = target.get_internal_organ(LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone))
	O.germ_level = min(INFECTION_LEVEL_ONE, O.germ_level * 0.4)
	if(istype(O,/obj/item/organ/external))
		var/obj/item/organ/external/E = O
		E.disinfect()

/decl/surgery_step/necrotic/tissue/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_DANGER("\The [user]'s hand slips, slicing into a healthy portion of \the [target]'s [affected.name] with \the [tool]!"), \
		SPAN_DANGER("Your hand slips, slicing into a healthy portion of [target]'s [affected.name] with \the [tool]!"))
	affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Dead organ regeneration treatment
//////////////////////////////////////////////////////////////////
/decl/surgery_step/necrotic/regeneration
	name = "Regenerate tissue"
	description = "This procedure uses direct regeneration serum application to bring back organs and tissue from necrosis."
	min_duration = 90
	max_duration = 100
	allowed_tools = list(
		/obj/item/chems/spray = 100,
		/obj/item/chems/dropper = 100,
		/obj/item/chems/glass/bottle = 90,
		/obj/item/chems/drinks/flask = 90,
		/obj/item/chems/glass/beaker = 75,
		/obj/item/chems/drinks/bottle = 75,
		/obj/item/chems/drinks/glass2 = 75,
		/obj/item/chems/glass/bucket = 50
	)

/decl/surgery_step/necrotic/regeneration/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.status & ORGAN_DEAD)
			return TRUE
		for(var/obj/item/organ/O in affected.internal_organs)
			if(O.status & ORGAN_DEAD)
				return TRUE
		return FALSE

/decl/surgery_step/necrotic/regeneration/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/chems/C = tool
	if(!(ATOM_IS_OPEN_CONTAINER(C) && C.reagents.has_reagent(/decl/material/liquid/regenerator, 5)))
		to_chat(user, SPAN_WARNING("\The [tool] doesn't have enough chemicals to regenerate anything."))
		return FALSE

	var/list/dead_organs
	var/obj/item/organ/E = target.get_organ(target_zone)
	if(E && (E.status & ORGAN_DEAD))
		var/image/radial_button = image(icon = E.icon, icon_state = E.icon_state)
		radial_button.name = "Regenerate \the [E.name]"
		LAZYSET(dead_organs, E.organ_tag, radial_button)

	for(var/obj/item/organ/I in target.get_internal_organs())
		if(I && (I.status & ORGAN_DEAD) && I.parent_organ == target_zone)
			if(!I.can_recover())
				to_chat(user, SPAN_WARNING("\The [I.name] is beyond saving."))
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Regenerate \the [I.name]"
			LAZYSET(dead_organs, I.organ_tag, radial_button)
	if(!LAZYLEN(dead_organs))
		to_chat(user, SPAN_WARNING("You can't find any organs to regenerate."))
	else
		if(length(dead_organs) == 1)
			return dead_organs[1]
		return show_radial_menu(user, tool, dead_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	return FALSE

/decl/surgery_step/necrotic/regeneration/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts pouring [tool]'s contents on \the [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)]." , \
	"You start pouring [tool]'s contents on \the [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)].")
	target.custom_pain("Your [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] is on fire!",50,affecting = affected)
	..()

/decl/surgery_step/necrotic/regeneration/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/target_organ = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
	var/obj/item/organ/O = target.get_organ(target_organ) || target.get_internal_organ(target_organ)
	var/obj/item/chems/C = tool
	var/temp_holder = new /obj()
	var/amount = C.amount_per_transfer_from_this
	var/datum/reagents/temp_reagents = new /datum/reagents(amount, temp_holder)
	C.reagents.trans_to_holder(temp_reagents, amount)
	var/usable_amount = temp_reagents.has_reagent(/decl/material/liquid/regenerator)
	temp_reagents.clear_reagent(/decl/material/liquid/regenerator) //We'll manually calculate how much it should heal
	temp_reagents.trans_to_mob(target, temp_reagents.total_volume, CHEM_INJECT) //And if there was something else, toss it in

	if (usable_amount > 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] finishes applying \the [tool]'s contents to \the [target]'s [O.name]."), \
			SPAN_NOTICE("You treat \the [target]'s [O.name] with \the [tool]'s contents."))

		O &= ~ORGAN_DEAD
		O.heal_damage(O.max_damage * (0.75 * (usable_amount / 5))) //Assuming they're using a dropper and completely pure chems, put the organ back to a working point
	else
		to_chat(user,SPAN_WARNING("You transferred too little for the organ to regenerate!"))
	qdel(temp_reagents)
	qdel(temp_holder)

/decl/surgery_step/necrotic/regeneration/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(!istype(tool) || !tool.reagents)
		return
	var/obj/item/chems/container = tool
	var/obj/item/organ/affected = target.get_organ(LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)) || target.get_internal_organ(LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone))
	tool.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_INJECT)
	user.visible_message(
		SPAN_DANGER("\The [user]'s hand slips, spilling \the [tool]'s contents over the [target]'s [affected.name]!") , \
		SPAN_DANGER("Your hand slips, spilling \the [tool]'s contents over the [target]'s [affected.name]!"))
