/obj/item/food/butchery/meat/fish
	name                           = "fillet"
	desc                           = "A fillet of fish."
	icon                           = 'icons/obj/items/butchery/fish.dmi'
	filling_color                  = "#ffdefe"
	center_of_mass                 = @'{"x":17,"y":13}'
	bitesize                       = 6
	nutriment_amt                  = 6
	nutriment_type                 = /decl/material/solid/organic/meat/fish
	material                       = /decl/material/solid/organic/meat/fish
	drying_wetness                 = 60
	dried_type                     = /obj/item/food/jerky/fish
	backyard_grilling_product      = /obj/item/food/butchery/meat/fish/grilled
	backyard_grilling_announcement = "steams gently."
	slice_path                     = /obj/item/food/sashimi
	slice_num                      = 3
	meat_name                      = "fish"
	ingredient_flags               = INGREDIENT_FLAG_MEAT | INGREDIENT_FLAG_FISH

/obj/item/food/butchery/meat/fish/get_meat_icons()
	var/static/list/meat_icons = list(
		'icons/obj/items/butchery/fish.dmi'
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
	icon                           = 'icons/obj/items/butchery/fish_grilled.dmi'
	nutriment_desc                 = list("flaky grilled fish" = 5)
	drying_wetness                 = 0
	dried_type                     = null
	backyard_grilling_product      = null
	backyard_grilling_announcement = null
	slice_path                     = null
	slice_num                      = null
	material_alteration            = MAT_FLAG_ALTERATION_NONE
	cooked_food                    = FOOD_COOKED

/obj/item/food/butchery/meat/fish/grilled/set_meat_name(new_meat_name)
	. = ..()
	SetName("grilled [name]")

/obj/item/food/butchery/meat/fish/get_meat_icons()
	var/static/list/meat_icons = list(
		'icons/obj/items/butchery/fish_grilled.dmi'
	)
	return meat_icons

/obj/item/food/butchery/meat/fish/poison
	meat_name = "space carp"

/obj/item/food/butchery/meat/fish/poison/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/carpotoxin, 6)

/obj/item/food/butchery/meat/fish/shark
	meat_name = "shark"

/obj/item/food/butchery/meat/fish/carp
	meat_name = "carp"

/obj/item/food/butchery/meat/fish/octopus
	meat_name = "tako"

/obj/item/food/butchery/meat/fish/mollusc
	name           = "meat"
	desc           = "Some slimy meat from clams or molluscs."
	meat_name      = "mollusc"
	nutriment_type = /decl/material/liquid/nutriment/slime_meat

/obj/item/food/butchery/meat/fish/mollusc/clam
	meat_name = "clam"

/obj/item/food/butchery/meat/fish/mollusc/barnacle
	meat_name = "barnacle"
