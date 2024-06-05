
/decl/archaeological_find/mask
	item_type = "mask"
	new_icon_state = "gasmask"
	possible_types = list(
		/obj/item/clothing/mask/gas = 4,
		/obj/item/clothing/mask/gas/poltergeist
	)

//a talking gas mask!

/obj/item/clothing/mask/gas/poltergeist
	icon = 'icons/clothing/mask/gas_mask_poltergeist.dmi'
	var/list/heard_talk = list()
	var/last_twitch = 0
	var/max_stored_messages = 100

/obj/item/clothing/mask/gas/poltergeist/Initialize()
	START_PROCESSING(SSobj, src)
	global.listening_objects += src
	. = ..()

/obj/item/clothing/mask/gas/poltergeist/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/mask/gas/poltergeist/Process()
	if(heard_talk.len && isliving(src.loc) && prob(10))
		var/mob/living/M = src.loc
		M.say(pick(heard_talk))

/obj/item/clothing/mask/gas/poltergeist/hear_talk(mob/M, text)
	..()
	if(heard_talk.len > max_stored_messages)
		heard_talk.Remove(pick(heard_talk))
	heard_talk.Add(text)
	if(isliving(src.loc) && world.time - last_twitch > 50)
		last_twitch = world.time