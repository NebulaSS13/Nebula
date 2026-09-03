/obj/item/grenade/spawnergrenade/spider
	name = "spider delivery grenade"
	spawner_type = /mob/living/simple_animal/hostile/giant_spider/hunter
	deliveryamt = 3
	origin_tech = @'{"materials":3,"magnets":4,"esoteric":4}'

/obj/item/food/animal_cube/spider
	name = "spider cube"
	spawn_type = /obj/effect/spider/spiderling

/obj/item/food/animal_cube/wrapped/spider
	name = "spider cube"
	spawn_type = /obj/effect/spider/spiderling

/obj/item/box/animal_cubes/spiders
	name = "spiderling cube box"
	desc = "Drymate brand spider cubes. WHY WOULD YOU ORDER THIS!?"

/obj/item/box/animal_cubes/spiders/WillContain()
	return list(/obj/item/food/animal_cube/wrapped/spider = 5)

/obj/item/matter_decompiler/try_ingest(atom/thing)
	if(istype(thing,/obj/effect/spider/spiderling))
		if(wood)
			wood.add_charge(2000)
		if(plastic)
			plastic.add_charge(2000)
		return TRUE
	return ..()

/decl/hierarchy/supply_pack/livecargo/spidercubes
	name = "Inert - Spider Cubes"
	contains = list(/obj/item/box/animal_cubes/spiders)
	containertype = /obj/structure/closet/crate/secure
	containername = "spiderling crate"
	access = access_research
