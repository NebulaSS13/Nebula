// CROW NOTES
// - Failing Animal Husbandry when you send a crow off should have a chance of it taking whatever you
//   gave it to a nest and hiding it there before returning 30-45 seconds later empty-beaked.
// - Hitting a crow should make every crow on the map hate you.
// - Similar to hawks, crows should be able to be sent off to pick up items (crossing gaps or going
//   through bars in dungeons?).
// - You probably should not be able to hand crows live grenades or active GPS then send them off to
//   drop it into someone's inventory.
// - Crows should check z-level or faction membership or something when being told to find someone.

/datum/mob_controller/passive/crow
	emote_speech   = list("Caw.","Caw!","Caw...")
	emote_hear     = list("croaks", "caws")
	emote_see      = list("preens its feathers", "hops around")

/mob/living/simple_animal/passive/bird/crow
	name = "crow"
	desc = "A black-feathered, highly intelligent scavenger bird; often kept as messengers. Downland crows are said to be the messengers of the spirit realm."
	icon = 'mods/content/birds/icons/crow.dmi'
	ai = /datum/mob_controller/passive/crow
	ability_handlers = list(/datum/ability_handler/predator) // should really be /scavenger
	holder_type = /obj/item/holder/bird/crow
	var/weakref/current_target

/mob/living/simple_animal/passive/bird/crow/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	LAZYADD(., SPAN_SUBTLE("Crows can be given a small item like a piece of paper to hold."))
	LAZYADD(., SPAN_SUBTLE("While holding a crow, say 'Go to \[target\]' or 'Find \[target\]', then use the crow in hand to release it to travel to the target."))

/mob/living/simple_animal/passive/bird/crow/hear_say(message, verb, decl/language/language, italics, mob/speaker, sound/speech_sound, sound_vol)
	. = ..()

	if(get_recursive_loc_of_type(/mob) != speaker || !can_be_handled_by(speaker))
		return
	message = lowertext(strip_html_properly(message))

	var/command = trim(copytext(message, 1, 6))
	if(command != "go to" && command != "find")
		return

	// TODO make this less stupid/magic, can be exploited for metagaming as written.
	// Check Z-level?
	// Check faction/knowledge?

	current_target = null

	var/find_punctuation
	var/static/list/punctuation = list(".", ",", "!", "?")
	for(var/punct in punctuation)
		var/found_at = findtext(message, punct)
		if(found_at == 0)
			continue
		find_punctuation = isnull(find_punctuation) ? findtext(message, punct) : min(find_punctuation, findtext(message, punct))

	var/target_string = lowertext(trim(copytext(message, 6, find_punctuation)))

	for(var/mob/player in global.living_mob_list_)
		if(findtext(lowertext(player.name), target_string))
			current_target = weakref(player)
			break

	if(isnull(current_target))
		for(var/mob/player in global.dead_mob_list_)
			if(findtext(lowertext(player.name), target_string))
				current_target = weakref(player)
				break

	var/decl/pronouns/bird_pronouns = get_pronouns()
	var/mob/mob_target = current_target?.resolve()
	if(!istype(mob_target) || QDELETED(mob_target))
		to_chat(speaker, SPAN_WARNING("\The [src] blinks a few times at you, head tilting left and right. [bird_pronouns.He] doesn't seem to know who you mean."))
	else if(mob_target == speaker)
		to_chat(speaker, SPAN_WARNING("\The [src] blinks a few times at you, then pecks you with [bird_pronouns.his] beak. [bird_pronouns.He] [bird_pronouns.has] already found you."))
		current_target = null
	else
		to_chat(speaker, SPAN_NOTICE("\The [src] blinks once, then emits a croaking call of acceptance. [bird_pronouns.He] will seek out \the [mob_target]."))

/obj/item/holder/bird/crow/Initialize()
	. = ..()
	global.listening_objects += src

/obj/item/holder/bird/crow/Destroy()
	. = ..()
	global.listening_objects -= src

/obj/item/holder/bird/crow/hear_talk(mob/M, text, verb, decl/language/speaking)
	. = ..()
	for(var/mob/bird in contents)
		bird.hear_say(text, verb, speaking, null, M)

/obj/item/holder/bird/crow/attack_self(mob/user)
	var/mob/living/simple_animal/passive/bird/crow/crow = locate() in contents
	if(!istype(crow) || !crow.can_be_handled_by(user))
		return ..()
	if(!is_outside())
		to_chat(user, SPAN_WARNING("You need to be outdoors to release \the [crow]."))
		return TRUE

	var/mob/target = crow.current_target?.resolve()
	if(!istype(target) || QDELETED(target))
		crow.current_target = null
	if(isnull(crow.current_target))
		var/decl/pronouns/pronouns = crow.get_pronouns()
		to_chat(user, SPAN_WARNING("\The [crow] tilts [pronouns.his] head at you in confusion. [pronouns.He] must not understand where you want [pronouns.him] to go."))
	else
		crow.current_target = null
		user.drop_from_inventory(src)
		crow.fly_to_target(user, target)
		qdel(src)
	return TRUE