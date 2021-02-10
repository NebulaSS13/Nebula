/obj/item/robot_module/uncertified
	name = "uncertified robot module"
	sprites = list(
		"Roller" = "omoikane"
	)
	upgrade_locked = TRUE
	skills = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_PROF
	) // For the money launcher, of course

/obj/item/robot_module/uncertified/party
	name = "Madhouse Productions Official Party Module"
	display_name = "Party"
	channels = list(
		"Service" = TRUE,
		"Entertainment" = TRUE
	)
	networks = list(
		NETWORK_THUNDER
	)
	equipment = list(
		/obj/item/boombox,
		/obj/item/bikehorn/airhorn,
		/obj/item/party_light,
		/obj/item/gun/hand/money
	)

/obj/item/robot_module/uncertified/party/finalize_equipment()
	. = ..()
	var/obj/item/gun/MC = new /obj/item/gun/hand/money(src)
	var/obj/item/firearm_component/receiver/launcher/money/rec = MC.receiver
	if(istype(rec))
		rec.receptacle_value = 5000
		rec.dispensing = 100
