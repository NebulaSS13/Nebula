//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////
//	generic surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic
	abstract_type = /decl/surgery_step/generic
	can_infect = 1
	shock_level = 10
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL

/decl/surgery_step/generic/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(target_zone != BP_EYES) //there are specific steps for eye surgery
		. = ..()

//////////////////////////////////////////////////////////////////
//	 scalpel surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/cut_open
	name = "Make incision"
	description = "This procedure cuts a small wound that allows access to deeper tissue."
	allowed_tools = list(TOOL_SCALPEL = 100)
	min_duration = 90
	max_duration = 110
	var/fail_string = "slicing open"
	var/access_string = "an incision"

/decl/surgery_step/generic/cut_open/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	. = ..()
	if(.)
		var/obj/item/organ/external/affected = .
		if(affected.how_open())
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access."))
			return FALSE

/decl/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts [access_string] on [target]'s [affected.name] with \the [tool].", \
	"You start [access_string] on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!",40, affecting = affected)
	..()

/decl/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='notice'>[user] has made [access_string] on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have made [access_string] on [target]'s [affected.name] with \the [tool].</span>",)
	affected.createwound(CUT, CEILING(affected.min_broken_damage/2), TRUE)
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)
	if(tool.damtype == BURN)
		affected.clamp_organ()

/decl/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, [fail_string] \the [target]'s [affected.name] in the wrong place with \the [tool]!</span>")
	affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

/decl/surgery_step/generic/cut_open/success_chance(mob/living/user, mob/living/target, obj/item/tool)
	. = ..()
	if(user.skill_check(SKILL_FORENSICS, SKILL_ADEPT))
		. += 40
		if(target.stat == DEAD)
			. += 40

//////////////////////////////////////////////////////////////////
//	 bleeder clamping surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/clamp_bleeders
	name = "Clamp bleeders"
	description = "This procedure clamps off veins within an incision, preventing it from bleeding excessively."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CABLECOIL = 75
	)
	min_duration = 40
	max_duration = 60
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_INCISION
	strict_access_requirement = FALSE

/decl/surgery_step/generic/clamp_bleeders/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && !affected.clamped())
		return affected

/decl/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!",40, affecting = affected)
	..()

/decl/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='notice'>[user] clamps bleeders in [target]'s [affected.name] with \the [tool].</span>",	\
	"<span class='notice'>You clamp bleeders in [target]'s [affected.name] with \the [tool].</span>")
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)

/decl/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",	\
	"<span class='warning'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",)
	affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 retractor surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/retract_skin
	name = "Widen incision"
	description = "This procedure is used to widen an incision when it is too small to access the interior."
	allowed_tools = list(
		TOOL_RETRACTOR = 100,
		TOOL_CROWBAR = 75
	)
	min_duration = 30
	max_duration = 40
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_INCISION
	strict_access_requirement = TRUE

/decl/surgery_step/generic/retract_skin/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	. = FALSE
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(affected)
		if(affected.how_open() >= SURGERY_RETRACTED)
			var/datum/wound/cut/incision = affected.get_incision()
			to_chat(user, SPAN_NOTICE("The [incision.desc] provides enough access, a larger incision isn't needed."))
		else
			. = TRUE

/decl/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool].",	\
	"You start to pry open the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!",40,affecting = affected)
	..()

/decl/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='notice'>[user] keeps the incision open on [target]'s [affected.name] with \the [tool].</span>",	\
	"<span class='notice'>You keep the incision open on [target]'s [affected.name] with \the [tool].</span>")
	affected.open_incision()

/decl/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>",	\
	"<span class='warning'>Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(12, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 skin cauterization surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/cauterize
	name = "Cauterize incision"
	description = "This procedure cauterizes and closes an incision."
	allowed_tools = list(
		TOOL_CAUTERY = 100,
		TOOL_WELDER = 25
	)
	min_duration = 70
	max_duration = 100
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL
	var/cauterize_term = "cauterize"
	var/post_cauterize_term = "cauterized"

/decl/surgery_step/generic/cauterize/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(!affected?.get_incision(1))
		to_chat(user, SPAN_WARNING("There are no incisions on [target]'s [affected.name] that can be closed cleanly with \the [tool]!"))
		return FALSE
	return TRUE

/decl/surgery_step/generic/cauterize/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.how_open())
		return affected

/decl/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message("[user] is beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Your [affected.name] is being burned!",40,affecting = affected)
	..()

/decl/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	var/datum/wound/W = affected.get_incision()
	user.visible_message("<span class='notice'>[user] [post_cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You [cauterize_term][W ? " \a [W.desc] on" : ""] \the [target]'s [affected.name] with \the [tool].</span>")
	if(istype(W))
		W.close()
		affected.update_wounds()
	if(affected.clamped())
		affected.remove_clamps()

/decl/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(0, 3, used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 limb amputation surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/generic/amputate
	name = "Amputate limb"
	description = "This procedure removes a limb, or the stump of a limb, from the body entirely."
	allowed_tools = list(
		TOOL_SAW = 100,
		TOOL_HATCHET = 75
	)
	min_duration = 110
	max_duration = 160
	surgery_candidate_flags = 0

/decl/surgery_step/generic/amputate/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && (affected.limb_flags & ORGAN_FLAG_CAN_AMPUTATE) && !affected.how_open())
		return affected

/decl/surgery_step/generic/amputate/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool)
	var/target_zone = user.get_target_zone()
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(BP_IS_PROSTHETIC(affected))
		return SURGERY_SKILLS_ROBOTIC
	else
		return ..()

/decl/surgery_step/generic/amputate/proc/is_clean(var/mob/user, var/obj/item/tool, var/mob/target)
	. = (user.a_intent != I_HELP) ? FALSE : (can_operate(target) >= OPERATE_OKAY && istype(tool, /obj/item/circular_saw))

/decl/surgery_step/generic/amputate/get_speed_modifier(var/mob/user, var/mob/target, var/obj/item/tool, var/tool_archetype)
	. = ..()
	if(!is_clean(user, tool, target))
		. *= 0.5

/decl/surgery_step/generic/amputate/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(is_clean(user, tool, target))
		user.visible_message( \
			SPAN_NOTICE("\The [user] is beginning to amputate \the [target]'s [affected.name] with \the [tool]."), \
			SPAN_NOTICE("<FONT size=3>You are beginning to cut through \the [target]'s [affected.amputation_point] with \the [tool].</FONT>"))
	else
		user.visible_message( \
			SPAN_DANGER("\The [user] starts hacking at \the [target]'s [affected.name] with \the [tool]!") , \
			SPAN_DANGER("<FONT size=3>You start hacking at \the [target]'s [affected.amputation_point] with \the [tool]!</FONT>"))
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!",100,affecting = affected)
	..()

/decl/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	var/clean_cut = is_clean(user, tool, target)
	if(clean_cut)
		user.visible_message( \
			SPAN_NOTICE("\The [user] cleanly amputates \the [target]'s [affected.name] at the [affected.amputation_point] with \the [tool]."), \
			SPAN_NOTICE("You cleanly amputate \the [target]'s [affected.name] with \the [tool]."))
	else
		user.visible_message( \
			SPAN_DANGER("\The [user] hacks off \the [target]'s [affected.name] at the [affected.amputation_point] with \the [tool]!"), \
			SPAN_DANGER("You hack off \the [target]'s [affected.name] with \the [tool]!"))
	affected.dismember(clean_cut, DISMEMBER_METHOD_EDGE)

/decl/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(user.try_unequip(tool, affected))
		user.visible_message(
			SPAN_DANGER("\The [user] manages to get \the [tool] stuck in \the [target]'s [affected.name]!"), \
			SPAN_DANGER("You manage to get \the [tool] stuck in \the [target]'s [affected.name]!"))
		affected.embed(tool, affected.take_external_damage(30, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool))
	else
		user.visible_message(
			SPAN_WARNING("\The [user] slips, mangling \the [target]'s [affected.name] with \the [tool]."), \
			SPAN_WARNING("You slip, mangling \the [target]'s [affected.name] with \the [tool]."))
		affected.take_external_damage(30, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)
	affected.fracture()
