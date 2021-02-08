/obj/item/firearm_component/barrel/ballistic
	var/caliber

/obj/item/firearm_component/barrel/ballistic/get_caliber()
	return caliber

/obj/item/firearm_component/barrel/ballistic/set_caliber(var/_caliber)
	caliber = _caliber

/obj/item/firearm_component/barrel/ballistic/Initialize(ml, material_key)
	. = ..()
	name = "\improper [caliber] [name]"

// Subtypes below.
/obj/item/firearm_component/barrel/ballistic/pistol
	caliber = CALIBER_PISTOL
	
/obj/item/firearm_component/barrel/ballistic/sniper
	caliber = CALIBER_ANTIMATERIAL

/obj/item/firearm_component/barrel/ballistic/holdout
	caliber = CALIBER_PISTOL_SMALL

/obj/item/firearm_component/barrel/ballistic/rifle
	caliber = CALIBER_RIFLE

/obj/item/firearm_component/barrel/ballistic/dart
	caliber = CALIBER_DART

/obj/item/firearm_component/barrel/ballistic/lasbulb
	caliber = CALIBER_PISTOL_LASBULB

/obj/item/firearm_component/barrel/ballistic/revolver
	caliber = CALIBER_PISTOL_MAGNUM

/obj/item/firearm_component/barrel/ballistic/capgun
	caliber = CALIBER_CAPS
