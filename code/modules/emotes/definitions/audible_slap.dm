/decl/emote/audible/slap
	key = "slap"
	emote_message_1p_target = "You slap $TARGET$ across the face. Ouch!"
	emote_message_1p = "You slap yourself across the face!"
	emote_message_3p_target = "$USER$ slaps $TARGET$ across the face. Ouch!"
	emote_message_3p = "$USER$ slaps $USER_SELF$ across the face!"
	emote_sound = 'sound/effects/snap.ogg'
	check_restraints = TRUE
	check_range = 1
	check_adjacent = TRUE

/decl/emote/audible/slap/Initialize()
	. = ..()
	emote_message_1p_target = SPAN_DANGER(emote_message_1p_target)
	emote_message_1p =        SPAN_DANGER(emote_message_1p)
	emote_message_3p_target = SPAN_DANGER(emote_message_3p_target)
	emote_message_3p =        SPAN_DANGER(emote_message_3p)

/decl/emote/audible/slap/do_extra(atom/user, atom/target)
	. = ..()
	if(ismob(user))
		var/mob/user_mob = user
		var/obj/item/clothing/mask/smokable/cig = user_mob.get_equipped_item(slot_wear_mask_str)
		if(istype(cig))
			user_mob.try_unequip(cig, user.loc)
