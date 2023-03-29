/obj/item/underwear
	icon = 'icons/mob/human.dmi'
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/cloth
	var/required_free_body_parts
	var/slot_offset_str

/obj/item/underwear/afterattack(var/atom/target, var/mob/user, var/proximity)
	if(!proximity)
		return // Might as well check
	DelayedEquipUnderwear(user, target)

/obj/item/underwear/handle_mouse_drop(atom/over, mob/user)
	DelayedEquipUnderwear(user, over)
	return TRUE

/obj/item/underwear/proc/CanEquipUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanAdjustUnderwear(user, H, "put on"))
		return FALSE
	if(!(H.species && (H.species.appearance_flags & HAS_UNDERWEAR)))
		to_chat(user, "<span class='warning'>\The [H]'s species cannot wear underwear of this nature.</span>")
		return FALSE
	if(is_path_in_list(type, H.worn_underwear))
		to_chat(user, "<span class='warning'>\The [H] is already wearing underwear of this nature.</span>")
		return FALSE
	return TRUE

/obj/item/underwear/proc/CanRemoveUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanAdjustUnderwear(user, H, "remove"))
		return FALSE
	if(!(src in H.worn_underwear))
		to_chat(user, "<span class='warning'>\The [H] isn't wearing \the [src].</span>")
		return FALSE
	return TRUE

/obj/item/underwear/proc/CanAdjustUnderwear(var/mob/user, var/mob/living/carbon/human/H, var/adjustment_verb)
	if(!istype(H))
		return FALSE
	if(user != H && !CanPhysicallyInteractWith(user, H))
		return FALSE

	var/list/covering_items = H.get_covering_equipped_items(required_free_body_parts)
	if(length(covering_items))
		var/obj/item/I = covering_items[1]
		var/decl/pronouns/G = I.get_pronouns()
		if(adjustment_verb)
			to_chat(user, "<span class='warning'>Cannot [adjustment_verb] \the [src]. [english_list(covering_items)] [covering_items.len == 1 ? G.is : "are"] in the way.</span>")
		return FALSE

	return TRUE

/obj/item/underwear/proc/DelayedRemoveUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanRemoveUnderwear(user, H))
		return
	if(user != H)
		visible_message("<span class='danger'>\The [user] is trying to remove \the [H]'s [name]!</span>")
		if(!do_after(user, HUMAN_STRIP_DELAY, H, progress = 0))
			return FALSE
	. = RemoveUnderwear(user, H)
	if(. && user != H)
		user.visible_message("<span class='warning'>\The [user] has removed \the [src] from \the [H].</span>", "<span class='notice'>You have removed \the [src] from \the [H].</span>")
		admin_attack_log(user, H, "Removed \a [src]", "Had \a [src] removed.", "removed \a [src] from")

/obj/item/underwear/proc/DelayedEquipUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanEquipUnderwear(user, H))
		return
	if(user != H)
		user.visible_message("<span class='warning'>\The [user] has begun putting on \a [src] on \the [H].</span>", "<span class='notice'>You begin putting on \the [src] on \the [H].</span>")
		if(!do_after(user, HUMAN_STRIP_DELAY, H, progress = FALSE))
			return FALSE
	. = EquipUnderwear(user, H)
	if(. && user != H)
		user.visible_message("<span class='warning'>\The [user] has put \the [src] on \the [H].</span>", "<span class='notice'>You have put \the [src] on \the [H].</span>")
		admin_attack_log(user, H, "Put on \a [src]", "Had \a [src] put on.", "put on \a [src] on")

/obj/item/underwear/proc/EquipUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanEquipUnderwear(user, H))
		return FALSE
	if(!user.try_unequip(src))
		return FALSE
	return ForceEquipUnderwear(H)

/obj/item/underwear/proc/ForceEquipUnderwear(var/mob/living/carbon/human/H, var/update_icons = TRUE)
	// No matter how forceful, we still don't allow multiples of the same underwear type
	if(is_path_in_list(type, H.worn_underwear))
		return FALSE

	H.worn_underwear += src
	forceMove(H)
	if(update_icons)
		H.update_underwear()

	return TRUE

/obj/item/underwear/proc/RemoveUnderwear(var/mob/user, var/mob/living/carbon/human/H)
	if(!CanRemoveUnderwear(user, H))
		return FALSE

	H.worn_underwear -= src
	dropInto(H.loc)
	user.put_in_hands(src)
	H.update_underwear()

	return TRUE

/obj/item/underwear/verb/RemoveSocks()
	set name = "Remove Underwear"
	set category = "Object"
	set src in usr

	RemoveUnderwear(usr, usr)

/obj/item/underwear/socks
	name = "socks"
	icon_state = "socks_norm"
	gender = PLURAL
	required_free_body_parts = SLOT_FEET
	slot_offset_str = slot_socks_str

/obj/item/underwear/top
	name = "bra"
	icon_state = "bra"
	required_free_body_parts = SLOT_UPPER_BODY
	slot_offset_str = slot_undershirt_str

/obj/item/underwear/bottom
	name = "briefs"
	icon_state = "briefs"
	required_free_body_parts = SLOT_FEET|SLOT_LEGS|SLOT_LOWER_BODY
	slot_offset_str = slot_underpants_str

/obj/item/underwear/undershirt
	name = "undershirt"
	icon_state = "undershirt"
	required_free_body_parts = SLOT_UPPER_BODY
	slot_offset_str = slot_undershirt_str
