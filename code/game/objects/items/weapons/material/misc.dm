/obj/item/harpoon
	name = "harpoon"
	desc = "A short throwing spear with a deep barb, specifically designed to embed itself in its target."
	sharp = 1
	edge = 1
	icon = 'icons/obj/items/weapon/harpoon.dmi'
	icon_state = "harpoon"
	item_state = "harpoon"
	item_flags = ITEM_FLAG_IS_WEAPON
	attack_verb = list("jabbed","stabbed","ripped")
	does_spin = FALSE
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	_base_attack_force = 20
	var/spent

/obj/item/harpoon/bomb
	name = "explosive harpoon"
	desc = "A short throwing spear with a deep barb and an explosive fitted in the head. Traditionally fired from some kind of cannon to harvest big game."
	icon_state = "harpoon_bomb"

/obj/item/harpoon/bomb/has_embedded()
	..()
	if(spent)
		return
	audible_message(SPAN_WARNING("\The [src] emits a long, harsh tone!"))
	playsound(loc, 'sound/weapons/bombwhine.ogg', 100, 0, -3)
	addtimer(CALLBACK(src, PROC_REF(harpoon_detonate)), 4 SECONDS) //for suspense

/obj/item/harpoon/bomb/proc/harpoon_detonate()
	audible_message(SPAN_DANGER("\The [src] detonates!")) //an actual sound will be handled by explosion()
	var/turf/T = get_turf(src)
	explosion(T, 0, 0, 2, 0, 1, UP|DOWN, 1)
	fragmentate(T, 4, 2)
	handle_afterbomb()

/obj/item/harpoon/bomb/proc/handle_afterbomb()
	spent = TRUE
	SetName("broken harpoon")
	desc = "A short spear with just a barb - if it once had a spearhead, it doesn't any more."
	icon_state = "harpoon_bomb_spent"
	sharp = FALSE
	edge = FALSE

/obj/item/scythe
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	icon = 'icons/obj/items/tool/scythe.dmi'
	icon_state = ICON_STATE_WORLD
	sharp = 1
	edge = 1
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	origin_tech = @'{"materials":2,"combat":2}'
	attack_verb = list("chopped", "sliced", "cut", "reaped")
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/cross
	name = "cross"
	desc = "It's a cross, commonly used as a holy symbol by Christians."
	icon = 'icons/obj/items/cross.dmi'
	icon_state = "cross"
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "bashed")
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	material = /decl/material/solid/organic/wood

/obj/item/cross/silver
	material = /decl/material/solid/metal/silver

/obj/item/cross/gold
	material = /decl/material/solid/metal/gold