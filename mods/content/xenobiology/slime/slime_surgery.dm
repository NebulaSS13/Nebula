//Procedures in this file: Slime surgery, core extraction.
//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//	generic slime surgery step datum
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime
	allowed_species = null
	disallowed_species = null
	expected_mob_type = /mob/living/slime
	hidden_from_codex = TRUE
	surgery_step_category = /decl/surgery_step/slime

/decl/surgery_step/slime/is_valid_target(mob/living/slime/target)
	return isslime(target)

/decl/surgery_step/slime/assess_bodypart(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	return TRUE

/decl/surgery_step/slime/assess_surgery_candidate(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	return isslime(target) && target.stat == DEAD

/decl/surgery_step/slime/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool)
	return list(SKILL_SCIENCE = SKILL_ADEPT)

//////////////////////////////////////////////////////////////////
//	slime flesh cutting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime/cut_flesh
	name = "Make incision in slime"
	description = "This procedure begins slime core removal surgery by cutting an incision open."
	allowed_tools = list(TOOL_SCALPEL = 100)
	min_duration = 5
	max_duration = 2 SECONDS

/decl/surgery_step/slime/cut_flesh/can_use(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 0

/decl/surgery_step/slime/cut_flesh/begin_step(mob/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through [target]'s flesh with \the [tool].", \
	"You start cutting through [target]'s flesh with \the [tool].")

/decl/surgery_step/slime/cut_flesh/end_step(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cuts through [target]'s flesh with \the [tool].</span>",	\
	"<span class='notice'>You cut through [target]'s flesh with \the [tool], revealing its silky innards.</span>")
	target.core_removal_stage = 1

/decl/surgery_step/slime/cut_flesh/fail_step(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s flesh with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, tearing [target]'s flesh with \the [tool]!</span>")

//////////////////////////////////////////////////////////////////
//	slime innards cutting surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime/cut_innards
	name = "Dissect innards"
	description = "This procedure disconnects slime cores from the innards."
	allowed_tools = list(TOOL_SCALPEL = 100)
	min_duration = 5
	max_duration = 2 SECONDS

/decl/surgery_step/slime/cut_innards/can_use(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == 1

/decl/surgery_step/slime/cut_innards/begin_step(mob/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting [target]'s silky innards apart with \the [tool].", \
	"You start cutting [target]'s silky innards apart with \the [tool].")

/decl/surgery_step/slime/cut_innards/end_step(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cuts [target]'s innards apart with \the [tool], exposing the cores.</span>",	\
	"<span class='notice'>You cut [target]'s innards apart with \the [tool], exposing the cores.</span>")
	target.core_removal_stage = 2

/decl/surgery_step/slime/cut_innards/fail_step(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s innards with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, tearing [target]'s innards with \the [tool]!</span>")

//////////////////////////////////////////////////////////////////
//	slime core removal surgery step
//////////////////////////////////////////////////////////////////
/decl/surgery_step/slime/saw_core
	name = "Remove slime core"
	description = "This procedure completely separates a slime cores and allows it to be removed."
	allowed_tools = list(
		TOOL_SAW = 100,
		TOOL_HATCHET = 75
	)
	min_duration = 1 SECOND
	max_duration = 3 SECONDS

/decl/surgery_step/slime/saw_core/can_use(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	return ..() && (istype(target) && target.core_removal_stage == 2 && target.cores > 0) //This is being passed a human as target, unsure why.

/decl/surgery_step/slime/saw_core/begin_step(mob/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts cutting out one of \the [target]'s cores with \the [tool]."), \
		SPAN_NOTICE("You start cutting out one of \the [target]'s cores with \the [tool]."))

/decl/surgery_step/slime/saw_core/end_step(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	if(target.cores <= 0)
		to_chat(user, SPAN_WARNING("You cannot find any cores within \the [target]."))
		return
	var/atom/core = new /obj/item/slime_extract(target.loc, /decl/material/liquid/slimejelly, target.slime_type)
	target.cores--
	user.visible_message(
		SPAN_NOTICE("\The [user] cuts \the [core] out of \the [target] with \the [tool]."),	\
		SPAN_NOTICE("You cut \the [core] out of \the [target] with \the [tool]. It looks like there are [target.cores] core\s left."))
	target.update_icon()

/decl/surgery_step/slime/saw_core/fail_step(mob/living/user, mob/living/slime/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_DANGER("\The [user]'s hand slips, failing to extract the slime core."), \
		SPAN_DANGER("Your hand slips, causing you to miss the core!"))
