/obj/item/grenade/fake
	icon = 'icons/obj/items/grenades/frag.dmi'

/obj/item/grenade/fake/detonate()
	active = 0
	playsound(src.loc, get_sfx("explosion"), 50, 1, 30)
