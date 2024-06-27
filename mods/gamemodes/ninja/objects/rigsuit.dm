/obj/item/rig/light/ninja
	name = "ominous suit control module"
	desc = "A unique, vaccum-proof suit of nano-enhanced armor designed specifically for assassins."
	suit_type = "ominous"
	icon = 'icons/clothing/rigs/rig_ninja.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED
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

	req_access = list(access_ninja)

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
	var/input = sanitize_safe(input("What do you want to name your suit?", "Rename suit"), MAX_NAME_LEN)
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
	var/input = sanitize_safe(input("Please describe your voidsuit in 128 letters or less.", "write description"), MAX_DESC_LEN)
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

// Modules
// Ninja throwing star launcher
/obj/item/rig_module/fabricator/ninja
	interface_name = "death blossom launcher"
	interface_desc = "An integrated microfactory that produces poisoned throwing stars from thin air and electricity."
	fabrication_type = /obj/item/star/ninja

/obj/item/star/ninja
	material = /decl/material/solid/metal/uranium

// Ninja energy blade projector
/obj/item/rig_module/mounted/energy_blade/ninja
	interface_name = "spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer or launch radioactive darts."
	gun = /obj/item/gun/energy/crossbow/ninja/mounted

/obj/item/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart
	max_shots = 5

/obj/item/gun/energy/crossbow/ninja/mounted
	use_external_power = 1
	has_safety = FALSE

// Ninja chemical injector
/obj/item/rig_module/chem_dispenser/ninja
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream. This variant is made to be extremely light and flexible."

	//just over a syringe worth of each. Want more? Go refill. Gives the ninja another reason to have to show their face.
	charges = list(
		list("oxygen",       "oxygel",       /decl/material/liquid/oxy_meds,          20),
		list("stabilizer",   "stabilizer",   /decl/material/liquid/stabilizer,        20),
		list("antitoxins",   "antitoxins",   /decl/material/liquid/antitoxins,        20),
		list("glucose",      "glucose",      /decl/material/liquid/nutriment/glucose, 80),
		list("antirads",     "antirads",     /decl/material/liquid/antirads,          20),
		list("regenerative", "regenerative", /decl/material/liquid/burn_meds,         20),
		list("antibiotics",  "antibiotics",  /decl/material/liquid/antibiotics,       20),
		list("painkillers",  "painkillers",  /decl/material/liquid/painkillers,       20)
	)

// Ninja grenade launcher. Doesn't show up visually. Stealthy!
/obj/item/rig_module/grenade_launcher/ninja
	suit_overlay = null