//Procedures in this file: internal organ surgery, removal, transplants
//////////////////////////////////////////////////////////////////
//						INTERNAL ORGANS							//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/internal
	can_infect = 1
	blood_level = 1
	shock_level = 40
	delicate = 1
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NEEDS_ENCASEMENT
	abstract_type = /decl/surgery_step/internal

//////////////////////////////////////////////////////////////////
//	Organ mending surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/internal/fix_organ
	name = "Repair internal organ"
	description = "This procedure is used to repair damage to the internal organs of a patient."
	allowed_tools = list(
		/obj/item/stack/medical/advanced/bruise_pack = 100,
		/obj/item/stack/medical/bruise_pack = 40,
		/obj/item/stack/tape_roll/duct_tape = 20
	)
	min_duration = 70
	max_duration = 90
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC

/decl/surgery_step/internal/fix_organ/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected)
		for(var/obj/item/organ/internal/I in affected.internal_organs)
			if(I.damage > 0)
				if(I.status & ORGAN_DEAD)
					to_chat(user, SPAN_WARNING("\The [I] is [I.can_recover() ? "decaying" : "necrotic"] and cannot be treated with \the [tool] alone."))
					continue
				if(I.surface_accessible || (affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
					return affected

/decl/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts treating damage within \the [target]'s [affected.name] with [tool_name].", \
	"You start treating damage within \the [target]'s [affected.name] with [tool_name]." )
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_PROSTHETIC(I) && !(I.status & ORGAN_DEAD) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			user.visible_message("[user] starts treating damage to [target]'s [I] with [tool_name].", \
			"You start treating damage to [target]'s [I] with [tool_name]." )
	target.custom_pain("The pain in your [affected.name] is living hell!",100,affecting = affected)
	..()

/decl/surgery_step/internal/fix_organ/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_PROSTHETIC(I) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			if(I.status & ORGAN_DEAD)
				to_chat(user, SPAN_NOTICE("You were unable to treat \the [I] due to its necrotic state."))
			else
				user.visible_message("<span class='notice'>[user] treats damage to [target]'s [I] with [tool_name].</span>", \
				"<span class='notice'>You treat damage to [target]'s [I] with [tool_name].</span>" )
				I.surgical_fix(user)
	user.visible_message("\The [user] finishes treating damage within \the [target]'s [affected.name] with [tool_name].", \
	"You finish treating damage within \the [target]'s [affected.name] with [tool_name]." )

/decl/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!</span>")
	var/dam_amt = 2
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		target.adjustToxLoss(5)
	else
		dam_amt = 5
		target.adjustToxLoss(10)
		affected.take_external_damage(dam_amt, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_PROSTHETIC(I) && (I.surface_accessible || affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)))
			I.take_internal_damage(dam_amt)

//////////////////////////////////////////////////////////////////
//	 Organ detachment surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/internal/detach_organ
	name = "Detach organ"
	description = "This procedure detaches an internal organ for removal."
	allowed_tools = list(TOOL_SCALPEL = 100)
	min_duration = 90
	max_duration = 110
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NEEDS_ENCASEMENT

/decl/surgery_step/internal/detach_organ/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/list/attached_organs
	for(var/obj/item/organ/I in target.get_internal_organs())
		if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Detach \the [I.name]"
			LAZYSET(attached_organs, I.organ_tag, radial_button)
	if(!LAZYLEN(attached_organs))
		to_chat(user, SPAN_WARNING("You can't find any organs to separate."))
	else
		if(length(attached_organs) == 1)
			return attached_organs[1]
		return show_radial_menu(user, tool, attached_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	return FALSE

/decl/surgery_step/internal/detach_organ/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to separate [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].", \
	"You start to separate [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool]." )
	target.custom_pain("Someone's ripping out your [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)]!",100)
	..()

/decl/surgery_step/internal/detach_organ/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has separated [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].</span>" , \
	"<span class='notice'>You have separated [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].</span>")
	var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(target, LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone))
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(I && istype(I) && istype(affected))
		//First only detach the organ, without fully removing it
		target.remove_organ(I, FALSE, TRUE)

/decl/surgery_step/internal/detach_organ/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(affected)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>")
		affected.take_external_damage(rand(30,50), 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Organ removal surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/internal/remove_organ
	name = "Remove internal organ"
	description = "This procedure removes a detached internal organ."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		TOOL_WIRECUTTERS = 75
	)
	min_duration = 60
	max_duration = 80

/decl/surgery_step/internal/remove_organ/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(affected)
		var/list/removable_organs
		for(var/obj/item/organ/internal/I in affected.implants)
			if(I.status & ORGAN_CUT_AWAY)
				var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
				radial_button.name = "Remove \the [I.name]"
				LAZYSET(removable_organs, I, radial_button)
		if(!LAZYLEN(removable_organs))
			to_chat(user, SPAN_WARNING("You can't find any removable organs."))
		else
			if(length(removable_organs) == 1)
				return removable_organs[1]
			return show_radial_menu(user, tool, removable_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	return FALSE

/decl/surgery_step/internal/remove_organ/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool)
	var/target_zone = user.get_target_zone()
	var/obj/item/organ/internal/O = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(BP_IS_PROSTHETIC(O))
		if(BP_IS_PROSTHETIC(affected))
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	else
		return ..()

/decl/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("\The [user] starts removing [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].", \
	"You start removing \the [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is living hell!",100,affecting = affected)
	..()

/decl/surgery_step/internal/remove_organ/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>\The [user] has removed \the [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].</span>", \
	"<span class='notice'>You have removed \the [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].</span>")

	// Extract the organ!
	var/obj/item/organ/O = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(istype(O) && istype(affected))
		//Now call remove again with detach = FALSE so we fully remove it
		target.remove_organ(O, TRUE, FALSE)

	// Just in case somehow the organ we're extracting from an organic is an MMI
	if(istype(O, /obj/item/organ/internal/mmi_holder))
		var/obj/item/organ/internal/mmi_holder/brain = O
		brain.transfer_and_delete()
		log_warning("Organ removal surgery on '[target]' returned a mmi_holder '[O]' instead of a mmi!!")

/decl/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(20, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 Organ inserting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/internal/replace_organ
	name = "Replace internal organ"
	description = "This procedure replaces a removed internal organ."
	allowed_tools = list(
		/obj/item/organ/internal = 100
	)
	min_duration = 60
	max_duration = 80
	var/robotic_surgery = FALSE

/decl/surgery_step/internal/replace_organ/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool)
	var/obj/item/organ/internal/O = tool
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, user.get_target_zone())
	if(BP_IS_PROSTHETIC(O) || istype(O, /obj/item/organ/internal/augment))
		if(BP_IS_PROSTHETIC(affected))
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	else
		return ..()

/decl/surgery_step/internal/replace_organ/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/internal/O = tool
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(istype(O) && istype(affected))
		if(BP_IS_CRYSTAL(O) && !BP_IS_CRYSTAL(affected))
			to_chat(user, SPAN_WARNING("You cannot install a crystalline organ into a non-crystalline bodypart."))
		else if(!BP_IS_CRYSTAL(O) && BP_IS_CRYSTAL(affected))
			to_chat(user, SPAN_WARNING("You cannot install a non-crystalline organ into a crystalline bodypart."))
		else if(BP_IS_PROSTHETIC(affected) && !BP_IS_PROSTHETIC(O))
			to_chat(user, SPAN_WARNING("You cannot install a naked organ into a robotic body."))
		else if(!target.get_species())
			CRASH("Target ([target]) of surgery [type] has no species!")
		else
			var/decl/pronouns/G = O.get_pronouns()
			var/decl/species/species = target.get_species()
			if(O.organ_tag == BP_POSIBRAIN && !species.has_organ[BP_POSIBRAIN])
				to_chat(user, SPAN_WARNING("There's no place in [target] to fit \the [O.organ_tag]."))
			else if(O.damage > (O.max_damage * 0.75))
				to_chat(user, SPAN_WARNING("\The [O.name] [G.is] in no state to be transplanted."))
			else if(O.w_class > affected.cavity_max_w_class)
				to_chat(user, SPAN_WARNING("\The [O.name] [G.is] too big for [affected.cavity_name] cavity!"))
			else
				var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(target, O.organ_tag)
				if(I && (I.parent_organ == affected.organ_tag))
					to_chat(user, SPAN_WARNING("\The [target] already has \a [O.name]."))
				else
					. = TRUE

/decl/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts [robotic_surgery ? "reinstalling" : "transplanting"] \the [tool] into [target]'s [affected.name].", \
	"You start [robotic_surgery ? "reinstalling" : "transplanting"] \the [tool] into [target]'s [affected.name].")
	target.custom_pain("Someone's rooting around in your [affected.name]!",100,affecting = affected)
	..()

/decl/surgery_step/internal/replace_organ/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='notice'>\The [user] has [robotic_surgery ? "reinstalled" : "transplanted"] \the [tool] into [target]'s [affected.name].</span>", \
	"<span class='notice'>You have [robotic_surgery ? "reinstalled" : "transplanted"] \the [tool] into [target]'s [affected.name].</span>")
	var/obj/item/organ/O = tool
	if(istype(O) && user.try_unequip(O, target))
		//Place the organ but don't attach it yet
		target.add_organ(O, affected, detached = TRUE)

		if(!BP_IS_PROSTHETIC(affected))
			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)
		else
			playsound(target.loc, 'sound/items/Ratchet.ogg', 50, 1)

		if(BP_IS_PROSTHETIC(O) && prob(user.skill_fail_chance(SKILL_DEVICES, 50, SKILL_ADEPT)))
			O.add_random_ailment()

/decl/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging \the [tool]!</span>")
	var/obj/item/organ/internal/I = tool
	if(istype(I))
		I.take_internal_damage(rand(3,5))

//////////////////////////////////////////////////////////////////
//	 Organ attachment surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/internal/attach_organ
	name = "Attach internal organ"
	description = "This procedure reattaches a replaced internal organ."
	allowed_tools = list(
		TOOL_SUTURES = 100,
		TOOL_CABLECOIL = 75
	)
	min_duration = 100
	max_duration = 120
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NO_ROBOTIC | SURGERY_NEEDS_ENCASEMENT

/decl/surgery_step/internal/attach_organ/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool)
	var/target_zone = user.get_target_zone()
	var/obj/item/organ/internal/O = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(BP_IS_PROSTHETIC(O))
		if(BP_IS_PROSTHETIC(affected))
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	else
		return ..()

/decl/surgery_step/internal/attach_organ/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)

	var/list/attachable_organs
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)

	for(var/obj/item/organ/I in affected.implants)
		if(I && (I.status & ORGAN_CUT_AWAY))
			var/image/radial_button = image(icon = I.icon, icon_state = I.icon_state)
			radial_button.name = "Attach \the [I.name]"
			LAZYSET(attachable_organs, I, radial_button)

	if(!LAZYLEN(attachable_organs))
		return FALSE

	var/obj/item/organ/organ_to_replace = show_radial_menu(user, tool, attachable_organs, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(tool))
	if(!organ_to_replace)
		return FALSE

	if(organ_to_replace.parent_organ != affected.organ_tag)
		to_chat(user, SPAN_WARNING("You can't find anywhere to attach \the [organ_to_replace] to!"))
		return FALSE

	if(istype(organ_to_replace, /obj/item/organ/internal/augment))
		var/obj/item/organ/internal/augment/A = organ_to_replace
		if(!(A.augment_flags & AUGMENTATION_ORGANIC))
			to_chat(user, SPAN_WARNING("\The [A] cannot function within a non-robotic limb."))
			return FALSE

	var/decl/species/species = target.get_species()
	if(!species)
		return FALSE

	if(BP_IS_PROSTHETIC(organ_to_replace) && (species.spawn_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS))
		user.visible_message("<span class='notice'>[target]'s biology has rejected the attempts to attach \the [organ_to_replace].</span>")
		return FALSE

	var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(target, organ_to_replace.organ_tag)
	if(I && (I.parent_organ == affected.organ_tag))
		to_chat(user, SPAN_WARNING("\The [target] already has \a [organ_to_replace]."))
		return FALSE
	return organ_to_replace

/decl/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].", \
	"You start reattaching [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].")
	target.custom_pain("Someone's digging needles into your [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)]!",100)
	..()

/decl/surgery_step/internal/attach_organ/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/I = LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)

	user.visible_message("<span class='notice'>[user] has reattached [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].</span>" , \
	"<span class='notice'>You have reattached [target]'s [LAZYACCESS(global.surgeries_in_progress["\ref[target]"], target_zone)] with \the [tool].</span>")

	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(istype(I) && I.parent_organ == target_zone && affected && (I in affected.implants))
		target.add_organ(I, affected, detached = FALSE)

/decl/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(20, used_weapon = tool)
