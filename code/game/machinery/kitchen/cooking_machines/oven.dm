/obj/machinery/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven_off"
	on_icon = "oven_on"
	off_icon = "oven_off"
	cook_type = "baked"
	cook_time = 300
	food_color = "#a34719"
	can_burn_food = 1

	output_options = list(
		"Personal Pizza" = /obj/item/chems/food/variable/pizza,
		"Bread" = /obj/item/chems/food/variable/bread,
		"Pie" = /obj/item/chems/food/variable/pie,
		"Small Cake" = /obj/item/chems/food/variable/cake,
		"Hot Pocket" = /obj/item/chems/food/variable/pocket,
		"Kebab" = /obj/item/chems/food/variable/kebab,
		"Waffles" = /obj/item/chems/food/variable/waffles,
		"Pancakes" = /obj/item/chems/food/variable/pancakes,
		"Cookie" = /obj/item/chems/food/variable/cookie,
		"Donut" = /obj/item/chems/food/variable/donut,
		)