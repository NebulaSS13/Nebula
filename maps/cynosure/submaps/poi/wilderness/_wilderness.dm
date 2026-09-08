// The 'wilderness' is the endgame for Explorers. Extremely dangerous and far away from help, but with vast shinies.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The top half connects to the outpost z-level, and is seperated from the bottom half by a river. It should provide a challenge to a well equiped Explorer team.
// The bottom half should be even more dangerous, where only the robust, fortunate, or lucky can survive.
/datum/map_template/sif/wilderness
	name = "Surface Content - Wildy"
	desc = "Used to make the surface's wilderness be 17% less boring."
	abstract_type = /datum/map_template/sif/wilderness

// 'Normal' templates get used on the top half, and should be challenging.
/datum/map_template/sif/wilderness/normal
	template_categories = list(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_WILDERNESS)
	abstract_type = /datum/map_template/sif/wilderness/normal

// 'Deep' templates get used on the bottom half, and should be (even more) dangerous and rewarding.
/datum/map_template/sif/wilderness/deep
	template_categories = list(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_DEEP_WILDERNESS)
	abstract_type = /datum/map_template/sif/wilderness/deep

/datum/map_template/sif/wilderness/normal/spider1
	name = "Spider Nest 1"
	desc = "A small spider nest, in the forest."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/spider1.dmm")
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES
	cost = 5

/datum/map_template/sif/wilderness/normal/Flake
	name = "Forest Lake"
	desc = "A serene lake sitting amidst the surface."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Flake.dmm")
	cost = 10

/datum/map_template/sif/wilderness/normal/Mcamp1
	name = "Military Camp 1"
	desc = "A derelict military camp host to some unsavory dangers"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/MCamp1.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/Mudpit
	name = "Mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Mudpit.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/Rocky1
	name = "Wilderness Rocky 1"
	desc = "DununanununanununuNAnana"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Rocky1.dmm")
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES
	cost = 5

/datum/map_template/sif/wilderness/normal/Rocky2
	name =  "Wilderness Rocky 2"
	desc = "More rocks."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Rocky2.dmm")
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES
	cost = 5

/datum/map_template/sif/wilderness/normal/Rocky3
	name = "Wilderness Rocky 3"
	desc = "More and more and more rocks."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Rocky3.dmm")
	desc = "DununanununanununuNAnana"
	cost = 5

/datum/map_template/sif/wilderness/normal/Shack1
	name = "Shack 1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Shack1.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/Smol1
	name = "Smol 1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Smol1.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/Snowrock1
	name = "Snowrock 1"
	desc = "A rocky snow covered area"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Snowrock1.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/Cragzone1
	name = "Cragzone 1"
	desc = "Rocks and more rocks."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Cragzone1.dmm")
	cost = 5
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/datum/map_template/sif/wilderness/normal/Lab1
	name = "Lab 1"
	desc = "An isolated small robotics lab."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Lab1.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/Rocky4
	name = "Rocky 4"
	desc = "An interesting geographic formation."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Rocky4.dmm")
	cost = 5

/datum/map_template/sif/wilderness/deep/DJOutpost1
	name = "DJOutpost 1"
	desc = "Home of Sif Free Radio, the best - and only - radio station for miles around."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/DJOutpost1.dmm")
	cost = 5

/datum/map_template/sif/wilderness/deep/DJOutpost2
	name = "DJOutpost 2"
	desc = "The cratered remains of Sif Free Radio, the best - and only - radio station for miles around."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/DJOutpost2.dmm")
	cost = 5

/datum/map_template/sif/wilderness/deep/DJOutpost3
	name = "DJOutpost 3"
	desc = "The surprisingly high-tech home of Sif Free Radio, the best - and only - radio station for miles around."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/DJOutpost3.dmm")
	cost = 10

/datum/map_template/sif/wilderness/deep/DJOutpost4
	name = "DJOutpost 4"
	desc = "The surprisingly high-tech home of Sif Free Radio, the only radio station run by mindless clones."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/DJOutpost4.dmm")
	cost = INFINITY /// Prevent spawning.

/datum/map_template/sif/wilderness/deep/Boombase
	name = "Boombase"
	desc = "What happens when you don't follow SOP."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Boombase.dmm")
	cost = 5

/datum/map_template/sif/wilderness/deep/BSD
	name = "Black Shuttle Down"
	desc = "You REALLY shouldn't be near this."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Blackshuttledown.dmm")
	cost = 30

/datum/map_template/sif/wilderness/deep/BluSD
	name = "Blue Shuttle Down"
	desc = "You REALLY shouldn't be near this. Mostly because they're SolGov."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Blueshuttledown.dmm")
	cost = INFINITY /// Prevent spawning.

/datum/map_template/sif/wilderness/deep/Rockybase
	name = "Rocky Base"
	desc = "A guide to upsetting Icarus and the EIO"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Rockybase.dmm")
	cost = 35

/datum/map_template/sif/wilderness/deep/MHR
	name = "Manhack Rock"
	desc = "A rock filled with nasty Synthetics."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/MHR.dmm")
	cost = 15

/datum/map_template/sif/wilderness/normal/GovPatrol
	name = "Government Patrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/GovPatrol.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/KururakDen
	name = "Kururak Den"
	desc = "The den of a Kururak pack. May contain hibernating members."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/kururakden.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/GrafadrekaDen
	name = "Grafadreka Den"
	desc = "The den of a Grafadreka pack. May contain hibernating members."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/grafadreka_den.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/DecoupledEngine
	name = "Decoupled Engine"
	desc = "A damaged fission engine jettisoned from a starship long ago."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/DecoupledEngine.dmm")
	cost = 15

/datum/map_template/sif/wilderness/deep/DoomP
	name = "DoomP"
	desc = "Witty description here."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/DoomP.dmm")
	cost = 30

/datum/map_template/sif/wilderness/deep/Cave
	name = "CaveS"
	desc = "Chitter chitter!"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/CaveS.dmm")
	cost = 20

/datum/map_template/sif/wilderness/normal/Drugden
	name = "Drug Den"
	desc = "The remains of ill thought out whims."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Drugden.dmm")
	cost = 20

/datum/map_template/sif/wilderness/deep/Manor1
	name = "Manor 1"
	desc = "Whodunit"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Manor1.dmm")
	cost = 20

/datum/map_template/sif/wilderness/deep/Epod3
	name = "Emergency Pod 3"
	desc = "A webbed Emergency pod in the middle of nowhere."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Epod3.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/Epod4
	name = "Emergency Pod 4"
	desc = "A flooded Emergency pod in the middle of nowhere."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Epod4.dmm")
	cost = 5

/datum/map_template/sif/wilderness/normal/ButcherShack
	name = "Butcher Shack"
	desc = "An old, bloody butcher's shack. Get your meat here!"
	mappaths = list("maps/cynosure/submaps/poi/wilderness/butchershack.dmm")
	cost = 5

/datum/map_template/sif/wilderness/deep/Chapel1
	name = "Chapel 1"
	desc = "The chapel of lights and a robot."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Chapel.dmm")
	cost = 20

/datum/map_template/sif/wilderness/normal/Shelter1
	name = "Shelter 1"
	desc = "The bitter end of a house after a drop pod crashed into it."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Shelter.dmm")
	cost = 10

/datum/map_template/sif/wilderness/normal/ChemSpill2
	name = "Acrid Lake"
	desc = "A pool of water contaminated with highly dangerous chemicals."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/chemspill2.dmm")
	cost = 10

/datum/map_template/sif/wilderness/normal/FrostflyNest
	name = "Frostfly Nest"
	desc = "The nest of a Frostfly, or more."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/FrostflyNest.dmm")
	cost = 20

/datum/map_template/sif/wilderness/deep/DerelictEngine
	name = "Derelict Engine"
	desc = "An crashed alien ship, something went wrong inside."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/derelictengine.dmm")
	cost = 45

/datum/map_template/sif/wilderness/normal/WolfDen
	name = "Wolf Den"
	desc = "Small wolf den and their hunt spoils."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/wolfden.dmm")
	cost = 10

/datum/map_template/sif/wilderness/normal/DemonPool
	name = "Demon Pool"
	desc = "A cult ritual gone horribly wrong."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/demonpool.dmm")
	cost = 15

/datum/map_template/sif/wilderness/normal/FrostOasis
	name = "Frost Oasis"
	desc = "A strange oasis with a gathering of wild animals."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/frostoasis.dmm")
	cost = 15

/datum/map_template/sif/wilderness/deep/XenoHive
	name = "Xeno Hive"
	desc = "A containment experiment gone wrong."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/xenohive.dmm")
	cost = 25

/datum/map_template/sif/wilderness/deep/BorgLab
	name = "Borg Lab"
	desc = "Production of experimental combat robots gone rogue."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/borglab.dmm")
	cost = 30

/datum/map_template/sif/wilderness/normal/Chasm
	name = "Chasm"
	desc = "An inconspicuous looking cave, watch your step."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/chasm.dmm")
	cost = 20

/datum/map_template/sif/wilderness/deep/DeathDen
	name = "Death Den"
	desc = "Gathering of acolytes gone wrong."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/deathden.dmm")
	cost = 15

/datum/map_template/sif/wilderness/deep/Research
	name = "Gene Research Lab"
	desc = "A covert gene research lab guarded by combat drones."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Research1.dmm")
	cost = 30

/datum/map_template/sif/wilderness/deep/CollapsedMine
	name = "Collapsed Mine"
	desc = "A Grayson expeditionary base, filled with spiders and drone defenders."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/collapsedmine.dmm")
	cost = 45
