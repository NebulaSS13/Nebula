/datum/composite_sound/air_pump
	start_sound = 'mods/content/polaris/sound/machines/airpumpstart.ogg'
	start_length = 10
	mid_sounds = list()//list('mods/content/polaris/sound/machines/airpumpidle_1.ogg' = 1, 'mods/content/polaris/sound/machines/airpumpidle_2.ogg' = 1, 'mods/content/polaris/sound/machines/airpumpidle_3.ogg' = 1, 'mods/content/polaris/sound/machines/airpumpidle_4.ogg' = 1)
	mid_length = 19
	end_sound = 'mods/content/polaris/sound/machines/airpumpshutdown.ogg'
	volume = 3

/obj/machinery/atmospherics/unary/vent_pump
	var/datum/composite_sound/air_pump/soundloop

/obj/machinery/atmospherics/unary/vent_pump/Initialize()
	soundloop = new(list(src), FALSE)
	. = ..()

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/used_item, mob/user)
	. = ..()
	can_pump() //in order to shut off sound when welded
	return .

/obj/machinery/atmospherics/unary/vent_pump/can_pump() //everything that update_sound() does should be done every time can_pump() is called
	. = ..()
	if(. == 1)
		if(!soundloop.started)
			soundloop.start()
		if(!sound_id)
			sound_id = "[sequential_id("vent_z[z]")]"
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, 'mods/content/polaris/sound/machines/airpumpidle.ogg', 8, range = 7, falloff = 4)
	else
		if(soundloop.started && !welded)
			soundloop.stop()
		if(sound_token)
			sound_token.Destroy()
			QDEL_NULL(sound_token)
	return .

/obj/machinery/atmospherics/unary/vent_pump/update_sound()
	can_pump()