//Recipes that produce items which aren't stacks or storage.
/datum/stack_recipe/baseball_bat
	title = "baseball bat"
	result_type = /obj/item/twohanded/baseballbat
	time = 20
	difficulty = 2

/datum/stack_recipe/bell
	title = "bell"
	result_type = /obj/item/bell
	time = 20

/datum/stack_recipe/ashtray
	title = "ashtray"
	result_type = /obj/item/ashtray
	one_per_turf = 1

/datum/stack_recipe/improvised_armour
	title = "improvised armour"
	result_type = /obj/item/clothing/suit/armor/crafted
	one_per_turf = 1

/datum/stack_recipe/coin
	title = "coin"
	result_type = /obj/item/coin
	var/datum/denomination/denomination

/datum/stack_recipe/coin/New(decl/material/material, reinforce_material, datum/denomination/_denomination)
	denomination = _denomination
	. = ..()
	title = denomination.name

/datum/stack_recipe/coin/spawn_result(mob/user, location, amount)
	var/obj/item/coin/coin = ..()
	if(denomination)
		coin.denomination = denomination
		coin.SetName(coin.denomination.name)
	return coin

/datum/stack_recipe/ring
	title = "ring"
	result_type = /obj/item/clothing/ring/material

/datum/stack_recipe/lock
	title = "lock"
	result_type = /obj/item/lock_construct
	time = 20

/datum/stack_recipe/fork
	title = "fork"
	result_type = /obj/item/kitchen/utensil/fork/plastic

/datum/stack_recipe/knife
	title = "table knife"
	result_type = /obj/item/knife/table
	difficulty = 2

/datum/stack_recipe/spoon
	title = "spoon"
	result_type = /obj/item/kitchen/utensil/spoon/plastic

/datum/stack_recipe/blade
	title = "knife"
	result_type = /obj/item/butterflyblade
	time = 20
	difficulty = 1

/datum/stack_recipe/grip
	title = "knife grip"
	result_type = /obj/item/butterflyhandle
	time = 20
	on_floor = 1
	difficulty = 1

/datum/stack_recipe/key
	title = "key"
	result_type = /obj/item/key
	time = 10

/datum/stack_recipe/cannon
	title = "cannon frame"
	result_type = /obj/item/cannonframe
	time = 15
	difficulty = 3

/datum/stack_recipe/grenade
	title = "grenade casing"
	result_type = /obj/item/grenade/chem_grenade
	difficulty = 3

/datum/stack_recipe/light
	title = "light fixture frame"
	result_type = /obj/item/frame/light
	difficulty = 2

/datum/stack_recipe/light_small
	title = "small light fixture frame"
	result_type = /obj/item/frame/light/small
	difficulty = 2

/datum/stack_recipe/light_switch
	title = "light switch frame"
	result_type = /obj/item/frame/button/light_switch
	difficulty = 2

/datum/stack_recipe/light_switch/windowtint
	title = "window tint switch frame"
	result_type = /obj/item/frame/button/light_switch/windowtint
	difficulty = 2

/datum/stack_recipe/apc
	title = "APC frame"
	result_type = /obj/item/frame/apc
	difficulty = 2

/datum/stack_recipe/air_alarm
	title = "air alarm frame"
	result_type = /obj/item/frame/air_alarm
	difficulty = 2

/datum/stack_recipe/fire_alarm
	title = "fire alarm frame"
	result_type = /obj/item/frame/fire_alarm
	difficulty = 2

/datum/stack_recipe/hazard_cone
	title = "hazard cone"
	result_type = /obj/item/caution/cone
	on_floor = 1

/datum/stack_recipe/ivbag
	title = "IV bag"
	result_type = /obj/item/chems/ivbag
	difficulty = 2

/datum/stack_recipe/cartridge
	title = "reagent dispenser cartridge"
	var/modifier = ""
	difficulty = 2

/datum/stack_recipe/cartridge/display_name()
	return "[title] ([modifier])"

/datum/stack_recipe/cartridge/small
	result_type = /obj/item/chems/chem_disp_cartridge/small
	modifier = "small"

/datum/stack_recipe/cartridge/medium
	result_type = /obj/item/chems/chem_disp_cartridge/medium
	modifier = "medium"

/datum/stack_recipe/cartridge/large
	result_type = /obj/item/chems/chem_disp_cartridge
	modifier = "large"

/datum/stack_recipe/sandals
	title = "sandals"
	result_type = /obj/item/clothing/shoes/sandal

/datum/stack_recipe/zipgunframe
	title = "zip gun frame"
	result_type = /obj/item/zipgunframe
	difficulty = 3

/datum/stack_recipe/coilgun
	title = "coilgun stock"
	result_type = /obj/item/coilgun_assembly
	difficulty = 3

/datum/stack_recipe/stick
	title = "stick"
	result_type = /obj/item/stick
	difficulty = 0

/datum/stack_recipe/crossbowframe
	title = "crossbow frame"
	result_type = /obj/item/crossbowframe
	time = 25
	difficulty = 3

/datum/stack_recipe/beehive_assembly
	title = "beehive assembly"
	result_type = /obj/item/beehive_assembly

/datum/stack_recipe/beehive_frame
	title = "beehive frame"
	result_type = /obj/item/honey_frame

/datum/stack_recipe/cardborg_suit
	title = "cardborg suit"
	result_type = /obj/item/clothing/suit/cardborg
	difficulty = 0

/datum/stack_recipe/cardborg_helmet
	title = "cardborg helmet"
	result_type = /obj/item/clothing/head/cardborg
	difficulty = 0

/datum/stack_recipe/candle
	title = "candle"
	result_type = /obj/item/flame/candle
	difficulty = 0

/datum/stack_recipe/clipboard
	title = "clipboard"
	result_type = /obj/item/clipboard

/datum/stack_recipe/urn
	title = "urn"
	result_type = /obj/item/urn

/datum/stack_recipe/drill_head
	title = "drill head"
	result_type = /obj/item/drill_head
	difficulty = 0

/datum/stack_recipe/cross
	title = "cross"
	result_type = /obj/item/cross
	on_floor = 1

/datum/stack_recipe/prosthetic
	difficulty = 0
	var/prosthetic_species = SPECIES_HUMAN
	var/prosthetic_model = /decl/prosthetics_manufacturer/wooden

/datum/stack_recipe/prosthetic/spawn_result(mob/user, location, amount)
	var/obj/item/organ/external/limb = ..()
	if(limb)
		limb.set_species(prosthetic_species)
		limb.robotize(prosthetic_model, apply_material = use_material, check_species = prosthetic_species)
		limb.status |= ORGAN_CUT_AWAY
	return limb

/datum/stack_recipe/prosthetic/left_arm
	title = "left arm"
	result_type = /obj/item/organ/external/arm

/datum/stack_recipe/prosthetic/right_arm
	title = "right arm"
	result_type = /obj/item/organ/external/arm/right

/datum/stack_recipe/prosthetic/left_leg
	title = "left leg"
	result_type = /obj/item/organ/external/leg

/datum/stack_recipe/prosthetic/right_leg
	title = "right leg"
	result_type = /obj/item/organ/external/leg/right

/datum/stack_recipe/prosthetic/left_hand
	title = "left hand"
	result_type = /obj/item/organ/external/hand

/datum/stack_recipe/prosthetic/right_hand
	title = "right hand"
	result_type = /obj/item/organ/external/hand/right

/datum/stack_recipe/prosthetic/left_foot
	title = "left foot"
	result_type = /obj/item/organ/external/foot

/datum/stack_recipe/prosthetic/right_foot
	title = "right foot"
	result_type = /obj/item/organ/external/foot/right

/datum/stack_recipe/cloak
	title = "cloak"
	result_type = /obj/item/clothing/accessory/cloak/hide

/datum/stack_recipe/banner
	title = "banner"
	result_type = /obj/item/banner

/datum/stack_recipe/shoes
	title = "shoes"
	result_type = /obj/item/clothing/shoes/craftable

/datum/stack_recipe/boots
	title = "boots"
	result_type = /obj/item/clothing/shoes/craftable/boots

/datum/stack_recipe/armguards
	title = "arm guards"
	result_type = /obj/item/clothing/accessory/armguards/craftable

/datum/stack_recipe/legguards
	title = "leg guards"
	result_type = /obj/item/clothing/accessory/legguards/craftable

/datum/stack_recipe/gauntlets
	title = "gauntlets"
	result_type = /obj/item/clothing/gloves/thick/craftable

/datum/stack_recipe/paper_sheets
	title          = "sheet of paper"
	result_type    = /obj/item/paper
	res_amount     = 4
	max_res_amount = 30

/datum/stack_recipe/paper_sheets/spawn_result(user, location, amount)
	var/obj/item/paper/P = ..()
	if(amount > 1)
		var/obj/item/paper_bundle/B = new(location)
		B.merge(P)
		for(var/i = 1 to (amount - 1))
			if(B.get_amount_papers() >= B.max_pages)
				B = new(location)
			B.merge(new /obj/item/paper(location))
		return B
	return P