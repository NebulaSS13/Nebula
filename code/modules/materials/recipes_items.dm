//Recipes that produce items which aren't stacks or storage.
/datum/stack_crafting/recipe/baseball_bat
	name = "baseball bat"
	result_type = /obj/item/twohanded/baseballbat
	time = 20
	difficulty = 2

/datum/stack_crafting/recipe/bell
	name = "bell"
	result_type = /obj/item/bell
	time = 20

/datum/stack_crafting/recipe/ashtray
	name = "ashtray"
	result_type = /obj/item/ashtray
	one_per_turf = 1
	craftable_stack_types = list(/obj/item/stack/material)
	required_tool = TOOL_CHISEL

/datum/stack_crafting/recipe/improvised_armour
	name = "improvised armour"
	result_type = /obj/item/clothing/suit/armor/crafted
	one_per_turf = 1

/datum/stack_crafting/recipe/coin
	name = "coin"
	result_type = /obj/item/coin
	var/datum/denomination/denomination

/datum/stack_crafting/recipe/coin/New(decl/material/material, reinforce_material, datum/denomination/_denomination)
	denomination = _denomination
	. = ..()
	name = denomination.name

/datum/stack_crafting/recipe/coin/spawn_result(mob/user, location, amount)
	var/obj/item/coin/coin = ..()
	if(denomination)
		coin.denomination = denomination
		coin.SetName(coin.denomination.name)
	return coin

/datum/stack_crafting/recipe/ring
	name = "ring"
	result_type = /obj/item/clothing/ring/material
	craftable_stack_types = list(/obj/item/stack/material)
	required_tool = TOOL_CHISEL

/datum/stack_crafting/recipe/lock
	name = "lock"
	result_type = /obj/item/lock_construct
	time = 20

/datum/stack_crafting/recipe/fork
	name = "fork"
	result_type = /obj/item/kitchen/utensil/fork/plastic

/datum/stack_crafting/recipe/knife
	name = "table knife"
	result_type = /obj/item/knife/table
	difficulty = 2

/datum/stack_crafting/recipe/spoon
	name = "spoon"
	result_type = /obj/item/kitchen/utensil/spoon/plastic

/datum/stack_crafting/recipe/blade
	name = "knife"
	result_type = /obj/item/butterflyblade
	time = 20
	difficulty = 1

/datum/stack_crafting/recipe/grip
	name = "knife grip"
	result_type = /obj/item/butterflyhandle
	time = 20
	on_floor = 1
	difficulty = 1

/datum/stack_crafting/recipe/key
	name = "key"
	result_type = /obj/item/key
	time = 10

/datum/stack_crafting/recipe/cannon
	name = "cannon frame"
	result_type = /obj/item/cannonframe
	time = 15
	difficulty = 3

/datum/stack_crafting/recipe/grenade
	name = "grenade casing"
	result_type = /obj/item/grenade/chem_grenade
	difficulty = 3

/datum/stack_crafting/recipe/light
	name = "light fixture frame"
	result_type = /obj/item/frame/light
	difficulty = 2

/datum/stack_crafting/recipe/light_small
	name = "small light fixture frame"
	result_type = /obj/item/frame/light/small
	difficulty = 2

/datum/stack_crafting/recipe/light_switch
	name = "light switch frame"
	result_type = /obj/item/frame/button/light_switch
	difficulty = 2

/datum/stack_crafting/recipe/light_switch/windowtint
	name = "window tint switch frame"
	result_type = /obj/item/frame/button/light_switch/windowtint
	difficulty = 2

/datum/stack_crafting/recipe/apc
	name = "APC frame"
	result_type = /obj/item/frame/apc
	difficulty = 2

/datum/stack_crafting/recipe/air_alarm
	name = "air alarm frame"
	result_type = /obj/item/frame/air_alarm
	difficulty = 2

/datum/stack_crafting/recipe/fire_alarm
	name = "fire alarm frame"
	result_type = /obj/item/frame/fire_alarm
	difficulty = 2

/datum/stack_crafting/recipe/hazard_cone
	name = "hazard cone"
	result_type = /obj/item/caution/cone
	on_floor = 1

/datum/stack_crafting/recipe/ivbag
	name = "IV bag"
	result_type = /obj/item/chems/ivbag
	difficulty = 2

/datum/stack_crafting/recipe/cartridge
	name = "reagent dispenser cartridge"
	var/modifier = ""
	difficulty = 2

/datum/stack_crafting/recipe/cartridge/display_name()
	return "[name] ([modifier])"

/datum/stack_crafting/recipe/cartridge/small
	result_type = /obj/item/chems/chem_disp_cartridge/small
	modifier = "small"

/datum/stack_crafting/recipe/cartridge/medium
	result_type = /obj/item/chems/chem_disp_cartridge/medium
	modifier = "medium"

/datum/stack_crafting/recipe/cartridge/large
	result_type = /obj/item/chems/chem_disp_cartridge
	modifier = "large"

/datum/stack_crafting/recipe/sandals
	name = "sandals"
	result_type = /obj/item/clothing/shoes/sandal

/datum/stack_crafting/recipe/zipgunframe
	name = "zip gun frame"
	result_type = /obj/item/zipgunframe
	difficulty = 3

/datum/stack_crafting/recipe/coilgun
	name = "coilgun stock"
	result_type = /obj/item/coilgun_assembly
	difficulty = 3

/datum/stack_crafting/recipe/stick
	name = "stick"
	result_type = /obj/item/stick
	difficulty = 0

/datum/stack_crafting/recipe/crossbowframe
	name = "crossbow frame"
	result_type = /obj/item/crossbowframe
	time = 25
	difficulty = 3

/datum/stack_crafting/recipe/beehive_assembly
	name = "beehive assembly"
	result_type = /obj/item/beehive_assembly

/datum/stack_crafting/recipe/beehive_frame
	name = "beehive frame"
	result_type = /obj/item/honey_frame

/datum/stack_crafting/recipe/cardborg_suit
	name = "cardborg suit"
	result_type = /obj/item/clothing/suit/cardborg
	difficulty = 0

/datum/stack_crafting/recipe/cardborg_helmet
	name = "cardborg helmet"
	result_type = /obj/item/clothing/head/cardborg
	difficulty = 0

/datum/stack_crafting/recipe/candle
	name = "candle"
	result_type = /obj/item/flame/candle
	difficulty = 0

/datum/stack_crafting/recipe/clipboard
	name = "clipboard"
	result_type = /obj/item/clipboard

/datum/stack_crafting/recipe/urn
	name = "urn"
	result_type = /obj/item/urn

/datum/stack_crafting/recipe/drill_head
	name = "drill head"
	result_type = /obj/item/drill_head
	difficulty = 0

/datum/stack_crafting/recipe/cross
	name = "cross"
	result_type = /obj/item/cross
	on_floor = 1

/datum/stack_crafting/recipe/prosthetic
	difficulty = 0
	var/prosthetic_species = SPECIES_HUMAN
	var/prosthetic_model = /decl/prosthetics_manufacturer/wooden

/datum/stack_crafting/recipe/prosthetic/spawn_result(mob/user, location, amount)
	var/obj/item/organ/external/limb = ..()
	if(limb)
		limb.set_species(prosthetic_species)
		limb.robotize(prosthetic_model, apply_material = use_material, check_species = prosthetic_species)
		limb.status |= ORGAN_CUT_AWAY
	return limb

/datum/stack_crafting/recipe/prosthetic/left_arm
	name = "left arm"
	result_type = /obj/item/organ/external/arm

/datum/stack_crafting/recipe/prosthetic/right_arm
	name = "right arm"
	result_type = /obj/item/organ/external/arm/right

/datum/stack_crafting/recipe/prosthetic/left_leg
	name = "left leg"
	result_type = /obj/item/organ/external/leg

/datum/stack_crafting/recipe/prosthetic/right_leg
	name = "right leg"
	result_type = /obj/item/organ/external/leg/right

/datum/stack_crafting/recipe/prosthetic/left_hand
	name = "left hand"
	result_type = /obj/item/organ/external/hand

/datum/stack_crafting/recipe/prosthetic/right_hand
	name = "right hand"
	result_type = /obj/item/organ/external/hand/right

/datum/stack_crafting/recipe/prosthetic/left_foot
	name = "left foot"
	result_type = /obj/item/organ/external/foot

/datum/stack_crafting/recipe/prosthetic/right_foot
	name = "right foot"
	result_type = /obj/item/organ/external/foot/right

/datum/stack_crafting/recipe/cloak
	name = "cloak"
	result_type = /obj/item/clothing/accessory/cloak/hide

/datum/stack_crafting/recipe/shoes
	name = "shoes"
	result_type = /obj/item/clothing/shoes/craftable

/datum/stack_crafting/recipe/boots
	name = "boots"
	result_type = /obj/item/clothing/shoes/craftable/boots

/datum/stack_crafting/recipe/armguards
	name = "arm guards"
	result_type = /obj/item/clothing/accessory/armguards/craftable

/datum/stack_crafting/recipe/legguards
	name = "leg guards"
	result_type = /obj/item/clothing/accessory/legguards/craftable

/datum/stack_crafting/recipe/gauntlets
	name = "gauntlets"
	result_type = /obj/item/clothing/gloves/thick/craftable

/datum/stack_crafting/recipe/paper_sheets
	name          = "sheet of paper"
	result_type    = /obj/item/paper
	res_amount     = 4
	max_res_amount = 30

/datum/stack_crafting/recipe/paper_sheets/spawn_result(user, location, amount)
	var/obj/item/paper/P = ..()
	if(istype(P) && amount > 1)
		var/obj/item/paper_bundle/B = new(location)
		B.merge(P)
		for(var/i = 1 to (amount - 1))
			if(B.get_amount_papers() >= B.max_pages)
				B = new(location)
			B.merge(new /obj/item/paper(location))
		return B
	return P
