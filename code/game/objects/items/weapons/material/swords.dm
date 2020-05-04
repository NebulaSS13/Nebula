/obj/item/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon = 'icons/obj/items/weapon/broadswords.dmi'
	icon_state = "claymore"
	item_state = "claymore"
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

/obj/item/material/sword/replica
	max_force = 10
	edge = 0
	sharp = 0
	material_force_multiplier = 0.2
	thrown_material_force_multiplier = 0.1

/obj/item/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon = 'icons/obj/items/weapon/katana.dmi'
	icon_state = "katana"
	item_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/katana/replica
	max_force = 10
	edge = 0
	sharp = 0
	material_force_multiplier = 0.2
	thrown_material_force_multiplier = 0.1

/obj/item/material/sword/katana/vibro
	name = "vibrokatana"
	desc = "A high-tech take on a woefully underpowered weapon. Can't mistake its sound for anything."
	material = MAT_TITANIUM
	hitsound = 'sound/weapons/anime_sword.wav'

/obj/item/material/sword/katana/vibro/equipped(mob/user, slot)
	if(slot == slot_l_hand || slot == slot_r_hand)
		playsound(src, 'sound/weapons/katana_out.wav', 50, 1, -5)
	