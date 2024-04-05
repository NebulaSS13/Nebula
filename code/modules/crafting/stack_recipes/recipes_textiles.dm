/decl/stack_recipe/textiles
	craft_stack_types = list(
		/obj/item/stack/material/bolt,
		/obj/item/stack/material/skin
	)
	abstract_type     = /decl/stack_recipe/textiles

/decl/stack_recipe/textiles/cloak
	result_type       = /obj/item/clothing/accessory/cloak/hide
	category      = "clothing"

/decl/stack_recipe/textiles/banner
	result_type       = /obj/item/banner
	category      = "furniture"

/decl/stack_recipe/textiles/leather
	abstract_type     = /decl/stack_recipe/textiles/leather
	craft_stack_types = /obj/item/stack/material/skin
	category      = "clothing"

/decl/stack_recipe/textiles/leather/shoes
	result_type       = /obj/item/clothing/shoes/craftable

/decl/stack_recipe/textiles/leather/boots
	result_type       = /obj/item/clothing/shoes/craftable/boots

/decl/stack_recipe/textiles/leather/coat
	result_type       = /obj/item/clothing/suit/leathercoat

/decl/stack_recipe/textiles/cloth
	abstract_type     = /decl/stack_recipe/textiles/cloth
	craft_stack_types = /obj/item/stack/material/bolt

/decl/stack_recipe/textiles/cloth/bandana
	result_type       = /obj/item/clothing/mask/bandana/colourable

/decl/stack_recipe/textiles/cloth/gloves
	result_type       = /obj/item/clothing/gloves/color/white

/decl/stack_recipe/textiles/cloth/robe
	result_type       = /obj/item/clothing/suit/robe

/decl/stack_recipe/textiles/cloth/poncho
	result_type       = /obj/item/clothing/suit/poncho/colored
