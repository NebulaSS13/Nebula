/obj/item/harpoon
	name = "harpoon"
	desc = "A short throwing spear with a deep barb, specifically designed to embed itself in its target."
	sharp = 1
	edge = 1
	icon = 'icons/obj/items/weapon/harpoon.dmi'
	icon_state = "harpoon"
	item_state = "harpoon"
	max_force = 20
	material_force_multiplier = 0.3 // 18 with hardness 60 (steel)
	thrown_material_force_multiplier = 0.6
	attack_verb = list("jabbed","stabbed","ripped")
	does_spin = FALSE
	material = /decl/material/solid/metal/steel
	applies_material_colour = TRUE
	applies_material_name = TRUE
	var/spent

/obj/item/harpoon/bomb
	name = "explosive harpoon"
	desc = "A short throwing spear with a deep barb and an explosive fitted in the head. Traditionally fired from some kind of cannon to harvest big game."
	icon_state = "harpoon_bomb"

/obj/item/harpoon/bomb/has_embedded()
	if(spent)
		return
	audible_message(SPAN_WARNING("\The [src] emits a long, harsh tone!"))
	playsound(loc, 'sound/weapons/bombwhine.ogg', 100, 0, -3)
	addtimer(CALLBACK(src, .proc/harpoon_detonate), 4 SECONDS) //for suspense

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
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.3
	sharp = FALSE
	edge = FALSE

/obj/item/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/items/tool/hatchet.dmi'
	icon_state = "hatchet"
	max_force = 15
	material_force_multiplier = 0.2 // 12 with hardness 60 (steel)
	thrown_material_force_multiplier = 0.25 // 15 with weight 60 (steel)
	w_class = ITEM_SIZE_SMALL
	sharp = 1
	edge = 1
	origin_tech = "{'materials':2,'combat':1}"
	attack_verb = list("chopped", "torn", "cut")
	material = /decl/material/solid/metal/steel
	applies_material_colour = FALSE
	applies_material_name = TRUE
	hitsound = "chop"

/obj/item/hatchet/unbreakable
	unbreakable = TRUE

/obj/item/hatchet/machete
	name = "machete"
	desc = "A long, sturdy blade with a rugged handle. Leading the way to cursed treasures since before space travel."
	icon = 'icons/obj/items/weapon/machetes/machete.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/metal/titanium
	base_parry_chance = 50
	max_force = 20
	material_force_multiplier = 0.20 //20 with hardness 80 (titanium) or 15 with hardness 60 (steel)
	var/global/list/standard_machete_icons = list(
		'icons/obj/items/weapon/machetes/machete.dmi',
		'icons/obj/items/weapon/machetes/machete_red.dmi',
		'icons/obj/items/weapon/machetes/machete_blue.dmi',
		'icons/obj/items/weapon/machetes/machete_black.dmi',
		'icons/obj/items/weapon/machetes/machete_olive.dmi'
	)

/obj/item/hatchet/machete/Initialize()
	icon = pick(standard_machete_icons)
	. = ..()

/obj/item/hatchet/machete/unbreakable
	unbreakable = TRUE

/obj/item/hatchet/machete/steel
	name = "fabricated machete"
	desc = "A long, machine-stamped blade with a somewhat ungainly handle. Found in military surplus stores, malls, and horror movies since before interstellar travel."
	base_parry_chance = 40
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/hatchet/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon = 'icons/obj/items/weapon/machetes/machete_dx.dmi'

/obj/item/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/items/tool/hoe.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	material_force_multiplier = 0.25 // 5 with weight 20 (steel)
	thrown_material_force_multiplier = 0.25
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")
	material = /decl/material/solid/metal/steel
	applies_material_colour = TRUE
	applies_material_name = TRUE

/obj/item/minihoe/unbreakable
	unbreakable = TRUE

/obj/item/scythe
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	icon = 'icons/obj/items/tool/scythe.dmi'
	icon_state = ICON_STATE_WORLD
	material_force_multiplier = 0.275 // 16 with hardness 60 (steel)
	thrown_material_force_multiplier = 0.2
	sharp = 1
	edge = 1
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	origin_tech = "{'materials':2,'combat':2}"
	attack_verb = list("chopped", "sliced", "cut", "reaped")
	material = /decl/material/solid/metal/steel
	applies_material_colour = TRUE
	applies_material_name = TRUE

/obj/item/cross
	name = "cross"
	desc = "It's a cross, commonly used as a holy symbol by Christians."
	icon = 'icons/obj/items/cross.dmi'
	icon_state = "cross"
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "bashed")
	applies_material_colour = TRUE
	applies_material_name = TRUE
	material = /decl/material/solid/wood

/obj/item/cross/silver
	material = /decl/material/solid/metal/silver

/obj/item/cross/gold
	material = /decl/material/solid/metal/gold