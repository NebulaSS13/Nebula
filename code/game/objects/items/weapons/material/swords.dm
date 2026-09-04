/obj/item/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/items/weapon/swords/claymore.dmi'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_LARGE
	item_flags = ITEM_FLAG_IS_WEAPON
	armor_penetration = 10
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	base_parry_chance = 50
	melee_accuracy_bonus = 10
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	pickup_sound = 'sound/foley/knife1.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'
	_base_attack_force = 15
	var/draw_handle = TRUE

/obj/item/sword/set_edge(new_edge)
	. = ..()
	if(. && !has_edge())
		attack_verb = list("attacked", "stabbed", "jabbed", "smacked", "prodded")
		hitsound = 'sound/weapons/pierce.ogg'

/obj/item/sword/set_sharp(new_sharp)
	. = ..()
	if(. && !is_sharp())
		attack_verb = list("attacked", "smashed", "jabbed", "smacked", "prodded", "bonked")
		hitsound = "chop"

/obj/item/sword/on_update_icon()
	. = ..()
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		if(draw_handle && check_state_in_icon("[icon_state]_handle", icon))
			add_overlay(mutable_appearance(icon, "[icon_state]_handle"))
		if(material.reflectiveness >= MAT_VALUE_SHINY && check_state_in_icon("[icon_state]_shine", icon))
			add_overlay(mutable_appearance(icon, "[icon_state]_shine"), adjust_brightness(color, 20 + material.reflectiveness))

/obj/item/sword/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	//Do not color scabbarded blades
	if(overlay && (material_alteration & MAT_FLAG_ALTERATION_COLOR) && (slot == slot_back_str || slot == slot_belt_str))
		overlay.color = null
	. = ..()

/obj/item/sword/wood
	material = /decl/material/solid/organic/wood/oak
	draw_handle = FALSE

/obj/item/sword/replica
	material = /decl/material/solid/organic/plastic
	_base_attack_force = 5

/obj/item/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon = 'icons/obj/items/weapon/swords/katana.dmi'
	slot_flags = SLOT_LOWER_BODY | SLOT_BACK
	_base_attack_force = 15

/obj/item/sword/katana/set_material(new_material)
	. = ..()
	if((material_alteration & MAT_FLAG_ALTERATION_NAME) && istype(material, /decl/material/solid/organic/wood))
		SetName("[material.solid_name] bokutou")
		desc = "Finest wooden fibers folded exactly one thousand times by master robots."

/obj/item/sword/katana/bamboo
	material = /decl/material/solid/organic/wood/bamboo
	draw_handle = FALSE

/obj/item/sword/katana/wood
	material = /decl/material/solid/organic/wood/oak
	draw_handle = FALSE

/obj/item/sword/katana/vibro
	name = "vibrokatana"
	desc = "A high-tech take on a woefully underpowered weapon. Can't mistake its sound for anything."
	material = /decl/material/solid/metal/titanium
	hitsound = 'sound/weapons/anime_sword.wav'
	pickup_sound = 'sound/weapons/katana_out.wav'
	_base_attack_force = 30

/obj/item/sword/katana/vibro/pickup_sound_callback()
	if(ismob(loc) && pickup_sound)
		playsound(src, pickup_sound, 50, -1, 5)
