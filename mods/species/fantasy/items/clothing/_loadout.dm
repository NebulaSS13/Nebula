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
		var/list/mat_options = list()
		for(var/mat in available_materials)
			var/decl/material/mat_decl = GET_DECL(mat)
			mat_options[mat_decl.name] = mat
		LAZYINITLIST(.[/datum/gear_tweak/material])
		.[/datum/gear_tweak/material] = mat_options

/decl/loadout_option/fantasy/uniform
	name = "loincloth"
	path = /obj/item/clothing/pants/loincloth
	slot = slot_w_uniform_str

/decl/loadout_option/fantasy/uniform/jerkin
	name = "jerkin"
	path = /obj/item/clothing/shirt/jerkin
	slot = slot_tie_str

/decl/loadout_option/fantasy/uniform/tunic
	name = "tunic"
	path = /obj/item/clothing/shirt/tunic
	slot = slot_tie_str

/decl/loadout_option/fantasy/uniform/tunic/short
	name = "tunic, short"
	path = /obj/item/clothing/shirt/tunic/short

/decl/loadout_option/fantasy/uniform/trousers
	name = "trousers"
	path = /obj/item/clothing/pants/trousers

/decl/loadout_option/fantasy/uniform/gown
	name = "gown"
	path = /obj/item/clothing/under/gown

/decl/loadout_option/fantasy/uniform/braies
	name = "braies"
	path = /obj/item/clothing/pants/trousers/braies

/decl/loadout_option/fantasy/suit
	name = "robes"
	path = /obj/item/clothing/suit/robe
	slot = slot_wear_suit_str

/decl/loadout_option/fantasy/suit/cloak
	name = "cloak"
	path = /obj/item/clothing/suit/cloak

/decl/loadout_option/fantasy/suit/poncho
	name = "poncho"
	path = /obj/item/clothing/suit/poncho/colored

/decl/loadout_option/fantasy/suit/apron
	name = "apron"
	path = /obj/item/clothing/suit/apron/colourable

/decl/loadout_option/fantasy/mask
	name = "bandana"
	path = /obj/item/clothing/mask/bandana/colourable
	slot = slot_wear_mask_str

/decl/loadout_option/fantasy/head
	name = "headband"
	path = /obj/item/clothing/head/headband
	slot = slot_head_str

/decl/loadout_option/fantasy/head/hood
	name = "hood"
	path = /obj/item/clothing/head/hood

/decl/loadout_option/fantasy/gloves
	name = "gloves"
	slot = slot_gloves_str
	path = /obj/item/clothing/gloves

/decl/loadout_option/fantasy/gloves/work
	name = "work gloves"
	path = /obj/item/clothing/gloves/thick
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/cloth
	)

/decl/loadout_option/fantasy/shoes
	name = "shoes"
	path = /obj/item/clothing/shoes/craftable
	slot = slot_shoes_str
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/cloth
	)

/decl/loadout_option/fantasy/shoes/boots
	name = "boots"
	path = /obj/item/clothing/shoes/craftable/boots

/decl/loadout_option/fantasy/shoes/sandal
	name = "sandals"
	slot = slot_shoes_str
	available_materials = list(
		/decl/material/solid/organic/leather,
		/decl/material/solid/organic/wood,
		/decl/material/solid/organic/wood/mahogany,
		/decl/material/solid/organic/wood/maple,
		/decl/material/solid/organic/wood/ebony,
		/decl/material/solid/organic/wood/walnut
	)

/decl/loadout_category/fantasy/utility
	name = "Utility"

/decl/loadout_option/fantasy/utility
	abstract_type = /decl/loadout_option/fantasy/utility
	category = /decl/loadout_category/fantasy/utility

/decl/loadout_option/fantasy/utility/striker
	name = "flint striker"
	path = /obj/item/rock/flint
	available_materials = null

/decl/loadout_option/fantasy/utility/knife
	name = "knife, belt"
	path = /obj/item/bladed/knife
	available_materials = list(
		/decl/material/solid/metal/iron,
		/decl/material/solid/metal/copper,
		/decl/material/solid/metal/bronze
	)

/decl/loadout_option/fantasy/utility/knife/folding
	name = "knife, folding"
	path = /obj/item/bladed/folding
