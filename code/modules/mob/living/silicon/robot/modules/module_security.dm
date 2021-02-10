/obj/item/robot_module/security
	associated_department = /decl/department/security
	channels = list(
		"Security" = TRUE
	)
	networks = list(
		NETWORK_SECURITY
	)
	software = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/digitalwarrant
	)
	can_be_pushed = FALSE
	supported_upgrades = list(
		/obj/item/borg/upgrade/weaponcooler
	)
	skills = list(
		SKILL_LITERACY    = SKILL_ADEPT,
		SKILL_COMBAT      = SKILL_EXPERT,
		SKILL_WEAPONS     = SKILL_EXPERT,
		SKILL_FORENSICS   = SKILL_EXPERT
	)

/obj/item/robot_module/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	for(var/obj/item/gun/T in equipment)
		var/obj/item/firearm_component/receiver/energy/rec = T.receiver
		var/obj/item/firearm_component/barrel/energy/bar = T.barrel
		if(istype(rec) && istype(bar) && rec.power_supply)
			if(rec.power_supply.charge < rec.power_supply.maxcharge)
				rec.power_supply.give(bar.charge_cost * amount)
				rec.update_icon()
			else
				rec.charge_tick = 0
	var/obj/item/baton/robot/B = locate() in equipment
	if(B && B.bcell)
		B.bcell.give(amount)

/obj/item/robot_module/security/general
	name = "security robot module"
	display_name = "Security"
	crisis_locked = TRUE
	sprites = list(
		"Basic" = "secborg",
		"Red Knight" = "Security",
		"Black Knight" = "securityrobot",
		"Bloodhound" = "bloodhound",
		"Bloodhound - Treaded" = "secborg+tread",
		"Tridroid" = "orb-security"
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/hud/sec,
		/obj/item/handcuffs/cyborg,
		/obj/item/baton/robot,
		/obj/item/gun/hand/egun/secure/mounted,
		/obj/item/taperoll/police,
		/obj/item/megaphone,
		/obj/item/holowarrant,
		/obj/item/crowbar,
		/obj/item/hailer
	)
	emag = /obj/item/gun/long/laser/mounted

/obj/item/robot_module/security/combat
	name = "combat robot module"
	display_name = "Combat"
	crisis_locked = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Combat Android" = "droid-combat"
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/thermal,
		/obj/item/gun/long/laser/mounted,
		/obj/item/gun/hand/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
		/obj/item/crowbar
	)
	emag = /obj/item/gun/cannon/laser/mounted
