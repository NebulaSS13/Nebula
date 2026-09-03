/datum/map/cynosure
	var/const/MAP_TEMPLATE_CATEGORY_CYNOSURE_PLAINS          = "template_category_cynosure_plains"
	var/const/MAP_TEMPLATE_CATEGORY_CYNOSURE_WILDERNESS      = "template_category_cynosure_wilds"
	var/const/MAP_TEMPLATE_CATEGORY_CYNOSURE_DEEP_WILDERNESS = "template_category_cynosure_deepwilds"
	var/const/MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS       = "template_category_cynosuyre_caves"
	var/const/MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS_DEEP  = "template_category_cynosuyre_deepcaves"

/area/cynosure_submap

/datum/map_template/sif
	var/cost = 0
	var/desc

/datum/map_template/cynosure_fixed
	name = "Cynosure Specific Content"

/obj/abstract/landmark/map_load_mark/cynosure/Initialize()
	if(ispath(map_template_names))
		var/list/template_names = list()
		for(var/map_template_type in subtypesof(map_template_names))
			var/datum/map_template/template = map_template_type
			if(TYPE_IS_ABSTRACT(template))
				continue
			var/template_name = template::name
			if(template_name)
				template_names |= template_name
		map_template_names = template_names
	. = ..()

/obj/abstract/landmark/map_load_mark/cynosure/medical_basement
	name = "Cynosure Basement - 5x7 Medical Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/medical_basement

/datum/map_template/cynosure_fixed/medical_basement
	abstract_type = /datum/map_template/cynosure_fixed/medical_basement

/datum/map_template/cynosure_fixed/medical_basement/break_room
	name = "Cynosure Basement - Medical Break Room"
	mappaths = list("maps/cynosure/submaps/5x7/MedicalBreakRoom.dmm")

/datum/map_template/cynosure_fixed/medical_basement/waste_storage
	name = "Cynosure Basement - Medical Waste Storage"
	mappaths = list("maps/cynosure/submaps/5x7/MedicalWasteStorage.dmm")

/datum/map_template/cynosure_fixed/medical_basement/training_room
	name = "Cynosure Basement - Medical Surgery Training Room"
	mappaths = list("maps/cynosure/submaps/5x7/SurgeryTrainingRoom.dmm")

/obj/abstract/landmark/map_load_mark/cynosure/seven_by_seven_maint
	name = "Cynosure Basement - 7x7 Maintenance Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/seven_by_seven_maint

/datum/map_template/cynosure_fixed/seven_by_seven_maint
	abstract_type = /datum/map_template/cynosure_fixed/seven_by_seven_maint

/datum/map_template/cynosure_fixed/seven_by_seven_maint/fight_club
	name = "Cynosure Basement - Fight Club"
	mappaths = list("maps/cynosure/submaps/7x7/FightClub.dmm")

/datum/map_template/cynosure_fixed/seven_by_seven_maint/janitor_closet
	name = "Cynosure Basement - Janitor Closet"
	mappaths = list("maps/cynosure/submaps/7x7/JanitorCloset.dmm")

/datum/map_template/cynosure_fixed/seven_by_seven_maint/server_room
	name = "Cynosure Basement - Party Room"
	mappaths = list("maps/cynosure/submaps/7x7/PartyRoom.dmm")

/obj/abstract/landmark/map_load_mark/cynosure/eight_by_five_maint
	name = "Cynosure Basement - 8x5 Maintenance Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/eight_by_five_maint

/datum/map_template/cynosure_fixed/eight_by_five_maint
	abstract_type = /datum/map_template/cynosure_fixed/eight_by_five_maint

/datum/map_template/cynosure_fixed/eight_by_five_maint/growers_den
	name = "Cynosure Basement - Grower's Den"
	mappaths = list("maps/cynosure/submaps/8x5/GrowersDen.dmm")

/datum/map_template/cynosure_fixed/eight_by_five_maint/hidden_bar
	name = "Cynosure Basement - Hidden Bar"
	mappaths = list("maps/cynosure/submaps/8x5/HiddenBar.dmm")

/datum/map_template/cynosure_fixed/eight_by_five_maint/restroom
	name = "Cynosure Basement - Restroom"
	mappaths = list("maps/cynosure/submaps/8x5/Restroom.dmm")

/datum/map_template/cynosure_fixed/eight_by_five_maint/squatters_den
	name = "Cynosure Basement - Squatter's Den"
	mappaths = list("maps/cynosure/submaps/8x5/SquattersDen.dmm")

/obj/abstract/landmark/map_load_mark/cynosure/eight_by_nine_maint
	name = "Cynosure Basement - 8x9 Maintenance Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/eight_by_nine_maint

/datum/map_template/cynosure_fixed/eight_by_nine_maint
	abstract_type = /datum/map_template/cynosure_fixed/eight_by_nine_maint

/datum/map_template/cynosure_fixed/eight_by_nine_maint/meeting_room
	name = "Cynosure Basement - Meeting Room"
	mappaths = list("maps/cynosure/submaps/8x9/MeetingRoom.dmm")

/datum/map_template/cynosure_fixed/eight_by_nine_maint/mouse_house
	name = "Cynosure Basement - Mouse House"
	mappaths = list("maps/cynosure/submaps/8x9/MouseHouse.dmm")

/datum/map_template/cynosure_fixed/eight_by_nine_maint/reptile_room
	name = "Cynosure Basement - Reptile Room"
	mappaths = list("maps/cynosure/submaps/8x9/ReptileRoom.dmm")

/datum/map_template/cynosure_fixed/eight_by_nine_maint/ritual_room
	name = "Cynosure Basement - Ritual Room"
	mappaths = list("maps/cynosure/submaps/8x9/RitualRoom.dmm")

/obj/abstract/landmark/map_load_mark/cynosure/nine_by_eight_maint
	name = "Cynosure Basement - 9x8 Maint Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/nine_by_eight_maint

/datum/map_template/cynosure_fixed/nine_by_eight_maint
	abstract_type = /datum/map_template/cynosure_fixed/nine_by_eight_maint

/datum/map_template/cynosure_fixed/nine_by_eight_maint/games_room
	name = "Cynosure Basement - Games Room"
	mappaths = list("maps/cynosure/submaps/9x8/GamesRoom.dmm")

/datum/map_template/cynosure_fixed/nine_by_eight_maint/server_room
	name = "Cynosure Basement - Server Room"
	mappaths = list("maps/cynosure/submaps/9x8/ServerRoom.dmm")

/datum/map_template/cynosure_fixed/nine_by_eight_maint/hot_tub
	name = "Cynosure Basement - Hot Tub"
	mappaths = list("maps/cynosure/submaps/9x8/HotTub.dmm")

/obj/abstract/landmark/map_load_mark/cynosure/nine_by_ten_maint
	name = "Cynosure Basement - 9x10 Maint Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/nine_by_ten_maint

/datum/map_template/cynosure_fixed/nine_by_ten_maint
	abstract_type = /datum/map_template/cynosure_fixed/nine_by_ten_maint

/datum/map_template/cynosure_fixed/nine_by_ten_maint/pressure_chamber
	name = "Cynosure Basement - Pressure Chamber"
	mappaths = list("maps/cynosure/submaps/9x10/PressureChamber.dmm")

/datum/map_template/cynosure_fixed/nine_by_ten_maint/sauna
	name = "Cynosure Basement - Sauna"
	mappaths = list("maps/cynosure/submaps/9x10/Sauna.dmm")

/datum/map_template/cynosure_fixed/nine_by_ten_maint/shooting_range
	name = "Cynosure Basement - Shooting Range"
	mappaths = list("maps/cynosure/submaps/9x10/ShootingRange.dmm")

/datum/map_template/cynosure_fixed/nine_by_ten_maint/theater
	name = "Cynosure Basement - Theater"
	mappaths = list("maps/cynosure/submaps/9x10/Theater.dmm")

/obj/abstract/landmark/map_load_mark/cynosure/ten_by_nine_maint
	name = "Cynosure Basement - 10x9 Maint Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/ten_by_nine_maint

/datum/map_template/cynosure_fixed/ten_by_nine_maint
	abstract_type = /datum/map_template/cynosure_fixed/ten_by_nine_maint

/datum/map_template/cynosure_fixed/ten_by_nine_maint/shop
	name = "Cynosure Basement - Shop"
	mappaths = list("maps/cynosure/submaps/10x9/Shop.dmm")

/datum/map_template/cynosure_fixed/ten_by_nine_maint/treasure_hoard
	name = "Cynosure Basement - Treasure Hoard"
	mappaths = list("maps/cynosure/submaps/10x9/TreasureHoard.dmm")

/datum/map_template/cynosure_fixed/ten_by_nine_maint/warehouse_one
	name = "Cynosure Basement - Warehouse One"
	mappaths = list("maps/cynosure/submaps/10x9/Warehouse1.dmm")

/datum/map_template/cynosure_fixed/ten_by_nine_maint/warehouse_two
	name = "Cynosure Basement - Warehouse Two"
	mappaths = list("maps/cynosure/submaps/10x9/Warehouse2.dmm")

/datum/map_template/cynosure_fixed/ten_by_nine_maint/warehouse_three
	name = "Cynosure Basement - Warehouse Three"
	mappaths = list("maps/cynosure/submaps/10x9/Warehouse3.dmm")

/obj/abstract/landmark/map_load_mark/cynosure/sixteen_by_eleven_maint
	name = "Cynosure Basement - 16x11 Maint Submap Loader"
	map_template_names = /datum/map_template/cynosure_fixed/sixteen_by_eleven_maint

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint
	abstract_type = /datum/map_template/cynosure_fixed/sixteen_by_eleven_maint

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint/laser_tag
	name = "Cynosure Basement - Laser Tag"
	mappaths = list("maps/cynosure/submaps/16x11/LaserTag.dmm")

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint/nightclub
	name = "Cynosure Basement - Nightclub"
	mappaths = list("maps/cynosure/submaps/16x11/Nightclub.dmm")

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint/old_dorms
	name = "Cynosure Basement - Old Dorms"
	mappaths = list("maps/cynosure/submaps/16x11/OldDorms.dmm")
