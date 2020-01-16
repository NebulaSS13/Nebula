/obj/item/chems/food/drinks/juicebox
	name = "juicebox"
	desc = "A small cardboard juicebox. Cheap and flimsy."
	volume = 30
	amount_per_transfer_from_this = 5
	atom_flags = 0
	matter = list(MATERIAL_CARDBOARD = 30)

/obj/item/chems/food/drinks/juicebox/examine(mob/user, distance)
	. = ..()
	if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		to_chat(user, SPAN_NOTICE("It has a straw stuck through the foil seal on top."))
	else
		to_chat(user, SPAN_NOTICE("It has a straw stuck to the side and the foil seal is intact."))

/obj/item/chems/food/drinks/juicebox/open(mob/user)
	playsound(loc,'sound/effects/bonebreak1.ogg', rand(10,50), 1)
	to_chat(user, SPAN_NOTICE("You pull off the straw and stab it into \the [src], perforating the foil!"))
	icon_state = "[initial(icon_state)]_open"
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/chems/food/drinks/juicebox/apple
	desc = "A small cardboard juicebox with a cartoon apple on it."
	icon_state = "juicebox_red"

/obj/item/chems/food/drinks/juicebox/apple/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/apple, 25)

/obj/item/chems/food/drinks/juicebox/orange
	desc = "A small cardboard juicebox with a cartoon orange on it."
	icon_state = "juicebox_orange"

/obj/item/chems/food/drinks/juicebox/orange/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/orange, 25)

/obj/item/chems/food/drinks/juicebox/grape
	desc = "A small cardboard juicebox with some cartoon grapes on it."
	icon_state = "juicebox_purple"

/obj/item/chems/food/drinks/juicebox/grape/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/grape, 25)
