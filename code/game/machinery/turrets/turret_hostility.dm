/decl/hostility/turret/can_special_target(atom/movable/target)
	if(isliving(target))
		return TRUE

// Network turret hostility
/decl/hostility/turret/network
	var/static/threat_level_threshold = 4

/decl/hostility/turret/network/can_special_target(atom/holder, atom/movable/target)
	var/obj/machinery/turret/network/owner = holder
	if(!istype(holder))
		log_error("Network turret hostility referenced with a non turret holder: [holder]!")
		return
	if(!ishuman(target))
		// Attack any living, non-small/silicon/human target.
		if(owner.check_lifeforms)
			if(isliving(target) && (!issilicon(target) && !issmall(target)))
				return TRUE
		return FALSE

	var/mob/living/L = target
	return L.assess_perp(holder, owner.check_access, owner.check_weapons, owner.check_records, owner.check_arrest, TRUE) >= threat_level_threshold
