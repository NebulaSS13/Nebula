/datum/codex_entry/bodyscanner
	associated_paths = list(/obj/machinery/bodyscanner)
	mechanics_text = "The advanced scanner detects and reports internal injuries such as bone fractures, internal bleeding, and organ damage. \
	This is useful if you are about to perform surgery.<br>\
	<br>\
	Click your target with Grab intent, then click on the scanner to place them in it. Click the red terminal to operate. \
	Right-click the scanner and click 'Eject Occupant' to remove them.  You can enter the scanner yourself in a similar way, using the 'Enter Body Scanner' \
	verb."
	disambiguator = "machinery"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/optable
	associated_paths = list(/obj/machinery/optable)
	mechanics_text = "Click your target with Grab intent, then click on the table with an empty hand, to place them on it.<br>Click on table after that to enable knockout function."
	disambiguator = "machinery"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/operating
	associated_paths = list(/obj/machinery/computer/operating)
	mechanics_text = "This console gives information on the status of the patient on the adjacent operating table, notably their consciousness."
	disambiguator = "machinery"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/sleeper
	associated_paths = list(/obj/machinery/sleeper)
	mechanics_text = "The sleeper allows you to clean the blood by means of dialysis, and to administer medication in a controlled environment.<br>\
	<br>\
	Click your target with Grab intent, then click on the sleeper to place them in it. Click the green console, with an empty hand, to open the menu. \
	Click 'Start Dialysis' to begin filtering unwanted chemicals from the occupant's blood. The beaker contained will begin to fill with their \
	contaminated blood, and will need to be emptied when full.<br>\
	There's similar functions for ingested or inhaled reagents, 'stomach pump' and 'lung lavage'.<br>\
	<br>\
	You can also inject common medicines directly into their bloodstream.\
	<br>\
	Right-click the cell and click 'Eject Occupant' to remove them.  You can enter the cell yourself by right clicking and selecting 'Enter Sleeper'. \
	Note that you cannot control the sleeper while inside of it."
	disambiguator = "machinery"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/cryobag
	associated_paths = list(/obj/item/bodybag/cryobag, /obj/structure/closet/body_bag/cryobag)
	mechanics_text = "This stasis bag will preserve the occupant, stopping most forms of harm from occuring, such as from oxygen \
	deprivation, irradiation, shock, and chemicals inside the occupant, at least until the bag is opened again.<br>\
	<br>\
	Stasis bags can only be used once, and are rather costly, so use them well.  They are ideal for situations where someone may die \
	before being able to bring them back to safety, or if they are in a hostile enviroment, such as in vacuum or in a toxins leak, as \
	the bag will protect the occupant from most outside enviromental hazards.  If you open a bag by mistake, closing the bag with no \
	occupant will not use up the bag, and you can pick it back up.<br>\
	<br>\
	You can use a health analyzer to scan the occupant's vitals without opening the bag by clicking the occupied bag with the analyzer."
	include_subtypes = TRUE
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/autopump
	associated_paths = list(/obj/item/auto_cpr/)
	mechanics_text = "This automatic pump will help a patient whose heart is stopped, much like CPR, when put in the patient's suit slot.<br>\
	<br>\
	There are several things to keep in mind when using it. First off, you need Basic Medicine AND Anatomy skills to align it properly, otherwise it'll hurt patient. \
	It will only provide some circulation, you need to fix blood volume and oxygen supply issues for it to be useful. \
	It performs worse than manual CPR by a skilled user and will NOT restart the heart. It's advantage is automatic nature.<br>"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE