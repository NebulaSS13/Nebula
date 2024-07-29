/decl/butchery_data/animal/arthropod
	meat_name     = "insect"
	abstract_type = /decl/butchery_data/animal/arthropod
	skin_material = /decl/material/solid/organic/skin/insect
	bone_material = null
	bone_amount   = 0
	bone_type     = null

/decl/butchery_data/animal/arthropod/crab
	meat_name     = "crab"
	meat_amount   = 3
	skin_amount   = 10
	must_use_hook = FALSE
	gut_type      = /obj/item/food/butchery/offal/small

/decl/butchery_data/animal/arthropod/crab/giant
	meat_amount   = 12
	must_use_hook = TRUE

/decl/butchery_data/animal/arthropod/giant_spider
	meat_name     = "spider"
	meat_type     = /obj/item/food/spider
	meat_amount   = 3
	skin_amount   = 5

/decl/butchery_data/animal/arthropod/giant_spider/guard
	meat_amount   = 4
