var/global/list/trading_hub_names = list()

/// These trade hubs are represented by an object on the overmap.
/// To interact with them, players' vessels need to be within the same tile as the overmap object.
/datum/trade_hub/overmap
	abstract_type = /datum/trade_hub/overmap
	var/obj/effect/overmap/trade_hub/overmap_object = null

/datum/trade_hub/overmap/generic
	name = null

/datum/trade_hub/overmap/New()
	if(!name)
		name = get_new_name()
	..()

/datum/trade_hub/overmap/Destroy(force)
	if(overmap_object)
		if(overmap_object.hub_datum == src)
			overmap_object.hub_datum = null
			qdel(overmap_object)
		overmap_object = null
	return ..()

/datum/trade_hub/overmap/is_accessible_from(turf/checked_turf)
	if(istype(checked_turf))
		var/obj/effect/overmap/customer = global.overmap_sectors[num2text(checked_turf.z)]
		// Must be on the same overmap tile in order to trade.
		return customer && overmap_object && get_turf(customer) == get_turf(overmap_object)


/// Creates a random name for a trade post.
/datum/trade_hub/overmap/proc/generate_name()
	if(prob(30))
		. = pick(global.station_prefixes)
	. = trim("[.] [pick(global.station_names)]")
	. = trim("[.] [pick(global.station_suffixes)]")
	if(prob(30))
		. = trim("[.] [pick(global.greek_letters)]")
	else if(prob(30))
		. = trim("[.] [pick(global.phonetic_alphabet)]")
	if(prob(25))
		. = trim("[.] [pick(global.numbers_as_words)]")

/// Assigns a unique randomly generated name to this trade post.
/datum/trade_hub/overmap/proc/get_new_name()
	var/new_name
	while(!new_name || global.trading_hub_names[new_name])
		new_name = generate_name()
		if(!global.trading_hub_names[new_name])
			global.trading_hub_names[new_name] = TRUE
			. = new_name
			break


/obj/effect/overmap/trade_hub
	name = "trading post"
	desc = "A place of commerce."
	icon_state = "trade"
	scannable = TRUE
	requires_contact = TRUE
	instant_contact = TRUE
	var/trade_hub_datum_type = /datum/trade_hub/overmap/generic
	var/datum/trade_hub/overmap/hub_datum = null

/obj/effect/overmap/trade_hub/Initialize()
	var/hub_type = get_trade_hub_type()
	hub_datum = new hub_type
	hub_datum.overmap_object = src
	name = hub_datum.name
	return ..()

/obj/effect/overmap/trade_hub/Destroy()
	if(hub_datum)
		if(hub_datum.overmap_object == src)
			hub_datum.overmap_object = null
			qdel(hub_datum)
		hub_datum = null
	return ..()

/obj/effect/overmap/trade_hub/get_scan_data(mob/user)
	var/list/lines = list()
	lines += ..()
	if(length(hub_datum.merchants))
		lines += "Can potentially trade with the following;"
		for(var/thing in hub_datum.merchants)
			var/datum/merchant/merchant = thing
			lines += " - [merchant.origin]"

	var/result = lines.Join("<br>")
	return result


/// Determines which type to use for the trade hub datum.
/// Override for custom behavior, such as choosing a random type.
/obj/effect/overmap/trade_hub/proc/get_trade_hub_type()
	return trade_hub_datum_type
