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
		"Personal Pizza" = /obj/item/food/variable/pizza,
		"Bread" = /obj/item/food/variable/bread,
		"Pie" = /obj/item/food/variable/pie,
		"Small Cake" = /obj/item/food/variable/cake,
		"Hot Pocket" = /obj/item/food/variable/pocket,
		"Kebab" = /obj/item/food/variable/kebab,
		"Waffles" = /obj/item/food/variable/waffles,
		"Pancakes" = /obj/item/food/variable/pancakes,
		"Cookie" = /obj/item/food/variable/cookie,
		"Donut" = /obj/item/food/variable/donut,
		)