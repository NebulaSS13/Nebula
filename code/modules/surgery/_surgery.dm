var/global/list/surgeries_in_progress = list()

// A list of types that will not attempt to perform surgery if the user is on help intent.
var/global/list/surgery_tool_exceptions = list(
	/obj/item/auto_cpr,
	/obj/item/scanner/health,
	/obj/item/scanner/breath,
	/obj/item/shockpaddles,
	/obj/item/chems/hypospray,
	/obj/item/chems/inhaler,
	/obj/item/modular_computer,
	/obj/item/chems/syringe,
	/obj/item/chems/borghypo
)
var/global/list/surgery_tool_exception_cache = list()

/* SURGERY STEPS */
/decl/surgery_step
	var/name
	var/description
	var/list/allowed_tools               // type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_species             // type paths referencing races that this step applies to.
	var/list/disallowed_species          // type paths referencing races that this step applies to.
	var/min_duration = 0                 // duration of the step
	var/max_duration = 0                 // duration of the step
	var/can_infect = 0                   // evil infection stuff that will make everyone hate me
	var/blood_level = 0                  // How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/shock_level = 0	                 // what shock level will this step put patient on
	var/delicate = 0                     // if this step NEEDS stable optable or can be done on any valid surface with no penalty
	var/surgery_candidate_flags = 0      // Various bitflags for requirements of the surgery.
	var/strict_access_requirement = TRUE // Whether or not this surgery will be fuzzy on size requirements.
	var/hidden_from_codex                // Is this surgery a secret?
	var/list/additional_codex_lines
	var/expected_mob_type = /mob/living/carbon/human
	abstract_type = /decl/surgery_step

/decl/surgery_step/validate()
	. = ..()
	if (!description)
		. += "Missing description"
	else if (!istext(description))
		. += "Non-text description"

//returns how fast the tool is for this step
/decl/surgery_step/proc/get_speed_modifier(var/mob/user, var/mob/target, var/obj/item/tool)
	for(var/T in allowed_tools)
		if(ispath(T, /decl/tool_archetype) && tool.get_tool_quality(T) > 0)
			if(isnull(.))
				. = tool.get_tool_speed(T)
			else
				. = min(. , tool.get_tool_speed(T))
	if(isnull(.))
		. = 1

//returns how well tool is suited for this step
/decl/surgery_step/proc/tool_quality(obj/item/tool)
	. = 0
	for(var/T in allowed_tools)
		if(istype(tool,T))
			return allowed_tools[T]
		if(ispath(T, /decl/tool_archetype))
			. = max((. || 0), allowed_tools[T] * tool.get_tool_quality(T))

/decl/surgery_step/proc/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	return TRUE

// Checks if this step applies to the user mob at all
/decl/surgery_step/proc/is_valid_target(mob/living/target)
	. = ((!expected_mob_type || istype(target, expected_mob_type)) && isliving(target))
	if(.)
		var/decl/species/species = target.get_species()
		if(allowed_species)
			. = FALSE
			if(species)
				for(var/species_name in allowed_species)
					if(species.get_root_species_name(target) == species_name)
						return TRUE
		if(species && disallowed_species)
			for(var/species_name in disallowed_species)
				if(species.get_root_species_name(target) == species_name)
					return FALSE

/decl/surgery_step/proc/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool, target_zone)
	if(delicate)
		return SURGERY_SKILLS_DELICATE
	else
		return SURGERY_SKILLS_GENERIC

// checks whether this step can be applied with the given user and target
/decl/surgery_step/proc/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	return assess_bodypart(user, target, target_zone, tool) && assess_surgery_candidate(user, target, target_zone, tool)

/decl/surgery_step/proc/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(ishuman(target) && target_zone)
		var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
		if(affected)
			// Check various conditional flags.
			if(((surgery_candidate_flags & SURGERY_NO_ROBOTIC) && BP_IS_PROSTHETIC(affected)) || \
			 ((surgery_candidate_flags & SURGERY_NO_CRYSTAL) && BP_IS_CRYSTAL(affected))   || \
			 ((surgery_candidate_flags & SURGERY_NO_FLESH) && !(BP_IS_PROSTHETIC(affected) || BP_IS_CRYSTAL(affected))))
				return FALSE
			// Check if the surgery target is accessible.
			if(BP_IS_PROSTHETIC(affected))
				if(((surgery_candidate_flags & SURGERY_NEEDS_ENCASEMENT) || \
				 (surgery_candidate_flags & SURGERY_NEEDS_INCISION)      || \
				 (surgery_candidate_flags & SURGERY_NEEDS_RETRACTED))    && \
				 affected.hatch_state != HATCH_OPENED)
					return FALSE
			else
				var/open_threshold = 0
				if(surgery_candidate_flags & SURGERY_NEEDS_INCISION)
					open_threshold = SURGERY_OPEN
				else if(surgery_candidate_flags & SURGERY_NEEDS_RETRACTED)
					open_threshold = SURGERY_RETRACTED
				else if(surgery_candidate_flags & SURGERY_NEEDS_ENCASEMENT)
					open_threshold = (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED)
				if(open_threshold && ((strict_access_requirement && affected.how_open() != open_threshold) || \
				 affected.how_open() < open_threshold))
					return FALSE
			// Check if clothing is blocking access
			var/mob/living/carbon/human/C = target
			var/obj/item/I = C.get_covering_equipped_item_by_zone(target_zone)
			if(I && (I.item_flags & ITEM_FLAG_THICKMATERIAL))
				to_chat(user,SPAN_NOTICE("The material covering this area is too thick for you to do surgery through!"))
				return FALSE
			return affected
	return FALSE

/decl/surgery_step/proc/assess_surgery_candidate(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	return ishuman(target)

// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/decl/surgery_step/proc/begin_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if (can_infect && affected)
		spread_germs_to_organ(affected, user)
	if(ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if (blood_level)
			H.bloody_hands(target,2)
		if (blood_level > 1)
			H.bloody_body(target,2)
	if(shock_level && ishuman(target))
		var/mob/living/carbon/human/H = target
		H.shock_stage = max(H.shock_stage, shock_level)

// does stuff to end the step, which is normally print a message + do whatever this step changes
/decl/surgery_step/proc/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	return

// stuff that happens when the step fails
/decl/surgery_step/proc/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	return null

/decl/surgery_step/proc/success_chance(mob/living/user, mob/living/target, obj/item/tool, target_zone)
	. = tool_quality(tool)
	if(user == target)
		. -= 10

	var/skill_reqs = get_skill_reqs(user, target, tool, target_zone)
	for(var/skill in skill_reqs)
		var/penalty = delicate ? 40 : 20
		. -= max(0, penalty * (skill_reqs[skill] - user.get_skill_value(skill)))
		if(user.skill_check(skill, SKILL_PROF))
			. += 20

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		. -= round(H.shock_stage * 0.5)
		if(GET_STATUS(H, STAT_BLURRY))
			. -= 20
		if(GET_STATUS(H, STAT_BLIND))
			. -= 60

	if(delicate)
		if(HAS_STATUS(user, STAT_SLUR))
			. -= 10
		if(!target.lying)
			. -= 30
		var/turf/T = get_turf(target)
		if(locate(/obj/machinery/optable, T))
			. -= 0
		else if(locate(/obj/structure/bed, T))
			. -= 5
		else if(locate(/obj/structure/table, T))
			. -= 10
		else if(locate(/obj/effect/rune/, T))
			. -= 10
	. = max(., 0)

/proc/spread_germs_to_organ(var/obj/item/organ/external/E, var/mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	var/obj/item/gloves = user.get_equipped_item(slot_gloves_str)
	if(gloves)
		germ_level = gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/obj/item/proc/do_surgery(mob/living/M, mob/living/user, fuckup_prob)

	// Check for the Hippocratic oath.
	if(!istype(M) || !istype(user) || user.a_intent == I_HURT)
		return FALSE

	// Check for multi-surgery drifting.
	var/zone = user.get_target_zone()
	if(!zone)
		return FALSE // Erroneous mob interaction

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(length(LAZYACCESS(H.species.limb_mapping, zone)) > 1)
			zone = input("Which bodypart do you wish to operate on?", "Non-standard surgery") as null|anything in H.species.limb_mapping[zone]
			if(!zone)
				return FALSE

	if(zone in global.surgeries_in_progress["\ref[M]"])
		to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		return TRUE

	// What surgeries does our tool/target enable?
	var/list/possible_surgeries
	var/list/all_surgeries = decls_repository.get_decls_of_subtype(/decl/surgery_step)
	for(var/decl in all_surgeries)
		var/decl/surgery_step/S = all_surgeries[decl]
		if(S.name && S.tool_quality(src) && S.can_use(user, M, zone, src))

			var/image/radial_button = image(icon = icon, icon_state = icon_state)
			radial_button.name = S.name
			LAZYSET(possible_surgeries, S, radial_button)

	// Which surgery, if any, do we actually want to do?
	var/decl/surgery_step/S
	if(LAZYLEN(possible_surgeries) == 1)
		S = possible_surgeries[1]
	else if(LAZYLEN(possible_surgeries) >= 1)
		if(!user.client) // In case of future autodocs.
			S = possible_surgeries[1]
		else
			S = show_radial_menu(user, M, possible_surgeries, radius = 42, use_labels = TRUE, require_near = TRUE, check_locs = list(src))
		if(S && !user.skill_check_multiple(S.get_skill_reqs(user, M, src, zone)))
			S = pick(possible_surgeries)

	// We didn't find a surgery, or decided not to perform one.
	if(!istype(S))
		// If we're on an optable, we are protected from some surgery fails. Bypass this for some items (like health analyzers).
		if((locate(/obj/machinery/optable) in get_turf(M)) && user.a_intent == I_HELP)
			// Keep track of which tools we know aren't appropriate for surgery on help intent.
			if(global.surgery_tool_exception_cache[type])
				return FALSE
			for(var/tool in global.surgery_tool_exceptions)
				if(istype(src, tool))
					global.surgery_tool_exception_cache[type] = TRUE
					return FALSE
			to_chat(user, SPAN_WARNING("You aren't sure what you could do to \the [M] with \the [src]."))
			return TRUE

	// Otherwise we can make a start on surgery!
	else if(istype(M) && !QDELETED(M) && user.a_intent != I_HURT && user.get_active_hand() == src)
		// Double-check this in case it changed between initial check and now.
		if(zone in global.surgeries_in_progress["\ref[M]"])
			to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		else if(S.can_use(user, M, zone, src) && S.is_valid_target(M))
			var/operation_data = S.pre_surgery_step(user, M, zone, src)
			if(operation_data)
				LAZYSET(global.surgeries_in_progress["\ref[M]"], zone, operation_data)
				S.begin_step(user, M, zone, src)
				var/skill_reqs = S.get_skill_reqs(user, M, src, zone)
				var/duration = max(1, round(user.skill_delay_mult(skill_reqs[1]) * rand(S.min_duration, S.max_duration) * S.get_speed_modifier(user, M, src)))
				if(prob(S.success_chance(user, M, src, zone)) && do_mob(user, M, duration))
					S.end_step(user, M, zone, src)
					handle_post_surgery()
				else if ((src in user.contents) && user.Adjacent(M))
					S.fail_step(user, M, zone, src)
				else
					to_chat(user, SPAN_WARNING("You must remain close to your patient to conduct surgery."))
				if(!QDELETED(M))
					LAZYREMOVE(global.surgeries_in_progress["\ref[M]"], zone) // Clear the in-progress flag.
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						H.update_surgery()
		return TRUE
	return FALSE

/obj/item/proc/handle_post_surgery()
	return

/obj/item/stack/handle_post_surgery()
	use(1)

//check if mob is lying down on something we can operate him on.
/proc/can_operate(mob/living/carbon/M, mob/living/carbon/user)
	var/turf/T = get_turf(M)
	if(locate(/obj/machinery/optable, T))
		. = OPERATE_IDEAL
	else if(locate(/obj/structure/table, T))
		. = OPERATE_OKAY
	else if(locate(/obj/structure/bed, T))
		. = OPERATE_PASSABLE
	else if(locate(/obj/effect/rune, T))
		. = OPERATE_PASSABLE
	else
		. = OPERATE_DENY
	if(. != OPERATE_DENY && M == user)
		var/hitzone = check_zone(user.get_target_zone(), M)
		var/list/badzones = list(BP_HEAD)
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(M, M.get_active_held_item_slot())
		if(E)
			badzones |= E.organ_tag
			badzones |= E.parent_organ
		if(hitzone in badzones)
			return OPERATE_DENY
		. = min(., OPERATE_OKAY) // it's awkward no matter what
