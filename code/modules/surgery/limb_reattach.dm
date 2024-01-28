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
	abstract_type = /decl/surgery_step/limb

/decl/surgery_step/limb/get_skill_reqs(mob/living/user, mob/living/target, obj/item/organ/external/tool)
	// Not supplied a limb.
	if(!istype(tool))
		return ..()
	// No parent (how did we get here?)
	var/tool_is_prosthetic = BP_IS_PROSTHETIC(tool)
	if(!tool.parent_organ)
		if(tool_is_prosthetic)
			return SURGERY_SKILLS_ROBOTIC
		return ..()
	// Parent is invalid.
	var/obj/item/organ/external/parent = target && GET_EXTERNAL_ORGAN(target, tool.parent_organ)
	if(!istype(parent))
		return ..()
	// If either is meat and the other is not, return mixed skills.
	var/parent_is_prosthetic = BP_IS_PROSTHETIC(parent)
	if(parent_is_prosthetic != tool_is_prosthetic)
		return SURGERY_SKILLS_ROBOTIC_ON_MEAT
	// If they are robotic, return robot skills.
	if(parent_is_prosthetic)
		return SURGERY_SKILLS_ROBOTIC
	// Otherwise return base skills.
	return ..()

/decl/surgery_step/limb/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(affected)
		return affected
	var/list/organ_data = target.should_have_limb(target_zone)
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
	var/obj/item/organ/external/P = GET_EXTERNAL_ORGAN(target, E.parent_organ)
	var/obj/item/organ/external/T = GET_EXTERNAL_ORGAN(target, E.organ_tag)

	if(!P)
		to_chat(user, SPAN_WARNING("The [E.amputation_point] is missing!"))
		return FALSE

	if(T)
		to_chat(user, SPAN_WARNING("There is already \a [T]!"))
		return FALSE
	if(BP_IS_PROSTHETIC(P))
		if(!BP_IS_PROSTHETIC(E))
			to_chat(user, SPAN_WARNING("You cannot attach a flesh part to a robotic body."))
		var/decl/bodytype/prosthetic/robo_model = P.bodytype
		if(!istype(robo_model) || !robo_model.check_can_install(E.organ_tag, target.get_bodytype_category()))
			to_chat(user, SPAN_WARNING("That model of prosthetic is incompatible with \the [target]."))
			return FALSE

	if(BP_IS_CRYSTAL(P) && !BP_IS_CRYSTAL(E))
		to_chat(user, SPAN_WARNING("You cannot attach a flesh part to a crystalline body."))
		return FALSE

	if(!BP_IS_CRYSTAL(P) && BP_IS_CRYSTAL(E))
		to_chat(user, SPAN_WARNING("You cannot attach a crystalline part to a flesh body."))
		return FALSE

	. = TRUE

/decl/surgery_step/limb/attach/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/E = tool
		var/obj/item/organ/external/P = GET_EXTERNAL_ORGAN(target, E.parent_organ)
		. = (P && !(BP_IS_PROSTHETIC(P) && !BP_IS_PROSTHETIC(E)))

/decl/surgery_step/limb/attach/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("[user] starts attaching [E.name] to [target]'s [E.amputation_point].", \
	"You start attaching [E.name] to [target]'s [E.amputation_point].")
	..()

/decl/surgery_step/limb/attach/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(!user.try_unequip(tool))
		return
	var/obj/item/organ/external/P = GET_EXTERNAL_ORGAN(target, target_zone)
	var/obj/item/organ/external/E = tool
	user.visible_message("<span class='notice'>[user] has attached [target]'s [E.name] to the [E.amputation_point].</span>",	\
	"<span class='notice'>You have attached [target]'s [E.name] to the [E.amputation_point].</span>")

	//Add the organ but in a detached state
	target.add_organ(E, P, FALSE, TRUE, TRUE)

	if(BP_IS_PROSTHETIC(E) && prob(user.skill_fail_chance(SKILL_DEVICES, 50, SKILL_ADEPT)))
		E.add_random_ailment()
	..()

/decl/surgery_step/limb/attach/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
	"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
	target.apply_damage(10, BRUTE, null, damage_flags=DAM_SHARP)
	..()

//////////////////////////////////////////////////////////////////
//	 limb connecting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/limb/connect
	name = "Connect limb"
	description = "This procedure is used to reconnect a replaced severed limb."
	allowed_tools = list(
		TOOL_SUTURES = 100,
		TOOL_CABLECOIL = 75
	)
	can_infect = 1
	min_duration = 100
	max_duration = 120

/decl/surgery_step/limb/connect/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool, target_zone)
	return ..(tool = (target && GET_EXTERNAL_ORGAN(target, target_zone)))

/decl/surgery_step/limb/connect/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(target, target_zone)
		return E && (E.status & ORGAN_CUT_AWAY)

/decl/surgery_step/limb/connect/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts reattaching tendons and muscles in [target]'s [E.amputation_point] with [tool].", \
	"You start reattaching tendons and muscle in [target]'s [E.amputation_point].")
	..()

/decl/surgery_step/limb/connect/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(target, target_zone)
	var/obj/item/organ/external/P = GET_EXTERNAL_ORGAN(target, E.parent_organ)
	user.visible_message("<span class='notice'>[user] has reattached tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>",	\
	"<span class='notice'>You have reattached tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>")

	//This time we call add_organ but we want it to install in a non detached state
	target.add_organ(E, P, FALSE, TRUE, FALSE)
	..()

/decl/surgery_step/limb/connect/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
	"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
	target.apply_damage(10, BRUTE, null, damage_flags=DAM_SHARP)
	..()
