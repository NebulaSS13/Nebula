/obj/random/single/cola
	name = "randomly spawned cola"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "cola"
	spawn_object = /obj/item/chems/drinks/cans/cola

/obj/random/mre
	name = "random MRE"
	desc = "This is a random single MRE."
	icon = 'icons/obj/food/mre/mre_generic.dmi'
	icon_state = ICON_STATE_WORLD

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
	icon = 'icons/obj/food/mre/pouch_medium.dmi'
	icon_state = ICON_STATE_WORLD


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
	icon = 'icons/obj/food/mre/pouch_medium.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/mre/dessert/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/food/junk/candy,
		/obj/item/food/junk/candy/proteinbar,
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
		/obj/item/food/junk/candy,
		/obj/item/food/chocolatebar,
		/obj/item/food/donut/jelly,
		/obj/item/food/plumphelmetbiscuit
	)
	return spawnable_choices

/obj/random/mre/drink
	name = "random MRE drink"
	desc = "This is a random drink for MREs."
	icon = 'icons/obj/food/condiments/packets/packet_small.dmi'

/obj/random/mre/drink/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/packet/coffee,
		/obj/item/chems/packet/tea,
		/obj/item/chems/packet/cocoa,
		/obj/item/chems/packet/grape,
		/obj/item/chems/packet/orange,
		/obj/item/chems/packet/watermelon,
		/obj/item/chems/packet/apple
	)
	return spawnable_choices

/obj/random/mre/spread
	name = "random MRE spread"
	desc = "This is a random spread packet for MREs."
	icon = 'icons/obj/food/condiments/packets/packet_small.dmi'

/obj/random/mre/spread/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/packet/jelly,
		/obj/item/chems/packet/honey,
		/obj/item/chems/packet/honey_fake
	)
	return spawnable_choices

/obj/random/mre/spread/vegan
	name = "random vegan MRE spread"
	desc = "This is a random vegan spread packet for MREs"

/obj/random/mre/spread/vegan/spawn_choices()
	var/static/list/spawnable_choices = list(/obj/item/chems/packet/jelly)
	return spawnable_choices

/obj/random/mre/sauce
	name = "random MRE sauce"
	desc = "This is a random sauce packet for MREs."
	icon = 'icons/obj/food/condiments/packets/packet_small.dmi'

/obj/random/mre/sauce/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/packet/salt,
		/obj/item/chems/packet/pepper,
		/obj/item/chems/packet/sugar,
		/obj/item/chems/packet/capsaicin,
		/obj/item/chems/packet/ketchup,
		/obj/item/chems/packet/mayo,
		/obj/item/chems/packet/soy
	)
	return spawnable_choices

/obj/random/mre/sauce/vegan/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/packet/salt,
		/obj/item/chems/packet/pepper,
		/obj/item/chems/packet/sugar,
		/obj/item/chems/packet/soy
	)
	return spawnable_choices

/obj/random/mre/sauce/sugarfree/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/packet/salt,
		/obj/item/chems/packet/pepper,
		/obj/item/chems/packet/capsaicin,
		/obj/item/chems/packet/ketchup,
		/obj/item/chems/packet/mayo,
		/obj/item/chems/packet/soy
	)
	return spawnable_choices

/obj/random/mre/sauce/crayon/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/packet/crayon,
		/obj/item/chems/packet/crayon/red,
		/obj/item/chems/packet/crayon/orange,
		/obj/item/chems/packet/crayon/yellow,
		/obj/item/chems/packet/crayon/green,
		/obj/item/chems/packet/crayon/blue,
		/obj/item/chems/packet/crayon/purple,
		/obj/item/chems/packet/crayon/grey,
		/obj/item/chems/packet/crayon/brown
	)
	return spawnable_choices

/obj/random/snack
	name = "random snack"
	desc = "This is a random snack item."
	icon = 'icons/obj/food/junk/junkfood.dmi'
	icon_state = "sosjerky"

/obj/random/snack/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/food/junk/liquidfood,
		/obj/item/food/junk/candy,
		/obj/item/chems/drinks/dry_ramen,
		/obj/item/food/junk/chips,
		/obj/item/food/junk/sosjerky,
		/obj/item/food/junk/no_raisin,
		/obj/item/food/junk/spacetwinkie,
		/obj/item/food/junk/cheesiehonkers,
		/obj/item/food/junk/tastybread,
		/obj/item/food/junk/candy/proteinbar,
		/obj/item/food/junk/syndicake,
		/obj/item/food/donut,
		/obj/item/food/donut/jelly,
		/obj/item/pizzabox/meat,
		/obj/item/pizzabox/vegetable,
		/obj/item/pizzabox/margherita,
		/obj/item/pizzabox/mushroom,
		/obj/item/food/plumphelmetbiscuit
	)
	return spawnable_choices

/obj/random/mug
	name = "random coffee cup"
	desc = "A random coffee cup/mug."
	icon = 'icons/obj/drink_glasses/coffecup.dmi'
	icon_state = "coffeecup"

/obj/random/mug/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/drinks/glass2/coffeecup,
		/obj/item/chems/drinks/glass2/coffeecup/black,
		/obj/item/chems/drinks/glass2/coffeecup/green,
		/obj/item/chems/drinks/glass2/coffeecup/heart,
		/obj/item/chems/drinks/glass2/coffeecup/one,
		/obj/item/chems/drinks/glass2/coffeecup/rainbow,
		/obj/item/chems/drinks/glass2/coffeecup/metal,
		/obj/item/chems/drinks/glass2/coffeecup/STC,
		/obj/item/chems/drinks/glass2/coffeecup/pawn,
		/obj/item/chems/drinks/glass2/coffeecup/britcup,
		/obj/item/chems/drinks/glass2/coffeecup/tall,
		/obj/item/chems/drinks/glass2/coffeecup/teacup
	)
	return spawnable_choices
