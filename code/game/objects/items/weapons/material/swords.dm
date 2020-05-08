/obj/item/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "world"
	icon = 'icons/obj/items/weapon/swords/claymore.dmi'
	on_mob_icon = 'icons/obj/items/weapon/swords/claymore.dmi'
	slot_flags = SLOT_BELT
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
	var/draw_handle

/obj/item/material/sword/update_force()
	if(material?.hardness < MAT_VALUE_HARD)
		edge = 0
		attack_verb = list("attacked", "stabbed", "jabbed", "smacked", "prodded")
		hitsound = 'sound/weapons/pierce.ogg'
	if(material?.hardness < MAT_VALUE_RIGID)
		sharp = 0
		attack_verb = list("attacked", "smashed", "jabbed", "smacked", "prodded", "bonked")
		hitsound = "chop"
	. = ..()
	
/obj/item/material/sword/on_update_icon()
	. = ..()
	if(applies_material_colour)
		if(draw_handle)
			add_overlay(get_mutable_overlay(icon, "[icon_state]_handle"))
		if(material.reflectiveness >= MAT_VALUE_SHINY)
			add_overlay(get_mutable_overlay(icon, "[icon_state]_shine"), adjust_brightness(color, 20 + material.reflectiveness))

/obj/item/material/sword/experimental_mob_overlay(mob/user_mob, slot)
	var/image/res = ..()
	//Do not color scabbarded blades
	if(applies_material_colour && (slot == slot_back_str || slot == slot_belt_str))
		res.color = null
	return res

/obj/item/material/sword/wood
	material = MAT_WOOD
	draw_handle = FALSE

/obj/item/material/sword/replica
	material = MAT_PLASTIC

/obj/item/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	on_mob_icon = 'icons/obj/items/weapon/swords/katana.dmi'
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/katana/set_material(new_material)
	. = ..()
	if(applies_material_name && istype(material, /material/wood))
		SetName("[material.display_name] bokutou")
		desc = "Finest wooden fibers folded exactly one thousand times by master robots."
	
/obj/item/material/sword/katana/bamboo
	material = MAT_BAMBOO
	draw_handle = FALSE

/obj/item/material/sword/katana/wood
	material = MAT_WOOD
	draw_handle = FALSE

/obj/item/material/sword/katana/vibro
	name = "vibrokatana"
	desc = "A high-tech take on a woefully underpowered weapon. Can't mistake its sound for anything."
	material = MAT_TITANIUM
	hitsound = 'sound/weapons/anime_sword.wav'

/obj/item/material/sword/katana/vibro/equipped(mob/user, slot)
	if(slot == slot_l_hand || slot == slot_r_hand)
		playsound(src, 'sound/weapons/katana_out.wav', 50, 1, -5)
	