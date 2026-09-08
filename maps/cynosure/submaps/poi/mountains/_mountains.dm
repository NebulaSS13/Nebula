// The 'mountains' is the mining z-level, and has a lot of caves.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The bottom half should be fairly tame, with perhaps a few enviromental hazards.
// The top half is when things start getting dangerous, but the loot gets better.

/datum/map_template/sif/mountains
	name = "Mountain Content"
	desc = "Don't dig too deep!"
	abstract_type = /datum/map_template/sif/mountains

// 'Normal' templates get used on the bottom half, and should be safer.
/datum/map_template/sif/mountains/normal
	template_categories = list(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS)
	abstract_type = /datum/map_template/sif/mountains/normal

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/sif/mountains/deep
	template_categories = list(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS_DEEP)
	abstract_type = /datum/map_template/sif/mountains/deep

/****************
 * Normal Caves *
 ****************/

/datum/map_template/sif/mountains/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	mappaths = list("maps/cynosure/submaps/poi/mountains/deadBeacon.dmm")
	cost = 10

/datum/map_template/sif/mountains/normal/prepper1
	name = "Prepper Bunker"
	desc = "A little hideaway for someone with more time and money than sense."
	mappaths = list("maps/cynosure/submaps/poi/mountains/prepper1.dmm")
	cost = 10

/datum/map_template/sif/mountains/normal/qshuttle
	name = "Quarantined Shuttle"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	mappaths = list("maps/cynosure/submaps/poi/mountains/quarantineshuttle.dmm")
	cost = 20

/datum/map_template/sif/mountains/normal/Mineshaft1
	name = "Abandoned Mineshaft 1"
	desc = "An abandoned minning tunnel from a lost money making effort."
	mappaths = list("maps/cynosure/submaps/poi/mountains/Mineshaft1.dmm")
	cost = 5

/datum/map_template/sif/mountains/normal/crystal1
	name = "Crystal Cave 1"
	desc = "A small cave with glowing gems and diamonds."
	mappaths = list("maps/cynosure/submaps/poi/mountains/crystal1.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/crystal2
	name = "Crystal Cave 2"
	desc = "A moderate sized cave with glowing gems and diamonds."
	mappaths = list("maps/cynosure/submaps/poi/mountains/crystal2.dmm")
	cost = 10
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/crystal2
	name = "Crystal Cave 3"
	desc = "A large spiral of crystals with diamonds in the center."
	mappaths = list("maps/cynosure/submaps/poi/mountains/crystal3.dmm")
	cost = 15

/datum/map_template/sif/mountains/normal/lost_explorer
	name = "Lost Explorer"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment."
	mappaths = list("maps/cynosure/submaps/poi/mountains/lost_explorer.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/Rockb1
	name = "Rocky Base 1"
	desc = "Someones underground hidey hole"
	mappaths = list("maps/cynosure/submaps/poi/mountains/Rockb1.dmm")
	cost = 15

/datum/map_template/sif/mountains/normal/corgiritual
	name = "Dark Ritual"
	desc = "Who put all these plushies here? What are they doing?"
	mappaths = list("maps/cynosure/submaps/poi/mountains/ritual.dmm")
	cost = 15

/datum/map_template/sif/mountains/normal/abandonedtemple
	name = "Abandoned Temple"
	desc = "An ancient temple, long since abandoned. Perhaps alien in origin?"
	mappaths = list("maps/cynosure/submaps/poi/mountains/temple.dmm")
	cost = 20

/datum/map_template/sif/mountains/normal/digsite
	name = "Dig Site"
	desc = "A small abandoned dig site."
	mappaths = list("maps/cynosure/submaps/poi/mountains/digsite.dmm")
	cost = 10

/datum/map_template/sif/mountains/normal/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault1.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault2.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault3.dmm")
	cost = 15

/datum/map_template/sif/mountains/normal/IceCave1A
	name = "Ice Cave 1A"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappaths = list("maps/cynosure/submaps/poi/mountains/IceCave1A.dmm")
	cost = 10

/datum/map_template/sif/mountains/normal/IceCave1B
	name = "Ice Cave 1B"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappaths = list("maps/cynosure/submaps/poi/mountains/IceCave1B.dmm")
	cost = 10

/datum/map_template/sif/mountains/normal/IceCave1C
	name = "Ice Cave 1C"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappaths = list("maps/cynosure/submaps/poi/mountains/IceCave1C.dmm")
	cost = 10

/datum/map_template/sif/mountains/normal/SwordCave
	name = "Cursed Sword Cave"
	desc = "An underground lake. The sword on the lake's island holds a terrible secret."
	mappaths = list("maps/cynosure/submaps/poi/mountains/SwordCave.dmm")

/datum/map_template/sif/mountains/normal/supplydrop1
	name = "Supply Drop 1"
	desc = "A drop pod that landed deep within the mountains."
	mappaths = list("maps/cynosure/submaps/poi/mountains/SupplyDrop1.dmm")
	cost = 10
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/crashedcontainmentshuttle
	name = "Crashed Cargo Shuttle"
	desc = "A severely damaged military shuttle, its cargo seems to remain intact."
	mappaths = list("maps/cynosure/submaps/poi/mountains/crashedcontainmentshuttle.dmm")
	cost = 30

/datum/map_template/sif/mountains/normal/deadspy
	name = "Spy Remains"
	desc = "W+M1 = Salt."
	mappaths = list("maps/cynosure/submaps/poi/mountains/deadspy.dmm")
	cost = 15

/datum/map_template/sif/mountains/normal/geyser1
	name = "Ore-Rich Geyser"
	desc = "A subterranean geyser that produces steam. This one has a particularly abundant amount of materials surrounding it."
	mappaths = list("maps/cynosure/submaps/poi/mountains/Geyser1.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/geyser2
	name = "Fenced Geyser"
	desc = "A subterranean geyser that produces steam. This one has a damaged fence surrounding it."
	mappaths = list("maps/cynosure/submaps/poi/mountains/Geyser2.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/geyser3
	name = "Magmatic Geyser"
	desc = "A subterranean geyser that produces incendiary gas. It is recessed into the ground, and filled with magma. It's a relatively dormant volcano."
	mappaths = list("maps/cynosure/submaps/poi/mountains/Geyser2.dmm")
	cost = 10
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/normal/cliff1
	name = "Ore-Topped Cliff"
	desc = "A raised area of rock created by volcanic forces."
	mappaths = list("maps/cynosure/submaps/poi/mountains/Cliff1.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/**************
 * Deep Caves *
 **************/

/datum/map_template/sif/mountains/deep/lost_explorer
	name = "Lost Explorer, Deep"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment. Again."
	mappaths = list("maps/cynosure/submaps/poi/mountains/lost_explorer.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/deep/crashed_ufo
	name = "Crashed UFO"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet it still seems to be running..."
	mappaths = list("maps/cynosure/submaps/poi/mountains/crashed_ufo.dmm")
	cost = 40

/datum/map_template/sif/mountains/deep/crashed_ufo_frigate
	name = "Crashed UFO Frigate"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet the combat protocols still seem to be running..."
	mappaths = list("maps/cynosure/submaps/poi/mountains/crashed_ufo_frigate.dmm")
	cost = 60

/datum/map_template/sif/mountains/deep/Scave1
	name = "Spider Cave 1"
	desc = "A minning tunnel home to an aggressive collection of spiders."
	mappaths = list("maps/cynosure/submaps/poi/mountains/Scave1.dmm")
	cost = 20

/datum/map_template/sif/mountains/deep/CaveTrench
	name = "Cave River"
	desc = "A strange underground river."
	mappaths = list("maps/cynosure/submaps/poi/mountains/CaveTrench.dmm")
	cost = 20

/datum/map_template/sif/mountains/deep/Cavelake
	name = "Cave Lake"
	desc = "A large underground lake."
	mappaths = list("maps/cynosure/submaps/poi/mountains/Cavelake.dmm")
	cost = 20

/datum/map_template/sif/mountains/deep/vault1
	name = "Deep Mine Vault 1"
	desc = "A small vault with potential loot."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault1.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/deep/vault2
	name = "Deep Mine Vault 2"
	desc = "A small vault with potential loot."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault2.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/mountains/deep/vault3
	name = "Deep Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault3.dmm")
	cost = 15

/datum/map_template/sif/mountains/deep/vault4
	name = "Deep Mine Vault 4"
	desc = "A small xeno vault with potential loot. Also horrible suprises."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault4.dmm")
	cost = 20

/datum/map_template/sif/mountains/deep/vault5
	name = "Deep Mine Vault 5"
	desc = "A small xeno vault with potential loot. Also major horrible suprises."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault5.dmm")
	cost = 25

/datum/map_template/sif/mountains/deep/vault6
	name = "Deep Mine Vault 6"
	desc = "A small mercenary tower with potential loot."
	mappaths = list("maps/cynosure/submaps/poi/mountains/vault6.dmm")
	cost = 25

/datum/map_template/sif/mountains/deep/BlastMine1
	name = "Blast Mine 1"
	desc = "An abandoned blast mining site, seems that local wildlife has moved in."
	mappaths = list("maps/cynosure/submaps/poi/mountains/BlastMine1.dmm")
	cost = 20

/datum/map_template/sif/mountains/deep/lava_trench
	name = "lava trench"
	desc = "A long stretch of lava underground, almost river-like, with a small crystal research outpost on the side."
	mappaths = list("maps/cynosure/submaps/poi/mountains/lava_trench.dmm")
	cost = 20

/datum/map_template/sif/mountains/deep/crashedmedshuttle
	name = "Crashed Med Shuttle"
	desc = "A medical response shuttle that went missing some time ago. So this is where they went."
	mappaths = list("maps/cynosure/submaps/poi/mountains/CrashedMedShuttle1.dmm")
	cost = 20

/datum/map_template/sif/mountains/deep/excavation1
	name = "Excavation Site"
	desc = "An abandoned mining site."
	mappaths = list("maps/cynosure/submaps/poi/mountains/excavation1.dmm")
	cost = 20
