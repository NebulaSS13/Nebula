/obj/effect/decal/writing
	name = "graffiti"
	icon_state = "writing1"
	icon = 'icons/effects/writing.dmi'
	desc = "It looks like someone has scratched something here."
	gender = PLURAL
	blend_mode = BLEND_MULTIPLY
	color = "#000000"
	alpha = 120
	anchored = TRUE

	var/message
	var/author = "unknown"

/obj/effect/decal/writing/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(message, /obj/effect/decal/writing)
	SERIALIZE_IF_MODIFIED(author, /obj/effect/decal/writing)

// If it's old enough we start to trim down any textual information and scramble strings.
#define SERDE_MESSAGE nameof(/obj/effect/decal/writing::message)
/obj/effect/decal/writing/HandlePersistentDecay(entries_decay_at, entry_decay_weight)
	var/original_message = __deserialization_payload[SERDE_MESSAGE]
	var/decayed_message = apply_serde_message_decay(
		__deserialization_payload[SERDE_MESSAGE],
		__deserialization_payload[nameof(/obj/effect/decal::age)],
		entry_decay_weight,
		entries_decay_at
	)
	to_world_log("decayed graffifi: [original_message] -> [decayed_message]")
	__deserialization_payload[SERDE_MESSAGE] = decayed_message
#undef SERDE_MESSAGE

/obj/effect/decal/writing/Initialize(mapload, var/_age, var/_message, var/_author)

	var/turf/checking_turf = loc
	if(istype(checking_turf) && !checking_turf.can_engrave())
		return INITIALIZE_HINT_QDEL

	var/too_much_graffiti = 0
	for(var/obj/effect/decal/writing/writing in loc)
		too_much_graffiti++
		if(too_much_graffiti >= 5)
			return INITIALIZE_HINT_QDEL

	var/list/random_icon_states = get_states_in_icon(icon)
	for(var/obj/effect/decal/writing/writing in loc)
		random_icon_states -= writing.icon_state
	if(length(random_icon_states))
		icon_state = pick(random_icon_states)
	SSpersistence.track_value(src, /decl/persistence_handler/graffiti)
	. = ..(mapload)
	if(!isnull(_age))
		age = _age
	if(_message && !message)
		message = _message
	if(_author && !author)
		author = _author

/obj/effect/decal/writing/Destroy()
	SSpersistence.forget_value(src, /decl/persistence_handler/graffiti)
	. = ..()

/obj/effect/decal/writing/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..(user)
	var/processed_message = user.handle_reading_literacy(user, message)
	if(processed_message)
		. += "It reads \"[processed_message]\"."

/obj/effect/decal/writing/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_WELDER(used_item) && used_item.do_tool_interaction(TOOL_WELDER, user, src, 3 SECONDS))
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		user.visible_message(SPAN_NOTICE("\The [user] clears away some graffiti."))
		qdel(src)
		return TRUE
	else if(used_item.is_sharp() && !user.check_intent(I_FLAG_HELP)) //Check intent so you don't go insane trying to unscrew a light fixture over a graffiti
		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
			return TRUE
		var/turf/T = get_turf(src)
		if(T)
			T.try_graffiti(user, used_item)
			return TRUE
	return ..()
