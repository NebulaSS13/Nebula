//Canned Foods - crack open, eat.

#define OPEN_HARD 1
#define OPEN_EASY 0

/obj/item/chems/food/can
	name = "empty can"
	icon = 'icons/obj/food_canned.dmi'
	center_of_mass = @"{'x':15,'y':9}"
	atom_flags = 0
	bitesize = 3

	var/sealed = TRUE
	var/open_complexity = OPEN_HARD

/obj/item/chems/food/can/Initialize()
	. = ..()
	if(!sealed)
		unseal()

/obj/item/chems/food/can/examine(mob/user)
	. = ..()
	to_chat(user, "It is [!ATOM_IS_OPEN_CONTAINER(src) ? "" : "un"]sealed.")
	to_chat(user, "It looks [open_complexity ? "hard" : "easy "] to open.")

/obj/item/chems/food/can/proc/unseal(mob/user)
	playsound(src, 'sound/effects/canopen.ogg', rand(10, 50), 1)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	sealed = FALSE

/obj/item/chems/food/can/attack(mob/M, mob/user, def_zone)
	if(force && !(obj_flags & ITEM_FLAG_NO_BLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		update_icon(src)
		return TRUE

	return FALSE

/obj/item/chems/food/can/standard_feed_mob(mob/user, mob/target)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_NOTICE("You need to open \the [src] first!"))
		return TRUE
	return ..()

/obj/item/chems/food/can/attack_self(mob/user)
	if(!ATOM_IS_OPEN_CONTAINER(src) && !open_complexity)
		to_chat(user, SPAN_NOTICE("You unseal \the [src] with a crack of metal."))
		unseal()

/obj/item/chems/food/can/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/knife) && !ATOM_IS_OPEN_CONTAINER(src))
		user.visible_message(
			SPAN_NOTICE("\The [user] is trying to open \the [src] with \the [W]."),
			SPAN_NOTICE("You start to open \the [src].")
		)
		var/open_timer = istype(W, /obj/item/knife/opener) ? 5 SECONDS : 15 SECONDS
		if(do_after(user, open_timer, src))
			to_chat(user, SPAN_NOTICE("You unseal \the [src] with a crack of metal."))
			unseal()
			return

	else if(istype(W,/obj/item/kitchen/utensil))
		if(ATOM_IS_OPEN_CONTAINER(src))
			..()
		else
			to_chat(user, SPAN_WARNING("You need a can-opener to open this!"))

/obj/item/chems/food/can/on_update_icon()
	icon_state = initial(icon_state)
	if(ATOM_IS_OPEN_CONTAINER(src))
		icon_state = "[initial(icon_state)]-open"

//Just a short line of Canned Consumables, great for treasure in faraway abandoned outposts

/obj/item/chems/food/can/beef
	name = "quadrangled beefium"
	icon_state = "beef"
	desc = "Proteins carefully cloned from an extinct species of cattle in a secret facility on the outer rim."
	trash = /obj/item/trash/beef
	filling_color = "#663300"
	nutriment_desc = list("beef" = 1)

/obj/item/chems/food/can/beef/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 12)

/obj/item/chems/food/can/beans
	name = "baked beans"
	icon_state = "beans"
	desc = "Carefully synthethized from soy."
	trash = /obj/item/trash/beans
	filling_color = "#ff6633"
	nutriment_desc = list("beans" = 1)
	nutriment_amt = 12

/obj/item/chems/food/can/tomato
	name = "tomato soup"
	icon_state = "tomato"
	desc = "Plain old unseasoned tomato soup. This can is older than you are!"
	trash = /obj/item/trash/tomato
	filling_color = "#ae0000"
	nutriment_desc = list("tomato" = 1)
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/can/tomato/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 12)


/obj/item/chems/food/can/tomato/feed_sound(var/mob/user)
	playsound(user, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/chems/food/can/spinach
	name = "spinach"
	icon_state = "spinach"
	desc = "Notably has less iron in it than a watermelon."
	trash = /obj/item/trash/spinach
	filling_color = "#003300"
	nutriment_desc = list("sogginess" = 1, "vegetable" = 1)
	bitesize = 20

/obj/item/chems/food/can/spinach/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 5)
	reagents.add_reagent(/decl/material/liquid/adrenaline, 5)
	reagents.add_reagent(/decl/material/liquid/amphetamines, 5)
	reagents.add_reagent(/decl/material/solid/metal/iron, 5)

//Vending Machine Foods should go here.

/obj/item/chems/food/can/caviar
	name = "canned caviar"
	icon_state = "fisheggs"
	desc = "Caviar, or space carp eggs. Carefully faked using alginate, artificial flavoring and salt."
	trash = /obj/item/trash/fishegg
	filling_color = "#000000"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 6

/obj/item/chems/food/can/caviar/true
	name = "canned caviar"
	icon_state = "carpeggs"
	desc = "Caviar, or space carp eggs. Exceeds the recomended amount of heavy metals in your diet! But very posh."
	trash = /obj/item/trash/carpegg
	filling_color = "#330066"
	nutriment_desc = list("fish" = 1, "salt" = 1, "numbing sensation" = 1)
	nutriment_amt = 6

/obj/item/chems/food/caviar/true/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)
	reagents.add_reagent(/decl/material/liquid/carpotoxin, 1)

/obj/item/knife/opener
	name = "can-opener"
	desc = "A simple can-opener."
	icon = 'icons/obj/items/weapon/knives/opener.dmi'

#undef OPEN_EASY
#undef OPEN_HARD
