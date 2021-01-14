// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/rig/light
	name = "light suit control module"
	desc = "A lighter, less armoured rig suit."
	suit_type = "light suit"
	icon = 'icons/clothing/rigs/rig_light.dmi'
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/cell)
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.4
	emp_protection = 10
	online_slowdown = 0
	item_flags = ITEM_FLAG_THICKMATERIAL
	offline_slowdown = TINT_NONE
	offline_vision_restriction = TINT_NONE
	max_pressure_protection = LIGHT_RIG_MAX_PRESSURE
	min_pressure_protection = 0

	chest =  /obj/item/clothing/suit/space/rig/light
	helmet = /obj/item/clothing/head/helmet/space/rig/light
	boots =  /obj/item/clothing/shoes/magboots/rig/light
	gloves = /obj/item/clothing/gloves/rig/light

/obj/item/clothing/suit/space/rig/light
	name = "suit"
	breach_threshold = 18 //comparable to voidsuits
	icon = 'icons/clothing/rigs/chests/chest_light.dmi'
/obj/item/clothing/gloves/rig/light
	name = "gloves"
	icon = 'icons/clothing/rigs/gloves/gloves_light.dmi'
/obj/item/clothing/shoes/magboots/rig/light
	name = "shoes"
	icon = 'icons/clothing/rigs/boots/boots_light.dmi'
/obj/item/clothing/head/helmet/space/rig/light
	name = "hood"
	icon = 'icons/clothing/rigs/helmets/helmet_light.dmi'

/obj/item/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon = 'icons/clothing/rigs/rig_hacker.dmi'
	req_access = list(access_syndicate)
	airtight = 0
	seal_delay = 5 //not being vaccum-proof has an upside I guess

	helmet = /obj/item/clothing/head/lightrig/hacker
	chest =  /obj/item/clothing/suit/lightrig/hacker
	gloves = /obj/item/clothing/gloves/lightrig/hacker
	boots =  /obj/item/clothing/shoes/lightrig/hacker

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/cooling_unit
		)

//The cybersuit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/lightrig/hacker
	name = "HUD"
	item_flags = 0
	icon = 'icons/clothing/rigs/helmets/helmet_hacker.dmi'
/obj/item/clothing/suit/lightrig/hacker
	siemens_coefficient = 0.2
	icon = 'icons/clothing/rigs/chests/chest_hacker.dmi'
/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.2
	item_flags = ITEM_FLAG_NOSLIP //All the other rigs have magboots anyways, hopefully gives the hacker suit something more going for it.
	icon = 'icons/clothing/rigs/boots/boots_hacker.dmi'
/obj/item/clothing/gloves/lightrig/hacker
	siemens_coefficient = 0
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'icons/clothing/rigs/gloves/gloves_hacker.dmi'

/obj/item/rig/light/ninja
	name = "ominous suit control module"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for assassins."
	suit_type = "ominous"
	icon = 'icons/clothing/rigs/rig_ninja.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED
		)
	siemens_coefficient = 0.2 //heavy hardsuit level shock protection
	emp_protection = 40 //change this to 30 if too high.
	online_slowdown = 0
	aimove_power_usage = 50

	helmet = /obj/item/clothing/head/helmet/space/rig/light/ninja
	boots =  /obj/item/clothing/shoes/magboots/rig/light/ninja
	chest =  /obj/item/clothing/suit/space/rig/light/ninja
	gloves = /obj/item/clothing/gloves/rig/light/ninja
	cell =   /obj/item/cell/hyper

	req_access = list(access_syndicate)

	initial_modules = list(
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/grenade_launcher/ninja,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/self_destruct,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/light/ninja/verb/rename_suit()
	set name = "Name Ninja Suit"
	set desc = "Rename your black voidsuit."
	set category = "Object"
	var/mob/M = usr
	if(!M.mind) return 0
	if(M.incapacitated()) return 0
	var/input = sanitizeSafe(input("What do you want to name your suit?", "Rename suit"), MAX_NAME_LEN)
	if(src && input && !M.incapacitated() && in_range(M,src))
		if(!findtext(input, "the", 1, 4))
			input = "\improper [input]"
		SetName(input)
		to_chat(M, "Suit naming succesful!")
		verbs -= /obj/item/rig/light/ninja/verb/rename_suit
		return 1


/obj/item/rig/light/ninja/verb/rewrite_suit_desc()
	set name = "Describe Ninja suit"
	set desc = "Give your voidsuit a custom description."
	set category = "Object"
	var/mob/M = usr
	if(!M.mind) return 0
	if(M.incapacitated()) return 0
	var/input = sanitizeSafe(input("Please describe your voidsuit in 128 letters or less.", "write description"), MAX_DESC_LEN)
	if(src && input && !M.incapacitated() && in_range(M,src))
		desc = input
		to_chat(M, "Suit description succesful!")
		verbs -= /obj/item/rig/light/ninja/verb/rename_suit
		return 1

/obj/item/clothing/gloves/rig/light/ninja
	name = "insulated gloves"
	siemens_coefficient = 0
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'icons/clothing/rigs/gloves/gloves_ninja.dmi'
/obj/item/clothing/suit/space/rig/light/ninja
	icon = 'icons/clothing/rigs/chests/chest_ninja.dmi'
/obj/item/clothing/shoes/magboots/rig/light/ninja
	icon = 'icons/clothing/rigs/boots/boots_ninja.dmi'
/obj/item/clothing/head/helmet/space/rig/light/ninja
	icon = 'icons/clothing/rigs/helmets/helmet_ninja.dmi'

/obj/item/rig/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	req_access = list(access_syndicate)
	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision
	)
