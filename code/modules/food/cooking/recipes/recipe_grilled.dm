/decl/recipe/grilled
	abstract_type = /decl/recipe/grilled
	//cooking_heat_type = COOKING_HEAT_DIRECT
	container_categories = list(
		RECIPE_CATEGORY_MICROWAVE,
		RECIPE_CATEGORY_SKILLET
	)
	completion_message = "The meat sizzles as it is cooked through."

/decl/recipe/grilled/plainsteak
	items = list(/obj/item/food/butchery/meat)
	result = /obj/item/food/plainsteak

/decl/recipe/grilled/meatsteak
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/food/butchery/cutlet)
	result = /obj/item/food/meatsteak

/decl/recipe/grilled/loadedsteak
	reagents = list(/decl/material/liquid/nutriment/garlicsauce = 5)
	fruit = list("onion" = 1, "mushroom" = 1)
	items = list(/obj/item/food/butchery/cutlet)
	result = /obj/item/food/loadedsteak
	completion_message = "The onions and mushroom caramelize around the sizzling meat."

/decl/recipe/grilled/syntisteak
	reagents = list(/decl/material/solid/sodiumchloride = 1, /decl/material/solid/blackpepper = 1)
	items = list(/obj/item/food/butchery/meat/syntiflesh)
	result = /obj/item/food/meatsteak/synthetic

/decl/recipe/grilled/toastedsandwich
	items = list(
		/obj/item/food/sandwich
	)
	result = /obj/item/food/toastedsandwich
	completion_message = "The outside of the sandwich darkens to a savoury toasted brown."

/decl/recipe/grilled/grilledcheese
	items = list(
		/obj/item/food/slice/bread = 2,
		/obj/item/food/cheesewedge,
	)
	result = /obj/item/food/grilledcheese
	completion_message = "The bread toasts and the cheese melts together."

/decl/recipe/grilled/fishfingers
	reagents = list(/decl/material/liquid/nutriment/flour = 10)
	items = list(
		/obj/item/food/egg,
		/obj/item/food/butchery/meat/fish
	)
	reagent_mix = REAGENT_REPLACE // no raw egg/fish
	result = /obj/item/food/fishfingers
	completion_message = "The breading browns and fish fillets sizzle as they are cooked through."

/decl/recipe/grilled/meatball
	items = list(
		/obj/item/food/meatball/raw
	)
	result = /obj/item/food/meatball

/decl/recipe/grilled/cutlet
	items = list(
		/obj/item/food/butchery/cutlet/raw
	)
	result = /obj/item/food/butchery/cutlet

/decl/recipe/grilled/meatkabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/food/butchery/cutlet = 2
	)
	result = /obj/item/food/meatkabob

/decl/recipe/grilled/tofukabob
	items = list(
		/obj/item/stack/material/rods,
		/obj/item/food/tofu = 2,
	)
	result = /obj/item/food/tofukabob
	completion_message = "The tofu sizzles and browns as it is cooked through."
