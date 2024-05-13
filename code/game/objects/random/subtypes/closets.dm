/obj/random/closet
	name = "random closet"
	desc = "This is a random closet."
	icon = 'icons/obj/closets/bases/closet.dmi'
	icon_state = "base"
	var/vermin_chance = 0.1
	var/list/locker_vermin = list(
		/mob/living/simple_animal/passive/mouse,
		/mob/living/simple_animal/opossum
	)

/obj/random/closet/spawn_choices()
	var/static/list/spawnable_choices = typesof(/obj/structure/closet) - (typesof(/obj/structure/closet/crate) | typesof(/obj/structure/closet/body_bag) | typesof(/obj/structure/closet/secure_closet))
	return spawnable_choices

/obj/random/closet/spawn_item()
	. = ..()
	if(. && length(locker_vermin) && prob(vermin_chance))
		var/vermin_type = pickweight(locker_vermin)
		new vermin_type(.)

/obj/random/crate
	name = "random crate"
	desc = "This is a random crate"
	icon = 'icons/obj/closets/bases/crate.dmi'
	icon_state = "base"

/obj/random/crate/spawn_choices()
	var/static/list/spawnable_choices = typesof(/obj/structure/closet/crate) - typesof(/obj/structure/closet/crate/secure)
	return spawnable_choices
