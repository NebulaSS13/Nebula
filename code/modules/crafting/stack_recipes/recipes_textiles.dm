/decl/stack_recipe/textiles
	craft_stack_types          = list(
		/obj/item/stack/material/bolt,
		/obj/item/stack/material/skin
	)
	difficulty                 = null // Autoset from material difficulty
	crafting_extra_cost_factor = 1.5 // measure twice, cut once; material is lost. todo: produce scraps?
	abstract_type              = /decl/stack_recipe/textiles
	validation_material        = /decl/material/solid/organic/cloth

/decl/stack_recipe/textiles/rug
	result_type                = /obj/structure/rug/crafted
	one_per_turf               = TRUE
	on_floor                   = TRUE
	category                   = "furniture"

/decl/stack_recipe/textiles/cloak
	result_type                = /obj/item/clothing/suit/cloak/hide
	category                   = "clothing"

/decl/stack_recipe/textiles/banner
	name                       = "banner"
	result_type                = /obj/item/banner
	category                   = "furniture"
	crafting_extra_cost_factor = 1.1 // less material is lost because it's relatively simple
	difficulty                 = MAT_VALUE_NORMAL_DIY // Slightly easier than making actual clothing.

/decl/stack_recipe/textiles/banner/forked
	name                       = "banner, forked"
	result_type                = /obj/item/banner/forked

/decl/stack_recipe/textiles/banner/pointed
	name                       = "banner, pointed"
	result_type                = /obj/item/banner/pointed

/decl/stack_recipe/textiles/banner/rounded
	name                       = "banner, rounded"
	result_type                = /obj/item/banner/rounded

/decl/stack_recipe/textiles/banner/square
	name                       = "banner, square"
	result_type                = /obj/item/banner/square

/decl/stack_recipe/textiles/banner/tasselled
	name                       = "banner, tasselled"
	result_type                = /obj/item/banner/tasselled

/decl/stack_recipe/textiles/sack
	result_type                = /obj/item/bag/sack
	category                   = "storage"
	crafting_extra_cost_factor = 1.1 // less material is lost because it's relatively simple
	difficulty                 = MAT_VALUE_NORMAL_DIY // Slightly easier than making actual clothing.

/decl/stack_recipe/textiles/bandolier
	result_type           = /obj/item/clothing/webbing/bandolier/crafted
	category              = "storage"

/decl/stack_recipe/textiles/headband
	result_type           = /obj/item/clothing/head/headband
	crafting_extra_cost_factor = 1.2 // less material is lost because it's relatively simple
	category              = "clothing"


/decl/stack_recipe/textiles/leather
	abstract_type         = /decl/stack_recipe/textiles/leather
	validation_material   = /decl/material/solid/organic/leather
	craft_stack_types     = /obj/item/stack/material/skin
	category              = "clothing"

/decl/stack_recipe/textiles/leather/bedroll
	result_type           = /obj/item/bedroll
	difficulty            = MAT_VALUE_NORMAL_DIY // Slightly easier than making clothing.
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
	result_type                = /obj/item/gun/launcher/bow/sling
	crafting_extra_cost_factor = 1.1 // less material is lost because it's relatively simple
	difficulty                 = MAT_VALUE_NORMAL_DIY // Slightly easier than making clothing.

/decl/stack_recipe/textiles/leather/sack
	result_type                = /obj/item/bag/sack
	difficulty                 = MAT_VALUE_HARD_DIY

/decl/stack_recipe/textiles/leather/backpack
	result_type                = /obj/item/backpack/crafted/backpack
	difficulty                 = MAT_VALUE_VERY_HARD_DIY

/decl/stack_recipe/textiles/leather/backpack/haversack
	result_type                = /obj/item/backpack/crafted

/decl/stack_recipe/textiles/leather/waterskin
	result_type           = /obj/item/chems/glass/waterskin/crafted
	required_material     = /decl/material/solid/organic/leather
	category              = null

/decl/stack_recipe/textiles/cloth
	abstract_type         = /decl/stack_recipe/textiles/cloth
	validation_material   = /decl/material/solid/organic/cloth
	craft_stack_types     = /obj/item/stack/material/bolt
	category              = "clothing"

/decl/stack_recipe/textiles/cloth/filter
	result_type           = /obj/item/chems/filter
	difficulty            = MAT_VALUE_EASY_DIY // see above comment
	category              = "utility"

/decl/stack_recipe/textiles/cloth/bandana
	result_type           = /obj/item/clothing/mask/bandana/colourable
	difficulty            = MAT_VALUE_EASY_DIY // see above comment
	crafting_extra_cost_factor = 1 // basically just a rag

/decl/stack_recipe/textiles/cloth/gloves
	result_type           = /obj/item/clothing/gloves

/decl/stack_recipe/textiles/cloth/robe
	result_type           = /obj/item/clothing/suit/robe

/decl/stack_recipe/textiles/cloth/poncho
	result_type           = /obj/item/clothing/suit/poncho/colored

/decl/stack_recipe/textiles/cloth/bedding
	result_type                = /obj/item/bedsheet
	crafting_extra_cost_factor = 1.1 // less material is lost because it's relatively simple
	category                   = "bedding"

/decl/stack_recipe/textiles/cloth/bandages
	result_type                = /obj/item/stack/medical/bandage/crafted
	difficulty                 = MAT_VALUE_EASY_DIY
	crafting_extra_cost_factor = 1.1 // it's not that much more complicated than making a rag, but you probably want to at least tidy up the edges
	category                   = "medical"

/decl/stack_recipe/textiles/fur
	abstract_type         = /decl/stack_recipe/textiles/fur
	craft_stack_types     = /obj/item/stack/material/skin/pelt
	validation_material   = /decl/material/solid/organic/skin/fur

/decl/stack_recipe/textiles/fur/bedding
	difficulty                 = MAT_VALUE_EASY_DIY
	crafting_extra_cost_factor = 1.1 // you're basically just trimming the edges and cleaning the pelt
	result_type                = /obj/item/bedsheet/furs
	category                   = "bedding"

/decl/stack_recipe/textiles/surgical_sutures
	result_type                 = /obj/item/ancient_surgery/sutures
	craft_stack_types           = list(/obj/item/stack/material/thread)
	difficulty                  = MAT_VALUE_HARD_DIY
	crafting_extra_cost_factor  = 1 // no overall material loss, you're just prepping the thread
	category                    = "medical"
	available_to_map_tech_level = MAP_TECH_LEVEL_MEDIEVAL

/decl/stack_recipe/textiles/rag
	result_type = /obj/item/chems/rag
	crafting_extra_cost_factor = 1 // whatever you produce is going to be a rag, there's no wastage
	difficulty = MAT_VALUE_TRIVIAL_DIY
