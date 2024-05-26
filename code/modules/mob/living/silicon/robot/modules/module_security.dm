/obj/item/robot_module/security
	channels = list(
		"Security" = TRUE
	)
	camera_channels = list(
		CAMERA_CHANNEL_SECURITY
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
	for(var/obj/item/gun/energy/T in equipment)
		var/obj/item/cell/power_supply = T.get_cell()
		if(power_supply.charge < power_supply.maxcharge)
			power_supply.give(T.charge_cost * amount)
			update_icon()
		else
			T.charge_tick = 0

/obj/item/robot_module/security/general
	name = "security robot module"
	display_name = "Security"
	crisis_locked = TRUE
	module_sprites = list(
		"Basic"                = 'icons/mob/robots/robot_security_old.dmi',
		"Black Knight"         = 'icons/mob/robots/robot_secborg.dmi',
		"Bloodhound"           = 'icons/mob/robots/robot_security.dmi',
		"Bloodhound - Treaded" = 'icons/mob/robots/robot_security_tread.dmi',
		"Tridroid"             = 'icons/mob/robots/robot_orb.dmi'
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/hud/sec,
		/obj/item/handcuffs/cyborg,
		/obj/item/baton/robot,
		/obj/item/gun/energy/gun/secure/mounted,
		/obj/item/stack/tape_roll/barricade_tape/police,
		/obj/item/megaphone,
		/obj/item/holowarrant,
		/obj/item/crowbar,
		/obj/item/hailer
	)
	emag = /obj/item/gun/energy/laser/mounted

/obj/item/robot_module/security/combat
	name = "combat robot module"
	display_name = "Combat"
	crisis_locked = TRUE
	hide_on_manifest = TRUE
	module_sprites = list(
		"Combat Android" = 'icons/mob/robots/robot_combat.dmi'
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/thermal,
		/obj/item/gun/energy/laser/mounted,
		/obj/item/gun/energy/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
		/obj/item/crowbar
	)
	emag = /obj/item/gun/energy/lasercannon/mounted
