/decl/loadout_category/storage
	name = "Storage"
	
/decl/loadout_option/storage
	category = /decl/loadout_category/storage
	slot = slot_tie_str

/decl/loadout_option/storage/webbing
	display_name = "webbing, small"
	path = /obj/item/clothing/accessory/storage
	cost = 2

/decl/loadout_option/storage/webbing_large
	display_name = "webbing, large"
	path = /obj/item/clothing/accessory/storage/webbing_large
	cost = 3

/decl/loadout_option/storage/bandolier
	display_name = "bandolier"
	path = /obj/item/clothing/accessory/storage/bandolier
	cost = 3

/decl/loadout_option/storage/waistpack
	display_name = "waist pack"
	path = /obj/item/storage/belt/waistpack
	slot = slot_belt_str
	cost = 2
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/storage/waistpack/big
	display_name = "large waist pack"
	path = /obj/item/storage/belt/waistpack/big
	cost = 4

/decl/loadout_option/accessory/wallet
	display_name = "wallet, colour select"
	path = /obj/item/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/storage/wallet/poly
	cost = 2