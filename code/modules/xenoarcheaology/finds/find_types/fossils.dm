
/decl/archaeological_find/fossil
	item_type = "bones"
	modification_flags = 0
	responsive_reagent = /decl/material/solid/carbon
	var/list/candidates = list(
		/obj/item/fossil/animal = 9,
		/obj/item/fossil/skull = 3,
		/obj/item/fossil/animal/skull/horned = 2
	)

/decl/archaeological_find/fossil/spawn_item(atom/loc)
	var/spawn_type = pickweight(candidates)
	return new spawn_type(loc)

/decl/archaeological_find/fossil/shell
	item_type = "shell"
	candidates = list(/obj/item/fossil)
	engraving_chance = 30

/decl/archaeological_find/fossil/plant
	item_type = "fossilized plant"
	candidates = list(/obj/item/fossil/plant)

/// Objects themselves

/obj/item/fossil
	name = "fossilised shell"
	desc = "A fossilised, pre-Stygian alien crustacean."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "shell"
	material = /decl/material/solid/stone/sandstone //Should probably be limestone, but whatever

/obj/item/fossil/plant
	name = "fossilised plant"
	icon_state = "plant1"
	desc = " A fossilised shred of alien plant matter."

/obj/item/fossil/plant/Initialize()
	. = ..()
	icon_state = "plant[rand(1,4)]"

/obj/item/fossil/animal
	name = "fossilised bone"
	icon_state = "bone"
	desc = "A fossilised part of an alien, long dead."

/obj/item/fossil/animal/skull
	name = "fossilised skull"
	icon_state = "skull"

/obj/item/fossil/animal/skull/horned
	icon_state = "hskull"

/obj/item/fossil/skull/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/fossil/animal))
		if(!user.canUnEquip(W))
			return
		var/mob/M = get_recursive_loc_of_type(/mob)
		if(M && !M.try_unequip(src))
			return
		var/obj/o = new /obj/structure/skeleton(get_turf(src))
		user.try_unequip(W, o)
		forceMove(o)

/obj/structure/skeleton
	name = "alien skeleton display"
	desc = "Fossilized bones mounted on a wire structure."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "uskel"
	var/bone_count = 1
	var/required_bones
	var/plaque_contents = "Unnamed alien creature"

/obj/structure/skeleton/Initialize()
	. = ..()
	required_bones = rand(6)+3

/obj/structure/skeleton/examine(mob/user, distance)
	. = ..()
	if(bone_count < required_bones)
		to_chat(user, "It's incomplete, looks like it could use [required_bones - bone_count] more bones.")
	if(.)
		to_chat(user, "The plaque reads \'[plaque_contents]\'.")

/obj/structure/skeleton/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/fossil/animal))
		if(bone_count < required_bones)
			if(user.try_unequip(W, src))
				bone_count++
				if(bone_count == required_bones)
					icon_state = "skel"
					set_density(1)
		else
			to_chat(user, SPAN_NOTICE("\The [src] is already complete."))
	else if(IS_PEN(W))
		plaque_contents = sanitize(input("What would you like to write on the plaque:","Skeleton plaque",""))
		user.visible_message("[user] writes something on the base of [src].","You relabel the plaque on the base of [src].")
	else
		..()