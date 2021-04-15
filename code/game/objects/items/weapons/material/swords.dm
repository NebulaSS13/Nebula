/obj/item/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/items/weapon/swords/claymore.dmi'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_LARGE
	material_force_multiplier = 0.5 // 30 when wielded with hardnes 60 (steel)
	armor_penetration = 10
	thrown_material_force_multiplier = 0.16 // 10 when thrown with weight 60 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	base_parry_chance = 50
	melee_accuracy_bonus = 10
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)
	applies_material_colour = TRUE
	applies_material_name = TRUE

	pickup_sound = 'sound/foley/knife1.ogg' 
	drop_sound = 'sound/foley/knifedrop3.ogg'

	var/draw_handle

/obj/item/sword/update_force()
	var/decl/material/material = get_primary_material()
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
	if(applies_material_colour)
		if(draw_handle && check_state_in_icon("[icon_state]_handle", icon))
			add_overlay(mutable_appearance(icon, "[icon_state]_handle"))
		var/decl/material/material = get_primary_material()
		if(material?.reflectiveness >= MAT_VALUE_SHINY && check_state_in_icon("[icon_state]_shine", icon))
			add_overlay(mutable_appearance(icon, "[icon_state]_shine"), adjust_brightness(color, 20 + material.reflectiveness))

/obj/item/sword/get_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	//Do not color scabbarded blades
	if(ret && applies_material_colour && (slot == slot_back_str || slot == slot_belt_str))
		ret.color = null
	return ret

/obj/item/sword/wood
	material_composition = list(/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY)
	draw_handle = FALSE

/obj/item/sword/replica
	material_composition = list(/decl/material/solid/plastic = MATTER_AMOUNT_PRIMARY)

/obj/item/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon = 'icons/obj/items/weapon/swords/katana.dmi'
	slot_flags = SLOT_LOWER_BODY | SLOT_BACK

/obj/item/sword/katana/Initialize(ml, material_key)
	. = ..()
	if(applies_material_name)
		var/decl/material/material = get_primary_material()
		if(istype(material, /decl/material/solid/wood))
			SetName("[material.solid_name] bokutou")
			desc = "Finest wooden fibers folded exactly 2056 times by master robots."

/obj/item/sword/katana/bamboo
	material_composition = list(/decl/material/solid/wood/bamboo = MATTER_AMOUNT_PRIMARY)
	draw_handle = FALSE

/obj/item/sword/katana/wood
	material_composition = list(/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY)
	draw_handle = FALSE

/obj/item/sword/katana/vibro
	name = "vibrokatana"
	desc = "A high-tech take on a woefully underpowered weapon. Can't mistake its sound for anything."
	material_composition = list(/decl/material/solid/metal/titanium = MATTER_AMOUNT_PRIMARY)
	hitsound = 'sound/weapons/anime_sword.wav'
	pickup_sound = 'sound/weapons/katana_out.wav'

/obj/item/sword/katana/vibro/pickup_sound_callback()
	if(ismob(loc) && pickup_sound)
		playsound(src, pickup_sound, 50, -1, 5)
