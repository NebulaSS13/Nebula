/obj/item/food/butchery/meat/fish
	name                           = "fillet"
	desc                           = "A fillet of fish."
	icon                           = 'icons/obj/food/butchery/fish.dmi'
	filling_color                  = "#ffdefe"
	center_of_mass                 = @'{"x":17,"y":13}'
	bitesize                       = 6
	nutriment_amt                  = 6
	nutriment_type                 = /decl/material/solid/organic/meat/fish
	material                       = /decl/material/solid/organic/meat/fish
	color                          = /decl/material/solid/organic/meat/fish::color
	drying_wetness                 = 60
	dried_type                     = /obj/item/food/jerky/fish
	backyard_grilling_product      = /obj/item/food/butchery/meat/fish/grilled
	backyard_grilling_announcement = "steams gently."
	slice_path                     = /obj/item/food/sashimi
	slice_num                      = 3
	butchery_data                  = /decl/butchery_data/animal/fish
	allergen_flags                 = ALLERGEN_FISH
	var/oil_type                   = /decl/material/liquid/oil/fish
	var/oil_amount                 = 2

/obj/item/food/butchery/meat/fish/oily
	nutriment_amt                  = 4
	oil_amount                     = 4

/obj/item/food/butchery/meat/fish/populate_reagents()
	. = ..()
	if(oil_type && oil_amount > 0)
		add_to_reagents(oil_type, oil_amount)

/obj/item/food/butchery/meat/fish/get_meat_icons()
	var/static/list/meat_icons = list(
		'icons/obj/food/butchery/fish.dmi'
	)
	return meat_icons

/obj/item/food/butchery/meat/fish/handle_utensil_cutting(obj/item/tool, mob/user)
	. = ..()
	if(islist(.) && !prob(user.skill_fail_chance(SKILL_COOKING, 100, SKILL_PROF)))
		for(var/atom/food in .)
			food.remove_from_reagents(/decl/material/liquid/carpotoxin, REAGENT_VOLUME(reagents, /decl/material/liquid/carpotoxin))

/obj/item/food/butchery/meat/fish/create_slice()
	return new slice_path(loc, material?.type, TRUE, meat_name) // pass fish name to sashimi

/obj/item/food/butchery/meat/fish/grilled
	desc                           = "A lightly grilled fish fillet."
	icon_state                     = "grilledfish"
	nutriment_amt                  = 8
	bitesize                       = 2
	icon                           = 'icons/obj/food/butchery/fish_grilled.dmi'
	nutriment_desc                 = list("flaky grilled fish" = 5)
	drying_wetness                 = 0
	dried_type                     = null
	backyard_grilling_product      = null
	backyard_grilling_announcement = null
	slice_path                     = null
	slice_num                      = 0 // null means autoset, 0 means none
	material_alteration            = MAT_FLAG_ALTERATION_NONE
	cooked_food                    = FOOD_COOKED

/obj/item/food/butchery/meat/fish/grilled/set_meat_name(new_meat_name)
	. = ..()
	SetName("grilled [name]")

/obj/item/food/butchery/meat/fish/grilled/get_meat_icons()
	var/static/list/meat_icons = list(
		'icons/obj/food/butchery/fish_grilled.dmi'
	)
	return meat_icons

/obj/item/food/butchery/meat/fish/poison
	butchery_data = /decl/butchery_data/animal/fish/space_carp

/obj/item/food/butchery/meat/fish/poison/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/carpotoxin, 6)

/obj/item/food/butchery/meat/fish/shark
	butchery_data = /decl/butchery_data/animal/fish/shark

/obj/item/food/butchery/meat/fish/carp
	butchery_data = /decl/butchery_data/animal/fish/carp

/obj/item/food/butchery/meat/fish/octopus
	butchery_data = /decl/butchery_data/animal/fish/mollusc/octopus

/obj/item/food/butchery/meat/fish/mollusc
	name           = "meat"
	desc           = "Some slimy meat from clams or molluscs."
	butchery_data  = /decl/butchery_data/animal/fish/mollusc
	nutriment_type = /decl/material/liquid/nutriment/slime_meat

/obj/item/food/butchery/meat/fish/mollusc/clam
	butchery_data  = /decl/butchery_data/animal/fish/mollusc/clam

/obj/item/food/butchery/meat/fish/mollusc/barnacle
	butchery_data  = /decl/butchery_data/animal/fish/mollusc/barnacle
