var/global/list/all_wormholes = list()

/obj/effect/portal/wormhole
	name = "wormhole"
	desc = "It looks highly unstable; It could close at any moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"

/obj/effect/portal/wormhole/Initialize()
	. = ..()
	global.all_wormholes += src

/obj/effect/portal/wormhole/Destroy()
	global.all_wormholes -= src
	return ..()

/obj/effect/portal/wormhole/setup_portal()
	return
