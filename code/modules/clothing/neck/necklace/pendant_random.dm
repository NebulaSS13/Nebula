/obj/item/pendant/prism/random/Initialize(ml, material_key)
	material_key = list(global.random_jewellery_gem_types)
	. = ..()

/obj/item/pendant/frill/random/Initialize(ml, material_key)
	material_key = pick(global.random_jewellery_material_types)
	. = ..()

/obj/item/pendant/setting/square/random/Initialize(ml, material_key)
	decorations  = list(pick(global.random_jewellery_gem_types))
	material_key = pick(global.random_jewellery_material_types)
	. = ..()

/obj/item/pendant/setting/cross/random/Initialize(ml, material_key)
	decorations  = list(pick(global.random_jewellery_gem_types))
	material_key = pick(global.random_jewellery_material_types)
	. = ..()

/obj/item/pendant/setting/diamond/random/Initialize(ml, material_key)
	decorations  = list(pick(global.random_jewellery_gem_types))
	material_key = pick(global.random_jewellery_material_types)
	. = ..()

/obj/item/pendant/setting/ornate/random/Initialize(ml, material_key)
	decorations  = list(pick(global.random_jewellery_gem_types))
	material_key = pick(global.random_jewellery_material_types)
	. = ..()
