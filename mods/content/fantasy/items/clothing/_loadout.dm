/decl/loadout_category/fantasy
	abstract_type = /decl/loadout_category/fantasy

/decl/loadout_category/fantasy/clothing
	name = "Clothing"

/decl/loadout_option/fantasy
	abstract_type = /decl/loadout_option/fantasy
	category = /decl/loadout_category/fantasy/clothing
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	var/list/available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/skin/feathers,
		/decl/material/solid/organic/skin/fur,
		/decl/material/solid/organic/cloth,
		/decl/material/solid/organic/cloth/wool,
		/decl/material/solid/organic/cloth/hemp,
		/decl/material/solid/organic/cloth/linen
	)

/decl/loadout_option/fantasy/get_gear_tweak_options()
	. = ..()
	if(length(available_materials))
		for(var/mat in available_materials)
			var/decl/material/mat_decl = GET_DECL(mat)
			available_materials -= mat
			available_materials[mat_decl.name] = mat
		LAZYINITLIST(.[/datum/gear_tweak/material])
		.[/datum/gear_tweak/material] = available_materials

/decl/loadout_option/fantasy/uniform
	name = "loincloth"
	path = /obj/item/clothing/pants/loincloth
	slot = slot_w_uniform_str
	uid = "gear_fantasy_loincloth"

/decl/loadout_option/fantasy/uniform/jerkin
	name = "jerkin"
	path = /obj/item/clothing/shirt/jerkin
	uid = "gear_fantasy_jerkin"

/decl/loadout_option/fantasy/uniform/tunic
	name = "tunic"
	path = /obj/item/clothing/shirt/tunic
	slot = slot_w_uniform_str
	uid = "gear_fantasy_tunic"

/decl/loadout_option/fantasy/uniform/tunic/short
	name = "tunic, short"
	path = /obj/item/clothing/shirt/tunic/short
	uid = "gear_fantasy_tunic_short"

/decl/loadout_option/fantasy/uniform/trousers
	name = "trousers"
	path = /obj/item/clothing/pants/trousers
	uid = "gear_fantasy_trousers"

/decl/loadout_option/fantasy/uniform/gown
	name = "gown"
	path = /obj/item/clothing/dress/gown
	uid = "gear_fantasy_gown"

/decl/loadout_option/fantasy/uniform/braies
	name = "braies"
	path = /obj/item/clothing/pants/trousers/braies
	uid = "gear_fantasy_braies"

/decl/loadout_option/fantasy/uniform/toga
	name = "toga"
	path = /obj/item/clothing/shirt/toga
	uid = "gear_fantasy_toga"

/decl/loadout_option/fantasy/uniform/pleated
	name = "pleated skirt selection"
	path = /obj/item/clothing/skirt/pleated
	loadout_flags = (GEAR_HAS_COLOR_SELECTION | GEAR_HAS_TYPE_SELECTION)
	uid = "gear_fantasy_skirt_pleated"

/decl/loadout_option/fantasy/uniform/gambeson
	name = "gambeson"
	path = /obj/item/clothing/shirt/gambeson
	uid = "gear_fantasy_gambeson"

/decl/loadout_option/fantasy/suit
	name = "robes"
	path = /obj/item/clothing/suit/robe
	slot = slot_wear_suit_str
	uid = "gear_fantasy_suit"

/decl/loadout_option/fantasy/suit/mantle
	name = "mantle"
	path = /obj/item/clothing/suit/mantle
	uid = "gear_fantasy_mantle"

/decl/loadout_option/fantasy/suit/cloak
	name = "cloak"
	path = /obj/item/clothing/suit/cloak/crafted // Takes material colour.
	uid = "gear_fantasy_cloak"

/decl/loadout_option/fantasy/suit/hooded_cloak
	name = "cloak, hooded"
	path = /obj/item/clothing/suit/hooded_cloak
	uid = "gear_fantasy_cloak_hooded"

/decl/loadout_option/fantasy/suit/poncho
	name = "poncho"
	path = /obj/item/clothing/suit/poncho/colored
	uid = "gear_fantasy_poncho"

/decl/loadout_option/fantasy/suit/apron
	name = "apron"
	path = /obj/item/clothing/suit/apron/colourable
	uid = "gear_fantasy_apron"

/decl/loadout_option/fantasy/mask
	name = "bandana"
	path = /obj/item/clothing/mask/bandana/colourable
	slot = slot_wear_mask_str
	uid = "gear_fantasy_bandana"

/decl/loadout_option/fantasy/head
	name = "headband"
	path = /obj/item/clothing/head/headband
	slot = slot_head_str
	uid = "gear_fantasy_headband"

/decl/loadout_option/fantasy/head/hood
	name = "hood"
	path = /obj/item/clothing/head/hood
	uid = "gear_fantasy_hood"

/decl/loadout_option/fantasy/gloves
	name = "gloves"
	slot = slot_gloves_str
	path = /obj/item/clothing/gloves
	uid = "gear_fantasy_gloves"

/decl/loadout_option/fantasy/gloves/work
	name = "work gloves"
	path = /obj/item/clothing/gloves/thick
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/cloth,
		/decl/material/solid/organic/cloth/wool,
		/decl/material/solid/organic/cloth/hemp

	)
	uid = "gear_fantasy_work_gloves"

/decl/loadout_option/fantasy/shoes
	name = "shoes"
	path = /obj/item/clothing/shoes/craftable
	slot = slot_shoes_str
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/cloth
	)
	uid = "gear_fantasy_shoes"

/decl/loadout_option/fantasy/shoes/boots
	name = "boots"
	path = /obj/item/clothing/shoes/craftable/boots
	uid = "gear_fantasy_boots"

/decl/loadout_option/fantasy/shoes/sandal
	name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = slot_shoes_str
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/wood,
		/decl/material/solid/organic/wood/mahogany,
		/decl/material/solid/organic/wood/maple,
		/decl/material/solid/organic/wood/ebony,
		/decl/material/solid/organic/wood/walnut
	)
	uid = "gear_fantasy_sandals"

/decl/loadout_option/fantasy/neck
	abstract_type = /decl/loadout_option/fantasy/neck
	slot = slot_wear_mask_str

/decl/loadout_option/fantasy/neck/prayer_beads
	name = "prayer beads"
	path = /obj/item/clothing/neck/necklace/prayer_beads
	available_materials = list(
		/decl/material/solid/organic/bone,
		/decl/material/solid/stone/marble,
		/decl/material/solid/stone/basalt,
		/decl/material/solid/organic/wood/mahogany,
		/decl/material/solid/organic/wood/ebony
	)
	uid = "gear_fantasy_prayerbeads"

/decl/loadout_category/fantasy/utility
	name = "Utility"

/decl/loadout_option/fantasy/utility
	abstract_type = /decl/loadout_option/fantasy/utility
	category = /decl/loadout_category/fantasy/utility
	available_materials = list(
		/decl/material/solid/metal/iron,
		/decl/material/solid/metal/copper,
		/decl/material/solid/metal/bronze
	)
	loadout_flags = null

/decl/loadout_option/fantasy/utility/scroll
	name = "paper scroll"
	path = /obj/item/paper/scroll
	available_materials = null
	uid = "gear_fantasy_scroll"

/decl/loadout_option/fantasy/utility/quill
	name = "quill pen"
	path = /obj/item/pen/fancy/quill
	available_materials = null
	uid = "gear_fantasy_quill"

/decl/loadout_option/fantasy/utility/striker
	name = "flint striker"
	path = /obj/item/rock/flint/striker
	available_materials = null
	loadout_flags = null
	uid = "gear_fantasy_striker"

/decl/loadout_option/fantasy/utility/knife
	name = "knife, belt"
	path = /obj/item/bladed/knife
	uid = "gear_fantasy_belt_knife"

/decl/loadout_option/fantasy/utility/knife/folding
	name = "knife, folding"
	path = /obj/item/bladed/folding
	uid = "gear_fantasy_folding_knife"

/decl/loadout_option/fantasy/utility/hand_axe
	name = "hand axe"
	path = /obj/item/tool/axe/ebony
	uid = "gear_fantasy_handaxe"

/decl/loadout_option/fantasy/utility/shovel
	name = "shovel"
	path = /obj/item/tool/shovel/one_material
	available_materials = list(
		/decl/material/solid/organic/wood,
		/decl/material/solid/organic/wood/mahogany,
		/decl/material/solid/organic/wood/maple,
		/decl/material/solid/organic/wood/ebony,
		/decl/material/solid/organic/wood/walnut
	)
	uid = "gear_fantasy_shovel"

/decl/loadout_option/fantasy/utility/bandolier
	name = "bandolier"
	path = /obj/item/clothing/webbing/bandolier/crafted
	slot = slot_w_uniform_str
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/cloth,
		/decl/material/solid/organic/cloth/wool,
		/decl/material/solid/organic/cloth/hemp
	)
	uid = "gear_fantasy_bandoler"

/decl/loadout_option/fantasy/utility/waterskin
	name = "waterskin selection"
	path = /obj/item/chems/waterskin
	available_materials = null
	apply_to_existing_if_possible = TRUE // overwrite beggar knight's wineskin
	uid = "gear_fantasy_waterskin"

/decl/loadout_option/fantasy/utility/waterskin/get_gear_tweak_options()
	. = ..()
	LAZYDISTINCTADD(.[/datum/gear_tweak/path], list(
		"crafted leather waterskin" = /obj/item/chems/waterskin/crafted,
		"dried stomach waterskin" =   /obj/item/chems/waterskin,
	))
	LAZYDISTINCTADD(.[/datum/gear_tweak/reagents], list(
		"ale" =         /decl/material/liquid/ethanol/ale,
		"apple cider" = /decl/material/liquid/ethanol/cider_apple,
		"beer" =        /decl/material/liquid/ethanol/beer,
		"kvass" =       /decl/material/liquid/ethanol/kvass,
		"pear cider" =  /decl/material/liquid/ethanol/cider_pear,
		"red wine" =    /decl/material/liquid/ethanol/wine,
		"sake" =        /decl/material/liquid/ethanol/sake,
		"water" =       /decl/material/liquid/water,
		"white wine" =  /decl/material/liquid/ethanol/wine/premium,
	))

/decl/loadout_option/fantasy/eyes
	abstract_type = /decl/loadout_option/fantasy/eyes
	slot = slot_glasses_str
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/cloth,
		/decl/material/solid/organic/cloth/wool,
		/decl/material/solid/organic/skin/fur,
		/decl/material/solid/organic/skin/feathers,
		/decl/material/solid/organic/cloth/linen
	)

/decl/loadout_option/fantasy/eyes/eyepatch
	name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	loadout_flags = null
	uid = "gear_fantasy_eyes_eyepatch"

/decl/loadout_option/fantasy/eyes/eyepatch_colourable
	name = "eyepatch, colourable"
	path = /obj/item/clothing/glasses/eyepatch/colourable
	uid = "gear_fantasy_eyes_eyepatch_colourable"

/decl/loadout_option/fantasy/eyes/glasses
	name = "glasses selection"
	path = /obj/item/clothing/glasses/prescription/pincenez
	uid = "gear_fantasy_eyes_glasses"
	available_materials = null
	loadout_flags = null

/decl/loadout_option/fantasy/eyes/glasses/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"pince-nez glasses" =    /obj/item/clothing/glasses/prescription/pincenez,
		"monocle" =              /obj/item/clothing/glasses/eyepatch/monocle
	)