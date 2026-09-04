///////////////////////////////////////////////////////////////////////////////////
// Warning Sign Definitions
///////////////////////////////////////////////////////////////////////////////////

///Base warning sign type
/obj/structure/sign/warning
	name               = "\improper WARNING"
	desc               = "You've been warned!"
	icon               = 'icons/obj/signs/warnings.dmi'
	icon_state         = "securearea"
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "WEST":{"x":34}, "EAST":{"x":-34}}'

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

/obj/structure/sign/warning/airlock/large
	icon_state = "doors-large"

/obj/structure/sign/warning/pods
	name       = "\improper WARNING: ESCAPE POD DOCKING AREA"
	icon_state = "pods"

/obj/structure/sign/warning/deathsposal
	name       = "\improper DISPOSAL LEADS TO SPACE"
	icon_state = "deathsposal"

/obj/structure/sign/warning/shock
	name       = "\improper HIGH VOLTAGE"
	icon_state = "shock"

/obj/structure/sign/warning/compressed_gas
	name       = "\improper COMPRESSED GAS"
	icon_state = "hikpa"

/obj/structure/sign/warning/compressed_gas/large
	icon_state = "hikpa-large"

/obj/structure/sign/warning/docking_area
	name = "\improper KEEP CLEAR: DOCKING AREA"

/obj/structure/sign/warning/engineering_access
	name = "\improper ENGINEERING ACCESS"

/obj/structure/sign/warning/moving_parts
	name       = "\improper MOVING PARTS"
	icon_state = "movingparts"

/obj/structure/sign/warning/moving_parts/large
	icon_state = "movingparts-large"

/obj/structure/sign/warning/nosmoking_1
	name       = "\improper NO SMOKING"
	icon_state = "nosmoking"

/obj/structure/sign/warning/nosmoking_1/large
	icon_state = "nosmoking-large"

/obj/structure/sign/warning/nosmoking_2
	name       = "\improper NO SMOKING"
	icon_state = "nosmoking2"

/obj/structure/sign/warning/nosmoking_burned
	name       = "\improper NO SMOKING"
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

/obj/structure/sign/warning/smoking/large
	icon_state = "smoking-large"

/obj/structure/sign/warning/secure_area
	name       = "\improper SECURE AREA"
	icon_state = "securearea2"

/obj/structure/sign/warning/secure_area/large
	icon_state = "securearea2-large"

/obj/structure/sign/warning/large
	icon_state = "securearea-large"

/obj/structure/sign/warning/armory
	name       = "\improper ARMORY"
	icon_state = "armory"

/obj/structure/sign/warning/armory/large
	icon_state = "armory-large"

/obj/structure/sign/warning/server_room
	name       = "\improper SERVER ROOM"
	icon_state = "server"

/obj/structure/sign/warning/server_room/large
	icon_state = "server-large"

///////////////////////////////////////////////////////////////////////////////////
// Hazard Sign Definitions
///////////////////////////////////////////////////////////////////////////////////

/obj/structure/sign/warning/biohazard
	name       = "\improper BIOHAZARD"
	icon_state = "bio"

/obj/structure/sign/warning/radioactive
	name       = "\improper RADIOACTIVE AREA"
	icon_state = "radiation"

/obj/structure/sign/warning/radioactive/large
	icon_state = "radiation-large"

/obj/structure/sign/warning/radioactive/alt
	name       = "\improper IONIZING RADIATION"
	icon_state = "radiation_2"

/obj/structure/sign/warning/fire
	name       = "\improper DANGER: FIRE"
	icon_state = "fire"

/obj/structure/sign/warning/fire/large
	icon_state = "fire-large"

/obj/structure/sign/warning/high_voltage
	name       = "\improper HIGH VOLTAGE"
	icon_state = "shock"

/obj/structure/sign/warning/high_voltage/large
	icon_state = "shock-large"

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
	icon_state = "blast"

/obj/structure/sign/warning/fall
	name       = "\improper FALL HAZARD"
	icon_state = "falling"

/obj/structure/sign/warning/lethal_turrets
	name       = "\improper LETHAL TURRETS"
	icon_state = "turrets"

/obj/structure/sign/warning/lethal_turrets/update_description()
	. = ..()
	desc += " Enter at own risk!"

/obj/structure/sign/warning/siphon_valve
	name = "\improper SIPHON VALVE"

/obj/structure/sign/warning/vacuum
	name       = "\improper HARD VACUUM AHEAD"
	icon_state = "space"

/obj/structure/sign/warning/vacuum/large
	icon_state = "space-large"

/obj/structure/sign/warning/vent_port
	name = "\improper EJECTION/VENTING PORT"

/obj/structure/sign/warning/anomalous_materials
	name = "\improper ANOMALOUS MATERIALS"

/obj/structure/sign/warning/mass_spectrometry
	name = "\improper MASS SPECTROMETRY"

/obj/structure/sign/warning/acid
	name = "\improper WARNING: CORROSIVE MATERIALS"
	icon_state = "acid"

/obj/structure/sign/warning/cold
	name = "\improper WARNING: LOW TEMPERATURES"
	icon_state = "cold"

/obj/structure/sign/warning/lava
	name = "\improper WARNING: MOLTEN ROCK"
	icon_state = "lava"

/obj/structure/sign/warning/malfunction
	name       = "\improper IN CASE OF MALFUNCTION"
	icon_state = "rogueai"

/obj/structure/sign/warning/explosives
	name       = "\improper WARNING: HIGH EXPLOSIVES"
	icon_state = "explosives"

/obj/structure/sign/warning/chemicals
	name       = "\improper WARNING: RISK OF CHEMICAL EXPOSURE"
	icon_state = "chemdiamond"

/obj/structure/sign/warning/atmos_co2
	name       = "\improper WARNING: CO2"
	icon_state = "atmos_co2"

/obj/structure/sign/warning/atmos_n2o
	name       = "\improper WARNING: N2O"
	icon_state = "atmos_n2o"

/obj/structure/sign/warning/atmos_phoron
	name       = "\improper WARNING: EXOTIC MATTER"
	icon_state = "atmos_phoron"

/obj/structure/sign/warning/atmos_o2
	name       = "\improper WARNING: O2"
	icon_state = "atmos_o2"

/obj/structure/sign/warning/atmos_air
	name       = "\improper WARNING: PRESSURIZED AIR"
	icon_state = "atmos_air"

/obj/structure/sign/warning/atmos_n2
	name       = "\improper WARNING: N2"
	icon_state = "atmos_n2"

/obj/structure/sign/warning/atmos_waste
	name       = "\improper WARNING: WASTE UNDER PRESSURE"
	icon_state = "atmos_waste"
