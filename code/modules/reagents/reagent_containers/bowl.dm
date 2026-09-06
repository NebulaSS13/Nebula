/obj/item/chems/glass/bowl
	name                          = "bowl"
	desc                          = "A moderately-sized bowl, suitable for serving soup or other soft or liquid foods."
	material                      = /decl/material/solid/stone/ceramic
	icon                          = 'icons/obj/food/plates/bowl.dmi'
	icon_state                    = ICON_STATE_WORLD
	material_alteration           = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	presentation_flags            = PRESENTATION_FLAG_NAME
	chem_volume                   = 30
	amount_per_transfer_from_this = 5

/obj/item/chems/glass/bowl/can_lid()
	return FALSE

// Predefined soup types for mapping.
/obj/item/chems/glass/bowl/mapped
	abstract_type = /obj/item/chems/glass/bowl/mapped
	var/initial_reagent_amount = 20
	var/initial_reagent_type   = /decl/material/liquid/nutriment/soup/simple

/obj/item/chems/glass/bowl/mapped/proc/get_initial_reagent_data()
	return

/obj/item/chems/glass/bowl/mapped/populate_reagents()
	. = ..()
	if(initial_reagent_type)
		add_to_reagents(initial_reagent_type, initial_reagent_amount, get_initial_reagent_data())

/obj/item/chems/glass/bowl/mapped/vegetable/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("carrot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2),
		DATA_INGREDIENT_LIST  = list("carrot" = 1, "corn" = 1, "eggplant" = 1, "potato" = 1),
		DATA_INGREDIENT_FLAGS = ALLERGEN_VEGETABLE,
		DATA_MASK_NAME        = "vegetable soup",
		DATA_MASK_COLOR       = "#afc4b5"
	)

/obj/item/chems/glass/bowl/mapped/beet/get_initial_reagent_data()
	. = list(
		DATA_TASTE            = list("whitebeet" = 1, "cabbage" = 1),
		DATA_INGREDIENT_LIST  = list("whitebeet" = 1, "cabbage" = 1),
		DATA_INGREDIENT_FLAGS = ALLERGEN_VEGETABLE,
		DATA_MASK_NAME        = pick("borsch","bortsch","borstch","borsh","borshch","borscht"),
		DATA_MASK_COLOR       = "#fac9ff"
	)

/obj/item/chems/glass/bowl/mapped/tomato/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("tomato" = 1),
		DATA_INGREDIENT_LIST  = list("tomato" = 1),
		DATA_INGREDIENT_FLAGS = ALLERGEN_VEGETABLE,
		DATA_MASK_COLOR       = "#ff0000"
	)

/obj/item/chems/glass/bowl/mapped/mushroom/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("creamy mushroom" = 1),
		DATA_INGREDIENT_LIST  = list("mushroom" = 1, "milk" = 1),
		DATA_INGREDIENT_FLAGS = (ALLERGEN_VEGETABLE | ALLERGEN_DAIRY),
		DATA_MASK_NAME        = "mushroom soup",
		DATA_MASK_COLOR       = "#e386bf"
	)

/obj/item/chems/glass/bowl/mapped/blood/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("iron" = 1, "copper" = 1),
		DATA_INGREDIENT_LIST  = list("blood" = 1),
		DATA_INGREDIENT_FLAGS = ALLERGEN_MEAT,
		DATA_MASK_NAME        = "tomato soup",
		DATA_MASK_COLOR       = "#ff0000"
	)

/obj/item/chems/glass/bowl/mapped/nettle/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("sharp acid" = 1, "nettles" = 1, "potato chunks" = 1),
		DATA_INGREDIENT_LIST  = list("nettle" = 1, "potato" = 1),
		DATA_INGREDIENT_FLAGS = ALLERGEN_VEGETABLE,
		DATA_MASK_COLOR       = "#afc4b5"
	)

/obj/item/chems/glass/bowl/mapped/meatball/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("savoury meatballs" = 2, "cooked carrot" = 1, "cooked potato" = 1),
		DATA_INGREDIENT_LIST  = list("meatball" = 1, "carrot" = 1, "potato" = 1),
		DATA_INGREDIENT_FLAGS = (ALLERGEN_VEGETABLE | ALLERGEN_MEAT),
		DATA_MASK_COLOR       = "#785210"
	)

/obj/item/chems/glass/bowl/mapped/stew
	initial_reagent_type = /decl/material/liquid/nutriment/soup/stew

/obj/item/chems/glass/bowl/mapped/stew/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("savoury meat" = 2, "stewed carrot" = 1, "stewed potato" = 1, "stewed tomato" = 1, "stewed eggplant" = 1, "stewed mushroom" = 1),
		DATA_INGREDIENT_LIST  = list("meat" = 1, "tomato" = 1, "carrot" = 1, "potato" = 1, "eggplant" = 1, "mushroom" = 1),
		DATA_INGREDIENT_FLAGS = (ALLERGEN_VEGETABLE | ALLERGEN_MEAT),
		DATA_MASK_NAME        = "hearty stew",
		DATA_MASK_COLOR       = "#9e673a"
	)

/obj/item/chems/glass/bowl/mapped/chili
	abstract_type = /obj/item/chems/glass/bowl/mapped/chili
	initial_reagent_type = /decl/material/liquid/nutriment/soup/chili

/obj/item/chems/glass/bowl/mapped/chili/hot/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("chilli peppers" = 1, "burning" = 1, "spicy meat" = 2, "tomato" = 1),
		DATA_INGREDIENT_LIST  = list("meat" = 1, "tomato" = 1, "chili" = 1),
		DATA_INGREDIENT_FLAGS = (ALLERGEN_VEGETABLE | ALLERGEN_MEAT),
		DATA_MASK_NAME        = "hot chili",
		DATA_MASK_COLOR       = "#ff3c00"
	)

/obj/item/chems/glass/bowl/mapped/chili/cold/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("chilly peppers" = 1, "freezing" = 1, "spicy meat" = 2, "tomato" = 1),
		DATA_INGREDIENT_LIST  = list("meat" = 1, "tomato" = 1, "chili" = 1),
		DATA_INGREDIENT_FLAGS = (ALLERGEN_VEGETABLE | ALLERGEN_MEAT),
		DATA_MASK_NAME        = "cold chili",
		DATA_MASK_COLOR       = "#2b00ff"
	)

/obj/item/chems/glass/bowl/mapped/curry
	abstract_type = /obj/item/chems/glass/bowl/mapped/curry
	initial_reagent_type = /decl/material/liquid/nutriment/soup/curry

/obj/item/chems/glass/bowl/mapped/curry/katsu/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("crumbed chicken" = 1, "curried apple" = 1, "curried potato" = 1, "curried carrot" = 1),
		DATA_INGREDIENT_LIST  = list("apple" = 1, "carrot" = 1, "potato" = 1, "chicken" = 1, "rice" = 1),
		DATA_INGREDIENT_FLAGS = (ALLERGEN_VEGETABLE | ALLERGEN_MEAT),
		DATA_MASK_NAME        = "chicken katsu curry",
		DATA_MASK_COLOR       = "#faa005"
	)

/obj/item/chems/glass/bowl/mapped/noodlesoup
	abstract_type = /obj/item/chems/glass/bowl/mapped/noodlesoup
	initial_reagent_type = /decl/material/liquid/nutriment/soup/noodle

/obj/item/chems/glass/bowl/mapped/noodlesoup/chicken/get_initial_reagent_data()
	return list(
		DATA_TASTE            = list("chicken" = 1, "carrot" = 1),
		DATA_INGREDIENT_LIST  = list("chicken" = 1, "carrot" = 1),
		DATA_INGREDIENT_FLAGS = (ALLERGEN_VEGETABLE | ALLERGEN_MEAT),
	)

// Mystery soup is special/stupid.
/obj/item/chems/glass/bowl/mystery
	var/drained = FALSE

/obj/item/chems/glass/bowl/mystery/populate_reagents()
	. = ..()
	var/list/fillings = pick(get_random_fillings())
	for(var/filling in fillings)
		add_to_reagents(filling, fillings[filling])

/obj/item/chems/glass/bowl/mystery/update_name()
	if(!drained && REAGENT_TOTAL_VOLUME(reagents))
		SetName("mystery soup")
	else
		..()

/obj/item/chems/glass/bowl/mystery/on_reagent_change()
	if(REAGENT_TOTAL_VOLUME(reagents) <= 0)
		drained = TRUE
	. = ..()

/obj/item/chems/glass/bowl/mystery/update_container_desc()
	if(!drained && REAGENT_TOTAL_VOLUME(reagents))
		desc = "The mystery is, why aren't you eating it?"
	else
		..()

/obj/item/chems/glass/bowl/mystery/proc/get_random_fillings()
	return list(
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/capsaicin =           3,
			/decl/material/liquid/drink/juice/tomato =  2
		),
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/frostoil =            3,
			/decl/material/liquid/drink/juice/tomato =  2
		),
		list(
			/decl/material/liquid/nutriment =           5,
			/decl/material/liquid/water =               5,
			/decl/material/liquid/regenerator =         5
		),
		list(
			/decl/material/liquid/nutriment =           5,
			/decl/material/liquid/water =              10
		),
		list(
			/decl/material/liquid/nutriment =           2,
			/decl/material/liquid/drink/juice/banana = 10
		),
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/blood =              10
		),
		list(
			/decl/material/solid/carbon =              10,
			/decl/material/liquid/acrylamide =         10
		),
		list(
			/decl/material/liquid/nutriment =           5,
			/decl/material/liquid/drink/juice/tomato = 10
		),
		list(
			/decl/material/liquid/nutriment =           6,
			/decl/material/liquid/drink/juice/tomato =  5,
			/decl/material/liquid/eyedrops =            5
		)
	)
