var/global/list/latejoin_locations =         list()
var/global/list/latejoin_cryo_locations =    list()
var/global/list/latejoin_cyborg_locations =  list()
var/global/list/latejoin_gateway_locations = list()

/obj/effect/landmark/latejoin
	delete_me = TRUE

/obj/effect/landmark/latejoin/Initialize()
	add_loc()
	. = ..()

/obj/effect/landmark/latejoin/proc/add_loc()
	global.latejoin_locations |= get_turf(src)

/obj/effect/landmark/latejoin/gateway/add_loc()
	global.latejoin_gateway_locations |= get_turf(src)

/obj/effect/landmark/latejoin/cryo/add_loc()
	global.latejoin_cryo_locations |= get_turf(src)

/obj/effect/landmark/latejoin/cyborg/add_loc()
	global.latejoin_cyborg_locations |= get_turf(src)
