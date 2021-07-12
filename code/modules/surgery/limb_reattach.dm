//Procedures in this file: Robotic limbs attachment, meat limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	 generic limb surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb
	can_infect = 0
	shock_level = 40
	delicate = 1
	surgery_step_category = /decl/surgery_step/limb

/decl/surgery_step/limb/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		return affected
	else if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/list/organ_data = H.species.has_limbs["[target_zone]"]
		return !isnull(organ_data)

//////////////////////////////////////////////////////////////////
//	 limb attachment surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb/attach
	name = "Replace limb"
	description = "This procedure is used to position a severed limb against the stump for further attachment."
	allowed_tools = list(/obj/item/organ/external = 100)
	min_duration = 50
	max_duration = 70

/decl/surgery_step/limb/attach/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return FALSE
	. = FALSE
	var/obj/item/organ/external/E = tool
	var/obj/item/organ/external/P = target.get_organ(E.parent_organ)
	var/obj/item/organ/external/T = target.get_organ(E.organ_tag)

	if(!P || P.is_stump())
		to_chat(user, SPAN_WARNING("The [E.amputation_point] is missing!"))
		return FALSE

	if(T)
		if(T.is_stump())
			to_chat(user, SPAN_WARNING("You cannot attach \a [E] when there is a stump!"))
		else
			to_chat(user, SPAN_WARNING("There is already \a [T]!"))
		return FALSE
	if(BP_IS_PROSTHETIC(P))
		if(!BP_IS_PROSTHETIC(E))
			to_chat(user, SPAN_WARNING("You cannot attach a flesh part to a robotic body."))
		if(P.model)
			var/decl/prosthetics_manufacturer/robo_model = GET_DECL(P.model)
			if(!istype(robo_model) || !robo_model.check_can_install(E.organ_tag, target.get_bodytype_category(), target.get_species_name()))
				to_chat(user, SPAN_WARNING("That model of prosthetic is incompatible with \the [target]."))
				return FALSE

	if(BP_IS_CRYSTAL(P) && !BP_IS_CRYSTAL(E))
		to_chat(user, SPAN_WARNING("You cannot attach a flesh part to a crystalline body."))
		return FALSE

	if(!BP_IS_CRYSTAL(P) && BP_IS_CRYSTAL(E))
		to_chat(user, SPAN_WARNING("You cannot attach a crystalline part to a flesh body."))
		return FALSE

	. = TRUE

/decl/surgery_step/limb/attach/get_skill_reqs(mob/living/user, mob/living/target, obj/item/organ/external/tool)
	if(istype(tool) && BP_IS_PROSTHETIC(tool))
		if(target.isSynthetic())
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	return ..()

/decl/surgery_step/limb/attach/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/E = tool
		var/obj/item/organ/external/P = target.get_organ(E.parent_organ)
		. = (P && !P.is_stump() && !(BP_IS_PROSTHETIC(P) && !BP_IS_PROSTHETIC(E)))

/decl/surgery_step/limb/attach/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("[user] starts attaching [E.name] to [target]'s [E.amputation_point].", \
	"You start attaching [E.name] to [target]'s [E.amputation_point].")

/decl/surgery_step/limb/attach/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(!user.unEquip(tool))
		return
	var/obj/item/organ/external/E = tool
	user.visible_message("<span class='notice'>[user] has attached [target]'s [E.name] to the [E.amputation_point].</span>",	\
	"<span class='notice'>You have attached [target]'s [E.name] to the [E.amputation_point].</span>")
	E.replaced(target)

	// Modular bodyparts (like prosthetics) do not need to be reconnected.
	if(E.get_modular_limb_category() != MODULAR_BODYPART_INVALID)
		E.status &= ~ORGAN_CUT_AWAY
		for(var/obj/item/organ/external/child in E.children)
			child.status &= ~ORGAN_CUT_AWAY
	else
		E.status |= ORGAN_CUT_AWAY

	if(BP_IS_PROSTHETIC(E) && prob(user.skill_fail_chance(SKILL_DEVICES, 50, SKILL_ADEPT)))
		E.add_random_ailment()

	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

/decl/surgery_step/limb/attach/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
	"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
	target.apply_damage(10, BRUTE, null, damage_flags=DAM_SHARP)

//////////////////////////////////////////////////////////////////
//	 limb connecting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb/connect
	name = "Connect limb"
	description = "This procedure is used to reconnect a replaced severed limb."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CABLECOIL = 75
	)
	can_infect = 1
	min_duration = 100
	max_duration = 120

/decl/surgery_step/limb/connect/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool, target_zone)
	var/obj/item/organ/external/E = target && target.get_organ(target_zone)
	if(istype(E) && BP_IS_PROSTHETIC(E))
		if(target.isSynthetic())
			return SURGERY_SKILLS_ROBOTIC
		else
			return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	return ..()

/decl/surgery_step/limb/connect/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		return E && !E.is_stump() && (E.status & ORGAN_CUT_AWAY)

/decl/surgery_step/limb/connect/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("[user] starts connecting tendons and muscles in [target]'s [E.amputation_point] with [tool].", \
	"You start connecting tendons and muscle in [target]'s [E.amputation_point].")

/decl/surgery_step/limb/connect/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has connected tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>",	\
	"<span class='notice'>You have connected tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>")
	E.status &= ~ORGAN_CUT_AWAY
	if(E.children)
		for(var/obj/item/organ/external/C in E.children)
			C.status &= ~ORGAN_CUT_AWAY
	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

/decl/surgery_step/limb/connect/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
	"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
	target.apply_damage(10, BRUTE, null, damage_flags=DAM_SHARP)
