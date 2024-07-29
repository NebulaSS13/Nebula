/obj/machinery/cooker/candy
	name = "candy machine"
	desc = "Get yer candied cheese wheels here!"
	icon_state = "mixer_off"
	off_icon = "mixer_off"
	on_icon = "mixer_on"
	cook_type = "candied"

	output_options = list(
		"Jawbreaker" = /obj/item/food/variable/jawbreaker,
		"Candy Bar" = /obj/item/food/variable/candybar,
		"Sucker" = /obj/item/food/variable/sucker,
		"Jelly" = /obj/item/food/variable/jelly
		)

/obj/machinery/cooker/candy/change_product_appearance(var/obj/item/food/product)
	food_color = get_random_colour(1)
	. = ..()
