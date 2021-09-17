/obj/item/robot_module/uncertified
	name = "uncertified robot module"
	module_sprites = list("Roller" = 'icons/mob/robots/robot_service_bro.dmi') //sadly rollersprites seem to have been lost
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
		/obj/item/gun/launcher/money
	)

/obj/item/robot_module/uncertified/party/finalize_equipment()
	. = ..()
	var/obj/item/gun/launcher/money/MC = new (src)
	MC.receptacle_value = 5000
	MC.dispensing = 100
