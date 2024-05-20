/obj/random/maintenance //Clutter and loot for maintenance and away missions
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items/gift_wrapped.dmi'
	icon_state = "gift_1"

/obj/random/maintenance/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/maintenance/clean = 5,
		/obj/random/junk =              4,
		/obj/random/trash =             4
	)
	return spawnable_choices

/obj/random/maintenance/clean
/*Maintenance loot lists without the trash, for use inside things.
Individual items to add to the maintenance list should go here, if you add
something, make sure it's not in one of the other lists.*/
	name = "random clean maintenance item"
	desc = "This is a random clean maintenance item."
	icon = 'icons/obj/items/gift_wrapped.dmi'
	icon_state = "gift_2"

/obj/random/maintenance/clean/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/tech_supply        = 100,
		/obj/random/medical/lite       =  80,
		/obj/random/technology_scanner =  80,
		/obj/random/bomb_supply        =  80,
		/obj/random/snack              =  60,
		/obj/random/powercell          =  50,
		/obj/random/advdevice          =  50,
		/obj/random/medical            =  40,
		/obj/random/material           =  40,
		/obj/random/smokes             =  30,
		/obj/random/storage            =  30,
		/obj/random/clothing           =  30,
		/obj/random/firstaid           =  20,
		/obj/random/toy                =  20,
		/obj/random/tank               =  20,
		/obj/random/shoes              =  20,
		/obj/random/glasses            =  20,
		/obj/random/suit               =  20,
		/obj/random/accessory          =  20,
		/obj/random/cash               =  10,
		/obj/random/masks              =  10,
		/obj/random/gloves             =  10,
		/obj/random/hat                =  10,
		/obj/random/coin               =   5,
		/obj/random/soap               =   5,
		/obj/random/drinkbottle        =   5,
		/obj/random/action_figure      =   2,
		/obj/random/plushie            =   2,
		/obj/random/contraband         =   1,
		/obj/random/loot               =   1
	)
	return spawnable_choices

/obj/random/maintenance/research
/*Maintenance loot list. This one is for around medical areas*/
	name = "random research maintenance item"
	desc = "This is a random research maintenance item."

/obj/random/maintenance/research/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/maintenance/clean                  = 320,
		/obj/item/backpack/toxins                      =  10,
		/obj/item/clothing/glasses/science             =   4,
		/obj/item/clothing/suit/toggle/labcoat         =   4,
		/obj/item/clothing/suit/toggle/labcoat/science =   4,
		/obj/item/clothing/jumpsuit/white           =   4,
		/obj/item/clothing/glasses/material            =   3,
		/obj/item/scanner/plant                        =   3,
		/obj/item/box/beakers                          =   3,
		/obj/item/box/syringes                         =   3,
		/obj/item/box/gloves                           =   3,
		/obj/item/chems/glass/bucket                   =   2,
		/obj/item/assembly/prox_sensor                 =   2,
		/obj/item/excavation                           =   2,
		/obj/item/clothing/gloves/latex                =   2,
		/obj/item/flash/synthetic                      =   1,
		/obj/item/cell/gun                             =   1,
		/obj/item/backpack/holding                     =   1,
		/obj/item/clothing/head/beret/purple           =   1,
		/obj/item/clothing/head/bio_hood/scientist     =   1,
		/obj/item/clothing/suit/bio_suit/scientist     =   1
	)
	return spawnable_choices

/obj/random/maintenance/engineering
/*Maintenance loot list. This one is for around medical areas*/
	name = "random engineering maintenance item"
	desc = "This is a random engineering maintenance item."

/obj/random/maintenance/engineering/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/maintenance/clean                  = 320,
		/obj/item/backpack/industrial                  =   5,
		/obj/item/backpack/satchel/eng                 =   5,
		/obj/item/backpack/messenger/engi              =   5,
		/obj/item/box                                  =   5,
		/obj/item/clothing/suit/hazardvest             =   4,
		/obj/item/clothing/mask/gas/half               =   3,
		/obj/item/belt/utility                         =   3,
		/obj/item/clothing/head/soft/yellow            =   3,
		/obj/item/clothing/shoes/workboots             =   3,
		/obj/item/clothing/head/earmuffs               =   3,
		/obj/item/backpack/dufflebag/eng               =   3,
		/obj/item/flashlight/maglight                  =   2,
		/obj/item/clothing/mask/balaclava              =   2,
		/obj/item/briefcase/inflatable                 =   2,
		/obj/item/belt/utility/full                    =   2,
		/obj/item/clothing/webbing/vest/black          =   2,
		/obj/item/clothing/suit/apron/overalls/laborer =   2,
		/obj/item/clothing/webbing/vest/brown          =   2,
		/obj/item/handcuffs                            =   2,
		/obj/item/clothing/mask/bandana/orange         =   2,
		/obj/item/clothing/head/hardhat/dblue          =   2,
		/obj/item/clothing/head/hardhat/orange         =   2,
		/obj/item/clothing/head/welding                =   2,
		/obj/item/clothing/glasses/welding             =   1,
		/obj/item/clothing/shoes/magboots              =   1,
		/obj/item/beartrap                             =   1,
		/obj/item/clothing/webbing/drop_pouches/brown  =   1
	)
	return spawnable_choices

/obj/random/maintenance/cargo
/*Maintenance loot list. This one is for around cargo areas*/
	name = "random cargo maintenance item"
	desc = "This is a random cargo maintenance item."

/obj/random/maintenance/cargo/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/maintenance/clean                = 320,
		/obj/item/backpack/industrial                =   5,
		/obj/item/backpack/satchel                   =   5,
		/obj/item/tool/pickaxe                       =   4,
		/obj/item/chems/toner_cartridge              =   4,
		/obj/item/clothing/suit/hazardvest           =   4,
		/obj/item/clothing/suit/apron                =   4,
		/obj/item/clothing/suit/apron/overalls       =   3,
		/obj/item/clothing/head/earmuffs             =   3,
		/obj/item/backpack/dufflebag                 =   3,
		/obj/item/flashlight/lantern                 =   3,
		/obj/item/clothing/glasses/material          =   3,
		/obj/item/clothing/head/soft/yellow          =   3,
		/obj/item/clothing/shirt/syndicate/tacticool =   2,
		/obj/item/clothing/webbing/vest/black        =   2,
		/obj/item/clothing/webbing/vest/brown        =   2,
		/obj/item/handcuffs                          =   2,
		/obj/item/belt/utility                       =   2,
		/obj/item/backpack/dufflebag/syndie/ammo     =   1,
		/obj/item/toolbox/syndicate                  =   1,
		/obj/item/belt/utility/full                  =   1,
		/obj/item/destTagger                         =   1,
		/obj/item/clothing/shirt/syndicate/combat    =   1,
		/obj/item/beartrap                           =   1
	)
	return spawnable_choices

/obj/random/maintenance/medical
/*Maintenance loot list. This one is for around medical areas*/
	name = "random medical maintenance item"
	desc = "This is a random medical maintenance item."

/obj/random/maintenance/medical/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/maintenance/clean                      = 320,
		/obj/random/medical/lite                           =  25,
		/obj/item/backpack/medic                           =   5,
		/obj/item/backpack/satchel/med                     =   5,
		/obj/item/backpack/messenger/med                   =   5,
		/obj/item/clothing/gloves                          =   5,
		/obj/item/clothing/suit/toggle/labcoat             =   4,
		/obj/item/clothing/shoes/color/white               =   3,
		/obj/item/backpack/dufflebag/med                   =   3,
		/obj/item/box/beakers                              =   3,
		/obj/item/box/syringes                             =   3,
		/obj/item/box/gloves                               =   3,
		/obj/item/clothing/mask/breath/medical             =   2,
		/obj/item/clothing/mask/surgical                   =   2,
		/obj/item/box/bodybags                             =   2,
		/obj/item/box/autoinjectors                        =   2,
		/obj/item/clothing/gloves/latex/nitrile            =   2,
		/obj/item/belt/medical/emt                         =   2,
		/obj/item/belt/medical                             =   2,
		/obj/item/clothing/jumpsuit/medical/paramedic         =   2,
		/obj/item/clothing/webbing/vest/black              =   2,
		/obj/item/clothing/webbing/vest                    =   2,
		/obj/item/clothing/neck/stethoscope                =   2,
		/obj/item/clothing/glasses/hud/health              =   2,
		/obj/item/backpack/dufflebag/syndie/med            =   1,
		/obj/item/clothing/shoes/jackboots/swat/combat     =   1,
		/obj/item/clothing/glasses/hud/health/prescription =   1,
		/obj/item/clothing/head/bio_hood/virology          =   1,
		/obj/item/clothing/suit/bio_suit/general           =   1,
		/obj/item/clothing/webbing/drop_pouches/white      =   1,
		/obj/item/clothing/webbing/drop_pouches/black      =   1
	)
	return spawnable_choices

/obj/random/maintenance/security
/*Maintenance loot list. This one is for around security areas*/
	name = "random security maintenance item"
	desc = "This is a random security maintenance item."

/obj/random/maintenance/security/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/maintenance/clean                        = 320,
		/obj/item/clothing/head/soft/sec                     =   4,
		/obj/item/clothing/head/soft/sec/corp                =   4,
		/obj/item/backpack/security                          =   3,
		/obj/item/backpack/satchel/sec                       =   3,
		/obj/item/clothing/shoes/jackboots                   =   3,
		/obj/item/clothing/suit/armor/vest                   =   3,
		/obj/item/clothing/head/beret/corp/sec               =   3,
		/obj/item/clothing/head/beret/corp/sec/corporate/hos =   3,
		/obj/item/clothing/head/beret/corp/sec/navy/officer  =   3,
		/obj/item/flashlight/maglight                        =   2,
		/obj/item/flash                                      =   2,
		/obj/item/clothing/mask/balaclava                    =   2,
		/obj/item/backpack/messenger/sec                     =   2,
		/obj/item/backpack/dufflebag/sec                     =   2,
		/obj/item/box/swabs                                  =   2,
		/obj/item/belt/security                              =   2,
		/obj/item/clothing/glasses/hud/security              =   2,
		/obj/item/clothing/head/helmet                       =   2,
		/obj/item/clothing/suit/armor/vest/security          =   2,
		/obj/item/clothing/webbing/drop_pouches/black        =   2,
		/obj/item/clothing/head/earmuffs                     =   2,
		/obj/item/handcuffs                                  =   2,
		/obj/item/clothing/webbing/holster/thigh             =   1,
		/obj/item/cell/gun                                   =   1,
		/obj/item/clothing/mask/gas/swat                     =   1,
		/obj/item/clothing/mask/gas/syndicate                =   1,
		/obj/item/clothing/mask/balaclava/tactical           =   1,
		/obj/item/backpack/dufflebag/syndie/ammo             =   1,
		/obj/item/backpack/dufflebag/syndie/med              =   1,
		/obj/item/grenade/flashbang                          =   1,
		/obj/item/baton                                      =   1,
		/obj/item/chems/spray/pepper                         =   1,
		/obj/item/clothing/shoes/jackboots/swat              =   1,
		/obj/item/clothing/shoes/jackboots/swat/combat       =   1,
		/obj/item/clothing/gloves/thick/swat                 =   1,
		/obj/item/clothing/gloves/thick/combat               =   1,
		/obj/item/clothing/glasses/sunglasses/big            =   1,
		/obj/item/clothing/glasses/sunglasses/sechud         =   1,
		/obj/item/clothing/glasses/sunglasses/sechud/toggle  =   1,
		/obj/item/clothing/glasses/sunglasses/sechud         =   1,
		/obj/item/clothing/webbing/holster/hip               =   1,
		/obj/item/clothing/webbing/holster/waist             =   1,
		/obj/item/clothing/webbing/holster/armpit            =   1
	)
	return spawnable_choices
