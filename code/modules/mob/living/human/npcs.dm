/mob/living/human/monkey/punpun
	real_name = "Pun Pun"
	gender = MALE

/mob/living/human/monkey/punpun/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/human/monkey/punpun/LateInitialize()
	..()
	if(prob(50))
		equip_to_appropriate_slot(new /obj/item/clothing/pants/slacks/black(src))
		equip_to_appropriate_slot(new /obj/item/clothing/shirt/button(src))
		equip_to_appropriate_slot(new /obj/item/clothing/neck/tie/bow/red(src))
		equip_to_appropriate_slot(new /obj/item/clothing/suit/jacket/vest/blue(src))
	else
		var/obj/item/clothing/C = new /obj/item/clothing/pants/casual/mustangjeans(src)
		C.attach_accessory(null, new /obj/item/clothing/shirt/hawaii/random(src))
		equip_to_appropriate_slot(C)
		if(prob(10))
			equip_to_appropriate_slot(new /obj/item/clothing/head/collectable/petehat(src))

/decl/outfit/blank_subject
	name = "Test Subject"
	uniform = /obj/item/clothing/jumpsuit/white/blank
	shoes = /obj/item/clothing/shoes/color/white
	head = /obj/item/clothing/head/helmet/facecover
	mask = /obj/item/clothing/mask/muzzle
	suit = /obj/item/clothing/suit/straight_jacket

/obj/item/clothing/jumpsuit/white/blank/Initialize()
	. = ..()
	var/obj/item/clothing/sensor/vitals/sensor = new(src)
	sensor.set_sensors_locked(TRUE)
	sensor.set_sensor_mode(VITALS_SENSOR_OFF)
	attach_accessory(null, sensor)

/mob/living/human/blank/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/human::uid
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/human/blank/LateInitialize()
	var/number = "[pick(global.greek_letters)]-[rand(1,30)]"
	fully_replace_character_name("Subject [number]")
	var/decl/outfit/outfit = GET_DECL(/decl/outfit/blank_subject)
	outfit.equip_outfit(src)
	var/obj/item/clothing/head/helmet/facecover/F = locate() in src
	if(F)
		F.SetName("[F.name] ([number])")

/mob/living/human/blank/ssd_check()
	return FALSE
