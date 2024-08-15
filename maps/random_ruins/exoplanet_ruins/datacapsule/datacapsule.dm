/datum/map_template/ruin/exoplanet/datacapsule
	name = "ejected data capsule"
	description = "A damaged capsule with some strange contents."
	suffixes = list("datacapsule/datacapsule.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	template_tags = TEMPLATE_TAG_HUMAN|TEMPLATE_TAG_WRECK

	apc_test_exempt_areas = list(
		/area/map_template/datacapsule = NO_SCRUBBER|NO_VENT|NO_APC
	)

/area/map_template/datacapsule
	name = "\improper Ejected Data Capsule"
	icon_state = "blue"

/obj/abstract/landmark/corpse/zombiescience
	name = "Dead Scientist"
	corpse_outfits = list(/decl/outfit/zombie_science)

/decl/outfit/zombie_science
	name = "Job - Dead Scientist"
	uniform = /obj/item/clothing/jumpsuit/white
	suit = /obj/item/clothing/suit/bio_suit/anomaly
	head = /obj/item/clothing/head/bio_hood/anomaly

/decl/material/liquid/zombie/science
	name = "isolated corruption"
	uid = "liquid_corruption_isolated"
	lore_text = "An incredibly dark, oily substance. Moves very slightly."
	taste_description = "decayed blood"
	color = "#800000"
	amount_to_zombify = 3

/obj/item/chems/glass/beaker/vial/random_podchem
	name = "unmarked vial"

/obj/item/chems/glass/beaker/vial/random_podchem/Initialize()
	. = ..()
	desc += "Label is smudged, and there's crusted blood fingerprints on it."

/obj/item/chems/glass/beaker/vial/random_podchem/populate_reagents()
	add_to_reagents(pick(/decl/material/liquid/random, /decl/material/liquid/zombie/science, /decl/material/liquid/retrovirals), 5)

/obj/structure/backup_server
	name = "backup server"
	icon = 'icons/obj/machines/server.dmi'
	icon_state = "server"
	desc = "Impact resistant server rack. You might be able to pry a disk out."
	var/disk_looted

/obj/structure/backup_server/attackby(obj/item/W, mob/user, var/click_params)
	if(IS_CROWBAR(W))
		if(disk_looted)
			to_chat(user, SPAN_WARNING("There's no disk in \the [src]."))
		else
			to_chat(user, SPAN_NOTICE("You pry out the data drive from \the [src]."))
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/item/stock_parts/computer/hard_drive/cluster/drive = new(get_turf(src))
			drive.origin_tech = @'{"[TECH_DATA]":[rand(4,5)],"[TECH_ENGINEERING]":[rand(4,5)],"[TECH_EXOTIC_MATTER]":[rand(4,5)],"[TECH_COMBAT]":[rand(2,5)],"[TECH_ESOTERIC]":[rand(0,6)]}'
			disk_looted = TRUE
		return TRUE
	. = ..()

#define POD_ONE   "random datapod contents #1 (chem vials)"
#define POD_TWO   "random datapod contents #2 (servers)"
#define POD_THREE "random datapod contents #2 (spiders)"

/obj/abstract/landmark/map_load_mark/ejected_datapod
	name = "random datapod contents"
	map_template_names = list(
		POD_ONE,
		POD_TWO,
		POD_THREE
	)

/datum/map_template/ejected_datapod_contents
	name = POD_ONE
	mappaths = list("maps/random_ruins/exoplanet_ruins/datacapsule/contents_1.dmm")

/datum/map_template/ejected_datapod_contents/type2
	name = POD_TWO
	mappaths = list("maps/random_ruins/exoplanet_ruins/datacapsule/contents_2.dmm")

/datum/map_template/ejected_datapod_contents/type3
	name = POD_THREE
	mappaths = list("maps/random_ruins/exoplanet_ruins/datacapsule/contents_3.dmm")

#undef POD_ONE
#undef POD_TWO
#undef POD_THREE
