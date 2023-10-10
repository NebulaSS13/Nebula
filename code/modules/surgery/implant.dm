//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	 generic implant surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/cavity
	shock_level = 40
	delicate = 1
	surgery_candidate_flags = SURGERY_NO_CRYSTAL | SURGERY_NEEDS_ENCASEMENT
	abstract_type = /decl/surgery_step/cavity

/decl/surgery_step/cavity/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>")
	affected.take_external_damage(20, 0, (DAM_SHARP|DAM_EDGE), used_weapon = tool)

//////////////////////////////////////////////////////////////////
//	 create implant space surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/cavity/make_space
	name = "Hollow out cavity"
	description = "This procedure is used to prepare a patient to have something large implanted in their body."
	allowed_tools = list(TOOL_DRILL = 100)
	min_duration = 60
	max_duration = 80

/decl/surgery_step/cavity/make_space/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.cavity_name && !affected.cavity)
		return affected

/decl/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts making some space inside [target]'s [affected.cavity_name] cavity with \the [tool].", \
	"You start making some space inside [target]'s [affected.cavity_name] cavity with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1,affecting = affected)
	affected.cavity = TRUE
	..()

/decl/surgery_step/cavity/make_space/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='notice'>[user] makes some space inside [target]'s [affected.cavity_name] cavity with \the [tool].</span>", \
	"<span class='notice'>You make some space inside [target]'s [affected.cavity_name] cavity with \the [tool].</span>" )

//////////////////////////////////////////////////////////////////
//	 implant cavity sealing surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/cavity/close_space
	name = "Close cavity"
	description = "This procedure is used to repair and close off a cavity within the body."
	allowed_tools = list(
		TOOL_CAUTERY = 100,
		TOOL_WELDER = 25
	)
	min_duration = 60
	max_duration = 80

/decl/surgery_step/cavity/close_space/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.cavity)
		return affected

/decl/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts mending [target]'s [affected.cavity_name] cavity wall with \the [tool].", \
	"You start mending [target]'s [affected.cavity_name] cavity wall with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1,affecting = affected)
	..()

/decl/surgery_step/cavity/close_space/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("<span class='notice'>[user] mends [target]'s [affected.cavity_name] cavity walls with \the [tool].</span>", \
	"<span class='notice'>You mend [target]'s [affected.cavity_name] cavity walls with \the [tool].</span>" )
	affected.cavity = FALSE

//////////////////////////////////////////////////////////////////
//	 implanting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/cavity/place_item
	name = "Place item in cavity"
	description = "This procedure inserts an item into a prepared cavity in the body."
	allowed_tools = list(/obj/item = 100)
	min_duration = 80
	max_duration = 100
	hidden_from_codex = TRUE

/decl/surgery_step/cavity/place_item/can_use(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	if(istype(user,/mob/living/silicon/robot))
		return FALSE
	. = ..()

/decl/surgery_step/cavity/place_item/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected && affected.cavity)
		return affected

/decl/surgery_step/cavity/place_item/pre_surgery_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(affected && affected.cavity)
		var/max_volume = BASE_STORAGE_CAPACITY(affected.cavity_max_w_class) + affected.internal_organs_size
		if(tool.w_class > affected.cavity_max_w_class)
			to_chat(user, SPAN_WARNING("\The [tool] is too big for [affected.cavity_name] cavity."))
			return FALSE
		var/total_volume = tool.get_storage_cost()
		for(var/obj/item/I in affected.implants)
			if(istype(I,/obj/item/implant))
				continue
			total_volume += I.get_storage_cost()
			for(var/obj/item/organ/internal/org in affected.internal_organs)
				max_volume -= org.get_storage_cost()
		if(total_volume > max_volume)
			to_chat(user, SPAN_WARNING("There isn't enough space left in [affected.cavity_name] cavity for [tool]."))
			return FALSE
		return TRUE

/decl/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts putting \the [tool] inside [target]'s [affected.cavity_name] cavity.", \
	"You start putting \the [tool] inside [target]'s [affected.cavity_name] cavity." )
	target.custom_pain("The pain in your chest is living hell!",1,affecting = affected)
	playsound(target.loc, 'sound/effects/squelch1.ogg', 25, 1)
	..()

/decl/surgery_step/cavity/place_item/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	if(!user.try_unequip(tool, affected))
		return
	user.visible_message("<span class='notice'>[user] puts \the [tool] inside [target]'s [affected.cavity_name] cavity.</span>", \
	"<span class='notice'>You put \the [tool] inside [target]'s [affected.cavity_name] cavity.</span>" )
	if (tool.w_class > affected.cavity_max_w_class/2 && prob(50) && !BP_IS_PROSTHETIC(affected) && affected.sever_artery())
		to_chat(user, "<span class='warning'>You tear some blood vessels trying to fit such a big object in this cavity.</span>")
		affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1,affecting = affected)
	LAZYDISTINCTADD(affected.implants, tool)
	affected.cavity = 0

//////////////////////////////////////////////////////////////////
//	 implant removal surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/cavity/implant_removal
	name = "Remove foreign body"
	description = "This procedure is used to remove foreign bodies like shrapnel or implants from a patient."
	allowed_tools = list(
		TOOL_HEMOSTAT =   100,
		TOOL_WIRECUTTERS = 75
	)
	min_duration = 80
	max_duration = 100

/decl/surgery_step/cavity/implant_removal/assess_bodypart(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = ..()
	if(affected)
		for(var/obj/O in affected.implants)
			if(!istype(O, /obj/item/organ/internal))
				return affected
	return FALSE

/decl/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	user.visible_message("[user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
	"You start poking around inside [target]'s [affected.name] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!",1,affecting = affected)
	..()

/decl/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	var/exposed = 0
	if(affected.how_open() >= (affected.encased ? SURGERY_ENCASED : SURGERY_RETRACTED))
		exposed = 1
	if(BP_IS_PROSTHETIC(affected) && affected.hatch_state == HATCH_OPENED)
		exposed = 1

	var/find_prob = 0
	var/list/loot = list()
	if(exposed)
		loot = affected.implants
	else
		for(var/datum/wound/wound in affected.wounds)
			if(LAZYLEN(wound.embedded_objects))
				loot |= wound.embedded_objects
			find_prob += 50

	if(LAZYLEN(loot))

		var/obj/item/obj = pick(loot)

		if(istype(obj,/obj/item/implant))
			var/obj/item/implant/imp = obj
			if (imp.islegal())
				find_prob +=60
			else
				find_prob +=40
		else
			find_prob +=50

		if (prob(find_prob))
			user.visible_message("<span class='notice'>[user] takes something out of incision on [target]'s [affected.name] with \the [tool].</span>", \
			"<span class='notice'>You take \the [obj] out of incision on \the [target]'s [affected.name] with \the [tool].</span>" )
			target.remove_implant(obj, TRUE, affected)
			BITSET(target.hud_updateflag, IMPLOYAL_HUD)
			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)
		else
			user.visible_message("<span class='notice'>[user] removes \the [tool] from [target]'s [affected.name].</span>", \
			"<span class='notice'>There's something inside [target]'s [affected.name], but you just missed it this time.</span>" )
	else
		user.visible_message("<span class='notice'>[user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.</span>", \
		"<span class='notice'>You could not find anything inside [target]'s [affected.name].</span>" )

/decl/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/target, target_zone, obj/item/tool)
	..()
	var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(target, target_zone)
	for(var/obj/item/implant/imp in affected.implants)
		var/fail_prob = 10
		fail_prob += 100 - tool_quality(tool)
		if (prob(fail_prob))
			user.visible_message("<span class='warning'>Something beeps inside [target]'s [affected.name]!</span>")
			playsound(imp.loc, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				imp.activate()

