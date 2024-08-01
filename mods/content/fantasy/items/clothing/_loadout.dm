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
		/decl/material/solid/organic/cloth
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
	path = /obj/item/clothing/suit/cloak
	uid = "gear_fantasy_cloak"

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
		/decl/material/solid/organic/cloth
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
		/decl/material/solid/organic/cloth
	)
	uid = "gear_fantasy_bandoler"
