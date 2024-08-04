//Canned Foods - crack open, eat.

#define OPEN_HARD 1
#define OPEN_EASY 0

/obj/item/food/can
	name = "empty can"
	icon = 'icons/obj/food_canned.dmi'
	center_of_mass = @'{"x":15,"y":9}'
	atom_flags = 0
	bitesize = 3

	var/sealed = TRUE
	var/open_complexity = OPEN_HARD

/obj/item/food/can/Initialize()
	. = ..()
	if(!sealed)
		unseal()

/obj/item/food/can/examine(mob/user)
	. = ..()
	to_chat(user, "It is [!ATOM_IS_OPEN_CONTAINER(src) ? "" : "un"]sealed.")
	to_chat(user, "It looks [open_complexity ? "hard" : "easy "] to open.")

/obj/item/food/can/proc/unseal(mob/user)
	playsound(src, 'sound/effects/canopen.ogg', rand(10, 50), 1)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	sealed = FALSE

/obj/item/food/can/attack_self(mob/user)
	if(!ATOM_IS_OPEN_CONTAINER(src) && !open_complexity)
		to_chat(user, SPAN_NOTICE("You unseal \the [src] with a crack of metal."))
		unseal()

/obj/item/food/can/attackby(obj/item/W, mob/user)
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

	else if(istype(W,/obj/item/utensil))
		if(ATOM_IS_OPEN_CONTAINER(src))
			..()
		else
			to_chat(user, SPAN_WARNING("You need a can-opener to open this!"))

/obj/item/food/can/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)
	if(ATOM_IS_OPEN_CONTAINER(src))
		icon_state = "[initial(icon_state)]-open"

/obj/item/food/can/apply_filling_overlay()
	return //Bypass searching through the whole icon file for a filling icon

/obj/item/food/can/can_be_poured_into(atom/source)
	return (reagents?.maximum_volume > 0) && ATOM_IS_OPEN_CONTAINER(src)

//Just a short line of Canned Consumables, great for treasure in faraway abandoned outposts

/obj/item/food/can/beef
	name = "quadrangled beefium"
	icon_state = "beef"
	desc = "Proteins carefully cloned from an extinct species of cattle in a secret facility on the outer rim."
	trash = /obj/item/trash/beef
	filling_color = "#663300"
	nutriment_desc = list("beef" = 1)

/obj/item/food/can/beef/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 12)

/obj/item/food/can/beans
	name = "baked beans"
	icon_state = "beans"
	desc = "Carefully synthethized from soy."
	trash = /obj/item/trash/beans
	filling_color = "#ff6633"
	nutriment_desc = list("beans" = 1)
	nutriment_amt = 12

/obj/item/food/can/tomato
	name = "tomato soup"
	icon_state = "tomato"
	desc = "Plain old unseasoned tomato soup. This can is older than you are!"
	trash = /obj/item/trash/tomato
	filling_color = "#ae0000"
	nutriment_desc = list("tomato" = 1)
	eat_sound = 'sound/items/drink.ogg'
	utensil_flags = UTENSIL_FLAG_SCOOP

/obj/item/food/can/tomato/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/drink/juice/tomato, 12)

/obj/item/food/can/spinach
	name = "spinach"
	icon_state = "spinach"
	desc = "Notably has less iron in it than a watermelon."
	trash = /obj/item/trash/spinach
	filling_color = "#003300"
	nutriment_desc = list("sogginess" = 1, "vegetable" = 1)
	bitesize = 20

/obj/item/food/can/spinach/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment,    5)
	add_to_reagents(/decl/material/liquid/adrenaline,   5)
	add_to_reagents(/decl/material/liquid/amphetamines, 5)
	add_to_reagents(/decl/material/solid/metal/iron,    5)

//Vending Machine Foods should go here.

/obj/item/food/can/caviar
	name = "canned caviar"
	icon_state = "fisheggs"
	desc = "Caviar, or space carp eggs. Carefully faked using alginate, artificial flavoring and salt."
	trash = /obj/item/trash/fishegg
	filling_color = "#000000"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 6

/obj/item/food/can/caviar/true
	name = "canned caviar"
	icon_state = "carpeggs"
	desc = "Caviar, or space carp eggs. Exceeds the recommended amount of heavy metals in your diet! But very posh."
	trash = /obj/item/trash/carpegg
	filling_color = "#330066"
	nutriment_desc = list("fish" = 1, "salt" = 1, "a numbing sensation" = 1)
	nutriment_amt = 6

/obj/item/food/can/caviar/true/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 4)
	add_to_reagents(/decl/material/liquid/carpotoxin,        1)

/obj/item/knife/opener
	name = "can-opener"
	desc = "A simple can-opener."
	icon = 'icons/obj/items/weapon/knives/opener.dmi'

#undef OPEN_EASY
#undef OPEN_HARD
