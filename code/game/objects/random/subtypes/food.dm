/obj/random/single/cola
	name = "randomly spawned cola"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "cola"
	spawn_object = /obj/item/chems/drinks/cans/cola

/obj/random/mre
	name = "random MRE"
	desc = "This is a random single MRE."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"

/obj/random/mre/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/mre,
		/obj/item/mre/menu2,
		/obj/item/mre/menu3,
		/obj/item/mre/menu4,
		/obj/item/mre/menu5,
		/obj/item/mre/menu6,
		/obj/item/mre/menu7,
		/obj/item/mre/menu8,
		/obj/item/mre/menu9,
		/obj/item/mre/menu10
	)
	return spawnable_choices

/obj/random/mre/main
	name = "random MRE main course"
	desc = "This is a random main course for MREs."
	icon_state = "pouch_medium"

/obj/random/mre/main/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/mrebag,
		/obj/item/mrebag/menu2,
		/obj/item/mrebag/menu3,
		/obj/item/mrebag/menu4,
		/obj/item/mrebag/menu5,
		/obj/item/mrebag/menu6,
		/obj/item/mrebag/menu7,
		/obj/item/mrebag/menu8
	)
	return spawnable_choices

/obj/random/mre/dessert
	name = "random MRE dessert"
	desc = "This is a random dessert for MREs."
	icon_state = "pouch_medium"

/obj/random/mre/dessert/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/food/candy,
		/obj/item/food/candy/proteinbar,
		/obj/item/food/donut,
		/obj/item/food/donut/jelly,
		/obj/item/food/chocolatebar,
		/obj/item/food/cookie,
		/obj/item/food/poppypretzel,
		/obj/item/clothing/mask/chewable/candy/gum
	)
	return spawnable_choices

/obj/random/mre/dessert/vegan
	name = "random vegan MRE dessert"
	desc = "This is a random vegan dessert for MREs."

/obj/random/mre/dessert/vegan/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/food/candy,
		/obj/item/food/chocolatebar,
		/obj/item/food/donut/jelly,
		/obj/item/food/plumphelmetbiscuit
	)
	return spawnable_choices

/obj/random/mre/drink
	name = "random MRE drink"
	desc = "This is a random drink for MREs."
	icon_state = "packet_small"

/obj/random/mre/drink/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/condiment/small/packet/coffee,
		/obj/item/chems/condiment/small/packet/tea,
		/obj/item/chems/condiment/small/packet/cocoa,
		/obj/item/chems/condiment/small/packet/grape,
		/obj/item/chems/condiment/small/packet/orange,
		/obj/item/chems/condiment/small/packet/watermelon,
		/obj/item/chems/condiment/small/packet/apple
	)
	return spawnable_choices

/obj/random/mre/spread
	name = "random MRE spread"
	desc = "This is a random spread packet for MREs."
	icon_state = "packet_small"

/obj/random/mre/spread/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/condiment/small/packet/jelly,
		/obj/item/chems/condiment/small/packet/honey
	)
	return spawnable_choices

/obj/random/mre/spread/vegan
	name = "random vegan MRE spread"
	desc = "This is a random vegan spread packet for MREs"

/obj/random/mre/spread/vegan/spawn_choices()
	var/static/list/spawnable_choices = list(/obj/item/chems/condiment/small/packet/jelly)
	return spawnable_choices

/obj/random/mre/sauce
	name = "random MRE sauce"
	desc = "This is a random sauce packet for MREs."
	icon_state = "packet_small"

/obj/random/mre/sauce/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/condiment/small/packet/salt,
		/obj/item/chems/condiment/small/packet/pepper,
		/obj/item/chems/condiment/small/packet/sugar,
		/obj/item/chems/condiment/small/packet/capsaicin,
		/obj/item/chems/condiment/small/packet/ketchup,
		/obj/item/chems/condiment/small/packet/mayo,
		/obj/item/chems/condiment/small/packet/soy
	)
	return spawnable_choices

/obj/random/mre/sauce/vegan/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/condiment/small/packet/salt,
		/obj/item/chems/condiment/small/packet/pepper,
		/obj/item/chems/condiment/small/packet/sugar,
		/obj/item/chems/condiment/small/packet/soy
	)
	return spawnable_choices

/obj/random/mre/sauce/sugarfree/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/condiment/small/packet/salt,
		/obj/item/chems/condiment/small/packet/pepper,
		/obj/item/chems/condiment/small/packet/capsaicin,
		/obj/item/chems/condiment/small/packet/ketchup,
		/obj/item/chems/condiment/small/packet/mayo,
		/obj/item/chems/condiment/small/packet/soy
	)
	return spawnable_choices

/obj/random/mre/sauce/crayon/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/condiment/small/packet/crayon,
		/obj/item/chems/condiment/small/packet/crayon/red,
		/obj/item/chems/condiment/small/packet/crayon/orange,
		/obj/item/chems/condiment/small/packet/crayon/yellow,
		/obj/item/chems/condiment/small/packet/crayon/green,
		/obj/item/chems/condiment/small/packet/crayon/blue,
		/obj/item/chems/condiment/small/packet/crayon/purple,
		/obj/item/chems/condiment/small/packet/crayon/grey,
		/obj/item/chems/condiment/small/packet/crayon/brown
	)
	return spawnable_choices

/obj/random/snack
	name = "random snack"
	desc = "This is a random snack item."
	icon = 'icons/obj/food.dmi'
	icon_state = "sosjerky"

/obj/random/snack/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/food/liquidfood,
		/obj/item/food/candy,
		/obj/item/chems/drinks/dry_ramen,
		/obj/item/food/chips,
		/obj/item/food/sosjerky,
		/obj/item/food/no_raisin,
		/obj/item/food/spacetwinkie,
		/obj/item/food/cheesiehonkers,
		/obj/item/food/tastybread,
		/obj/item/food/candy/proteinbar,
		/obj/item/food/syndicake,
		/obj/item/food/donut,
		/obj/item/food/donut/jelly,
		/obj/item/pizzabox/meat,
		/obj/item/pizzabox/vegetable,
		/obj/item/pizzabox/margherita,
		/obj/item/pizzabox/mushroom,
		/obj/item/food/plumphelmetbiscuit
	)
	return spawnable_choices
