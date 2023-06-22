//Parachutes
/obj/item/storage/backpack/parachute
	name = "parachute"
	desc = "A specially-made backpack, designed to help one survive jumping from incredible heights. It sacrifices some storage space for that added functionality."
	icon = 'icons/obj/items/storage/backpack/parachute.dmi'
	var/packed = TRUE

/obj/item/storage/backpack/parachute/Initialize(ml, material_key)
	max_storage_space = round(max_storage_space * 0.5)
	. = ..()

/obj/item/storage/backpack/parachute/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(packed)
			to_chat(user, SPAN_NOTICE("The parachute seems to be packed and ready to deploy."))
		else
			to_chat(user, SPAN_DANGER("The parachute is unpacked."))

/obj/item/storage/backpack/parachute/attack_self(mob/user)
	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	var/initial_pack = packed
	var/pack_msg = packed ? "unpack" : "pack"
	user.visible_message(
		SPAN_NOTICE("\The [user] starts to [pack_msg] \the [src]."),
		SPAN_NOTICE("You start to pack \the [src]."),
		"You hear the shuffling of cloth."
	)
	if(!do_after(user, 5 SECONDS))
		user.visible_message(
			SPAN_NOTICE("\The [user] gives up on [pack_msg]ing \the [src]."),
			SPAN_NOTICE("You give up on [pack_msg]ing \the [src].")
		)
		return TRUE
	if(packed != initial_pack)
		return TRUE
	user.visible_message(
		SPAN_NOTICE("\The [user] finishes [pack_msg]ing \the [src]."),
		SPAN_NOTICE("You finish [pack_msg]ing \the [src]."),
		"You hear the shuffling of cloth."
	)
	packed = !packed
	return TRUE
