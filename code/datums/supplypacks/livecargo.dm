/decl/hierarchy/supply_pack/livecargo
	name = "Live cargo"
	containertype = /obj/structure/closet/crate/hydroponics

/decl/hierarchy/supply_pack/livecargo/monkey
	name = "Inert - Monkey cubes"
	contains = list (/obj/item/box/monkeycubes)
	containertype = /obj/structure/closet/crate/freezer
	containername = "monkey crate"

/decl/hierarchy/supply_pack/livecargo/spidercubes
	name = "Inert - Spiders"
	contains = list(/obj/item/box/monkeycubes/spidercubes)
	containertype = /obj/structure/closet/crate/secure
	containername = "spiderling crate"
	contraband = 1
	security_level = null

//actual live animals
/decl/hierarchy/supply_pack/livecargo/corgi
	name = "Live - Corgi"
	contains = list(/mob/living/simple_animal/corgi)
	containertype = /obj/structure/largecrate/animal
	containername = "corgi crate"

//farm animals - useless and annoying, but potentially a good source of food. expensive because they're live animals and their produce is available cheaper
/decl/hierarchy/supply_pack/livecargo/cow
	name = "Live - Cow"
	contains = list(/mob/living/simple_animal/cow)
	containertype = /obj/structure/largecrate/animal
	containername = "cow crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/livecargo/goat
	name = "Live - Goat"
	contains = list(/mob/living/simple_animal/hostile/goat)
	containertype = /obj/structure/largecrate/animal
	containername = "goat crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/livecargo/sheep
	name = "Live - Sheep"
	contains = list(/mob/living/simple_animal/passive/sheep)
	containertype = /obj/structure/largecrate/animal
	containername = "sheep crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/livecargo/goose
	name = "Live - Goose"
	contains = list(/mob/living/simple_animal/hostile/goose)
	containertype = /obj/structure/largecrate/animal
	containername = "goose containment unit"
	access = access_hydroponics

/decl/hierarchy/supply_pack/livecargo/chicken
	name = "Live - Chicken"
	contains = list(/mob/living/simple_animal/chick = 5)
	containertype = /obj/structure/largecrate/animal
	containername = "chicken crate"
	access = access_hydroponics

/decl/hierarchy/supply_pack/livecargo/duck
	name = "Live - Duck"
	contains = list(/mob/living/simple_animal/fowl/duck = 3)
	containertype = /obj/structure/largecrate/animal
	containername = "duck crate"
	access = access_hydroponics
