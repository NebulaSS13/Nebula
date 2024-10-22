/obj/item/chems/glass/bowl
	name                          = "bowl"
	desc                          = "A moderately-sized bowl, suitable for serving soup or other soft or liquid foods."
	material                      = /decl/material/solid/stone/ceramic
	icon                          = 'icons/obj/food/plates/bowl.dmi'
	icon_state                    = ICON_STATE_WORLD
	material_alteration           = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	presentation_flags            = PRESENTATION_FLAG_NAME
	volume                        = 30
	amount_per_transfer_from_this = 5

// Drinking out of bowls.
/obj/item/chems/glass/bowl/attack_self(mob/user)
	if(is_edible(user) && handle_eaten_by_mob(user, user) != EATEN_INVALID)
		return TRUE
	return ..()

/obj/item/chems/glass/bowl/can_lid()
	return FALSE

/obj/item/chems/glass/bowl/get_food_default_transfer_amount(mob/eater)
	return eater?.get_eaten_transfer_amount(amount_per_transfer_from_this)

/obj/item/chems/glass/bowl/get_edible_material_amount(mob/eater)
	return reagents?.total_volume

/obj/item/chems/glass/bowl/get_food_consumption_method(mob/eater)
	return EATING_METHOD_DRINK

/obj/item/chems/glass/bowl/get_utensil_food_type()
	return /obj/item/food/lump

// Interaction code borrowed from /food.
/obj/item/chems/glass/bowl/attackby(obj/item/W, mob/living/user)

	if(istype(W, /obj/item/food))
		if(!reagents?.total_volume)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return TRUE
		var/transferring = min(get_food_default_transfer_amount(user), REAGENTS_FREE_SPACE(W.reagents))
		if(!transferring)
			to_chat(user, SPAN_WARNING("You cannot dip \the [W] in \the [src]."))
			return TRUE
		reagents.trans_to_holder(W.reagents, transferring)
		user.visible_message(SPAN_NOTICE("\The [user] dunks \the [W] in \the [src]."))
		return TRUE

	var/obj/item/utensil/utensil = W
	if(istype(utensil) && (utensil.utensil_flags & UTENSIL_FLAG_SCOOP))
		if(utensil.loaded_food)
			to_chat(user, SPAN_WARNING("You already have something on \the [utensil]."))
			return TRUE
		if(!reagents?.total_volume)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return TRUE
		seperate_food_chunk(utensil, user)
		if(utensil.loaded_food?.reagents?.total_volume)
			to_chat(user, SPAN_NOTICE("You scoop up some of \the [utensil.loaded_food.reagents.get_primary_reagent_name()] with \the [utensil]."))
		return TRUE

	return ..()

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

// Mystery soup is special/stupid.
/obj/item/chems/glass/bowl/mystery
	var/drained = FALSE

/obj/item/chems/glass/bowl/mystery/populate_reagents()
	. = ..()
	var/list/fillings = pick(get_random_fillings())
	for(var/filling in fillings)
		add_to_reagents(filling, fillings[filling])

/obj/item/chems/glass/bowl/mystery/update_name()
	if(!drained && reagents?.total_volume)
		SetName("mystery soup")
	else
		..()

/obj/item/chems/glass/bowl/mystery/on_reagent_change()
	if(reagents?.total_volume <= 0)
		drained = TRUE
	. = ..()

/obj/item/chems/glass/bowl/mystery/update_container_desc()
	if(!drained && reagents?.total_volume)
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
