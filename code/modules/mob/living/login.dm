
/mob/living/Login()
	. = ..()
	//login during ventcrawl
	if(is_ventcrawling && istype(loc, /obj/machinery/atmospherics)) //attach us back into the pipes
		remove_ventcrawl()
		add_ventcrawl(loc)
	//Mind updates
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the mind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)

	// Clear our cosmetic/sound weather cooldowns.
	var/obj/abstract/weather_system/weather = get_affecting_weather()

	var/mob_ref = weakref(src)
	if(istype(weather))
		weather.mob_shown_weather -= mob_ref
		weather.mob_shown_wind    -= mob_ref
	global.current_mob_ambience   -= mob_ref

	// Update our equipped item presence.
	for(var/slot in (get_inventory_slots()|get_held_item_slots()))
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(slot)
		var/obj/item/held = inv_slot?.get_equipped_item()
		if(held)
			held.reconsider_client_screen_presence(client, slot)

	var/datum/extension/abilities/abilities = get_extension(src, /datum/extension/abilities)
	abilities?.refresh_login()
