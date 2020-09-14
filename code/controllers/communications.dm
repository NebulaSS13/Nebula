/*
  HOW IT WORKS

  The radio_controller is a global object maintaining all radio transmissions, think about it as about "ether".
  Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
  procs:

	add_object(obj/device as obj, var/new_frequency as num, var/filter as text|null = null)
	  Adds listening object.
	  parameters:
		device - device receiving signals, must have proc receive_signal (see description below).
		  one device may listen several frequencies, but not same frequency twice.
		new_frequency - see possibly frequencies below;
		filter - thing for optimization. Optional, but recommended.
				 All filters should be consolidated in this file, see defines later.
				 Device without listening filter will receive all signals (on specified frequency).
				 Device with filter will receive any signals sent without filter.
				 Device with filter will not receive any signals sent with different filter.
	  returns:
	   Reference to frequency object.

	remove_object (obj/device, old_frequency)
	  Obliviously, after calling this proc, device will not receive any signals on old_frequency.
	  Other frequencies will left unaffected.

   return_frequency(var/frequency as num)
	  returns:
	   Reference to frequency object. Use it if you need to send and do not need to listen.

  radio_frequency is a global object maintaining list of devices that listening specific frequency.
  procs:

	post_signal(obj/source as obj|null, datum/signal/signal, var/filter as text|null = null, var/range as num|null = null)
	  Sends signal to all devices that wants such signal.
	  parameters:
		source - object, emitted signal. Usually, devices will not receive their own signals.
		signal - see description below.
		filter - described above.
		range - radius of regular byond's square circle on that z-level. null means everywhere, on all z-levels.

  obj/proc/receive_signal(datum/signal/signal, var/receive_method as num, var/receive_param)
	Handler from received signals. By default does nothing. Define your own for your object.
	Avoid of sending signals directly from this proc, use spawn(-1). DO NOT use sleep() here or call procs that sleep please. If you must, use spawn()
	  parameters:
		signal - see description below. Extract all needed data from the signal before doing sleep(), spawn() or return!
		receive_method - may be TRANSMISSION_WIRE or TRANSMISSION_RADIO.
		  TRANSMISSION_WIRE is currently unused.
		receive_param - for TRANSMISSION_RADIO here comes frequency.

  datum/signal
	vars:
	source
	  an object that emitted signal. Used for debug and bearing.
	data
	  list with transmitting data. Usual use pattern:
		data["msg"] = "hello world"
	encryption
	  Some number symbolizing "encryption key".
	  Note that game actually do not use any cryptography here.
	  If receiving object don't know right key, it must ignore encrypted signal in its receive_signal.

*/

/*
Frequency range: 1200 to 1600
Radiochat range: 1441 to 1489 (most devices refuse to be tune to other frequency, even during mapmaking)
*/

var/global/const/RADIO_LOW_FREQ	= 1200
var/global/const/PUBLIC_LOW_FREQ	= 1441
var/global/const/PUB_FREQ =         1459
var/global/const/PUBLIC_HIGH_FREQ = 1489
var/global/const/RADIO_HIGH_FREQ  = 1600

#define COMMON_FREQUENCY_DATA list("name" = "Common", "key" = "g", "frequency" = PUB_FREQ, "color" = COMMS_COLOR_COMMON,  "span_class" = "radio")

// Device signal frequencies
var/global/const/ATMOS_ENGINE_FREQ = 1438 // Used by atmos monitoring in the engine.
var/global/const/PUMP_FREQ         = 1439 // Used by air alarms and their progeny.
var/global/const/FUEL_FREQ         = 1447 // Used by fuel atmos stuff, and currently default for digital valves
var/global/const/ATMOS_TANK_FREQ   = 1441 // Used for gas tank sensors and monitoring.
var/global/const/ATMOS_DIST_FREQ   = 1443 // Alternative atmos frequency.
var/global/const/BUTTON_FREQ       = 1301 // Used by generic buttons controlling stuff
var/global/const/BLAST_DOORS_FREQ  = 1303 // Used by blast doors, buttons controlling them, and mass drivers.
var/global/const/AIRLOCK_FREQ      = 1305 // Used by airlocks and buttons controlling them.
var/global/const/SHUTTLE_AIR_FREQ  = 1331 // Used by shuttles and shuttle-related atmos systems.
var/global/const/EXTERNAL_AIR_FREQ = 1381 // Used by some external airlocks.

#define TRANSMISSION_WIRE	0
#define TRANSMISSION_RADIO	1

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also recieve signals sent to any other filter.
var/global/const/RADIO_DEFAULT = "radio_default"
//This filter is special because devices belonging to it do not recieve any signals at all. Useful for devices which only transmit.
var/global/const/RADIO_NULL = "radio_null"

var/global/const/RADIO_TO_AIRALARM =   "radio_airalarm" //air alarms
var/global/const/RADIO_FROM_AIRALARM = "radio_airalarm_rcvr" //devices interested in recieving signals from air alarms
var/global/const/RADIO_CHAT =          "radio_telecoms"
var/global/const/RADIO_ATMOSIA =       "radio_atmos"
var/global/const/RADIO_NAVBEACONS =    "radio_navbeacon"
var/global/const/RADIO_AIRLOCK =       "radio_airlock"
var/global/const/RADIO_SECBOT =        "radio_secbot"
var/global/const/RADIO_MULEBOT =       "radio_mulebot"
var/global/const/RADIO_MAGNETS =       "radio_magnet"

// These are exposed to players, by name.
var/global/list/all_selectable_radio_filters = list(
	RADIO_DEFAULT,
	RADIO_TO_AIRALARM,
	RADIO_FROM_AIRALARM,
	RADIO_CHAT,
	RADIO_ATMOSIA,
	RADIO_NAVBEACONS,
	RADIO_AIRLOCK,
	RADIO_SECBOT,
	RADIO_MULEBOT,
	RADIO_MAGNETS
)

var/global/datum/controller/radio/radio_controller

/hook/startup/proc/createRadioController()
	radio_controller = new /datum/controller/radio()
	return 1

//callback used by objects to react to incoming radio signals
/obj/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	set waitfor = FALSE
	return null

//The global radio controller
/datum/controller/radio
	var/list/datum/radio_frequency/frequencies = list()

/datum/controller/radio/proc/add_object(obj/device, var/new_frequency, var/object_filter)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	frequency.add_listener(device, object_filter)
	return frequency

/datum/controller/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(frequency)
		frequency.remove_listener(device)

	return 1

/datum/controller/radio/proc/return_frequency(var/new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	return frequency

/datum/radio_frequency
	var/frequency // numerical frequency value
	var/list/list/obj/devices = list()

/datum/radio_frequency/proc/post_signal(obj/source, datum/signal/signal, var/radio_filter, var/range)
	var/turf/start_point
	if(range)
		start_point = get_turf(source)
		if(!start_point)
			qdel(signal)
			return 0
	if (radio_filter)
		send_to_filter(source, signal, radio_filter, start_point, range)
		send_to_filter(source, signal, RADIO_DEFAULT, start_point, range)
	else
		//Broadcast the signal to everyone!
		for (var/next_filter in devices)
			send_to_filter(source, signal, next_filter, start_point, range)

//Sends a signal to all machines belonging to a given filter. Should be called by post_signal()
/datum/radio_frequency/proc/send_to_filter(obj/source, datum/signal/signal, var/radio_filter, var/turf/start_point = null, var/range = null)
	var/list/z_levels
	if(start_point)
		z_levels = SSmapping.get_connected_levels(start_point.z)

	for(var/obj/device in devices[radio_filter])
		if(device == source)
			continue
		var/turf/end_point = get_turf(device)
		if(!end_point)
			continue
		if(z_levels && !(end_point.z in z_levels))
			continue
		if(range && get_dist(start_point, end_point) > range)
			continue

		device.receive_signal(signal, TRANSMISSION_RADIO, frequency)

/datum/radio_frequency/proc/add_listener(obj/device, var/radio_filter)
	if(radio_filter == RADIO_NULL)
		return // Just don't add them
	if (!radio_filter)
		radio_filter = RADIO_DEFAULT
	var/list/obj/devices_line = devices[radio_filter]
	if (!devices_line)
		devices_line = new
		devices[radio_filter] = devices_line
	devices_line |= device

/datum/radio_frequency/proc/remove_listener(obj/device)
	for (var/devices_filter in devices)
		var/list/devices_line = devices[devices_filter]
		devices_line-=device
		while (null in devices_line)
			devices_line -= null
		if (devices_line.len==0)
			devices -= devices_filter

/datum/signal
	var/obj/source
	var/list/data = list()
	var/encryption
	var/frequency = 0

/datum/signal/proc/copy_from(datum/signal/model)
	source = model.source
	data = model.data
	encryption = model.encryption
	frequency = model.frequency

/datum/signal/proc/debug_print()
	if (source)
		. = "signal = {source = '[source]' ([source:x],[source:y],[source:z])\n"
	else
		. = "signal = {source = '[source]' ()\n"
	for (var/i in data)
		. += "data\[\"[i]\"\] = \"[data[i]]\"\n"
		if(islist(data[i]))
			var/list/L = data[i]
			for(var/t in L)
				. += "data\[\"[i]\"\] list has: [t]"
