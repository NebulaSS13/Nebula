/obj/item/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/items/weapon/swords/claymore.dmi'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_LARGE
	item_flags = ITEM_FLAG_IS_WEAPON
	material_force_multiplier = 0.5 // 30 when wielded with hardnes 60 (steel)
	armor_penetration = 10
	thrown_material_force_multiplier = 0.16 // 10 when thrown with weight 60 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	base_parry_chance = 50
	melee_accuracy_bonus = 10
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	pickup_sound = 'sound/foley/knife1.ogg'
	drop_sound = 'sound/foley/knifedrop3.ogg'

	var/draw_handle = TRUE

/obj/item/sword/update_force()
	sharp = initial(sharp)
	edge = initial(edge)
	hitsound = initial(hitsound)
	if(material?.hardness < MAT_VALUE_HARD)
		edge = 0
		attack_verb = list("attacked", "stabbed", "jabbed", "smacked", "prodded")
		hitsound = 'sound/weapons/pierce.ogg'
	if(material?.hardness < MAT_VALUE_RIGID)
		sharp = 0
		attack_verb = list("attacked", "smashed", "jabbed", "smacked", "prodded", "bonked")
		hitsound = "chop"
	. = ..()

/obj/item/sword/on_update_icon()
	. = ..()
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		if(draw_handle && check_state_in_icon("[icon_state]_handle", icon))
			add_overlay(mutable_appearance(icon, "[icon_state]_handle"))
		if(material.reflectiveness >= MAT_VALUE_SHINY && check_state_in_icon("[icon_state]_shine", icon))
			add_overlay(mutable_appearance(icon, "[icon_state]_shine"), adjust_brightness(color, 20 + material.reflectiveness))

/obj/item/sword/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	//Do not color scabbarded blades
	if(overlay && (material_alteration & MAT_FLAG_ALTERATION_COLOR) && (slot == slot_back_str || slot == slot_belt_str))
		overlay.color = null
	. = ..()

/obj/item/sword/wood
	material = /decl/material/solid/wood
	draw_handle = FALSE

/obj/item/sword/replica
	material = /decl/material/solid/plastic

/obj/item/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon = 'icons/obj/items/weapon/swords/katana.dmi'
	slot_flags = SLOT_LOWER_BODY | SLOT_BACK

/obj/item/sword/katana/set_material(new_material)
	. = ..()
	if((material_alteration & MAT_FLAG_ALTERATION_NAME) && istype(material, /decl/material/solid/wood))
		SetName("[material.solid_name] bokutou")
		desc = "Finest wooden fibers folded exactly one thousand times by master robots."

/obj/item/sword/katana/bamboo
	material = /decl/material/solid/wood/bamboo
	draw_handle = FALSE

/obj/item/sword/katana/wood
	material = /decl/material/solid/wood
	draw_handle = FALSE

/obj/item/sword/katana/vibro
	name = "vibrokatana"
	desc = "A high-tech take on a woefully underpowered weapon. Can't mistake its sound for anything."
	material = /decl/material/solid/metal/titanium
	hitsound = 'sound/weapons/anime_sword.wav'
	pickup_sound = 'sound/weapons/katana_out.wav'

/obj/item/sword/katana/vibro/pickup_sound_callback()
	if(ismob(loc) && pickup_sound)
		playsound(src, pickup_sound, 50, -1, 5)
