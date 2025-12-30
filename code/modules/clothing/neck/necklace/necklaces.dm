// Subtypes for mapping etc.
/obj/item/clothing/neck/necklace/locket
	pendant = /obj/item/pendant/locket

/obj/item/clothing/neck/necklace/random/Initialize(ml, material_key)
	material_key = pick(global.random_jewellery_material_types)
	pendant      = pick(list(
		/obj/item/pendant/setting/cross/random,
		/obj/item/pendant/setting/square/random,
		/obj/item/pendant/setting/diamond/random,
		/obj/item/pendant/setting/ornate/random,
		/obj/item/pendant/prism/random,
		/obj/item/pendant/frill/random
	))
	return ..()
