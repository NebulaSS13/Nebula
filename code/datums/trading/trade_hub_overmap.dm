var/list/trading_hub_names = list()

/obj/effect/overmap/trade_hub
	name = "trading post"
	icon_state = "trade"
	var/datum/trade_hub/overmap/hub_datum

/obj/effect/overmap/trade_hub/proc/get_trading_post_type()
	. = /datum/trade_hub/overmap

/obj/effect/overmap/trade_hub/Initialize()
	var/hub_type = get_trading_post_type()
	hub_datum = new hub_type
	hub_datum.update_hub(src)
	update_hub_datum(hub_datum)
	. = ..()

/obj/effect/overmap/trade_hub/proc/update_hub_datum(var/datum/trade_hub/overmap/hub)	
	hub.owner = src

/obj/effect/overmap/trade_hub/Destroy()
	if(hub_datum)
		if(hub_datum.owner == src)
			qdel(hub_datum)
		hub_datum = null
	. = ..()

/datum/trade_hub/overmap
	var/hub_icon
	var/hub_icon_state
	var/hub_color
	var/obj/effect/overmap/owner

/datum/trade_hub/overmap/proc/get_new_name()
	if(prob(30))
		. = pick(GLOB.station_prefixes)
	. = trim("[.] [pick(GLOB.station_names)]")
	. = trim("[.] [pick(GLOB.station_suffixes)]")
	if(prob(30))
		. = trim("[.] [pick(GLOB.greek_letters)]")
	else if(prob(30))
		. = trim("[.] [pick(GLOB.phonetic_alphabet)]")
	if(prob(25))
		. = trim("[.] [pick(GLOB.numbers_as_words)]")

/datum/trade_hub/overmap/proc/generate_name()
	var/newname
	while(!newname || global.trading_hub_names[newname])
		newname = get_new_name()
		if(!global.trading_hub_names[newname])
			global.trading_hub_names[newname] = TRUE
			. = newname
			break

/datum/trade_hub/overmap/New()
	..()
	name = generate_name()

/datum/trade_hub/overmap/Destroy(force)
	if(owner)
		var/obj/effect/overmap/trade_hub/hub = owner
		if(istype(hub) && hub.hub_datum == src)
			hub.hub_datum = null
		owner = null
	. = ..()

/datum/trade_hub/overmap/is_accessible_from(var/turf/check)
	if(istype(check))
		var/obj/effect/overmap/customer = map_sectors["[check.z]"]
		return customer && owner && get_turf(customer) == get_turf(owner)

/datum/trade_hub/overmap/proc/update_hub(var/obj/effect/overmap/trade_hub/hub)
	hub.name = name
	if(hub_icon)
		hub.icon = hub_icon
	if(hub_icon_state)
		hub.icon_state = hub_icon_state
	if(hub_color)
		hub.color = hub_color
