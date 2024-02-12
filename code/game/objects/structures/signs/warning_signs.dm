///////////////////////////////////////////////////////////////////////////////////
// Warning Sign Definitions
///////////////////////////////////////////////////////////////////////////////////

///Base warning sign type
/obj/structure/sign/warning
	name               = "\improper WARNING"
	desc               = "You've been warned!"
	icon               = 'icons/obj/signs/slim_warnings.dmi'
	icon_state         = "securearea"
	directional_offset = "{'NORTH':{'y':-32}, 'SOUTH':{'y':32}, 'WEST':{'x':34}, 'EAST':{'x':-34}}"

/obj/structure/sign/warning/update_description()
	desc = "A warning sign which reads '[sanitize(name)]'."

///////////////////////////////////////////////////////////////////////////////////
// Sign Definitions
///////////////////////////////////////////////////////////////////////////////////

/obj/structure/sign/warning/detailed
	icon_state = "securearea2"

/obj/structure/sign/warning/caution
	name       = "\improper CAUTION"
	icon_state = "caution"

/obj/structure/sign/warning/airlock
	name       = "\improper EXTERNAL AIRLOCK"
	icon_state = "doors"

/obj/structure/sign/warning/evac
	name       = "\improper KEEP CLEAR: EVAC DOCKING AREA"
	icon       = 'icons/obj/signs/warnings.dmi'
	icon_state = "evac"

/obj/structure/sign/warning/deathsposal
	name       = "\improper DISPOSAL LEADS TO SPACE"
	icon       = 'icons/obj/signs/warnings.dmi'
	icon_state = "deathsposal"

/obj/structure/sign/warning/shock
	name       = "\improper HIGH VOLTAGE"
	icon       = 'icons/obj/signs/warnings.dmi'
	icon_state = "shock"

/obj/structure/sign/warning/compressed_gas
	name       = "\improper COMPRESSED GAS"
	icon_state = "hikpa"

/obj/structure/sign/warning/docking_area
	name = "\improper KEEP CLEAR: DOCKING AREA"

/obj/structure/sign/warning/engineering_access
	name = "\improper ENGINEERING ACCESS"

/obj/structure/sign/warning/moving_parts
	name       = "\improper MOVING PARTS"
	icon_state = "movingparts"

/obj/structure/sign/warning/nosmoking_1
	name       = "\improper NO SMOKING"
	icon_state = "nosmoking"

/obj/structure/sign/warning/nosmoking_2
	name       = "\improper NO SMOKING"
	icon       = 'icons/obj/signs/warnings.dmi' //This one is a full-size sign
	icon_state = "nosmoking2"

/obj/structure/sign/warning/nosmoking_burned
	name       = "\improper NO SMOKING"
	icon       = 'icons/obj/signs/warnings.dmi' //This one is a full-size sign
	icon_state = "nosmoking2_b"
/obj/structure/sign/warning/nosmoking_burned/update_description()
	. = ..()
	desc += " It looks charred."

/obj/structure/sign/warning/smoking
	name       = "\improper SMOKING"
	icon_state = "smoking"
/obj/structure/sign/warning/smoking/update_description()
	. = ..()
	desc += " Hell yeah."

/obj/structure/sign/warning/secure_area
	name       = "\improper SECURE AREA"
	icon_state = "securearea2"

/obj/structure/sign/warning/armory
	name       = "\improper ARMORY"
	icon_state = "armory"

/obj/structure/sign/warning/server_room
	name       = "\improper SERVER ROOM"
	icon_state = "server"


///////////////////////////////////////////////////////////////////////////////////
// Hazard Sign Definitions
///////////////////////////////////////////////////////////////////////////////////

/obj/structure/sign/warning/biohazard
	name       = "\improper BIOHAZARD"
	icon       = 'icons/obj/signs/warnings.dmi' //This one is a full-size sign
	icon_state = "bio"

/obj/structure/sign/warning/radioactive
	name       = "\improper RADIOACTIVE AREA"
	icon_state = "radiation"

/obj/structure/sign/warning/radioactive/alt
	name       = "\improper IONIZING RADIATION"
	icon_state = "radiation_2"

/obj/structure/sign/warning/fire
	name       = "\improper DANGER: FIRE"
	icon_state = "fire"

/obj/structure/sign/warning/high_voltage
	name       = "\improper HIGH VOLTAGE"
	icon_state = "shock"

/obj/structure/sign/warning/hot_exhaust
	name       = "\improper HOT EXHAUST"
	icon_state = "fire"

/obj/structure/sign/warning/laser
	name       = "\improper LASER HAZARD"
	icon_state = "beam"

/obj/structure/sign/warning/internals_required
	name = "\improper INTERNALS REQUIRED"

/obj/structure/sign/warning/bomb_range
	name       = "\improper BOMB RANGE"
	icon       = 'icons/obj/signs/warnings.dmi' //This one is a full-size sign
	icon_state = "blast"

/obj/structure/sign/warning/fall
	name       = "\improper FALL HAZARD"
	icon       = 'icons/obj/signs/warnings.dmi' //This one is a full-size sign
	icon_state = "falling"

/obj/structure/sign/warning/lethal_turrets
	name       = "\improper LETHAL TURRETS"
	icon       = 'icons/obj/signs/warnings.dmi' //This one is a full-size sign
	icon_state = "turrets"

/obj/structure/sign/warning/lethal_turrets/update_description()
	. = ..()
	desc += " Enter at own risk!"

/obj/structure/sign/warning/siphon_valve
	name = "\improper SIPHON VALVE"

/obj/structure/sign/warning/vacuum
	name       = "\improper HARD VACUUM AHEAD"
	icon_state = "space"

/obj/structure/sign/warning/vent_port
	name = "\improper EJECTION/VENTING PORT"

/obj/structure/sign/warning/anomalous_materials
	name = "\improper ANOMALOUS MATERIALS"

/obj/structure/sign/warning/mass_spectrometry
	name = "\improper MASS SPECTROMETRY"

//legacy stuff - The exodus map still uses it
/obj/structure/sign/warning/pods
	name       = "\improper ESCAPE PODS"
	icon       = 'icons/obj/signs/directions.dmi'
	icon_state = "podsnorth"
/obj/structure/sign/warning/pods/south
	icon_state = "podssouth"
/obj/structure/sign/warning/pods/east
	icon_state = "podseast"
/obj/structure/sign/warning/pods/west
	icon_state = "podswest"