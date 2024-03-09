var/global/list/BUMP_TELEPORTERS = list()

/obj/effect/bump_teleporter
	name = "bump-teleporter"
	icon = 'icons/effects/markers.dmi'
	icon_state = "x2"
	invisibility = INVISIBILITY_ABSTRACT //nope, can't see this
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/id = null                        //id of this bump_teleporter.
	var/id_target = null                 //id of bump_teleporter which this moves you to.

/obj/effect/bump_teleporter/Initialize()
	. = ..()
	BUMP_TELEPORTERS += src

/obj/effect/bump_teleporter/Destroy()
	BUMP_TELEPORTERS -= src
	return ..()

/obj/effect/bump_teleporter/Bumped(atom/user)
	if(!ismob(user))
		return

	if(!id_target)
		return

	for(var/obj/effect/bump_teleporter/BT in BUMP_TELEPORTERS)
		if(BT.id == src.id_target)
			usr.forceMove(BT.loc)	//Teleport to location with correct id.
			return