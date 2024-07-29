/obj/item/food/processed_grown
	abstract_type     = /obj/item/food/processed_grown
	is_spawnable_type = FALSE
	icon_state        = ICON_STATE_WORLD
	w_class           = ITEM_SIZE_SMALL
	center_of_mass    = @'{"x":16,"y":16}'
	bitesize          = 2
	material          = /decl/material/solid/organic/plantmatter

	// We get these from being sliced.
	nutriment_type = null
	nutriment_amt  = 0

	/// Flag for drawing the skin/rind or not.
	var/draw_rind  = TRUE
	/// Reference to the originating seed datum we were produced from.
	var/datum/seed/seed
	/// Used in recipes to distinguish between general types.
	var/processed_grown_tag

/obj/item/food/processed_grown/Initialize(mapload, material_key, _seed)

	if(isnull(seed) && _seed)
		seed = _seed

	if(istext(seed))
		seed = SSplants.seeds[seed]

	if(!istype(seed))
		PRINT_STACK_TRACE("Processed grown initializing with null or invalid seed type '[seed || "NULL"]'")
		return INITIALIZE_HINT_QDEL

	. = ..()

	filling_color = seed.get_trait(TRAIT_PRODUCT_COLOUR) || seed.get_trait(TRAIT_FLESH_COLOUR)
	dried_type = type
	update_strings()
	update_icon()

/obj/item/food/processed_grown/get_grown_tag()
	if(!processed_grown_tag || !seed?.grown_tag)
		return
	. = dry ? "dried [seed.grown_tag] [processed_grown_tag]" : "[seed.grown_tag] [processed_grown_tag]"

/obj/item/food/processed_grown/create_slice()
	return new slice_path(loc, material?.type, seed)

/obj/item/food/processed_grown/proc/update_strings()
	return

/obj/item/food/processed_grown/on_update_icon()
	. = ..()
	if(!istype(seed))
		return
	icon_state = get_world_inventory_state()
	var/rind_colour = seed.get_trait(TRAIT_PRODUCT_COLOUR)
	color = seed.get_trait(TRAIT_FLESH_COLOUR) || rind_colour
	if(draw_rind)
		var/image/rind = image(icon, "[icon_state]-rind")
		rind.color = rind_colour || color
		rind.appearance_flags |= RESET_COLOR
		add_overlay(rind)

// Fruit slices. TODO: seed color so orange slices don't get black seeds.
/obj/item/food/processed_grown/slice
	name                = "fruit slice"
	icon                = 'icons/obj/grown/fruit_slice.dmi'
	processed_grown_tag = "slice"
	slice_path          = /obj/item/food/processed_grown/chopped
	slice_num           = 1

// Purely a visual distinction.
/obj/item/food/processed_grown/slice/large
	icon                = 'icons/obj/grown/fruit_slice_large.dmi'

/obj/item/food/processed_grown/slice/update_strings()
	name = "slice of [seed.product_name]"
	desc = "A slice of \a [seed.product_name]. Tasty, probably."

// Chopped fruit or veg
/obj/item/food/processed_grown/chopped
	name                = "chopped produce"
	icon                = 'icons/obj/grown/chopped.dmi'
	processed_grown_tag = "chopped"

/obj/item/food/processed_grown/chopped/update_strings()
	name = "chopped [seed.product_name]"
	desc = "A handful of roughly chopped [seed.product_name]."

// Matchstick veg
/obj/item/food/processed_grown/sticks
	name                = "vegetable sticks"
	icon                = 'icons/obj/grown/sticks.dmi'
	gender              = PLURAL
	draw_rind           = FALSE
	processed_grown_tag = "sticks"
	slice_path          = /obj/item/food/processed_grown/chopped
	slice_num           = 1

/obj/item/food/processed_grown/sticks/update_strings()
	name = "[seed.product_name] sticks"
	desc = "A handful of [seed.product_name] sticks."

// Crushed nuts/bulbs/flowers
/obj/item/food/processed_grown/crushed
	name                = "crushed produce"
	icon                = 'icons/obj/grown/crushed.dmi'
	gender              = PLURAL
	processed_grown_tag = "crushed"

/obj/item/food/processed_grown/crushed/update_strings()
	name = "crushed [seed.product_name]"
	desc = "A handful of crushed [seed.product_name]."

// Premade types for mapping
/obj/item/food/processed_grown/slice/apple
	seed              = "apple"
	is_spawnable_type = TRUE
	nutriment_type    = /decl/material/liquid/drink/juice/apple
	nutriment_amt     = 2

/obj/item/food/processed_grown/slice/large/watermelon
	seed              = "watermelon"
	is_spawnable_type = TRUE
	nutriment_type    = /decl/material/liquid/drink/juice/watermelon
	nutriment_amt     = 2

/obj/item/food/processed_grown/sticks/carrot
	seed              = "carrot"
	is_spawnable_type = TRUE
	nutriment_type    = /decl/material/liquid/drink/juice/carrot
	nutriment_amt     = 2

/obj/item/food/processed_grown/sticks/potato
	seed              = "potato"
	is_spawnable_type = TRUE
	nutriment_type    = /decl/material/liquid/drink/juice/potato
	nutriment_amt     = 2

/obj/item/food/processed_grown/chopped/soy
	seed              = "soybeans"
	is_spawnable_type = TRUE
	nutriment_type    = /decl/material/liquid/drink/milk/soymilk
	nutriment_amt     = 2

/obj/item/food/processed_grown/crushed/garlic
	seed              = "garlic"
	is_spawnable_type = TRUE
	nutriment_type    = /decl/material/liquid/drink/juice/garlic
	nutriment_amt     = 2
