/obj/item/grooming/comb
	name     = "comb"
	desc     = "A pristine comb."
	icon     = 'icons/obj/items/grooming/comb.dmi'
	material = /decl/material/solid/organic/plastic

	message_target_other_generic = "$USER$ tidily combs $TARGET$ with $TOOL$."
	message_target_self_generic  = "$USER$ tidily combs $USER_SELF$ with $TOOL$."
	message_target_other         = "$USER$ tidily combs $TARGET$'s $DESCRIPTOR$ with $TOOL$."
	message_target_self          = "$USER$ tidily combs $USER_HIS$ $DESCRIPTOR$ with $TOOL$."
	grooming_flags               = GROOMABLE_COMB

/obj/item/grooming/comb/colorable
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/grooming/comb/colorable/random/Initialize()
	set_color(get_random_colour(lower = 150))
	. = ..()

// Looks exactly like a butterfly knife inhand.
/obj/item/grooming/comb/butterfly
	name     = "butterfly comb"
	desc     = "A very stylish comb that folds into a handle."
	icon     = 'icons/obj/items/grooming/comb_butterfly.dmi'
	material = /decl/material/solid/metal/steel

	message_target_other_generic = "$USER$ uses $TOOL$ to comb $TARGET$ with incredible style and sophistication."
	message_target_self_generic  = "$USER$ uses $TOOL$ to comb $USER_SELF$ with incredible style and sophistication. What a $USER_GUY$."
	message_target_other         = "$USER$ uses $TOOL$ to comb $TARGET$'s hair with incredible style and sophistication."
	message_target_self          = "$USER$ uses $TOOL$ to comb $USER_HIS$ hair with incredible style and sophistication. What a $USER_GUY$."

	var/opened = FALSE

/obj/item/grooming/comb/butterfly/attack_self(mob/user)
	if(user.a_intent == I_HURT)
		return ..()
	opened = !opened
	if(opened)
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	user.visible_message(SPAN_NOTICE("\The [user] flicks \the [src] [opened ? "open" : "closed"]."))
	update_icon()
	return TRUE

/obj/item/grooming/comb/butterfly/try_groom(mob/living/user, mob/living/target)
	return opened && ..()

/obj/item/grooming/comb/butterfly/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(opened)
		icon_state = "[icon_state]_open"

/obj/item/grooming/comb/butterfly/replace_message_tokens(message, mob/living/user, mob/living/target, obj/item/tool, limb, descriptor)
	message = replacetext(message, "$USER_GUY$", user.get_pronouns().informal_term)
	return ..()

/obj/item/grooming/comb/butterfly/colorable
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
