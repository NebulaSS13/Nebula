/decl/butchery_data/animal/ruminant
	abstract_type = /decl/butchery_data/animal/ruminant
	stomach_type  = /obj/item/food/butchery/stomach/ruminant

/decl/butchery_data/animal/ruminant/harvest_meat(mob/donor)
	var/static/list/extra_product = list(
		/obj/item/food/butchery/haunch/shoulder,
		/obj/item/food/butchery/haunch/shoulder,
		/obj/item/food/butchery/haunch/side,
		/obj/item/food/butchery/haunch/side,
		/obj/item/food/butchery/haunch,
		/obj/item/food/butchery/haunch
	)
	var/create_turf = get_turf(donor)
	for(var/product in extra_product)
		var/food = new product(create_turf, meat_material, donor, bone_material)
		LAZYADD(., food)

/decl/butchery_data/animal/ruminant/goat
	meat_name       = "chevon"
	meat_type       = /obj/item/food/butchery/meat/goat
	meat_amount     = 4
	bone_amount     = 8
	skin_material   = /decl/material/solid/organic/skin/goat
	skin_amount     = 8
	butchery_offset = list(-6, 0)

/decl/butchery_data/animal/ruminant/deer
	meat_name       = "venison"
	meat_type       = /obj/item/food/butchery/meat
	meat_amount     = 5
	bone_amount     = 9
	skin_material   = /decl/material/solid/organic/skin/deer
	skin_amount     = 9
	butchery_offset = list(-8, 0)

/decl/butchery_data/animal/ruminant/deer/buck
	// todo: drop antlers

/decl/butchery_data/animal/ruminant/cow
	meat_name     = "beef"
	meat_type     = /obj/item/food/butchery/meat/beef
	meat_amount   = 6
	bone_amount   = 10
	skin_material = /decl/material/solid/organic/skin/cow
	skin_amount   = 10

/decl/butchery_data/animal/small/fowl
	meat_name       = "fowl"
	meat_type       = /obj/item/food/butchery/meat/chicken
	meat_material   = /decl/material/solid/organic/meat/chicken
	meat_amount     = 2
	bone_amount     = 2
	skin_amount     = 2
	skin_material   = /decl/material/solid/organic/skin/feathers
	butchery_offset = list(-10, 0)

/decl/butchery_data/animal/small/fowl/chicken
	meat_name     = "chicken"

/decl/butchery_data/animal/small/fowl/goose
	meat_name     = "goose"
	meat_amount   = 6
	bone_amount   = 8
	skin_amount   = 8

/decl/butchery_data/animal/small/fowl/goose/dire/harvest_meat(mob/donor)
	. = ..()
	var/quill = new /obj/item/pen/fancy/quill(get_turf(donor))
	LAZYADD(., quill)

/decl/butchery_data/animal/small/fowl/duck
	meat_name     = "duck"

/decl/butchery_data/animal/small/fowl/chicken/chick
	meat_amount   = 1
	bone_amount   = 1
	skin_amount   = 1
