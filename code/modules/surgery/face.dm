//////////////////////////////////////////////////////////////////
//	facial reconstruction surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/fix_face
	name = "Repair face"
	description = "This procedure is used to repair disfiguring facial damage."
	allowed_tools = list(
		TOOL_HEMOSTAT = 100,
		TOOL_CABLECOIL = 75
	)
	min_duration = 100
	max_duration = 120
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_CRYSTAL | SURGERY_NEEDS_RETRACTED
	strict_access_requirement = TRUE

/decl/surgery_step/fix_face/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(target_zone == BP_HEAD)
		var/obj/item/organ/external/affected = ..()
		if(affected && (affected.status & ORGAN_DISFIGURED))
			return affected

/decl/surgery_step/fix_face/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts repairing damage to \the [target]'s face with \the [tool].", \
	"You start repairing damage to \the [target]'s face with \the [tool].")
	..()

/decl/surgery_step/fix_face/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] repairs \the [target]'s face with \the [tool].</span>",	\
	"<span class='notice'>You repair \the [target]'s face with \the [tool].</span>")
	var/obj/item/organ/external/h = GET_EXTERNAL_ORGAN(target, target_zone)
	if(h)
		h.status &= ~ORGAN_DISFIGURED
	..()

/decl/surgery_step/fix_face/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing skin on [target]'s face with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, tearing skin on [target]'s face with \the [tool]!</span>")
	affected.take_external_damage(10, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)
	..()
