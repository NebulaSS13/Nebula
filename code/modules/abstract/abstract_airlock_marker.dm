// Defines below are used to tell a docking controller what id tags to set.
/// Air pump in the main airlock chamber.
#define ATAG_AIR_PUMP       BITFLAG(0)
/// Air alarm in the main airlock chamber.
#define ATAG_AIR_ALARM      BITFLAG(1)
/// Atmos sensor in the main airlock chamber.
#define ATAG_SENSOR_CHAMBER BITFLAG(2)
/// Exterior (usually space)-facing airlock.
#define ATAG_EXT_DOOR       BITFLAG(3)
/// Exterior placed air sensor.
#define ATAG_EXT_SENSOR     BITFLAG(4)
/// Exterior placed pump inlet/outlet.
#define ATAG_EXT_PUMP_OUT   BITFLAG(5)
/// Interior (usually station)-facing airlock.
#define ATAG_INT_DOOR       BITFLAG(6)
/// Interior placed air sensor.
#define ATAG_INT_SENSOR     BITFLAG(7)
/// Interior placed pump inlet/outlet.
#define ATAG_INT_PUMP_OUT   BITFLAG(8)

// Use this macro to declare the required types for mapping your airlock.
// Ex. DECLARE_AIRLOCK_HELPER_TYPES(example, "example airlock", (ATAG_AIR_PUMP|ATAG_SENSOR_CHAMBER|ATAG_EXT_DOOR|ATAG_INT_DOOR))
#define DECLARE_AIRLOCK_HELPER_TYPES(AIRLOCK_ID, AIRLOCK_NAME, AIRLOCK_FLAGS)                                               \
/obj/abstract/airlock_marker/airlock_controller/##AIRLOCK_ID/name         = "##AIRLOCK_NAME docking controller marker"; \
/obj/abstract/airlock_marker/airlock_controller/##AIRLOCK_ID/id_tag_flags = AIRLOCK_FLAGS; \
/obj/abstract/airlock_marker/airlock_controller/##AIRLOCK_ID/airlock_id   = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/sensor/chamber/##AIRLOCK_ID/name             = "##AIRLOCK_NAME chamber sensor marker"; \
/obj/abstract/airlock_marker/sensor/chamber/##AIRLOCK_ID/airlock_id       = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/sensor/internal/##AIRLOCK_ID/name            = "##AIRLOCK_NAME internal sensor marker"; \
/obj/abstract/airlock_marker/sensor/internal/##AIRLOCK_ID/airlock_id      = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/sensor/external/##AIRLOCK_ID/name            = "##AIRLOCK_NAME external sensor marker"; \
/obj/abstract/airlock_marker/sensor/external/##AIRLOCK_ID/airlock_id      = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/pump/chamber/##AIRLOCK_ID/name               = "##AIRLOCK_NAME chamber pump marker"; \
/obj/abstract/airlock_marker/pump/chamber/##AIRLOCK_ID/airlock_id         = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/pump/internal_out/##AIRLOCK_ID/name          = "##AIRLOCK_NAME internal pump marker"; \
/obj/abstract/airlock_marker/pump/internal_out/##AIRLOCK_ID/airlock_id    = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/pump/external_out/##AIRLOCK_ID/name          = "##AIRLOCK_NAME external pump marker"; \
/obj/abstract/airlock_marker/pump/external_out/##AIRLOCK_ID/airlock_id    = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/button/interior/##AIRLOCK_ID/name            = "##AIRLOCK_NAME interior button marker"; \
/obj/abstract/airlock_marker/button/interior/##AIRLOCK_ID/airlock_id      = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/button/exterior/##AIRLOCK_ID/name            = "##AIRLOCK_NAME exterior button marker"; \
/obj/abstract/airlock_marker/button/exterior/##AIRLOCK_ID/airlock_id      = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/door/interior/##AIRLOCK_ID/name              = "##AIRLOCK_NAME interior door marker"; \
/obj/abstract/airlock_marker/door/interior/##AIRLOCK_ID/airlock_id        = "##AIRLOCK_ID"; \
/obj/abstract/airlock_marker/door/exterior/##AIRLOCK_ID/name              = "##AIRLOCK_NAME exterior door marker"; \
/obj/abstract/airlock_marker/door/exterior/##AIRLOCK_ID/airlock_id        = "##AIRLOCK_ID";

// Actual atom types and logic below.
// Initialize immediately so the machinery can initialize with the id tags during SSatoms flush.
INITIALIZE_IMMEDIATE(/obj/abstract/airlock_marker)
/obj/abstract/airlock_marker
	name = "airlock master marker"
	is_spawnable_type = FALSE
	abstract_type = /obj/abstract/airlock_marker
	var/airlock_id
	var/tag_modifier
	var/target_type

/obj/abstract/airlock_marker/Initialize()
	. = ..()
	if(!airlock_id)
		PRINT_STACK_TRACE("Airlock mapping helper [type] at ([x],[y],[z]) initializing with no airlock_id!")
	else if(!target_type)
		PRINT_STACK_TRACE("Airlock mapping helper [type] at ([x],[y],[z]) initializing with no target_machine!")
	else
		var/fail_msg = apply_id_tags()
		if(istext(fail_msg))
			PRINT_STACK_TRACE("Airlock mapping helper [type] at ([x],[y],[z]) failed to apply tags to target machine for reason: [fail_msg]!")
		else if(!istype(fail_msg, target_type))
			PRINT_STACK_TRACE("Airlock mapping helper [type] at ([x],[y],[z]) failed to find a machine of the appropriate type!")
	return INITIALIZE_HINT_QDEL

/obj/abstract/airlock_marker/proc/apply_id_tags()
	var/obj/machinery/machine
	for(var/obj/machinery/check_machine in loc)
		if(!istype(machine, target_type) || machine.id_tag)
			continue
		check_machine = machine
		break
	if(istype(machine))
		if(tag_modifier)
			machine.id_tag = "[airlock_id]_[tag_modifier]"
		else
			machine.id_tag = airlock_id
	return machine

/// Airlock/docking port controller.
/obj/abstract/airlock_marker/airlock_controller
	name = "airlock controller marker"
	target_type = /obj/machinery/embedded_controller/radio/airlock
	var/id_tag_flags

/obj/abstract/airlock_marker/airlock_controller/apply_id_tags()
	var/obj/machinery/embedded_controller/radio/airlock/port = ..()
	if(!istype(port))
		return "no docking port of appropriate type"
	port.id_tag = "[airlock_id]_dock"
	if(id_tag_flags & ATAG_AIR_PUMP)
		port.id_tag = "[airlock_id]_chamber_pump"
	if(id_tag_flags & ATAG_AIR_ALARM)
		port.id_tag = "[airlock_id]_chamber_alarm"
	if(id_tag_flags & ATAG_SENSOR_CHAMBER)
		port.id_tag = "[airlock_id]_chamber_sensor"
	if(id_tag_flags & ATAG_EXT_DOOR)
		port.id_tag = "[airlock_id]_door_ext"
	if(id_tag_flags & ATAG_EXT_SENSOR)
		port.id_tag = "[airlock_id]_sensor_ext"
	if(id_tag_flags & ATAG_EXT_PUMP_OUT)
		port.id_tag = "[airlock_id]_pump_out_ext"
	if(id_tag_flags & ATAG_INT_DOOR)
		port.id_tag = "[airlock_id]_door_int"
	if(id_tag_flags & ATAG_INT_SENSOR)
		port.id_tag = "[airlock_id]_sensor_int"
	if(id_tag_flags & ATAG_INT_PUMP_OUT)
		port.id_tag = "[airlock_id]_pump_out_int"
	return port

/// Sensor marker.
/obj/abstract/airlock_marker/sensor
	abstract_type = /obj/abstract/airlock_marker/sensor
	target_type = /obj/machinery/airlock_sensor

/obj/abstract/airlock_marker/sensor/chamber
	name = "chamber sensor marker"
	tag_modifier = "chamber_sensor"

/obj/abstract/airlock_marker/sensor/internal
	name = "internal sensor marker"
	tag_modifier = "sensor_int"

/obj/abstract/airlock_marker/sensor/external
	name = "external sensor marker"
	tag_modifier = "sensor_ext"

/// Pump markers
/obj/abstract/airlock_marker/pump
	abstract_type = /obj/abstract/airlock_marker/pump
	target_type = /obj/machinery/atmospherics/unary/vent_pump

/obj/abstract/airlock_marker/pump/chamber
	name = "chamber pump marker"
	tag_modifier = "chamber_pump"

/obj/abstract/airlock_marker/pump/internal_out
	name = "internal out pump marker"
	tag_modifier = "pump_out_int"

/obj/abstract/airlock_marker/pump/external_out
	name = "external out pump marker"
	tag_modifier = "pump_out_ext"

/// Access buttons.
/obj/abstract/airlock_marker/button
	abstract_type = /obj/abstract/airlock_marker/button

/obj/abstract/airlock_marker/button/interior
	name = "interior access button marker"
	target_type = /obj/machinery/button/access/interior

/obj/abstract/airlock_marker/button/exterior
	name = "exterior access button marker"
	target_type = /obj/machinery/button/access/exterior

/// Door markers
/obj/abstract/airlock_marker/door
	abstract_type = /obj/abstract/airlock_marker/door
	target_type = /obj/machinery/door/airlock

/obj/abstract/airlock_marker/door/interior
	name = "interior door marker"
	tag_modifier = "door_int"

/obj/abstract/airlock_marker/door/exterior
	name = "exterior door marker"
	tag_modifier = "door_ext"
