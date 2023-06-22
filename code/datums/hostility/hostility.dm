// A singleton useful for recycling hostility logic in things such as mobs or turrets.
/decl/hostility

// Returns a value determining whether or not whatever is calling should attack the target.
// Don't override this, go override `can_special_target()`, as this proc has 'the basics' that everything should use.
/decl/hostility/proc/can_target(atom/holder, atom/movable/target)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = TRUE
	if(!istype(target))
		return FALSE
	if(isobserver(target))
		return FALSE

	if(isliving(target))
		var/mob/living/L = target
		if(L.stat)
			return FALSE

		if(isliving(holder))
			var/mob/living/H = holder
			if(L.faction == H.faction)
				return FALSE

	return can_special_target(holder, target)

// Override this for subtypes.
/decl/hostility/proc/can_special_target(atom/holder, atom/movable/target)
	return TRUE


// Aggressive towards humans wearing the opposite lasertag vest.
/decl/hostility/laser_tag
	var/enemy_vest_type = null

/decl/hostility/laser_tag/can_special_target(atom/holder, atom/movable/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(enemy_vest_type && istype(H.get_equipped_item(slot_wear_suit_str), enemy_vest_type))
			return TRUE
	return FALSE

/decl/hostility/laser_tag/red
	enemy_vest_type = /obj/item/clothing/suit/bluetag

/decl/hostility/laser_tag/blue
	enemy_vest_type = /obj/item/clothing/suit/redtag


// Hostile to whatever is too sus.
/decl/hostility/securitron
	var/threat_level_threshold = 4
	var/access_check = access_security
	var/check_weapons = FALSE
	var/check_no_record = FALSE
	var/check_wanted = TRUE

/decl/hostility/securitron/can_special_target(atom/holder, atom/movable/target)
	if(isliving(target))
		var/mob/living/L = target
		if(iscuffed(L))
			return FALSE
		return L.assess_perp(holder, access_security, check_weapons, check_no_record, check_wanted) < threat_level_threshold
	return FALSE