/decl/special_role
	initial_spawn_req = 1
	initial_spawn_target = 1

/decl/special_role/mercenary
	initial_spawn_req = 1
	initial_spawn_target = 2

/decl/special_role/raider
	initial_spawn_req = 1
	initial_spawn_target = 2

/decl/special_role/cultist
	initial_spawn_req = 1
	initial_spawn_target = 2

/decl/special_role/renegade
	initial_spawn_req = 1
	initial_spawn_target = 2

/decl/special_role/loyalist
	initial_spawn_req = 1
	initial_spawn_target = 2
	command_department_id = /decl/department/command

/decl/special_role/revolutionary
	initial_spawn_req = 1
	initial_spawn_target = 2
	command_department_id = /decl/department/command

/datum/map/ministation
	potential_theft_targets = list(
		"an owl mask"                        = /obj/item/clothing/mask/gas/owl_mask,
		"a toy ripley"                       = /obj/item/toy/prize/powerloader,
		"a collectable top hat"              = /obj/item/clothing/head/collectable/tophat,
		"a jetpack"                          = /obj/item/tank/jetpack,
		"a captain's jumpsuit"               = /obj/item/clothing/jumpsuit/captain,
		"a pair of magboots"                 = /obj/item/clothing/shoes/magboots,
		"the master blueprints"              = /obj/item/blueprints,
		"a sample of slime extract"          = /obj/item/slime_extract,
		"a piece of corgi meat"              = /obj/item/food/butchery/meat/corgi,
		"the hypospray"                      = /obj/item/chems/hypospray,
		"the captain's pinpointer"           = /obj/item/pinpointer,
		"the championship belt"              = /obj/item/belt/champion,
		"the tradehouse account documents"   = /obj/item/documents/tradehouse/account,
		"the tradehouse personnel data"      = /obj/item/documents/tradehouse/personnel,
		"the table-top spaceship model"      = /obj/item/toy/shipmodel,
		"the AI inteliCard"                  = /obj/item/aicard,
		"the nuclear authentication disk"    = /obj/item/disk/nuclear,
		"the officer's sword"                = /obj/item/sword/replica/officersword
	)