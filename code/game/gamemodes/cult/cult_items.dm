/obj/item/sword/cultblade
	name = "cult blade"
	desc = "An arcane weapon wielded by the followers of Nar-Sie."
	icon = 'icons/obj/items/weapon/swords/cult.dmi'
	applies_material_colour = FALSE
	applies_material_name = FALSE

/obj/item/sword/cultblade/attack(mob/living/M, mob/living/user, var/target_zone)

	var/decl/special_role/godcult = decls_repository.get_decl(/decl/special_role/godcultist)
	if(iscultist(user) || (user.mind in godcult.current_antagonists))
		return ..()

	var/zone = user.get_active_held_item_slot()

	var/obj/item/organ/external/affecting = null
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		affecting = H.get_organ(zone)

	if(affecting)
		to_chat(user, "<span class='danger'>An unexplicable force rips through your [affecting.name], tearing the sword from your grasp!</span>")
	else
		to_chat(user, "<span class='danger'>An unexplicable force rips through you, tearing the sword from your grasp!</span>")

	//random amount of damage between half of the blade's force and the full force of the blade.
	user.apply_damage(rand(force/2, force), BRUTE, zone, (DAM_SHARP|DAM_EDGE), armor_pen = 100)
	user.Weaken(5)

	if(user.unEquip(src))
		throw_at(get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(loc, spooky, 50, 1)

	return 1

/obj/item/sword/cultblade/pickup(mob/living/user)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>An overwhelming feeling of dread comes over you as you pick up the cultist's sword. It would be wise to be rid of this blade quickly.</span>")
		user.make_dizzy(120)


/obj/item/clothing/head/culthood
	name = "cult hood"
	desc = "A hood worn by the followers of Nar-Sie."

	icon = 'icons/clothing/head/cult.dmi'
	flags_inv = HIDEFACE
	body_parts_covered = SLOT_HEAD
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL
	)
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.8 //That's a pretty cool opening in the hood. Also: Cloth making physical contact to the skull.

/obj/item/clothing/head/culthood/magus
	name = "magus helm"
	desc = "A helm worn by the followers of Nar-Sie."
	icon = 'icons/clothing/head/wizard/magus.dmi'
	flags_inv = HIDEFACE | BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT
	)

/obj/item/clothing/head/culthood/alt
	icon = 'icons/clothing/head/cult_alt.dmi'

/obj/item/clothing/suit/cultrobes
	name = "cult robes"
	icon = 'icons/clothing/suit/cult.dmi'
	desc = "A set of durable robes worn by the followers of Nar-Sie."
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	allowed = list(/obj/item/book/tome,/obj/item/sword/cultblade)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.6

/obj/item/clothing/suit/cultrobes/alt
	icon = 'icons/clothing/suit/cult_alt.dmi'

/obj/item/clothing/suit/cultrobes/magusred
	name = "magus robes"
	desc = "A set of plated robes worn by the followers of Nar-Sie."
	icon = 'icons/clothing/suit/wizard/magusred.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/suit/cultrobes/magusred/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

/obj/item/clothing/head/helmet/space/cult
	name = "cult helmet"
	desc = "A space worthy helmet used by the followers of Nar-Sie."
	icon = 'icons/clothing/spacesuit/cult/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	) //Real tanky shit.
	siemens_coefficient = 0.3 //Bone is not very conducive to electricity.

/obj/item/clothing/suit/space/cult
	name = "cult armour"
	desc = "A bulky suit of armour, bristling with spikes. It looks space proof."
	icon = 'icons/clothing/spacesuit/cult/suit.dmi'
	allowed = list(/obj/item/book/tome,/obj/item/sword/cultblade,/obj/item/tank,/obj/item/suit_cooling_unit)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.2
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS|SLOT_HANDS

/obj/item/clothing/suit/space/cult/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)