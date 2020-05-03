GLOBAL_LIST_EMPTY(corticalStacks)

/proc/switchToStack(var/ckey)
	for(var/obj/item/organ/internal/stack/S in GLOB.corticalStacks)
		if(S.owner_ckey == ckey)
			var/mob/stack/stackmob = new()
			S.stackmob = stackmob
			stackmob.forceMove(S)
			stackmob.ckey = ckey
			stackmob.mind = S.backup
			return 1
	return 0

/mob/living/carbon/human/proc/create_stack()
	internal_organs_by_name[BP_STACK] = new /obj/item/organ/internal/stack(src, 1)
	to_chat(src, "<span class='notice'>You feel a faint sense of vertigo as your cortical stack boots.</span>")

/mob/stack
	use_me = 0
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cortical-stack"

/obj/item/organ/internal/stack
	name = "cortical stack"
	parent_organ = BP_HEAD
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	vital = 1
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_DATA = 3)
	relative_size = 10

	var/datum/computer_file/data/cloning/backup
	var/owner_ckey
	var/mob/stack/stackmob = null

/obj/item/organ/internal/stack/New(var/mob/living/carbon/holder)
	..()
	LAZYDISTINCTADD(GLOB.corticalStacks, src)
	robotize()

/obj/item/organ/internal/stack/examine(var/mob/user)
	. = ..(user)
	if(istype(backup)) // Do we have a backup?
		if(user.skill_check(SKILL_DEVICES, SKILL_EXPERT)) // Can we even tell what the blinking means?
			if(find_dead_player(owner_ckey, 1)) // Is the player still around and dead?
				to_chat(user, "<span class='notice'>The light on [src] is blinking rapidly. Someone might have a second chance.</span>")
			else
				to_chat(user, "The light on [src] is blinking slowly. Maybe wait a while...")
		else
			to_chat(user, "The light on [src] is blinking, but you don't know what it means.")
	else
		to_chat(user, "The light on [src] is off. " + (user.skill_check(SKILL_DEVICES, SKILL_EXPERT) ? "It doesn't have a backup." : "Wonder what that means."))

/obj/item/organ/internal/stack/emp_act()
	return

/obj/item/organ/internal/stack/getToxLoss()
	return 0

/obj/item/organ/internal/stack/removed()
	qdel(backup)
	backup = new()
	backup.initialize_backup(owner)
	return ..()

/obj/item/organ/internal/stack/Destroy()
	QDEL_NULL(stackmob)
	QDEL_NULL(backup)
	. = ..()