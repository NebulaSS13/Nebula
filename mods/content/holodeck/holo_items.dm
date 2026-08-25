/obj/machinery/destructive_analyzer/can_deconstruct(var/obj/item/used_item)
	if(used_item.holographic)
		return FALSE

/obj/item/grenade/spawnergrenade/fake_carp
	origin_tech = @'{"materials":2,"magnets":2,"wormholes":5}'
	spawner_type = /mob/living/simple_animal/hostile/carp/holodeck/fake
	deliveryamt = 4