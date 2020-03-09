/obj/item/material/harpoon
	name = "harpoon"
	desc = "A short throwing spear with a deep barb, specifically designed to embed itself in its target."
	sharp = 1
	edge = 1
	icon_state = "harpoon"
	item_state = "harpoon"
	max_force = 20
	material_force_multiplier = 0.3 // 18 with hardness 60 (steel)
	thrown_material_force_multiplier = 1.8
	attack_verb = list("jabbed","stabbed","ripped")
	does_spin = FALSE
	var/spent
	base_worth = 15


/obj/item/material/harpoon/bomb
	name = "explosive harpoon"
	desc = "A short throwing spear with a deep barb and an explosive fitted in the head. Traditionally fired from some kind of cannon to harvest big game."
	icon_state = "harpoon_bomb"

/obj/item/material/harpoon/bomb/has_embedded()
	if(spent)
		return
	audible_message(SPAN_WARNING("\The [src] emits a long, harsh tone!"))
	playsound(loc, 'sound/weapons/bombwhine.ogg', 100, 0, -3)
	addtimer(CALLBACK(src, .proc/harpoon_detonate), 4 SECONDS) //for suspense

/obj/item/material/harpoon/bomb/proc/harpoon_detonate()
	audible_message(SPAN_DANGER("\The [src] detonates!")) //an actual sound will be handled by explosion()
	var/turf/T = get_turf(src)
	explosion(T, 0, 0, 2, 0, 1, UP|DOWN, 1)
	fragmentate(T, 4, 2)
	handle_afterbomb()

/obj/item/material/harpoon/bomb/proc/handle_afterbomb()
	spent = TRUE
	SetName("broken harpoon")
	desc = "A short spear with just a barb - if it once had a spearhead, it doesn't any more."
	icon_state = "harpoon_bomb_spent"
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.3
	sharp = FALSE
	edge = FALSE
	base_worth = 6

/obj/item/material/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/items.dmi'
	icon_state = "hatchet"
	max_force = 15
	material_force_multiplier = 0.2 // 12 with hardness 60 (steel)
	thrown_material_force_multiplier = 0.75 // 15 with weight 20 (steel)
	w_class = ITEM_SIZE_SMALL
	sharp = 1
	edge = 1
	origin_tech = "{'" + TECH_MATERIAL + "':2,'" + TECH_COMBAT + "':1}"
	attack_verb = list("chopped", "torn", "cut")
	applies_material_colour = 0
	hitsound = "chop"

/obj/item/material/hatchet/unbreakable
	unbreakable = TRUE

/obj/item/material/hatchet/machete
	name = "machete"
	desc = "A long, sturdy blade with a rugged handle. Leading the way to cursed treasures since before space travel."
	item_state = "machete"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	material = MAT_TITANIUM
	base_parry_chance = 50
	max_force = 20
	material_force_multiplier = 0.20 //20 with hardness 80 (titanium) or 15 with hardness 60 (steel)

/obj/item/material/hatchet/machete/unbreakable
	unbreakable = TRUE

/obj/item/material/hatchet/machete/steel
	name = "fabricated machete"
	desc = "A long, machine-stamped blade with a somewhat ungainly handle. Found in military surplus stores, malls, and horror movies since before interstellar travel."
	material = MAT_STEEL
	base_parry_chance = 40

/obj/item/material/hatchet/machete/Initialize()
	icon_state = "machete[pick("","_red","_blue", "_black", "_olive")]"
	. = ..()

/obj/item/material/hatchet/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."

/obj/item/material/hatchet/machete/deluxe/Initialize()
	. = ..()
	icon_state = "machetedx"

/obj/item/material/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/items.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	max_force = 5
	material_force_multiplier = 0.25 // 5 with weight 20 (steel)
	thrown_material_force_multiplier = 0.25 // as above
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/obj/item/material/minihoe/unbreakable
	unbreakable = TRUE

/obj/item/material/scythe
	icon_state = "scythe0"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	max_force = 15
	material_force_multiplier = 0.275 // 16 with hardness 60 (steel)
	thrown_material_force_multiplier = 0.25 // 5 with weight 20 (steel)
	sharp = 1
	edge = 1
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	origin_tech = "{'" + TECH_MATERIAL + "':2,'" + TECH_COMBAT + "':2}"
	attack_verb = list("chopped", "sliced", "cut", "reaped")
	base_worth = 20


/obj/item/material/cross
	name = "cross"
	desc = "It's a cross, commonly used as a holy symbol by Christians."
	icon_state = "cross"
	max_force = 5
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("attacked", "bashed")

/obj/item/material/cross/wood
	material = MAT_WOOD

/obj/item/material/cross/silver
	material = MAT_SILVER

/obj/item/material/cross/gold
	material = MAT_GOLD