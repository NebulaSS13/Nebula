/mob/living/simple_animal/hostile/parrot/pirate
	name = "\proper Meatbag"
	ai = /datum/mob_controller/aggressive/parrot/pirate

/datum/mob_controller/aggressive/parrot/pirate
	emote_speech = list("Yaaar!","Squaaak!","Fight me Matey!","BAWWWWK Vox trying to eat me!")

/obj/machinery/network/telecomms_hub/raider
	initial_network_id = "piratenet"
	req_access = list(access_raider)
	channels = list(
		COMMON_FREQUENCY_DATA,
		list(
			"name" = "Raider",
			"key" = "t",
			"frequency" = PUB_FREQ,
			"color" = COMMS_COLOR_SYNDICATE,
			"span_class" = CSS_CLASS_RADIO,
			"secured" = access_raider
		)
	)

/obj/structure/sign/warning/nosmoking_1/heist
	desc = "A warning sign which reads 'NO SMOKING'. Someone has scratched a variety of crude words in gutter across the entire sign."