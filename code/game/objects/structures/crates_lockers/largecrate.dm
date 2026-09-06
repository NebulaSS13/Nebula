/obj/structure/largecrate
	name = "large crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/shipping_crates.dmi'
	icon_state = "densecrate"
	density = TRUE
	atom_flags = ATOM_FLAG_CLIMBABLE
	material = /decl/material/solid/organic/wood/oak

/obj/structure/largecrate/Initialize()
	. = ..()
	for(var/obj/I in src.loc)
		if(I.density || I.anchored || I == src || !I.simulated)
			continue
		I.forceMove(src)

/obj/structure/largecrate/attack_hand(mob/user)
	if(user.check_intent(I_FLAG_HARM))
		return ..()
	to_chat(user, SPAN_WARNING("You need a crowbar to pry this open!"))
	return TRUE

/obj/structure/largecrate/attackby(obj/item/used_item, mob/user)
	if(IS_CROWBAR(used_item))
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
	animal_type = /mob/living/simple_animal/passive/cat

/obj/structure/largecrate/animal/cow
	animal_type = /mob/living/simple_animal/cow

/obj/structure/largecrate/animal/corgi
	animal_type = /mob/living/simple_animal/corgi
