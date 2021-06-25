/decl/recipe/pizzamargherita
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/margherita

/decl/recipe/meatpizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/meatpizza

/decl/recipe/syntipizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/chems/food/snacks/meat/syntiflesh,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/meatpizza

/decl/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/chems/food/snacks/sliceable/pizza/mushroompizza

/decl/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza

/decl/recipe/pineapplepizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/pineapple_ring,
		/obj/item/chems/food/snacks/pineapple_ring
	)
	result = /obj/item/chems/food/snacks/sliceable/pizza/pineapple

/decl/recipe/bacon_flatbread
	appliance = OVEN
	fruit = list("tomato" = 2)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/bacon,
		/obj/item/chems/food/snacks/bacon,
		/obj/item/chems/food/snacks/bacon,
		/obj/item/chems/food/snacks/bacon
	)
	result = /obj/item/chems/food/snacks/bacon_flatbread

/decl/recipe/soywafers
	appliance = OVEN
	fruit = list("soybeans" = 1)
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/chems/food/snacks/soywafers

/decl/recipe/berryclafoutis
	appliance = OVEN
	fruit = list("berries" = 1)
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough
	)
	result = /obj/item/chems/food/snacks/berryclafoutis

/decl/recipe/loadedbakedpotato
	appliance = OVEN
	fruit = list("potato" = 1)
	items = list(/obj/item/chems/food/snacks/cheesewedge)
	result = /obj/item/chems/food/snacks/loadedbakedpotato

/decl/recipe/ribplate //Putting this here for not seeing a roast section.
	appliance = OVEN
	reagents = list(/decl/material/liquid/nutriment/honey = 5, /decl/material/solid/spacespice = 2, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/chems/food/snacks/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/chems/food/snacks/ribplate

/decl/recipe/eggplantparm
	appliance = OVEN
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/chems/food/snacks/cheesewedge,
		/obj/item/chems/food/snacks/cheesewedge
		)
	result = /obj/item/chems/food/snacks/eggplantparm

/decl/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/sliceable/flatdough,
		/obj/item/chems/food/snacks/meatball,
		/obj/item/chems/food/snacks/cheesewedge
	)
	result = /obj/item/chems/food/snacks/meat_pocket
	result_quantity = 2

/decl/recipe/donkpocket
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/meatball
	)
	result = /obj/item/chems/food/snacks/donkpocket //does it make sense for newly made donk to come out cold? no, do I care? coincidentally, also no.

/decl/recipe/plumphelmetbiscuit
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/material/liquid/water = 5, /decl/material/liquid/nutriment/flour = 5)
	result = /obj/item/chems/food/snacks/plumphelmetbiscuit

/decl/recipe/spacylibertyduff
	appliance = OVEN
	reagents = list(/decl/material/liquid/water = 5, /decl/material/solid/alcohol/vodka = 5, /decl/material/solid/psilocybin = 5)
	result = /obj/item/chems/food/snacks/spacylibertyduff

/decl/recipe/hotdiggitydonk //heated donk, in lieu of a microwave
	appliance = OVEN
	items = list(
		/obj/item/chems/food/snacks/donkpocket
	)
	result = /obj/item/chems/food/snacks/donkpocket/warm

/decl/recipe/rofflewaffles
	appliance = OVEN
	reagents = list(/decl/material/solid/psilocybin = 5, /decl/material/solid/sugar = 10)
	items = list(
		/obj/item/chems/food/snacks/dough,
		/obj/item/chems/food/snacks/dough
	)
	result = /obj/item/chems/food/snacks/rofflewaffles
