/obj/machinery/destructive_analyzer/can_deconstruct(var/obj/item/used_item)
	return !used_item.holographic && ..()

/obj/item/grenade/spawnergrenade/fake_carp
	origin_tech = @'{"materials":2,"magnets":2,"wormholes":5}'
	spawner_type = /mob/living/simple_animal/hostile/carp/holodeck/fake
	deliveryamt = 4