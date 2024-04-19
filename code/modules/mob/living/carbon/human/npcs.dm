/mob/living/carbon/human/monkey/punpun
	real_name = "Pun Pun"
	gender = MALE

/mob/living/carbon/human/monkey/punpun/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/monkey/punpun/LateInitialize()
	..()
	if(prob(50))
		equip_to_appropriate_slot(new /obj/item/clothing/under/waiter/monke(src))
	else
		var/obj/item/clothing/C = new /obj/item/clothing/pants/casual/mustangjeans/monke(src)
		C.attach_accessory(null, new /obj/item/clothing/shirt/hawaii/random(src))
		equip_to_appropriate_slot(C)
		if(prob(10))
			equip_to_appropriate_slot(new /obj/item/clothing/head/collectable/petehat(src))

/decl/hierarchy/outfit/blank_subject
	name = "Test Subject"
	uniform = /obj/item/clothing/under/color/white/blank
	shoes = /obj/item/clothing/shoes/color/white
	head = /obj/item/clothing/head/helmet/facecover
	mask = /obj/item/clothing/mask/muzzle
	suit = /obj/item/clothing/suit/straight_jacket

/obj/item/clothing/under/color/white/blank/Initialize()
	. = ..()
	var/obj/item/clothing/sensor/vitals/sensor = new(src)
	sensor.set_sensors_locked(TRUE)
	sensor.set_sensor_mode(VITALS_SENSOR_OFF)
	attach_accessory(null, sensor)

/mob/living/carbon/human/blank/Initialize(mapload, species_name, datum/dna/new_dna, decl/bodytype/new_bodytype)
	species_name = SPECIES_HUMAN
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/blank/LateInitialize()
	var/number = "[pick(global.greek_letters)]-[rand(1,30)]"
	fully_replace_character_name("Subject [number]")
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/blank_subject)
	outfit.equip_outfit(src)
	var/obj/item/clothing/head/helmet/facecover/F = locate() in src
	if(F)
		F.SetName("[F.name] ([number])")

/mob/living/carbon/human/blank/ssd_check()
	return FALSE
