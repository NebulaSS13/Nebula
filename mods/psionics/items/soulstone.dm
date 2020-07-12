/obj/item/soulstone/disrupts_psionics()
	. = !full ? src : FALSE

/obj/item/soulstone/shatter()
	for(var/i=1 to rand(2,5))
		new /obj/item/shard(get_turf(src), MAT_NULLGLASS)
	. = ..()

/obj/item/soulstone/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(. > 0)
		. = max(0, . - rand(2,5))
		shatter()
