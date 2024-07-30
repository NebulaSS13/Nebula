/decl/stack_recipe/textiles
	craft_stack_types     = list(
		/obj/item/stack/material/bolt,
		/obj/item/stack/material/skin
	)
	abstract_type         = /decl/stack_recipe/textiles

/decl/stack_recipe/textiles/cloak
	result_type           = /obj/item/clothing/suit/cloak/hide
	category              = "clothing"

/decl/stack_recipe/textiles/banner
	result_type           = /obj/item/banner
	category              = "furniture"

/decl/stack_recipe/textiles/sack
	result_type           = /obj/item/bag/sack
	category              = "storage"

/decl/stack_recipe/textiles/bandolier
	result_type           = /obj/item/clothing/webbing/bandolier/crafted
	category              = "storage"

/decl/stack_recipe/textiles/headband
	result_type           = /obj/item/clothing/head/headband
	category              = "clothing"


/decl/stack_recipe/textiles/leather
	abstract_type         = /decl/stack_recipe/textiles/leather
	craft_stack_types     = /obj/item/stack/material/skin
	category              = "clothing"

/decl/stack_recipe/textiles/leather/bedroll
	result_type           = /obj/item/bedroll
	category              = "bedding"

/decl/stack_recipe/textiles/leather/shoes
	result_type           = /obj/item/clothing/shoes/craftable

/decl/stack_recipe/textiles/leather/boots
	result_type           = /obj/item/clothing/shoes/craftable/boots

/decl/stack_recipe/textiles/leather/coat
	result_type           = /obj/item/clothing/suit/leathercoat

/decl/stack_recipe/textiles/leather/gloves
	result_type           = /obj/item/clothing/gloves/thick

/decl/stack_recipe/textiles/leather/sling
	result_type           = /obj/item/gun/launcher/bow/sling

/decl/stack_recipe/textiles/leather/waterskin
	result_type           = /obj/item/chems/waterskin/crafted
	required_material     = /decl/material/solid/organic/leather
	category              = null

/decl/stack_recipe/textiles/cloth
	abstract_type         = /decl/stack_recipe/textiles/cloth
	craft_stack_types     = /obj/item/stack/material/bolt
	category              = "clothing"

/decl/stack_recipe/textiles/cloth/bandana
	result_type           = /obj/item/clothing/mask/bandana/colourable

/decl/stack_recipe/textiles/cloth/gloves
	result_type           = /obj/item/clothing/gloves

/decl/stack_recipe/textiles/cloth/robe
	result_type           = /obj/item/clothing/suit/robe

/decl/stack_recipe/textiles/cloth/poncho
	result_type           = /obj/item/clothing/suit/poncho/colored

/decl/stack_recipe/textiles/cloth/bedding
	result_type           = /obj/item/bedsheet
	category              = "bedding"

/decl/stack_recipe/textiles/cloth/bandages
	result_type           = /obj/item/stack/medical/bandage/crafted
	category              = "medical"

/decl/stack_recipe/textiles/fur
	abstract_type         = /decl/stack_recipe/textiles/fur
	craft_stack_types     = /obj/item/stack/material/skin/pelt

/decl/stack_recipe/textiles/fur/bedding
	result_type           = /obj/item/bedsheet/furs
	category              = "bedding"

/decl/stack_recipe/textiles/surgical_sutures
	result_type           = /obj/item/ancient_surgery/sutures
	craft_stack_types     = list(/obj/item/stack/material/thread)
	difficulty            = MAT_VALUE_HARD_DIY
	category              = "medical"
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL

/decl/stack_recipe/textiles/rag
	result_type = /obj/item/chems/glass/rag
