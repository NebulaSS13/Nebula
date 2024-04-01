/*
 * Defines the helmets, gloves and shoes for rigs.
 */
/mob/proc/check_rig_status(check_offline)
	return 0

/mob/living/carbon/human/check_rig_status(check_offline)
	var/obj/item/rig/rig = get_rig()
	if(!rig || rig.canremove)
		return 0 //not wearing a rig control unit or it's offline or unsealed
	if(check_offline)
		return !rig.offline
	return 1

/obj/item/clothing/head/helmet/space/rig
	name = "helmet"
	item_flags = ITEM_FLAG_THICKMATERIAL
	flags_inv = 		 HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	heat_protection =    SLOT_HEAD|SLOT_FACE|SLOT_EYES
	cold_protection =    SLOT_HEAD|SLOT_FACE|SLOT_EYES
	brightness_on = 4
	light_wedge = LIGHT_WIDE
	bodytype_equip_flags = null

/obj/item/clothing/head/helmet/space/rig/on_update_icon(mob/user)
	. = ..()
	icon_state = get_world_inventory_state()
	if(user?.check_rig_status() && check_state_in_icon("[icon_state]-sealed", icon))
		icon_state = "[icon_state]-sealed"

/obj/item/clothing/head/helmet/space/rig/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && user_mob?.check_rig_status() && check_state_in_icon("[overlay.icon_state]-sealed", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-sealed"
	. = ..()

/obj/item/clothing/gloves/rig
	name = "gauntlets"
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	body_parts_covered = SLOT_HANDS
	heat_protection =    SLOT_HANDS
	cold_protection =    SLOT_HANDS
	bodytype_equip_flags = null
	gender = PLURAL

/obj/item/clothing/gloves/rig/on_update_icon(mob/user)
	. = ..()
	icon_state = get_world_inventory_state()
	if(user?.check_rig_status() && check_state_in_icon("[icon_state]-sealed", icon))
		icon_state = "[icon_state]-sealed"

/obj/item/clothing/gloves/rig/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && user_mob?.check_rig_status() && check_state_in_icon("[overlay.icon_state]-sealed", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-sealed"
	. = ..()

/obj/item/clothing/shoes/magboots/rig
	name = "boots"
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	body_parts_covered = SLOT_FEET
	cold_protection = SLOT_FEET
	heat_protection = SLOT_FEET
	bodytype_equip_flags = null
	gender = PLURAL

/obj/item/clothing/shoes/magboots/rig/on_update_icon(mob/user)
	. = ..()
	icon_state = get_world_inventory_state()
	if(user?.check_rig_status() && check_state_in_icon("[icon_state]-sealed", icon))
		icon_state = "[icon_state]-sealed"

/obj/item/clothing/shoes/magboots/rig/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && user_mob?.check_rig_status() && check_state_in_icon("[overlay.icon_state]-sealed", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-sealed"
	. = ..()

/obj/item/clothing/suit/space/rig
	name = "chestpiece"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	heat_protection =    SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	cold_protection =    SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	// HIDEJUMPSUIT no longer needed, see "hides_uniform" and "update_component_sealed()" in rig.dm
	flags_inv =          HIDETAIL
	item_flags =         ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	//will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit. Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = 1
	var/list/supporting_limbs = list() //If not-null, automatically splints breaks. Checked when removing the suit.

/obj/item/clothing/suit/space/rig/on_update_icon(mob/user)
	. = ..()
	icon_state = get_world_inventory_state()
	if(user?.check_rig_status() && check_state_in_icon("[icon_state]-sealed", icon))
		icon_state = "[icon_state]-sealed"

/obj/item/clothing/suit/space/rig/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && user_mob?.check_rig_status() && check_state_in_icon("[overlay.icon_state]-sealed", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-sealed"
	. = ..()

/obj/item/clothing/suit/space/rig/equipped(mob/M)
	check_limb_support(M)
	..()

/obj/item/clothing/suit/space/rig/dropped(var/mob/user)
	check_limb_support(user)
	..()

// Some space suits are equipped with reactive membranes that support broken limbs
/obj/item/clothing/suit/space/rig/proc/can_support(var/mob/living/carbon/human/user)
	if(user.get_equipped_item(slot_wear_suit_str) != src)
		return 0 //not wearing the suit
	return user.check_rig_status(1)

/obj/item/clothing/suit/space/rig/check_limb_support(var/mob/living/carbon/human/user)

	// If this isn't set, then we don't need to care.
	if(!istype(user) || isnull(supporting_limbs))
		return

	if(can_support(user))
		for(var/obj/item/organ/external/E in user.bad_external_organs)
			if((E.body_part & body_parts_covered) && E.is_broken() && E.apply_splint(src))
				to_chat(user, "<span class='notice'>You feel [src] constrict about your [E.name], supporting it.</span>")
				supporting_limbs |= E
	else
		// Otherwise, remove the splints.
		for(var/obj/item/organ/external/E in supporting_limbs)
			if(E.splinted == src && E.remove_splint(src))
				to_chat(user, "<span class='notice'>\The [src] stops supporting your [E.name].</span>")
		supporting_limbs.Cut()

/obj/item/clothing/suit/space/rig/proc/handle_fracture(var/mob/living/carbon/human/user, var/obj/item/organ/external/E)
	if(!istype(user) || isnull(supporting_limbs) || !can_support(user))
		return
	if((E.body_part & body_parts_covered) && E.is_broken() && E.apply_splint(src))
		to_chat(user, "<span class='notice'>You feel [src] constrict about your [E.name], supporting it.</span>")
		supporting_limbs |= E


/obj/item/clothing/gloves/rig/Touch(var/atom/A, var/proximity)

	if(!A || !proximity)
		return 0

	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return 0

	var/obj/item/rig/suit = H.get_equipped_item(slot_back_str)
	if(!istype(suit) || !suit.installed_modules.len)
		return 0

	for(var/obj/item/rig_module/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A))
				return 1
	return 0

//Rig pieces for non-spacesuit based rigs

/obj/item/clothing/head/lightrig
	name = "mask"
	icon = 'icons/clothing/rigs/helmets/helmet_light.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	heat_protection =    SLOT_HEAD|SLOT_FACE|SLOT_EYES
	cold_protection =    SLOT_HEAD|SLOT_FACE|SLOT_EYES
	item_flags =         ITEM_FLAG_THICKMATERIAL|ITEM_FLAG_AIRTIGHT

/obj/item/clothing/suit/lightrig
	name = "suit"
	icon = 'icons/clothing/rigs/chests/chest_light.dmi'
	allowed = list(/obj/item/flashlight)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	heat_protection =    SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	cold_protection =    SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	flags_inv =          HIDEJUMPSUIT
	item_flags =         ITEM_FLAG_THICKMATERIAL

/obj/item/clothing/shoes/lightrig
	name = "boots"
	icon = 'icons/clothing/rigs/boots/boots_light.dmi'
	body_parts_covered = SLOT_FEET
	cold_protection = SLOT_FEET
	heat_protection = SLOT_FEET
	bodytype_equip_flags = null
	gender = PLURAL

/obj/item/clothing/gloves/lightrig
	name = "gloves"
	icon = 'icons/clothing/rigs/gloves/gloves_light.dmi'
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_HANDS
	heat_protection =    SLOT_HANDS
	cold_protection =    SLOT_HANDS
	bodytype_equip_flags = null
	gender = PLURAL
