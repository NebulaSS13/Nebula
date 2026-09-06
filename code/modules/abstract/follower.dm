// Simple obj for following another obj around (for light effects or such that need a physical reference)
/obj/abstract/follower
	anchored     = TRUE
	simulated    = FALSE
	invisibility = INVISIBILITY_ABSTRACT

/obj/abstract/follower/Initialize()
	. = ..()
	name = ""
	verbs.Cut()

/obj/abstract/follower/proc/follow_owner(atom/movable/owner)
	if(istype(owner) && !QDELETED(owner))
		set_dir(owner.dir)
		if(owner.loc)
			forceMove(owner.loc)
	else
		forceMove(null)
