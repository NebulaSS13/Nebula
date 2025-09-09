/obj/item/grenade/smokebomb/detonate()
	. = ..()
	for(var/obj/effect/blob/B in view(8,src))
		var/damage = round(30/(get_dist(B,src)+1))
		B.current_health -= damage
		B.update_icon()

/obj/item/grenade/flashbang/on_detonate(turf/our_turf)
	var/const/BASE_DAMAGE = 30
	// Deals BASE_DAMAGE damage at 0 distance,
	// half at 1, 1/3 at 2, 1/4 at 3, and so on.
	. = ..()
	FOR_DVIEW(var/obj/effect/blob/enemy_blob, 7, our_turf, INVISIBILITY_MAXIMUM) //Blob damage here
		var/damage = round(BASE_DAMAGE/(get_dist(enemy_blob, our_turf)+1))
		enemy_blob.take_damage(damage, BURN)
	END_FOR_DVIEW