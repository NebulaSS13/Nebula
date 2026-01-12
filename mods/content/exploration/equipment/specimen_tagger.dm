// Device used to implant, remove or read specimen tags.

/* Notes on specimen tagger and expected flow:
 * - Xenofauna player uses tagger (/obj/item/specimen_tagger) on appropriate critter (appropriate type, has cataloguer info).
 * - Tag (/obj/item/gps/specimen_tag) is created and registered in the critter.
 * - Xenofauna players can then track the tag via GPS to scan, remove, etc.
 * - When persistent specimens are committed, tags will be loaded and assigned to mobs at world init.
 */

/obj/item/specimen_tagger
	name = "specimen tagger"
	desc = "A handheld device used to implant, remove and read xenofauna tracking tags from local specimens. Not for use on crewmembers."
	icon = 'mods/content/exploration/icons/specimen_tagger.dmi'
	icon_state = ICON_STATE_WORLD
	_base_attack_force = 0
	item_flags = ITEM_FLAG_NO_BLUDGEON
	var/tag_id = "FAUNA0"

/obj/item/specimen_tagger/attack_self(mob/user)
	var/new_tag = input("Please enter desired tag.", name, tag_id) as text
	if(QDELETED(src) || QDELETED(user) || user.incapacitated() || loc != user)
		return TRUE
	new_tag = uppertext(copytext(sanitize(new_tag), 1, 11))
	if(!length(new_tag))
		return TRUE
	tag_id = new_tag
	to_chat(usr, "You set the tracker tag to '[tag_id]'.")
	return TRUE

/obj/item/specimen_tagger/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	. += "Use this on a living animal on help intent to read an existing tracker, grab intent to tag an animal with a tracker, and any other intent to remove an existing tracker."

/obj/item/specimen_tagger/use_on_mob(mob/living/target, mob/living/user, animate)
	SHOULD_CALL_PARENT(FALSE)
	if(user.check_intent(I_FLAG_HELP))
		try_read_tag(user, target)
	else if(user.check_intent(I_FLAG_GRAB))
		try_implant_tag(user, target)
	else
		try_remove_tag(user, target)
	return TRUE

/obj/item/specimen_tagger/proc/try_read_tag(var/mob/user, var/mob/living/target)
	var/obj/item/gps/specimen_tag/xenotag = locate() in target
	if(!istype(xenotag) || !xenotag.has_been_implanted())
		to_chat(user, SPAN_WARNING("\The [target] has not been tagged."))
		return FALSE
	to_chat(user, "<b>Specimen data for [xenotag.gps_tag]:</b>")
	to_chat(user, "<b>Species:</b> [target.real_name]")
	to_chat(user, "<b>Tag duration:</b> [xenotag.age] shift\s")
	to_chat(user, "<b>Tagged by:</b> [xenotag.implanted_by]")
	to_chat(user, "<b>Physical notes:</b> [xenotag.physical_info]")
	to_chat(user, "<b>Behavioral notes:</b> [xenotag.behavioral_info]")
	return TRUE

/obj/item/specimen_tagger/proc/check_can_tag(var/mob/user, var/mob/living/target)
	if(QDELETED(target) || !istype(target) || target.stat == DEAD || target.isSynthetic())
		to_chat(user, SPAN_WARNING("Xenofauna specimens need to be living organic creatures."))
		return FALSE
	if(!SScodex.get_codex_entry(target.get_codex_value()))
		to_chat(user, SPAN_WARNING("There's no scientific reason to tag \the [target]."))
		return FALSE
	if(!target.is_tagging_suitable())
		to_chat(user, SPAN_WARNING("\The [target] is not suitable for tagging."))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = locate(/obj/item/gps/specimen_tag) in target
	if(istype(xenotag) && xenotag.has_been_implanted())
		to_chat(user, SPAN_WARNING("\The [target] has already been tagged."))
		return FALSE
	return TRUE

/obj/item/specimen_tagger/proc/try_implant_tag(var/mob/user, var/mob/living/target)
	if(!check_can_tag(user, target))
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] begins tagging \the [target] with \the [src]..."))
	if(!do_after(user, 3 SECONDS, target) || !check_can_tag(user, target))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = new
	xenotag.set_gps_tag(tag_id)
	xenotag.implanted_by = user.real_name
	if(user.mind)
		var/user_title = user.mind.assigned_role || user.mind.role_alt_title
		if(user_title)
			xenotag.implanted_by = "[xenotag.implanted_by], [user_title]"

	xenotag.implant(target)
	user.visible_message(SPAN_NOTICE("\The [user] tags \the [target] with \a [xenotag]!"))
	return TRUE

/obj/item/specimen_tagger/proc/can_remove_tag(var/mob/user, var/mob/living/target)
	if(!istype(target))
		to_chat(user, SPAN_WARNING("\The [target] is not a xenofauna specimen."))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = locate() in target
	if(!istype(xenotag) || !xenotag.has_been_implanted())
		to_chat(user, SPAN_WARNING("\The [target] has not been tagged."))
		return FALSE
	return TRUE

/obj/item/specimen_tagger/proc/try_remove_tag(var/mob/user, var/mob/living/target)
	if(!can_remove_tag(user, target))
		return FALSE
	var/obj/item/gps/specimen_tag/xenotag = locate() in target
	if(!istype(xenotag))
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] starts removing \the [xenotag] from \the [target] with \the [src]..."))
	if(!do_after(user, 3 SECONDS, target) || !can_remove_tag(user, target))
		return FALSE
	if(!istype(xenotag))
		return FALSE
	qdel(xenotag)
	user.visible_message(SPAN_NOTICE("\The [user] removes \the [xenotag] from \the [target]!"))
	return TRUE

