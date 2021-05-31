/datum/trader
	var/name = "unsuspicious trader"                            //The name of the trader in question
	var/origin = "some place"                                   //The place that they are trading from
	var/list/possible_origins                                   //Possible names of the trader origin
	var/disposition = 0                                         //The current disposition of them to us.
	var/trade_flags = TRADER_MONEY                              //Flags
	var/name_language                                                //If this is set to a language name this will generate a name from the language
	var/icon/portrait                                           //The icon that shows up in the menu @TODO
	var/trader_currency
	var/datum/trade_hub/hub

	var/list/wanted_items = list()                              //What items they enjoy trading for. Structure is (type = known/unknown)
	var/list/possible_wanted_items                              //List of all possible wanted items. Structure is (type = mode)
	var/list/possible_trading_items                             //List of all possible trading items. Structure is (type = mode)
	var/list/trading_items = list()                             //What items they are currently trading away.
	var/list/blacklisted_trade_items = list(/mob/living/carbon/human)
	                                                            //Things they will automatically refuse

	var/list/speech = list()                                    //The list of all their replies and messages. Structure is (id = talk)
	/*SPEECH IDS:
	hail_generic		When merchants hail a person
	hail_[race]			Race specific hails
	hail_deny			When merchant denies a hail

	insult_good			When the player insults a merchant while they are on good disposition
	insult_bad			When a player insults a merchatn when they are not on good disposition
	complement_accept	When the merchant accepts a complement
	complement_deny		When the merchant refuses a complement

	how_much			When a merchant tells the player how much something is.
	trade_complete		When a trade is made
	trade_refuse		When a trade is refused

	what_want			What the person says when they are asked if they want something

	*/
	var/want_multiplier = 2                                     //How much wanted items are multiplied by when traded for
	var/margin = 1.2											//Multiplier to price when selling to player
	var/force_sell_multiplier = 0.05							//Multiplier for not wanted items being sold
	var/price_rng = 10                                          //Percentage max variance in sell prices.
	var/insult_drop = 5                                         //How far disposition drops on insult
	var/compliment_increase = 5                                 //How far compliments increase disposition
	var/refuse_comms = 0                                        //Whether they refuse further communication

	var/mob_transfer_message = "You are transported to ORIGIN." //What message gets sent to mobs that get sold.

	var/static/list/blacklisted_types = list(
		/obj,
		/obj/item/TVAssembly,
		/obj/item/a_gift,
		/obj/item/ai_verbs,
		/obj/item/armblade,
		/obj/item/armblade/claws,
		/obj/item/assembly,
		/obj/item/assembly_holder,
		/obj/item/baton/robot,
		/obj/item/baton/robot/electrified_arm,
		/obj/item/beach_ball/holoball,
		/obj/item/beach_ball/holovolleyball,
		/obj/item/bioreactor,
		/obj/item/blob_tendril,
		/obj/item/blob_tendril/core,
		/obj/item/blob_tendril/core/aux,
		/obj/item/blueprints,
		/obj/item/blueprints/outpost,
		/obj/item/bone,
		/obj/item/bone/skull,
		/obj/item/book/manual/magshield_manual,
		/obj/item/book/tome,
		/obj/item/book/union_charter,
		/obj/item/borg,
		/obj/item/borg/combat,
		/obj/item/borg/combat/mobility,
		/obj/item/borg/combat/shield,
		/obj/item/borg/overdrive,
		/obj/item/borg/sight,
		/obj/item/borg/sight/hud,
		/obj/item/borg/sight/hud/jani,
		/obj/item/borg/sight/hud/med,
		/obj/item/borg/sight/hud/sec,
		/obj/item/borg/sight/material,
		/obj/item/borg/sight/meson,
		/obj/item/borg/sight/thermal,
		/obj/item/borg/sight/xray,
		/obj/item/borg/upgrade,
		/obj/item/borg/upgrade/uncertified,
		/obj/item/c_tube,
		/obj/item/camera/siliconcam,
		/obj/item/camera/siliconcam/ai_camera,
		/obj/item/camera/siliconcam/drone_camera,
		/obj/item/camera/siliconcam/robot_camera,
		/obj/item/card,
		/obj/item/card/robot,
		/obj/item/cash,
		/obj/item/cash/c1,
		/obj/item/cash/c10,
		/obj/item/cash/c100,
		/obj/item/cash/c1000,
		/obj/item/cash/c20,
		/obj/item/cash/c200,
		/obj/item/cash/c50,
		/obj/item/cash/c500,
		/obj/item/cash/scavbucks,
		/obj/item/cash/scrip,
		/obj/item/cell,
		/obj/item/cell/device/variable,
		/obj/item/cell/infinite,
		/obj/item/cell/slime,
		/obj/item/chems,
		/obj/item/chems/borghypo,
		/obj/item/chems/borghypo/crisis,
		/obj/item/chems/borghypo/service,
		/obj/item/chems/borghypo/surgeon,
		/obj/item/chems/dropper/industrial,
		/obj/item/chems/food,
		/obj/item/chems/food/condiment,
		/obj/item/chems/food/condiment/small,
		/obj/item/chems/food/condiment/small/packet,
		/obj/item/chems/food/condiment/small/packet/crayon,
		/obj/item/chems/food/drinks,
		/obj/item/chems/food/drinks/bottle,
		/obj/item/chems/food/drinks/bottle/small,
		/obj/item/chems/food/drinks/cans,
		/obj/item/chems/food/drinks/glass2,
		/obj/item/chems/food/drinks/juicebox,
		/obj/item/chems/food/drinks/tea,
		/obj/item/chems/food/drinks/zombiedrink,
		/obj/item/chems/food/snacks,
		/obj/item/chems/food/snacks/canned,
		/obj/item/chems/food/snacks/donut,
		/obj/item/chems/food/snacks/fruit_slice,
		/obj/item/chems/food/snacks/grown,
		/obj/item/chems/food/snacks/grown/ambrosiadeus,
		/obj/item/chems/food/snacks/grown/ambrosiavulgaris,
		/obj/item/chems/food/snacks/grown/dried_tobacco,
		/obj/item/chems/food/snacks/grown/dried_tobacco/bad,
		/obj/item/chems/food/snacks/grown/dried_tobacco/fine,
		/obj/item/chems/food/snacks/grown/mushroom,
		/obj/item/chems/food/snacks/grown/mushroom/libertycap,
		/obj/item/chems/food/snacks/grown/potato,
		/obj/item/chems/food/snacks/human,
		/obj/item/chems/food/snacks/meat,
		/obj/item/chems/food/snacks/old,
		/obj/item/chems/food/snacks/organ,
		/obj/item/chems/food/snacks/pie,
		/obj/item/chems/food/snacks/slice,
		/obj/item/chems/food/snacks/sliceable,
		/obj/item/chems/food/snacks/sliceable/pizza,
		/obj/item/chems/food/snacks/slimesoup,
		/obj/item/chems/food/snacks/variable,
		/obj/item/chems/food/snacks/variable/bread,
		/obj/item/chems/food/snacks/variable/cake,
		/obj/item/chems/food/snacks/variable/candybar,
		/obj/item/chems/food/snacks/variable/cookie,
		/obj/item/chems/food/snacks/variable/donut,
		/obj/item/chems/food/snacks/variable/jawbreaker,
		/obj/item/chems/food/snacks/variable/jelly,
		/obj/item/chems/food/snacks/variable/kebab,
		/obj/item/chems/food/snacks/variable/pancakes,
		/obj/item/chems/food/snacks/variable/pie,
		/obj/item/chems/food/snacks/variable/pizza,
		/obj/item/chems/food/snacks/variable/pocket,
		/obj/item/chems/food/snacks/variable/sucker,
		/obj/item/chems/food/snacks/variable/waffles,
		/obj/item/chems/glass,
		/obj/item/chems/glass/beaker/vial/random,
		/obj/item/chems/glass/beaker/vial/random_podchem,
		/obj/item/chems/glass/bottle,
		/obj/item/chems/glass/bottle/adminordrazine,
		/obj/item/chems/glass/bottle/robot,
		/obj/item/chems/glass/bottle/robot/antitoxin,
		/obj/item/chems/glass/bottle/robot/stabilizer,
		/obj/item/chems/glass/paint,
		/obj/item/chems/glass/replenishing,
		/obj/item/chems/hypospray,
		/obj/item/chems/hypospray/autoinjector,
		/obj/item/chems/hypospray/autoinjector/pouch_auto,
		/obj/item/chems/ivbag/blood,
		/obj/item/chems/pill,
		/obj/item/chems/pill/adminordrazine,
		/obj/item/chems/pill/pod,
		/obj/item/chems/pill/pouch_pill,
		/obj/item/chems/spray,
		/obj/item/chems/spray/cleaner/drone,
		/obj/item/clipboard,
		/obj/item/clothing,
		/obj/item/clothing/accessory,
		/obj/item/clothing/accessory/armguards/craftable,
		/obj/item/clothing/accessory/armor,
		/obj/item/clothing/accessory/armor/helmcover,
		/obj/item/clothing/accessory/armor/plate,
		/obj/item/clothing/accessory/badge,
		/obj/item/clothing/accessory/bowtie,
		/obj/item/clothing/accessory/legguards/craftable,
		/obj/item/clothing/accessory/long,
		/obj/item/clothing/accessory/medal/silver/marooned_medal,
		/obj/item/clothing/accessory/space_adapted,
		/obj/item/clothing/accessory/storage/drop_pouches,
		/obj/item/clothing/accessory/toggleable,
		/obj/item/clothing/ears,
		/obj/item/clothing/ears/dangle,
		/obj/item/clothing/glasses/blindfold/tape,
		/obj/item/clothing/glasses/hud,
		/obj/item/clothing/glasses/sunglasses/quantum,
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/gloves,
		/obj/item/clothing/gloves/boxing,
		/obj/item/clothing/gloves/boxing/hologlove,
		/obj/item/clothing/gloves/color/white/quantum,
		/obj/item/clothing/gloves/lightrig,
		/obj/item/clothing/gloves/lightrig/hacker,
		/obj/item/clothing/gloves/rig,
		/obj/item/clothing/gloves/rig/ce,
		/obj/item/clothing/gloves/rig/combat,
		/obj/item/clothing/gloves/rig/ert,
		/obj/item/clothing/gloves/rig/ert/assetprotection,
		/obj/item/clothing/gloves/rig/ert/engineer,
		/obj/item/clothing/gloves/rig/ert/janitor,
		/obj/item/clothing/gloves/rig/ert/medical,
		/obj/item/clothing/gloves/rig/ert/security,
		/obj/item/clothing/gloves/rig/eva,
		/obj/item/clothing/gloves/rig/hazard,
		/obj/item/clothing/gloves/rig/hazmat,
		/obj/item/clothing/gloves/rig/industrial,
		/obj/item/clothing/gloves/rig/light,
		/obj/item/clothing/gloves/rig/light/ninja,
		/obj/item/clothing/gloves/rig/medical,
		/obj/item/clothing/gloves/rig/merc,
		/obj/item/clothing/gloves/rig/merc/heavy,
		/obj/item/clothing/gloves/rig/military,
		/obj/item/clothing/gloves/thick/craftable,
		/obj/item/clothing/gloves/wizard,
		/obj/item/clothing/head,
		/obj/item/clothing/head/bio_hood,
		/obj/item/clothing/head/caretakerhood,
		/obj/item/clothing/head/champhelm,
		/obj/item/clothing/head/chaplain_hood,
		/obj/item/clothing/head/collectable,
		/obj/item/clothing/head/culthood,
		/obj/item/clothing/head/culthood/alt,
		/obj/item/clothing/head/culthood/magus,
		/obj/item/clothing/head/fated,
		/obj/item/clothing/head/fiendhood,
		/obj/item/clothing/head/fiendhood/fem,
		/obj/item/clothing/head/hasturhood,
		/obj/item/clothing/head/helmet/augment,
		/obj/item/clothing/head/helmet/space/cult,
		/obj/item/clothing/head/helmet/space/rig,
		/obj/item/clothing/head/helmet/space/rig/ce,
		/obj/item/clothing/head/helmet/space/rig/combat,
		/obj/item/clothing/head/helmet/space/rig/ert,
		/obj/item/clothing/head/helmet/space/rig/ert/assetprotection,
		/obj/item/clothing/head/helmet/space/rig/ert/engineer,
		/obj/item/clothing/head/helmet/space/rig/ert/janitor,
		/obj/item/clothing/head/helmet/space/rig/ert/medical,
		/obj/item/clothing/head/helmet/space/rig/ert/security,
		/obj/item/clothing/head/helmet/space/rig/eva,
		/obj/item/clothing/head/helmet/space/rig/hazard,
		/obj/item/clothing/head/helmet/space/rig/hazmat,
		/obj/item/clothing/head/helmet/space/rig/industrial,
		/obj/item/clothing/head/helmet/space/rig/light,
		/obj/item/clothing/head/helmet/space/rig/light/ninja,
		/obj/item/clothing/head/helmet/space/rig/medical,
		/obj/item/clothing/head/helmet/space/rig/merc,
		/obj/item/clothing/head/helmet/space/rig/merc/heavy,
		/obj/item/clothing/head/helmet/space/rig/military,
		/obj/item/clothing/head/helmet/space/rig/zero,
		/obj/item/clothing/head/helmet/space/shadowhood,
		/obj/item/clothing/head/helmet/space/void/wizard,
		/obj/item/clothing/head/helmet/sunhelm,
		/obj/item/clothing/head/helmet/thunderdome,
		/obj/item/clothing/head/hoodiehood,
		/obj/item/clothing/head/infilhat,
		/obj/item/clothing/head/infilhat/fem,
		/obj/item/clothing/head/lightrig,
		/obj/item/clothing/head/lightrig/hacker,
		/obj/item/clothing/head/nun_hood,
		/obj/item/clothing/head/overseerhood,
		/obj/item/clothing/head/winterhood,
		/obj/item/clothing/head/xeno,
		/obj/item/clothing/head/xeno/scarf,
		/obj/item/clothing/mask,
		/obj/item/clothing/mask/chewable,
		/obj/item/clothing/mask/chewable/candy,
		/obj/item/clothing/mask/chewable/tobacco,
		/obj/item/clothing/mask/monitor,
		/obj/item/clothing/mask/muzzle/tape,
		/obj/item/clothing/mask/smokable,
		/obj/item/clothing/mask/smokable/cigarette/rolled,
		/obj/item/clothing/pants,
		/obj/item/clothing/ring,
		/obj/item/clothing/ring/aura_ring,
		/obj/item/clothing/ring/aura_ring/talisman_of_blueforged,
		/obj/item/clothing/ring/aura_ring/talisman_of_shadowling,
		/obj/item/clothing/ring/aura_ring/talisman_of_starborn,
		/obj/item/clothing/ring/material,
		/obj/item/clothing/sealant,
		/obj/item/clothing/shoes,
		/obj/item/clothing/shoes/color/black/quantum,
		/obj/item/clothing/shoes/craftable,
		/obj/item/clothing/shoes/craftable/boots,
		/obj/item/clothing/shoes/cult,
		/obj/item/clothing/shoes/dress/caretakershoes,
		/obj/item/clothing/shoes/dress/devilshoes,
		/obj/item/clothing/shoes/dress/infilshoes,
		/obj/item/clothing/shoes/lightrig,
		/obj/item/clothing/shoes/lightrig/hacker,
		/obj/item/clothing/shoes/magboots/rig,
		/obj/item/clothing/shoes/magboots/rig/ce,
		/obj/item/clothing/shoes/magboots/rig/combat,
		/obj/item/clothing/shoes/magboots/rig/ert,
		/obj/item/clothing/shoes/magboots/rig/ert/assetprotection,
		/obj/item/clothing/shoes/magboots/rig/ert/engineer,
		/obj/item/clothing/shoes/magboots/rig/ert/janitor,
		/obj/item/clothing/shoes/magboots/rig/ert/medical,
		/obj/item/clothing/shoes/magboots/rig/ert/security,
		/obj/item/clothing/shoes/magboots/rig/eva,
		/obj/item/clothing/shoes/magboots/rig/hazard,
		/obj/item/clothing/shoes/magboots/rig/hazmat,
		/obj/item/clothing/shoes/magboots/rig/industrial,
		/obj/item/clothing/shoes/magboots/rig/light,
		/obj/item/clothing/shoes/magboots/rig/light/ninja,
		/obj/item/clothing/shoes/magboots/rig/medical,
		/obj/item/clothing/shoes/magboots/rig/military,
		/obj/item/clothing/shoes/rig,
		/obj/item/clothing/shoes/rig/merc,
		/obj/item/clothing/shoes/rig/merc/heavy,
		/obj/item/clothing/shoes/sandal/grimboots,
		/obj/item/clothing/suit,
		/obj/item/clothing/suit/armor,
		/obj/item/clothing/suit/armor/crafted,
		/obj/item/clothing/suit/armor/pirate,
		/obj/item/clothing/suit/armor/sunrobe,
		/obj/item/clothing/suit/armor/sunsuit,
		/obj/item/clothing/suit/armor/tdome,
		/obj/item/clothing/suit/armor/tdome/green,
		/obj/item/clothing/suit/armor/tdome/red,
		/obj/item/clothing/suit/bio_suit,
		/obj/item/clothing/suit/caretakercloak,
		/obj/item/clothing/suit/champarmor,
		/obj/item/clothing/suit/cultrobes,
		/obj/item/clothing/suit/cultrobes/alt,
		/obj/item/clothing/suit/cultrobes/magusred,
		/obj/item/clothing/suit/fated,
		/obj/item/clothing/suit/fiendcowl,
		/obj/item/clothing/suit/fiendcowl/fem,
		/obj/item/clothing/suit/hastur,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/suit/infilsuit,
		/obj/item/clothing/suit/infilsuit/fem,
		/obj/item/clothing/suit/poncho,
		/obj/item/clothing/suit/poncho/roles,
		/obj/item/clothing/suit/space/cult,
		/obj/item/clothing/suit/space/rig,
		/obj/item/clothing/suit/space/rig/ce,
		/obj/item/clothing/suit/space/rig/combat,
		/obj/item/clothing/suit/space/rig/ert,
		/obj/item/clothing/suit/space/rig/ert/assetprotection,
		/obj/item/clothing/suit/space/rig/ert/engineer,
		/obj/item/clothing/suit/space/rig/ert/janitor,
		/obj/item/clothing/suit/space/rig/ert/medical,
		/obj/item/clothing/suit/space/rig/ert/security,
		/obj/item/clothing/suit/space/rig/eva,
		/obj/item/clothing/suit/space/rig/hazard,
		/obj/item/clothing/suit/space/rig/hazmat,
		/obj/item/clothing/suit/space/rig/industrial,
		/obj/item/clothing/suit/space/rig/internal_affairs,
		/obj/item/clothing/suit/space/rig/light,
		/obj/item/clothing/suit/space/rig/light/ninja,
		/obj/item/clothing/suit/space/rig/medical,
		/obj/item/clothing/suit/space/rig/merc,
		/obj/item/clothing/suit/space/rig/merc/heavy,
		/obj/item/clothing/suit/space/rig/military,
		/obj/item/clothing/suit/space/rig/zero,
		/obj/item/clothing/suit/space/void/wizard,
		/obj/item/clothing/suit/storage,
		/obj/item/clothing/suit/storage/hooded,
		/obj/item/clothing/suit/storage/toggle,
		/obj/item/clothing/suit/straight_jacket/overseercloak,
		/obj/item/clothing/under,
		/obj/item/clothing/under/wedding,
		/obj/item/clothing/under/centcom,
		/obj/item/clothing/under/centcom_captain,
		/obj/item/clothing/under/centcom_officer,
		/obj/item/clothing/under/color/quantum,
		/obj/item/clothing/under/devildress,
		/obj/item/clothing/under/fated,
		/obj/item/clothing/under/gimmick,
		/obj/item/clothing/under/gimmick/rank,
		/obj/item/clothing/under/gimmick/rank/captain,
		/obj/item/clothing/under/gimmick/rank/captain/suit,
		/obj/item/clothing/under/gimmick/rank/head_of_personnel,
		/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
		/obj/item/clothing/under/lawyer/infil,
		/obj/item/clothing/under/lawyer/infil/fem,
		/obj/item/clothing/under/magintka_uniform,
		/obj/item/clothingbag,
		/obj/item/contraband,
		/obj/item/contract,
		/obj/item/contract/apprentice,
		/obj/item/contract/boon,
		/obj/item/contract/boon/wizard,
		/obj/item/contract/boon/wizard/artificer,
		/obj/item/contract/boon/wizard/charge,
		/obj/item/contract/boon/wizard/fireball,
		/obj/item/contract/boon/wizard/forcewall,
		/obj/item/contract/boon/wizard/horsemask,
		/obj/item/contract/boon/wizard/knock,
		/obj/item/contract/boon/wizard/smoke,
		/obj/item/contract/wizard,
		/obj/item/contract/wizard/telepathy,
		/obj/item/contract/wizard/xray,
		/obj/item/crafting_holder,
		/obj/item/cross,
		/obj/item/crowbar/brace_jack,
		/obj/item/crowbar/finger,
		/obj/item/debugger,
		/obj/item/deck,
		/obj/item/deck/cag,
		/obj/item/dice/d100,
		/obj/item/disk/nuclear,
		/obj/item/disk/secret_project,
		/obj/item/disk/secret_project/science,
		/obj/item/disk/icarus,
		/obj/item/documents,
		/obj/item/documents/nanotrasen,
		/obj/item/documents/scg,
		/obj/item/documents/scg/blue,
		/obj/item/documents/scg/brains,
		/obj/item/documents/scg/red,
		/obj/item/documents/scg/verified,
		/obj/item/documents/tradehouse,
		/obj/item/documents/tradehouse/account,
		/obj/item/documents/tradehouse/personnel,
		/obj/item/drain,
		/obj/item/drill_head,
		/obj/item/ducttape,
		/obj/item/ecletters,
		/obj/item/ectoplasm,
		/obj/item/energy_blade,
		/obj/item/energy_blade/blade,
		/obj/item/energy_blade_net,
		/obj/item/energy_blade_net/safari,
		/obj/item/engine,
		/obj/item/engine/electric,
		/obj/item/engine/thermal,
		/obj/item/extinguisher/mech,
		/obj/item/flame,
		/obj/item/flame/hands,
		/obj/item/flame/lighter,
		/obj/item/flashlight/drone,
		/obj/item/flashlight/slime,
		/obj/item/folder/envelope,
		/obj/item/folder/envelope/nuke_instructions,
		/obj/item/forensics,
		/obj/item/form_printer,
		/obj/item/fossil,
		/obj/item/frame,
		/obj/item/frame_holder,
		/obj/item/fuel_assembly,
		/obj/item/gift,
		/obj/item/glass_extra,
		/obj/item/gps,
		/obj/item/grab,
		/obj/item/grenade,
		/obj/item/grenade/chem_grenade,
		/obj/item/grenade/spawnergrenade,
		/obj/item/gripper,
		/obj/item/gripper/chemistry,
		/obj/item/gripper/clerical,
		/obj/item/gripper/cultivator,
		/obj/item/gripper/miner,
		/obj/item/gripper/no_use,
		/obj/item/gripper/no_use/loader,
		/obj/item/gripper/organ,
		/obj/item/gripper/research,
		/obj/item/gripper/service,
		/obj/item/grown,
		/obj/item/gun,
		/obj/item/gun/energy,
		/obj/item/gun/energy/capacitor/rifle/linear_fusion,
		/obj/item/gun/energy/chameleon,
		/obj/item/gun/energy/crossbow/ninja,
		/obj/item/gun/energy/crossbow/ninja/mounted,
		/obj/item/gun/energy/gun/mounted,
		/obj/item/gun/energy/gun/secure/mounted,
		/obj/item/gun/energy/ionrifle/mounted,
		/obj/item/gun/energy/ionrifle/mounted/mech,
		/obj/item/gun/energy/laser/mounted,
		/obj/item/gun/energy/laser/mounted/mech,
		/obj/item/gun/energy/lasercannon/mounted,
		/obj/item/gun/energy/lasertag,
		/obj/item/gun/energy/plasmacutter/mounted,
		/obj/item/gun/energy/plasmacutter/mounted/mech,
		/obj/item/gun/energy/staff,
		/obj/item/gun/energy/staff/animate,
		/obj/item/gun/energy/staff/beacon,
		/obj/item/gun/energy/staff/focus,
		/obj/item/gun/energy/taser/mounted,
		/obj/item/gun/energy/taser/mounted/mech,
		/obj/item/gun/energy/taser/mounted/cyborg,
		/obj/item/gun/launcher,
		/obj/item/gun/projectile,
		/obj/item/gun/projectile/automatic,
		/obj/item/gun/projectile/shotgun,
		/obj/item/hand,
		/obj/item/hand/missing_card,
		/obj/item/handcuffs/cyborg,
		/obj/item/handcuffs/wizard,
		/obj/item/handcuffs/cable/tape,
		/obj/item/hatchet/machete,
		/obj/item/hatchet/machete/unbreakable,
		/obj/item/hatchet/unbreakable,
		/obj/item/holder,
		/obj/item/holder/corgi,
		/obj/item/holder/diona,
		/obj/item/holder/drone,
		/obj/item/holder/mouse,
		/obj/item/holder/runtime,
		/obj/item/holder/slug,
		/obj/item/holo,
		/obj/item/holo/esword,
		/obj/item/holo/esword/green,
		/obj/item/holo/esword/red,
		/obj/item/icarus,
		/obj/item/icarus/dead_personnel,
		/obj/item/implant,
		/obj/item/implant/translator/natural,
		/obj/item/implant/uplink,
		/obj/item/implanter/uplink,
		/obj/item/inflatable,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/instrument,
		/obj/item/integrated_circuit,
		/obj/item/integrated_circuit/arithmetic,
		/obj/item/integrated_circuit/converter,
		/obj/item/integrated_circuit/filter,
		/obj/item/integrated_circuit/filter/ref,
		/obj/item/integrated_circuit/input,
		/obj/item/integrated_circuit/lists,
		/obj/item/integrated_circuit/logic,
		/obj/item/integrated_circuit/logic/binary,
		/obj/item/integrated_circuit/logic/unary,
		/obj/item/integrated_circuit/manipulation,
		/obj/item/integrated_circuit/output,
		/obj/item/integrated_circuit/passive,
		/obj/item/integrated_circuit/passive/power,
		/obj/item/integrated_circuit/power,
		/obj/item/integrated_circuit/power/transmitter,
		/obj/item/integrated_circuit/reagent,
		/obj/item/integrated_circuit/reagent/temp,
		/obj/item/integrated_circuit/smart,
		/obj/item/integrated_circuit/time,
		/obj/item/integrated_circuit/transfer,
		/obj/item/integrated_circuit/trig,
		/obj/item/integrated_circuit_printer/debug,
		/obj/item/integrated_electronics,
		/obj/item/key,
		/obj/item/key/cargo_train,
		/obj/item/key/soap,
		/obj/item/kit,
		/obj/item/kit/paint,
		/obj/item/kit/paint/powerloader,
		/obj/item/kit/suit,
		/obj/item/kitchen,
		/obj/item/kitchen/utensil,
		/obj/item/kitchen/utensil/foon,
		/obj/item/kitchen/utensil/fork,
		/obj/item/kitchen/utensil/spoon,
		/obj/item/kitchen/utensil/spork,
		/obj/item/knife,
		/obj/item/knife/combat,
		/obj/item/knife/folding/swiss,
		/obj/item/knife/ritual,
		/obj/item/knife/ritual/sacrifice,
		/obj/item/knife/ritual/shadow,
		/obj/item/knife/table,
		/obj/item/knife/utility,
		/obj/item/light,
		/obj/item/light/bulb/fire,
		/obj/item/machine_chassis,
		/obj/item/magic_hand,
		/obj/item/magic_rock,
		/obj/item/matter_decompiler,
		/obj/item/mech_component,
		/obj/item/mech_component/chassis,
		/obj/item/mech_component/manipulators,
		/obj/item/mech_component/propulsion,
		/obj/item/mech_component/sensors,
		/obj/item/mech_equipment,
		/obj/item/mech_equipment/mounted_system,
		/obj/item/minihoe/unbreakable,
		/obj/item/mmi/digital,
		/obj/item/mmi/digital/robot,
		/obj/item/modular_computer,
		/obj/item/modular_computer/telescreen,
		/obj/item/modular_computer/telescreen/preset,
		/obj/item/modular_computer/telescreen/preset/engineering,
		/obj/item/modular_computer/telescreen/preset/generic,
		/obj/item/modular_computer/telescreen/preset/medical,
		/obj/item/multitool/finger,
		/obj/item/multitool/uplink,
		/obj/item/ore,
		/obj/item/organ,
		/obj/item/organ/external,
		/obj/item/organ/external/stump,
		/obj/item/organ/internal,
		/obj/item/organ/internal/augment,
		/obj/item/organ/internal/augment/active,
		/obj/item/organ/internal/augment/active/polytool,
		/obj/item/organ/internal/augment/active/simple,
		/obj/item/organ/internal/augment/boost,
		/obj/item/organ/internal/brain/golem,
		/obj/item/pack,
		/obj/item/pai_cable,
		/obj/item/party_light,
		/obj/item/passport,
		/obj/item/pen/robopen,
		/obj/item/personal_shield,
		/obj/item/pickaxe/xeno,
		/obj/item/pinpointer,
		/obj/item/pinpointer/advpinpointer,
		/obj/item/pinpointer/nukeop,
		/obj/item/pipe,
		/obj/item/pipe/tank,
		/obj/item/plantspray,
		/obj/item/portable_destructive_analyzer,
		/obj/item/proxy_debug,
		/obj/item/proxy_debug/line,
		/obj/item/proxy_debug/square,
		/obj/item/rcd/borg,
		/obj/item/rcd/mounted,
		/obj/item/research,
		/obj/item/rig,
		/obj/item/rig_module,
		/obj/item/rig_module/chem_dispenser,
		/obj/item/rig_module/device,
		/obj/item/rig_module/fabricator,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision,
		/obj/item/robot_harvester,
		/obj/item/robot_parts,
		/obj/item/robot_parts/robot_component,
		/obj/item/robot_rack,
		/obj/item/robot_rack/body_bag,
		/obj/item/robot_rack/roller,
		/obj/item/rocksliver,
		/obj/item/rsf,
		/obj/item/scanner,
		/obj/item/screwdriver/finger,
		/obj/item/scrying,
		/obj/item/seeds,
		/obj/item/shield,
		/obj/item/shockpaddles,
		/obj/item/shockpaddles/linked,
		/obj/item/shockpaddles/linked/combat,
		/obj/item/shockpaddles/rig,
		/obj/item/shockpaddles/robot,
		/obj/item/shockpaddles/standalone,
		/obj/item/shockpaddles/standalone/traitor,
		/obj/item/shreddedp,
		/obj/item/sign,
		/obj/item/sign/medipolma,
		/obj/item/slime_extract,
		/obj/item/smallDelivery,
		/obj/item/soulstone,
		/obj/item/soulstone/full,
		/obj/item/spellbook,
		/obj/item/spellbook/apprentice,
		/obj/item/spellbook/cleric,
		/obj/item/spellbook/druid,
		/obj/item/spellbook/spatial,
		/obj/item/spellbook/standard,
		/obj/item/spellbook/student,
		/obj/item/spike,
		/obj/item/stack,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/cable_coil/fabricator,
		/obj/item/stack/flag,
		/obj/item/stack/material,
		/obj/item/stack/medical,
		/obj/item/stack/medical/advanced,
		/obj/item/stack/package_wrap/cyborg,
		/obj/item/stack/telecrystal,
		/obj/item/stack/tile,
		/obj/item/stamp,
		/obj/item/star,
		/obj/item/stick,
		/obj/item/stock_parts,
		/obj/item/stock_parts/access_lock,
		/obj/item/stock_parts/building_material,
		/obj/item/stock_parts/circuitboard,
		/obj/item/stock_parts/computer,
		/obj/item/stock_parts/network_receiver,
		/obj/item/stock_parts/network_receiver/network_lock,
		/obj/item/stock_parts/power,
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery,
		/obj/item/stock_parts/power/battery/buildable,
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/radio,
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/radio/transmitter,
		/obj/item/stock_parts/radio/transmitter/basic,
		/obj/item/stock_parts/radio/transmitter/on_event,
		/obj/item/stock_parts/shielding,
		/obj/item/stock_parts/subspace,
		/obj/item/stool,
		/obj/item/stool/bar,
		/obj/item/stool/stone,
		/obj/item/storage,
		/obj/item/storage/backpack/holding,
		/obj/item/storage/backpack/holding/duffle,
		/obj/item/storage/backpack/holding/quantum,
		/obj/item/storage/bag,
		/obj/item/storage/bag/cash/infinite,
		/obj/item/storage/bag/plasticbag,
		/obj/item/storage/bag/trash/advanced,
		/obj/item/storage/belt/soulstone,
		/obj/item/storage/belt/soulstone/full,
		/obj/item/storage/box/secret_project_disks,
		/obj/item/storage/box/secret_project_disks/science,
		/obj/item/storage/box/supermatters,
		/obj/item/storage/chewables,
		/obj/item/storage/chewables/candy,
		/obj/item/storage/chewables/rollable,
		/obj/item/storage/fancy,
		/obj/item/storage/internal,
		/obj/item/storage/internal/pockets,
		/obj/item/storage/internal/pouch,
		/obj/item/storage/laundry_basket,
		/obj/item/storage/laundry_basket/offhand,
		/obj/item/storage/mech,
		/obj/item/storage/med_pouch,
		/obj/item/storage/messenger,
		/obj/item/storage/mirror,
		/obj/item/storage/mre,
		/obj/item/storage/mrebag,
		/obj/item/storage/pill_bottle,
		/obj/item/storage/secure,
		/obj/item/storage/secure/safe,
		/obj/item/storage/secure/briefcase/nukedisk,
		/obj/item/storage/secure/briefcase/money,
		/obj/item/storage/sheetsnatcher,
		/obj/item/storage/sheetsnatcher/borg,
		/obj/item/storage/toolbox,
		/obj/item/storage/tray,
		/obj/item/storage/tray/robotray,
		/obj/item/storage/tray/metal,
		/obj/item/storage/wallet,
		/obj/item/summoning_stone,
		/obj/item/supply_beacon,
		/obj/item/supply_beacon/supermatter,
		/obj/item/sword,
		/obj/item/sword/cultblade,
		/obj/item/sword/excalibur,
		/obj/item/synthesized_instrument,
		/obj/item/tankassemblyproxy,
		/obj/item/tape/loose,
		/obj/item/teleportation_scroll,
		/obj/item/toy,
		/obj/item/toy/desk,
		/obj/item/toy/figure,
		/obj/item/toy/plushie,
		/obj/item/toy/prize,
		/obj/item/trash,
		/obj/item/twohanded,
		/obj/item/underwear,
		/obj/item/underwear/bottom,
		/obj/item/underwear/socks,
		/obj/item/underwear/top,
		/obj/item/underwear/undershirt,
		/obj/item/uplink,
		/obj/item/uplink/contained,
		/obj/item/uplink_service,
		/obj/item/urn,
		/obj/item/vampiric,
		/obj/item/voice_changer,
		/obj/item/weldingtool/finger,
		/obj/item/weldingtool/electric,
		/obj/item/whip,
		/obj/item/whip/abyssal,
		/obj/item/whip/tail,
		/obj/item/wirecutters/finger,
		/obj/item/wrench/finger,
		/obj/item/natural_weapon = TRADER_BLACKLIST_ALL,
		/obj/item/radio,
		/obj/item/radio/announcer = TRADER_BLACKLIST_ALL,
		/obj/item/radio/beacon/anchored,
		/obj/item/radio/borg = TRADER_BLACKLIST_ALL,
		/obj/item/radio/exosuit,
		/obj/item/radio/headset = TRADER_BLACKLIST_SUB,
		/obj/item/radio/intercept,
		/obj/item/radio/intercom = TRADER_BLACKLIST_ALL,
		/obj/item/radio/phone = TRADER_BLACKLIST_ALL,
		/obj/item/radio/spy,
		/obj/item/radio/uplink,
		/obj/item/radio/virtual,
		/obj/item/card/id = TRADER_BLACKLIST_SUB,
		/obj/item/encryptionkey = TRADER_BLACKLIST_ALL,
		/obj/item/projectile = TRADER_BLACKLIST_ALL,
		/obj/item/robot_module = TRADER_BLACKLIST_ALL,
		/obj/item/paper = TRADER_BLACKLIST_SUB
	)

/datum/trader/New()
	..()
	for(var/type in blacklisted_types)
		if(blacklisted_types[type] == TRADER_BLACKLIST_ALL)
			blacklisted_types += typesof(type)
		if(blacklisted_types[type] == TRADER_BLACKLIST_SUB)
			blacklisted_types += subtypesof(type)
	if(!ispath(trader_currency, /decl/currency))
		trader_currency = global.using_map.default_currency
	if(name_language)
		if(name_language == TRADER_DEFAULT_NAME)
			name = capitalize(pick(global.first_names_female + global.first_names_male)) + " " + capitalize(pick(global.last_names))
		else
			var/decl/language/L = GET_DECL(name_language)
			if(istype(L))
				name = L.get_random_name(pick(MALE,FEMALE))
	if(possible_origins && possible_origins.len)
		origin = pick(possible_origins)

	for(var/i in 3 to 9)
		add_to_pool(trading_items, possible_trading_items, force = 1)
		add_to_pool(wanted_items, possible_wanted_items, force = 1)

//If this hits 0 then they decide to up and leave.
/datum/trader/proc/tick()
	add_to_pool(trading_items, possible_trading_items, 200)
	add_to_pool(wanted_items, possible_wanted_items, 50)
	remove_from_pool(possible_trading_items, 9) //We want the stock to change every so often, so we make it so that they have roughly 10~11 ish items max
	return 1

/datum/trader/proc/remove_from_pool(var/list/pool, var/chance_per_item)
	if(pool && prob(chance_per_item * pool.len))
		var/i = rand(1,pool.len)
		pool[pool[i]] = null
		pool -= pool[i]

/datum/trader/proc/add_to_pool(var/list/pool, var/list/possible, var/base_chance = 100, var/force = 0)
	var/divisor = 1
	if(pool && pool.len)
		divisor = pool.len
	if(force || prob(base_chance/divisor))
		var/new_item = get_possible_item(possible)
		if(new_item)
			pool |= new_item

/datum/trader/proc/get_possible_item(var/list/trading_pool)
	if(!trading_pool || !trading_pool.len)
		return
	var/list/possible = list()
	for(var/type in trading_pool)
		var/status = trading_pool[type]
		if(status & TRADER_THIS_TYPE)
			possible += type
		if(status & TRADER_SUBTYPES_ONLY)
			possible += subtypesof(type)
		if(status & TRADER_BLACKLIST)
			possible -= type
		if(status & TRADER_BLACKLIST_SUB)
			possible -= subtypesof(type)
	possible -= blacklisted_types
	return SAFEPICK(possible)

/datum/trader/proc/get_response(var/key, var/default)
	if(speech && speech[key])
		. = speech[key]
	else
		. = default
	. = replacetext(., "MERCHANT", name)
	. = replacetext(., "ORIGIN", origin)

	var/decl/currency/cur = GET_DECL(trader_currency)
	. = replacetext(.,"CURRENCY_SINGULAR", cur.name_singular)
	. = replacetext(.,"CURRENCY", cur.name)

/datum/trader/proc/print_trading_items(var/num)
	num = Clamp(num,1,trading_items.len)
	if(trading_items[num])
		return "<b>[atom_info_repository.get_name_for(trading_items[num])]</b>"

/datum/trader/proc/skill_curve(skill)
	switch(skill)
		if(SKILL_EXPERT)
			. = 1
		if(SKILL_EXPERT to SKILL_MAX)
			. = 1 + (SKILL_EXPERT - skill) * 0.2
		else
			. = 1 + (SKILL_EXPERT - skill) ** 2
	//This condition ensures that the buy price is higher than the sell price on generic goods, i.e. the merchant can't be exploited
	. = max(., price_rng/((margin - 1)*(200 - price_rng)))

/datum/trader/proc/get_item_value(var/trading_num, skill = SKILL_MAX)
	if(!trading_items[trading_items[trading_num]])
		var/item_type = trading_items[trading_num]
		var/value = atom_info_repository.get_combined_worth_for(item_type)
		value = round(rand(100 - price_rng,100 + price_rng)/100 * value) //For some reason rand doesn't like decimals.
		trading_items[item_type] = value
	. = trading_items[trading_items[trading_num]]
	. *= 1 + (margin - 1) * skill_curve(skill) //Trader will overcharge at lower skill.
	. = max(1, round(.))

/datum/trader/proc/get_buy_price(var/atom/movable/item, is_wanted, skill = SKILL_MAX, force_sell = FALSE)
	if(ispath(item, /atom/movable))
		. = atom_info_repository.get_combined_worth_for(item)
	else if(istype(item))
		. = item.get_combined_monetary_worth()
	if(is_wanted)
		. *= want_multiplier
	. *= max(1 - (margin - 1) * skill_curve(skill), 0.1) //Trader will underpay at lower skill.
	. = max(1, round(.))
	if(force_sell)
		. *= force_sell_multiplier

/datum/trader/proc/offer_money_for_trade(var/trade_num, var/money_amount, skill = SKILL_MAX)
	if(!(trade_flags & TRADER_MONEY))
		return TRADER_NO_MONEY
	var/value = get_item_value(trade_num, skill)
	if(money_amount < value)
		return TRADER_NOT_ENOUGH
	return value

/datum/trader/proc/offer_items_for_trade(var/list/offers, var/num, var/turf/location, skill = SKILL_MAX)
	if(!offers || !offers.len)
		return TRADER_NOT_ENOUGH
	num = Clamp(num, 1, trading_items.len)
	var/offer_worth = 0
	for(var/item in offers)
		var/atom/movable/offer = item
		var/is_wanted = 0
		if((trade_flags & TRADER_WANTED_ONLY) && is_type_in_list(offer,wanted_items))
			is_wanted = 2
		if((trade_flags & TRADER_WANTED_ALL) && is_type_in_list(offer,possible_wanted_items))
			is_wanted = 1
		if(blacklisted_trade_items && blacklisted_trade_items.len && is_type_in_list(offer,blacklisted_trade_items))
			return 0

		if(istype(offer,/obj/item/cash))
			if(!(trade_flags & TRADER_MONEY))
				return TRADER_NO_MONEY
		else
			if(!(trade_flags & TRADER_GOODS))
				return TRADER_NO_GOODS
			else if((trade_flags & TRADER_WANTED_ONLY|TRADER_WANTED_ALL) && !is_wanted)
				return TRADER_FOUND_UNWANTED

		offer_worth += get_buy_price(offer, is_wanted - 1, skill)
	if(!offer_worth)
		return TRADER_NOT_ENOUGH
	var/trading_worth = get_item_value(num, skill)
	if(!trading_worth)
		return TRADER_NOT_ENOUGH
	var/percent = offer_worth/trading_worth
	if(percent > max(0.9,0.9-disposition/100))
		return trade(offers, num, location)
	return TRADER_NOT_ENOUGH

/datum/trader/proc/hail(var/mob/user)
	var/specific
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species)
			specific = H.species.name
	else if(istype(user, /mob/living/silicon))
		specific = "silicon"
	if(!speech["hail_[specific]"])
		specific = "generic"
	. = get_response("hail_[specific]", "Greetings, MOB!")
	. = replacetext(., "MOB", user.name)

/datum/trader/proc/can_hail()
	if(!refuse_comms && prob(-disposition))
		refuse_comms = 1
	return !refuse_comms

/datum/trader/proc/insult()
	disposition -= rand(insult_drop, insult_drop * 2)
	if(prob(-disposition/10))
		refuse_comms = 1
	if(disposition > 50)
		return get_response("insult_good","What? I thought we were cool!")
	else
		return get_response("insult_bad", "Right back at you asshole!")

/datum/trader/proc/compliment()
	if(prob(-disposition))
		return get_response("compliment_deny", "Fuck you!")
	if(prob(100-disposition))
		disposition += rand(compliment_increase, compliment_increase * 2)
	return get_response("compliment_accept", "Thank you!")

/datum/trader/proc/trade(var/list/offers, var/num, var/turf/location)
	if(offers && offers.len)
		for(var/offer in offers)
			if(istype(offer,/mob))
				var/text = mob_transfer_message
				to_chat(offer, replacetext(text, "ORIGIN", origin))
			qdel(offer)

	var/type = trading_items[num]

	var/atom/movable/M = new type(location)
	playsound(location, 'sound/effects/teleport.ogg', 50, 1)

	disposition += rand(compliment_increase,compliment_increase*3) //Traders like it when you trade with them

	return M

/datum/trader/proc/how_much_do_you_want(var/num, skill = SKILL_MAX)
	. = get_response("how_much", "Hmm.... how about VALUE CURRENCY?")
	. = replacetext(.,"VALUE",get_item_value(num, skill))
	. = replacetext(.,"ITEM", atom_info_repository.get_name_for(trading_items[num]))

/datum/trader/proc/what_do_you_want()
	if(!(trade_flags & TRADER_GOODS))
		return get_response(TRADER_NO_GOODS, "I don't deal in goods.")
	. = get_response("what_want", "Hm, I want")
	var/list/want_english = list()
	for(var/wtype in wanted_items)
		want_english += atom_info_repository.get_name_for(wtype)
	. += " [english_list(want_english)]"

/datum/trader/proc/sell_items(var/list/offers, skill = SKILL_MAX)
	if(!(trade_flags & TRADER_GOODS))
		return TRADER_NO_GOODS
	if(!offers || !offers.len)
		return TRADER_NOT_ENOUGH

	var/wanted
	var/force_selling
	. = 0
	for(var/offer in offers)
		if((trade_flags & TRADER_WANTED_ONLY) && is_type_in_list(offer,wanted_items))
			wanted = 1
		else if((trade_flags & TRADER_WANTED_ALL) && is_type_in_list(offer,possible_wanted_items))
			wanted = 0
		else
			force_selling = TRUE
		. += get_buy_price(offer, wanted, skill, force_selling)

	playsound(get_turf(offers[1]), 'sound/effects/teleport.ogg', 50, 1)
	for(var/offer in offers)
		qdel(offer)

/datum/trader/proc/bribe_to_stay_longer(var/amt)
	return get_response("bribe_refusal", "How about... no?")

/datum/trader/Destroy(force)
	if(hub)
		hub.traders -= src
	. = ..()
