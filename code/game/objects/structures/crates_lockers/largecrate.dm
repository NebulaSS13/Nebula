/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/shipping_crates.dmi'
	icon_state = "densecrate"
	density = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	material = /decl/material/solid/wood

/obj/structure/largecrate/Initialize()
	. = ..()
	for(var/obj/I in src.loc)
		if(I.density || I.anchored || I == src || !I.simulated)
			continue
		I.forceMove(src)

/obj/structure/largecrate/attack_hand(mob/user)
	if(user.a_intent == I_HURT)
		return ..()
	to_chat(user, SPAN_WARNING("You need a crowbar to pry this open!"))
	return TRUE

/obj/structure/largecrate/attackby(obj/item/W, mob/user)
	if(IS_CROWBAR(W))
		user.visible_message(
			SPAN_NOTICE("\The [user] pries \the [src] open."),
			SPAN_NOTICE("You pry open \the [src]."),
			SPAN_NOTICE("You hear splitting wood.")
		)
		physically_destroyed()
		return TRUE
	return attack_hand_with_interaction_checks(user)

/obj/structure/largecrate/animal
	name = "animal crate"
	var/animal_type

/obj/structure/largecrate/animal/Initialize()
	. = ..()
	if(animal_type)
		var/mob/critter = new animal_type(src)
		name = "[name] ([critter.name])"

/obj/structure/largecrate/animal/cat
	animal_type = /mob/living/simple_animal/cat

/obj/structure/largecrate/animal/cow
	animal_type = /mob/living/simple_animal/cow

/obj/structure/largecrate/animal/corgi
	animal_type = /mob/living/simple_animal/corgi
