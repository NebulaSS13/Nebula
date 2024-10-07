/decl/ability/wizard/conjure/grove
	name = "Grove"
	desc = "Creates a sanctuary of nature around the wizard as well as creating a healing plant."

	ignore_space_turfs = TRUE
	charge_max = 1200
	school = "transmutation"

	range = 1
	cooldown_min = 600

	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 1)

	summon_amt = 47
	summon_type = list(/turf/floor/fake_grass)
	var/spread = 0
	var/datum/seed/seed
	var/seed_type = /datum/seed/merlin_tear
	cast_sound = 'sound/magic/repulse.ogg'

/decl/ability/wizard/conjure/grove/New()
	..()
	if(seed_type)
		seed = new seed_type()
	else
		seed = SSplants.create_random_seed(1)

/decl/ability/wizard/conjure/grove/before_cast()
	var/turf/T = get_turf(holder)
	var/obj/effect/vine/P = new(T,seed)
	P.spread_chance = spread


/decl/ability/wizard/conjure/grove/sanctuary
	name = "Sanctuary"
	desc = "Creates a sanctuary of nature around the wizard as well as creating a healing plant."
	feedback = "SY"
	invocation = "Bo K'Iitan!"
	invocation_type = SpI_SHOUT
	ignore_space_turfs = TRUE
	cooldown_min = 600

	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 1)

	seed_type = /datum/seed/merlin_tear
	newVars = list("name" = "sanctuary", "desc" = "This grass makes you feel comfortable. Peaceful.","blessed" = 1)

	ability_icon_state = "wiz_grove"
/decl/ability/wizard/conjure/grove/sanctuary/empower_spell()
	if(!..())
		return 0

	seed.set_trait(TRAIT_SPREAD,2) //make it grow.
	spread = 40
	return "Your sanctuary will now grow beyond that of the grassy perimeter."

/datum/seed/merlin_tear
	name = "merlin tears"
	product_name = "merlin tears"
	display_name = "merlin tears"
	chems = list(/decl/material/liquid/brute_meds = list(3,7), /decl/material/liquid/burn_meds = list(3,7), /decl/material/liquid/antitoxins = list(3,7), /decl/material/liquid/regenerator = list(3,7), /decl/material/liquid/neuroannealer = list(1,2), /decl/material/liquid/eyedrops = list(1,2))
	grown_tag = "berries"

/datum/seed/merlin_tear/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4d4dff")
	set_trait(TRAIT_PLANT_COLOUR, "#ff6600")
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_IMMUTABLE,1) //no making op plants pls