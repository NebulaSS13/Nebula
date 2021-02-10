/obj/item/firearm_component/barrel/ballistic
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
	accuracy_power = 7
	fire_sound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	accuracy_power = 7

/obj/item/firearm_component/barrel/ballistic/sniper
	caliber = CALIBER_ANTIMATERIAL
	screen_shake = 2 //extra kickback
	one_hand_penalty = 6
	bulk = 8
	accuracy = -2
	scoped_accuracy = 8 //increased accuracy over the LWAP because only one shot
	scope_zoom = 2

/obj/item/firearm_component/barrel/ballistic/holdout
	caliber = CALIBER_PISTOL_SMALL

/obj/item/firearm_component/barrel/ballistic/rifle
	caliber = CALIBER_RIFLE
	one_hand_penalty = 2
	accuracy = 2
	accuracy_power = 7

/obj/item/firearm_component/barrel/ballistic/dart
	caliber = CALIBER_DART
	screen_shake = 0
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"

/obj/item/firearm_component/barrel/ballistic/lasbulb
	caliber = CALIBER_PISTOL_LASBULB
	one_hand_penalty = 0
	screen_shake = 0
	silenced = 1
	fire_sound_text = "pop"

/*
/obj/item/gun/hand/pistol/holdout/attackby(obj/item/I, mob/user)
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