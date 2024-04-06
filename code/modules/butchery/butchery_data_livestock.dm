/decl/butchery_data/animal/ruminant
	abstract_type = /decl/butchery_data/animal/ruminant
	stomach_type  = /obj/item/chems/food/butchery/stomach/ruminant

/decl/butchery_data/animal/ruminant/harvest_meat(mob/donor)
	var/static/list/extra_product = list(
		/obj/item/chems/food/butchery/haunch/shoulder,
		/obj/item/chems/food/butchery/haunch/shoulder,
		/obj/item/chems/food/butchery/haunch/side,
		/obj/item/chems/food/butchery/haunch/side,
		/obj/item/chems/food/butchery/haunch,
		/obj/item/chems/food/butchery/haunch
	)
	var/create_turf = get_turf(donor)
	for(var/product in extra_product)
		var/food = new product(create_turf, meat_material, donor, bone_material)
		LAZYADD(., food)

/decl/butchery_data/animal/ruminant/goat
	meat_type     = /obj/item/chems/food/butchery/meat/goat
	meat_amount   = 4
	bone_amount   = 8
	skin_material = /decl/material/solid/organic/skin/goat
	skin_amount   = 8

/decl/butchery_data/animal/ruminant/cow
	meat_type     = /obj/item/chems/food/butchery/meat/beef
	meat_amount   = 6
	bone_amount   = 10
	skin_material = /decl/material/solid/organic/skin/cow
	skin_amount   = 10

/decl/butchery_data/animal/small/fowl
	meat_type     = /obj/item/chems/food/butchery/meat/chicken
	meat_material = /decl/material/solid/organic/meat/chicken
	meat_amount   = 2
	bone_amount   = 2
	skin_amount   = 2
	skin_material = /decl/material/solid/organic/skin/feathers

/decl/butchery_data/animal/small/fowl/chick
	meat_type     = /obj/item/chems/food/butchery/meat/chicken
	meat_amount   = 1
	bone_amount   = 1
	skin_amount   = 1
	skin_material = /decl/material/solid/organic/skin/feathers
