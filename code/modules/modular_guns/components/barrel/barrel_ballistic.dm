/obj/item/firearm_component/barrel/ballistic
	var/silenced
	var/caliber

/obj/item/firearm_component/barrel/ballistic/get_caliber()
	return caliber

/obj/item/firearm_component/barrel/ballistic/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret)
		ret.overlays += "silenced"
	else
		ret = image(icon, "silenced")
	return ret	

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

/*
/obj/item/gun/pistol/holdout/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/silencer))
		if(src in user.get_held_items())	//if we're not in his hands
			to_chat(user, SPAN_WARNING("You'll need \the [holder || src] in your hands to do that."))
			return TRUE
		if(user.unEquip(I, src))
			to_chat(user, SPAN_NOTICE("You screw [I] onto \the [holder || src]."))
			silenced = I	//dodgy?
			w_class = ITEM_SIZE_NORMAL
			update_icon()
		return TRUE
	. = ..()
*/