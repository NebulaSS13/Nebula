/proc/switchToStack(var/datum/mind/mind)
	for(var/obj/item/organ/internal/stack/S in world)
		if(S.owner.mind == mind)
			S.stackmob = new()
			S.stackmob.forceMove(S)
			mind.transfer_to(S.stackmob)
			to_chat(S.stackmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just \a [S.name]."))
			return S

/obj/item/organ/internal/stack
	name = "cortical stack"
	parent_organ = BP_HEAD
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	vital = 1
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_DATA = 3)
	relative_size = 10

	var/datum/computer_file/data/cloning/backup
	var/mob/living/carbon/limbo/stackmob = null

/obj/item/organ/internal/stack/Initialize()
	. = ..()
	robotize()

/obj/item/organ/internal/stack/examine(var/mob/user)
	. = ..(user)
	if(istype(backup)) // Do we have a backup?
		if(user.skill_check(SKILL_DEVICES, SKILL_EXPERT)) // Can we even tell what the blinking means?
			if(owner && owner.mind && find_dead_player(owner.mind.key, 1)) // Is the player still around and dead?
				to_chat(user, SPAN_NOTICE("The light on [src] is blinking rapidly. Someone might have a second chance."))
			else
				to_chat(user, "The light on [src] is blinking slowly. Maybe wait a while...")
		else
			to_chat(user, "The light on [src] is blinking, but you don't know what it means.")
	else
		to_chat(user, "The light on [src] is off. " + (user.skill_check(SKILL_DEVICES, SKILL_EXPERT) ? "It doesn't have a backup." : "Wonder what that means."))

/obj/item/organ/internal/stack/emp_act()
	return FALSE

/obj/item/organ/internal/stack/getToxLoss()
	return 0

/obj/item/organ/internal/stack/replaced()
	. = ..()
	qdel(backup)

/obj/item/organ/internal/stack/removed(var/mob/living/user, var/drop_organ=1)
	if(!istype(owner))
		return
	qdel(backup)
	backup = new()
	backup.initialize_backup(owner)
	return ..()

/obj/item/organ/internal/stack/Destroy()
	if(stackmob)
		// Stacks can be destroyed. This is the next tiny death.
		stackmob.death(0)
	QDEL_NULL(stackmob)
	QDEL_NULL(backup)
	. = ..()