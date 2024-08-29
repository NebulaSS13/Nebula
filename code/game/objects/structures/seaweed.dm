/obj/structure/flora/seaweed
	name = "seaweed"
	desc = "Waving fronds of ocean greenery."
	icon = 'icons/obj/structures/plants.dmi'
	icon_state = "seaweed"
	anchored = TRUE
	density = FALSE
	opacity = FALSE

/obj/structure/flora/seaweed/mid
	icon_state = "seaweed1"

/obj/structure/flora/seaweed/large
	icon_state = "seaweed2"

/obj/structure/flora/seaweed/glow
	name = "glowing seaweed"
	desc = "It shines with an eerie bioluminescent light."
	icon_state = "glowweed1"
	light_color = "#00fff4"

/obj/structure/flora/seaweed/glow/Initialize()
	. = ..()
	set_light(3, 0.6, l_color = light_color)
	icon_state = "glowweed[rand(1,3)]"

/obj/effect/decal/cleanable/lichen
	name = "lichen"
	desc = "Damp and mossy plant life."
	icon_state = "lichen"
	icon = 'icons/obj/structures/plants.dmi'

/obj/effect/decal/cleanable/lichen/attackby(obj/item/I, mob/user)
	if(I.sharp && I.get_attack_force(user) > 1)
		qdel(src)
		return TRUE
	. = ..()