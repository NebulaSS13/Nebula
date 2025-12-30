/*
	Mining and plant bags, can store a ridiculous number of items in order to deal with the ridiculous amount of ores or plant products
	that can be produced by mining or (xeno)botany, however it can only hold those items.

	These storages typically should also support quick gather and quick empty to make managing large numbers of items easier.
*/

// -----------------------------
//        Mining Satchel
// -----------------------------

/obj/item/ore
	name = "mining satchel"
	desc = "This sturdy bag can be used to store and transport ores."
	icon = 'icons/obj/items/mining_satchel.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_LARGE
	storage = /datum/storage/ore
	material = /decl/material/solid/organic/leather


// -----------------------------
//          Evidence bag
// -----------------------------
/obj/item/evidence
	name = "evidence case"
	desc = "A heavy steel case for storing evidence."
	icon = 'icons/obj/items/storage/crime_kit.dmi'
	icon_state = ICON_STATE_WORLD
	storage = /datum/storage/evidence
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/stainlesssteel
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT)

// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/plants
	name = "botanical satchel"
	desc = "This bag can be used to store all kinds of plant products and botanical specimen."
	icon = 'icons/obj/hydroponics/hydroponics_machines.dmi'
	icon_state = "plantbag"
	slot_flags = SLOT_LOWER_BODY
	storage = /datum/storage/plants
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/organic/leather


// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu
// This is old and terrible

/obj/item/sheetsnatcher
	name = "sheet snatcher"
	icon = 'icons/obj/items/sheet_snatcher.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A patented storage system designed for any kind of mineral sheet."
	material = /decl/material/solid/organic/plastic
	storage = /datum/storage/sheets
	w_class = ITEM_SIZE_NORMAL

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/sheetsnatcher/borg
	name = "sheet snatcher 9000"
	desc = ""
	storage = /datum/storage/sheets/robot
