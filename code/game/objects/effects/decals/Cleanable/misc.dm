/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	gender = PLURAL
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	gender = PLURAL
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"

/obj/effect/decal/cleanable/ash/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	to_chat(user, "<span class='notice'>[src] sifts through your fingers.</span>")
	var/turf/simulated/floor/F = get_turf(src)
	if (istype(F))
		F.dirt += 4
	qdel(src)
	return TRUE

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	gender = PLURAL
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = 0
	persistent = TRUE

/obj/effect/decal/cleanable/dirt/Destroy()
	var/turf/simulated/T = loc
	. = ..()
	if(istype(T) && !(locate(/obj/effect/decal/cleanable/dirt) in T))
		T.dirt = 0

/obj/effect/decal/cleanable/flour
	name = "flour"
	desc = "It's still good. Four second rule!"
	gender = PLURAL
	icon = 'icons/effects/effects.dmi'
	icon_state = "flour"
	persistent = TRUE

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	layer = ABOVE_HUMAN_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb1"

/obj/effect/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	icon = 'icons/effects/molten_item.dmi'
	icon_state = "molten"
	persistent = TRUE
	generic_filth = TRUE

/obj/effect/decal/cleanable/cobweb2
	name = "cobweb"
	desc = "Somebody should remove that."
	layer = ABOVE_HUMAN_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb2"

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	gender = PLURAL
	icon = 'icons/effects/vomit.dmi'
	icon_state = "vomit_1"
	persistent = TRUE
	generic_filth = TRUE

/obj/effect/decal/cleanable/vomit/Initialize(ml, _age)
	random_icon_states = icon_states(icon)
	. = ..()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	create_reagents(30, src)
	if(prob(75))
		set_rotation(pick(90, 180, 270))

/obj/effect/decal/cleanable/vomit/on_update_icon()
	. = ..()
	color = reagents.get_color()

/obj/effect/decal/cleanable/tomato_smudge
	name = "tomato smudge"
	desc = "It's red."
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")
	persistent = TRUE
	generic_filth = TRUE

/obj/effect/decal/cleanable/egg_smudge
	name = "smashed egg"
	desc = "Seems like this one won't hatch."
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")
	persistent = TRUE
	generic_filth = TRUE

/obj/effect/decal/cleanable/pie_smudge //honk
	name = "smashed pie"
	desc = "It's pie cream from a cream pie."
	icon = 'icons/effects/tomatodecal.dmi'
	random_icon_states = list("smashed_pie")
	persistent = TRUE
	generic_filth = TRUE

/obj/effect/decal/cleanable/fruit_smudge
	name = "smudge"
	desc = "Some kind of fruit smear."
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")
	persistent = TRUE
	generic_filth = TRUE
