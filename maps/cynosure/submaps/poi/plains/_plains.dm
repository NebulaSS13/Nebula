// The 'plains' is the area outside the immediate perimeter of the big outpost.
// POIs here should not be dangerous, be mundane, and be somewhat conversative on the loot. Some of the loot can be useful, but it shouldn't trivialize the Wilderness.

/datum/map_template/sif/plains
	name = "Surface Content - Plains"
	desc = "Used to make the surface outside the outpost be 16% less boring."
	template_categories = list(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_PLAINS)
	abstract_type = /datum/map_template/sif/plains

/datum/map_template/sif/plains/farm1
	name = "Farm 1"
	desc = "A small farm tended by a farmbot."
	mappaths = list("maps/cynosure/submaps/poi/plains/farm1.dmm")
	cost = 10

/datum/map_template/sif/plains/construction1
	name = "Construction Site 1"
	desc = "A structure being built. It seems laziness is not limited to engineers."
	mappaths = list("maps/cynosure/submaps/poi/plains/construction1.dmm")
	cost = 10

/datum/map_template/sif/plains/camp1
	name = "Camp Site 1"
	desc = "A small campsite, complete with housing and bonfire."
	mappaths = list("maps/cynosure/submaps/poi/plains/camp1.dmm")
	cost = 10

/datum/map_template/sif/plains/house1
	name = "House 1"
	desc = "A fair sized house out in the frontier, that belonged to a well-traveled explorer."
	mappaths = list("maps/cynosure/submaps/poi/plains/house1.dmm")
	cost = 10

/datum/map_template/sif/plains/Epod
	name = "Emergency Pod"
	desc = "A vacant Emergency pod in the middle of nowhere."
	mappaths = list("maps/cynosure/submaps/poi/plains/Epod.dmm")
	cost = 5

/datum/map_template/sif/plains/Epod2
	name = "Emergency Pod 2"
	desc = "A locked Emergency pod in the middle of nowhere."
	mappaths = list("maps/cynosure/submaps/poi/plains/Epod2.dmm")
	cost = 5

/datum/map_template/sif/plains/normal/Rocky2
	name =  "Rocky 2"
	desc = "More rocks."
	mappaths = list("maps/cynosure/submaps/poi/wilderness/Rocky2.dmm")
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES
	cost = 5

/datum/map_template/sif/plains/PascalB
	name = "Irradiated Manhole Cover"
	desc = "How did this old thing get all the way out here?"
	mappaths = list("maps/cynosure/submaps/poi/plains/PascalB.dmm")
	cost = 5

/datum/map_template/sif/plains/bonfire
	name = "Abandoned Bonfire"
	desc = "Someone seems to enjoy orange juice a bit too much."
	mappaths = list("maps/cynosure/submaps/poi/plains/bonfire.dmm")
	cost = 5

/datum/map_template/sif/plains/Rocky5
	name = "Rocky 5"
	desc = "More rocks, Less Stalone"
	mappaths = list("maps/cynosure/submaps/poi/plains/Rocky5.dmm")
	cost = 5

/datum/map_template/sif/plains/Shakden
	name = "Shantak Den"
	desc = "Not to be confused with Shaq Den"
	mappaths = list("maps/cynosure/submaps/poi/plains/Shakden.dmm")
	cost = 10

/datum/map_template/sif/plains/Field1
	name = "Field 1"
	desc = "A regular field with a tug on it"
	mappaths = list("maps/cynosure/submaps/poi/plains/Field1.dmm")
	cost = 20

/datum/map_template/sif/plains/Thiefc
	name = "Thieves Cave"
	desc = "A thieves stash"
	mappaths = list("maps/cynosure/submaps/poi/plains/Thiefc.dmm")
	cost = 20

/datum/map_template/sif/plains/smol2
	name = "Small 2"
	desc = "A small formation of mishaped surgery"
	mappaths = list("maps/cynosure/submaps/poi/plains/smol2.dmm")
	cost = 10

/datum/map_template/sif/plains/Mechpt
	name = "Mechpit"
	desc = "A illmade Mech brawling ring"
	mappaths = list("maps/cynosure/submaps/poi/plains/Mechpt.dmm")
	cost = 15

/datum/map_template/sif/plains/Boathouse
	name = "Boathouse"
	desc = "A fance house on a lake."
	mappaths = list("maps/cynosure/submaps/poi/plains/Boathouse.dmm")
	cost = 30

/datum/map_template/sif/plains/PooledR
	name = "Pooled Rocks"
	desc = "An intresting rocky location"
	mappaths = list("maps/cynosure/submaps/poi/plains/PooledR.dmm")
	cost = 15

/datum/map_template/sif/plains/Smol3
	name = "Small 3"
	desc = "A small stand"
	mappaths = list("maps/cynosure/submaps/poi/plains/Smol3.dmm")
	cost = 10

/datum/map_template/sif/plains/Diner
	name = "Diner"
	desc = "Old Timey Tasty"
	mappaths = list("maps/cynosure/submaps/poi/plains/Diner.dmm")
	cost = 25

/datum/map_template/sif/plains/snow1
	name = "Snow 1"
	desc = "Snow"
	mappaths = list("maps/cynosure/submaps/poi/plains/snow1.dmm")
	cost = 5

/datum/map_template/sif/plains/snow2
	name = "Snow 2"
	desc = "More snow"
	mappaths = list("maps/cynosure/submaps/poi/plains/snow2.dmm")
	cost = 5

/datum/map_template/sif/plains/snow3
	name = "Snow 3"
	desc = "Snow Snow Snow"
	mappaths = list("maps/cynosure/submaps/poi/plains/snow3.dmm")
	cost = 5

/datum/map_template/sif/plains/snow4
	name = "Snow 4"
	desc = "Too much snow"
	mappaths = list("maps/cynosure/submaps/poi/plains/snow4.dmm")
	cost = 5

/datum/map_template/sif/plains/snow5
	name = "Snow 5"
	desc = "Please stop the snow"
	mappaths = list("maps/cynosure/submaps/poi/plains/snow5.dmm")
	cost = 5

/datum/map_template/sif/plains/RationCache
	name = "Ration Cache"
	desc = "A forgotten cache of emergency rations."
	mappaths = list("maps/cynosure/submaps/poi/plains/RationCache.dmm")
	cost = 5

/datum/map_template/sif/plains/SupplyDrop2
	name = "Old Supply Drop"
	desc = "A drop pod that's clearly been here a while, most of the things inside are rusted and worthless."
	mappaths = list("maps/cynosure/submaps/poi/plains/SupplyDrop2.dmm")
	cost = 8

/datum/map_template/sif/plains/Oldhouse
	name = "Old House"
	desc = "Someones old library it seems.."
	mappaths = list("maps/cynosure/submaps/poi/plains/Oldhouse.dmm")
	cost = 15

/datum/map_template/sif/plains/ChemSpill1
	name = "Ruptured Canister"
	desc = "A dumped chemical canister. Looks dangerous."
	mappaths = list("maps/cynosure/submaps/poi/plains/chemspill1.dmm")
	cost = 10

/datum/map_template/sif/plains/PlainsKururak
	name = "Lone Kururak"
	desc = "A lone Kururak's den."
	mappaths = list("maps/cynosure/submaps/poi/plains/PlainsKururak.dmm")
	cost = 10

/datum/map_template/sif/plains/BuriedTreasure1
	name = "Buried Treasure 1"
	desc = "A hole in the ground, who knows what might be inside!"
	mappaths = list("maps/cynosure/submaps/poi/plains/BuriedTreasure.dmm")
	cost = 10

/datum/map_template/sif/plains/BuriedTreasure2
	name = "Buried Treasure 2"
	desc = "A hole in the ground, who knows what might be inside!"
	mappaths = list("maps/cynosure/submaps/poi/plains/BuriedTreasure2.dmm")
	cost = 10

/datum/map_template/sif/plains/BuriedTreasure3
	name = "Buried Treasure 3"
	desc = "A hole in the ground, who knows what might be inside!"
	mappaths = list("maps/cynosure/submaps/poi/plains/BuriedTreasure3.dmm")
	cost = 10

/datum/map_template/sif/plains/oldhotel
	name = "Old Hotel"
	desc = "A abandoned hotel of sort, wonder why it was left behind."
	mappaths = list("maps/cynosure/submaps/poi/plains/oldhotel.dmm")
	cost = 15

/datum/map_template/sif/plains/priderock
	name = "Pride Rock"
	desc = "A quite steep petruding rock from the earth, looks like a good hike."
	mappaths = list("maps/cynosure/submaps/poi/plains/priderock.dmm")
	cost = 10

/datum/map_template/sif/plains/lonehome
	name = "Lone Home"
	desc = "A quite inoffensive looking home, damaged but still holding up."
	mappaths = list("maps/cynosure/submaps/poi/plains/lonehome.dmm")
	cost = 15

/datum/map_template/sif/plains/hotspring
	name = "Hot Spring"
	desc = "Wait what, a hotspring in a frost planet?"
	mappaths = list("maps/cynosure/submaps/poi/plains/hotspring.dmm")
	cost = 5

/datum/map_template/sif/plains/methlab
	name = "Meth Lab"
	desc = "A broken down greenhouse lab?, this does not look safe."
	mappaths = list("maps/cynosure/submaps/poi/plains/methlab.dmm")
	cost = 15

/datum/map_template/sif/plains/VRDen
	name = "VR Den"
	desc = "A temporarily abandoned VR den, still functional."
	mappaths = list("maps/cynosure/submaps/poi/plains/VRDen.dmm")
	cost = 10

/datum/map_template/sif/plains/reststop
	name = "Rest Stop"
	desc = "Once this place was a nice spot to take a load off, now the wildlife call it home."
	mappaths = list("maps/cynosure/submaps/poi/plains/reststop.dmm")
	cost = 10

/datum/map_template/sif/plains/animalruin_den
	name = "Ruin Den"
	desc = "A small fallen cabin that a creature is nesting in."
	mappaths = list("maps/cynosure/submaps/poi/plains/animalruin_den.dmm")
	cost = 5

/datum/map_template/sif/plains/crescent_den
	name = "Crescent Den"
	desc = "An animal den, shaped like a cresecent moon."
	mappaths = list("maps/cynosure/submaps/poi/plains/crescent_den.dmm")
	cost = 5

/datum/map_template/sif/plains/plainsdrake_den
	name = "Plains Drake Den"
	desc = "A cave where a drake is living."
	mappaths = list("maps/cynosure/submaps/poi/plains/plainsdrake_den.dmm")
	cost = 10

/datum/map_template/sif/plains/pondside_den
	name = "Pond Den"
	desc = "A small animal den by a pond."
	mappaths = list("maps/cynosure/submaps/poi/plains/pondside_den.dmm")
	cost = 5

/datum/map_template/sif/plains/swampy_den
	name = "Swamp Den"
	desc = "A muddy animal den."
	mappaths = list("maps/cynosure/submaps/poi/plains/swampy_den.dmm")
	cost = 5

/datum/map_template/sif/plains/TapeHouse
	name = "Tape House"
	desc = "An eerie and untouched abandoned home."
	mappaths = list("maps/cynosure/submaps/poi/plains/TapeHouse.dmm")
	cost = 15
