/decl/stack_recipe/textiles
	craft_stack_types     = list(
		/obj/item/stack/material/bolt,
		/obj/item/stack/material/skin
	)
	abstract_type         = /decl/stack_recipe/textiles

/decl/stack_recipe/textiles/cloak
	result_type           = /obj/item/clothing/accessory/cloak/hide

/decl/stack_recipe/textiles/banner
	result_type           = /obj/item/banner

/decl/stack_recipe/textiles/shoes
	result_type           = /obj/item/clothing/shoes/craftable

/decl/stack_recipe/textiles/boots
	result_type           = /obj/item/clothing/shoes/craftable/boots

/decl/stack_recipe/textiles/gloves
	result_type           = /obj/item/clothing/gloves

/decl/stack_recipe/textiles/leather
	abstract_type         = /decl/stack_recipe/textiles/leather
	required_material     = /decl/material/solid/organic/leather

/decl/stack_recipe/textiles/leather/whip
	result_type           = /obj/item/whip

/decl/stack_recipe/textiles/leather/gloves
	result_type           = /obj/item/clothing/gloves/thick
