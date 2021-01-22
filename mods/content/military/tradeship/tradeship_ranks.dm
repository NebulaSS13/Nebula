/datum/job/submap
	branch = /datum/mil_branch/civilian
	rank =   /datum/mil_rank/civ/civ
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	required_language = null

/datum/map/tradeship
	branch_types = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)

	spawn_branch_types = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/ntsfod,
		/datum/mil_branch/fed_armsmen
	)

	species_to_branch_blacklist = list()

	species_to_branch_whitelist = list()

	species_to_rank_blacklist = list()

	species_to_rank_whitelist = list()

/*
 *  Branches
 *  ========
 */

/datum/mil_branch/civilian
	name = "Civilian"
	name_short = "Civ"

	rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/synthetic
	)

	spawn_rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/synthetic
	)

/datum/mil_branch/ntsfod
	name = "Nanotrasen Survey and Field Operations Division"
	name_short = "NTSFOD"

	rank_types = list(
		/datum/mil_rank/ntsfod/employee,
		/datum/mil_rank/ntsfod/official
	)

	spawn_rank_types = list(
		/datum/mil_rank/ntsfod/employee
	)

/datum/mil_branch/fed_armsmen
	name = "Federation Armsmen"
	name_short = "Armsmen"

	rank_types = list(
		/datum/mil_rank/arm/e1,
		/datum/mil_rank/arm/e2,
		/datum/mil_rank/arm/e3,
		/datum/mil_rank/arm/e4,
		/datum/mil_rank/arm/e5,
		/datum/mil_rank/arm/e6,
		/datum/mil_rank/arm/e7,
		/datum/mil_rank/arm/e8,
		/datum/mil_rank/arm/e9,
		/datum/mil_rank/arm/e10,
		/datum/mil_rank/arm/o1,
		/datum/mil_rank/arm/o2,
		/datum/mil_rank/arm/o3,
		/datum/mil_rank/arm/o4,
		/datum/mil_rank/arm/o5,
		/datum/mil_rank/arm/o6,
		/datum/mil_rank/arm/o7,
		/datum/mil_rank/arm/o8,
		/datum/mil_rank/arm/o9,
		/datum/mil_rank/arm/o10
	)

	spawn_rank_types = list(
		/datum/mil_rank/arm/e1,
		/datum/mil_rank/arm/e2,
		/datum/mil_rank/arm/e3,
		/datum/mil_rank/arm/e4,
		/datum/mil_rank/arm/e5,
		/datum/mil_rank/arm/e6,
		/datum/mil_rank/arm/e7,
		/datum/mil_rank/arm/e8,
		/datum/mil_rank/arm/e9,
		/datum/mil_rank/arm/e10,
		/datum/mil_rank/arm/o1,
		/datum/mil_rank/arm/o2,
		/datum/mil_rank/arm/o3,
		/datum/mil_rank/arm/o4,
		/datum/mil_rank/arm/o5,
		/datum/mil_rank/arm/o6,
		/datum/mil_rank/arm/o7,
		/datum/mil_rank/arm/o8,
		/datum/mil_rank/arm/o9,
		/datum/mil_rank/arm/o10
	)	

/*
 *  Civilians
 *  =========
 */

/datum/mil_rank/civ/civ
	name = "Civilian"

/datum/mil_rank/civ/contractor
	name = "Contractor"

/datum/mil_rank/civ/synthetic
	name = "Synthetic"


/*
 *  NTSFOD
 *  =========
 */
/datum/mil_rank/ntsfod/employee
	name = "Nanotrasen Employee"
	name_short = "NT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ntsfod)
	sort_order = 1

/datum/mil_rank/ntsfod/official //Adminbus so doesn´t really matter
	name = "Nanotrasen Official"
	name_short = "NTOF"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ntsfod/nt)
	sort_order = 2

/*
 *  Armsmen
 *  =====
 */
 //Enlisted
/datum/mil_rank/arm/e1
	name = "Junior Armsman"
	name_short = "JARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted)
	sort_order = 1

/datum/mil_rank/arm/e2
	name = "Armsman Basic"
	name_short = "ARMB"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e2)
	sort_order = 2

/datum/mil_rank/arm/e3
	name = "Armsman"
	name_short = "ARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e3)
	sort_order = 3

/datum/mil_rank/arm/e4
	name = "Senior Armsman"
	name_short = "SARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e4)
	sort_order = 4

/datum/mil_rank/arm/e5
	name = "Staff Armsman"
	name_short = "STARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e5)
	sort_order = 5

/datum/mil_rank/arm/e6
	name = "Chief Armsman"
	name_short = "CARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e6)
	sort_order = 6

/datum/mil_rank/arm/e7
	name = "Master Armsman"
	name_short = "MARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e7)
	sort_order = 7

/datum/mil_rank/arm/e8
	name = "Chief Master Armsman"
	name_short = "CHMARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e8)
	sort_order = 8

/datum/mil_rank/arm/e9
	name = "Command Master Armsman"
	name_short = "COMARM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e9)
	sort_order = 9

/datum/mil_rank/arm/e10
	name = "Command Master Armsman of the Federation"
	name_short = "COMARMOF"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/enlisted/e10)
	sort_order = 10
//
//Officer
/datum/mil_rank/arm/o1
	name = "Cadet"
	name_short = "CAD"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer)
	sort_order = 11

/datum/mil_rank/arm/o2
	name = "Sub-Lieutenant"
	name_short = "SLT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o2)
	sort_order = 12

/datum/mil_rank/arm/o3
	name = "Lieutenant"
	name_short = "LT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o3)
	sort_order = 13

/datum/mil_rank/arm/o4
	name = "Senior-Lieutenant"
	name_short = "SELT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o4)
	sort_order = 14

/datum/mil_rank/arm/o5
	name = "Sub-Adjutant"
	name_short = "SADJ"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o5)
	sort_order = 15

/datum/mil_rank/arm/o6
	name = "Adjutant"
	name_short = "ADJ"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o6)
	sort_order = 16

/datum/mil_rank/arm/o7
	name = "Regiment Commandant"
	name_short = "RCMD"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o7)
	sort_order = 17

/datum/mil_rank/arm/o8
	name = "Brigade Commandant"
	name_short = "BCMD"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o8)
	sort_order = 18

/datum/mil_rank/arm/o9
	name = "Armsman Commandant"
	name_short = "ARMCMD"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o9)
	sort_order = 19

/datum/mil_rank/arm/o10
	name = "High Commandant of the Federation Armsmen"
	name_short = "HCMDFA"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/arm/officer/o10)
	sort_order = 20
//

//Nanotrasen survey and field operations division NTSFOD