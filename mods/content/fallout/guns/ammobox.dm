/obj/item/box/ammo/fallout
	icon = 'mods/content/fallout/guns/icons/!misc/ammobox.dmi'
	icon_state = "slug"

/obj/item/box/ammo/fallout/slug
	name = "large box of shotgun slugs"
/obj/item/box/ammo/fallout/slug/WillContain()
    return list(/obj/item/ammo_magazine/shotholder = 6)

/obj/item/box/ammo/fallout/shells
    name = "box of shotgun shells"
    icon_state = "pellet"
/obj/item/box/ammo/fallout/shells/WillContain()
    return list(/obj/item/ammo_magazine/shotholder/shell = 6)

/obj/item/box/ammo/fallout/magnum
	name = "box of magnum bullets"
	icon_state = "magnum"
/obj/item/box/ammo/fallout/magnum/WillContain()
		return list(/obj/item/ammo_magazine/speedloader = 6)