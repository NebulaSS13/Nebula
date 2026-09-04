/datum/artifact_find/New()
	var/static/supermatter_injected = FALSE
	if(!supermatter_injected)
		potential_finds[/obj/structure/supermatter] = 5
		potential_finds[/obj/structure/supermatter/shard] = 25
		supermatter_injected = TRUE
	..()
