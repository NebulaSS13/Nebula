/obj/item/clothing/gloves/ring/aura_ring
	var/obj/aura/granted_aura

/obj/item/clothing/gloves/ring/aura_ring/equipped(var/mob/living/L, var/slot)
	..()
	if(granted_aura && slot == slot_gloves_str)
		L.add_aura(granted_aura)

/obj/item/clothing/gloves/ring/aura_ring/dropped(var/mob/living/L)
	..()
	if(granted_aura)
		L.remove_aura(granted_aura)

/obj/item/clothing/gloves/ring/aura_ring/Destroy()
	QDEL_NULL(granted_aura)
	. = ..()

/obj/item/clothing/gloves/ring/aura_ring/talisman_of_starborn
	name = "Talisman of the Starborn"
	desc = "This ring seems to shine with more light than is put on it."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_star.dmi'

/obj/item/clothing/gloves/ring/aura_ring/talisman_of_starborn/Initialize()
	. = ..()
	granted_aura = new /obj/aura/starborn()

/obj/item/clothing/gloves/ring/aura_ring/talisman_of_blueforged
	name = "Talisman of the Blueforged"
	desc = "The gem on this ring is quite peculiar..."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_blue.dmi'

/obj/item/clothing/gloves/ring/aura_ring/talisman_of_blueforged/Initialize()
	. = ..()
	granted_aura = new /obj/aura/blueforge_aura()

/obj/item/clothing/gloves/ring/aura_ring/talisman_of_shadowling
	name = "Talisman of the Shadowling"
	desc = "If you weren't looking at this, you probably wouldn't have noticed it."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_shadow.dmi'

/obj/item/clothing/gloves/ring/aura_ring/talisman_of_shadowling/Initialize()
	. = ..()
	granted_aura = new /obj/aura/shadowling_aura()

/obj/item/clothing/suit/armor/sunsuit
	name = "knight's armor"
	desc = "Now, you can be the knight in shining armor you've always wanted to be. With complementary sun insignia."
	icon = 'icons/clothing/suits/deity/star_champion.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_AP,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/head/helmet/sunhelm
	name = "knight's helm"
	desc = "It's a shiny metal helmet. It looks ripped straight out of the Dark Ages, actually."
	icon = 'icons/clothing/head/star_champion.dmi'
	flags_inv = HIDEEARS | BLOCK_ALL_HAIR

/obj/item/clothing/suit/armor/sunrobe
	name = "oracle's robe"
	desc = "The robes of a priest. One that praises the sun, apparently. Well, it certainly reflects light well."
	icon = 'icons/clothing/suits/deity/star_oracle.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/suit/armor/sunrobe/Initialize()
	. = ..()
	set_light(4, 0.3)

/obj/item/clothing/suit/space/shadowsuit
	name = "traitor's cloak"
	desc = "There is absolutely nothing visible through the fabric. The shadows stick to your skin when you touch it."
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	min_pressure_protection = 0
	icon = 'icons/clothing/suits/deity/star_traitor.dmi'

/obj/item/clothing/head/helmet/space/shadowhood
	name = "traitor's hood"
	desc = "No light can pierce this hood. It's unsettling."
	icon = 'icons/clothing/head/star_traitor.dmi'
	flags_inv = HIDEEARS | BLOCK_ALL_HAIR

/obj/item/knife/ritual/shadow
	name = "black death"
	desc = "An obsidian dagger. The singed remains of a green cloth are wrapped around the 'handle.'"
	var/charge = 5

/obj/item/knife/ritual/shadow/apply_hit_effect(var/mob/living/target, var/mob/living/user, var/hit_zone)
	. = ..()
	if(charge)
		if(target.get_damage(BRUTE) > 15)
			var/datum/reagents/R = target.reagents
			if(!R)
				return
			R.add_reagent(/decl/material/liquid/venom, 5)
			new /obj/effect/temporary(get_turf(target),3, 'icons/effects/effects.dmi', "fire_goon")
			charge--
	else
		user.take_damage(5, BURN)
		if(prob(5))
			to_chat(user, SPAN_WARNING("\The [src] appears to be out of power!"))
		new /obj/effect/temporary(get_turf(user),3, 'icons/effects/effects.dmi', "fire_goon")

/obj/item/gun/energy/staff/beacon
	name = "holy beacon"
	desc = "Look closely into its crystal; there's a miniature sun. Or maybe that's just some fancy LEDs. Either way, it looks thoroughly mystical."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "starstaff"
	self_recharge = 0
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/flash
	required_antag_type = /decl/special_role/godcultist

/obj/item/sword/blazing
	name = "blazing blade"
	icon = 'icons/obj/items/weapon/swords/flaming.dmi'
	atom_damage_type =  BURN
	material_alteration = MAT_FLAG_ALTERATION_NONE
	var/last_near_structure = 0
	var/mob/living/deity/linked

/obj/item/sword/blazing/Initialize(var/maploading, var/material, var/deity)
	. = ..()
	START_PROCESSING(SSobj, src)
	linked = deity

/obj/item/sword/blazing/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/sword/blazing/Process()
	if(!linked || last_near_structure + 10 SECONDS > world.time)
		return

	if(linked.near_structure(src,1))
		if(last_near_structure < world.time - 30 SECONDS)
			to_chat(loc, SPAN_NOTICE("\The [src] surges with power anew!"))
		last_near_structure = world.time
	else
		if(last_near_structure < world.time - 30 SECONDS) //If it has been at least 30 seconds.
			if(prob(5))
				to_chat(loc, SPAN_WARNING("\The [src] begins to fade, its power dimming this far away from a shrine."))
		else if(last_near_structure + 1800 < world.time)
			visible_message(SPAN_WARNING("\The [src] disintegrates into a pile of ash!"))
			new /obj/effect/decal/cleanable/ash(get_turf(src))
			qdel(src)
