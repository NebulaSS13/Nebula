/obj/item/clothing/tie/bow
	var/tied = TRUE

/obj/item/clothing/tie/bow/on_attached(obj/item/clothing/under/S, mob/user)
	..()
	var/obj/item/clothing/suit = loc
	if(istype(suit))
		suit.verbs += /obj/item/clothing/tie/bow/verb/toggle

/obj/item/clothing/tie/bow/on_removed(mob/user)
	var/obj/item/clothing/suit = loc
	if(istype(suit))
		suit.verbs -= /obj/item/clothing/tie/bow/verb/toggle
	..()

/obj/item/clothing/tie/bow/verb/toggle()
	set name = "Toggle Bowtie"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return 0
	if(!istype(src)) // This verb is given to our holding clothing item and called on it, so src might not be the bowtie.
		for(var/obj/item/clothing/tie/bow/tie in accessories)
			src = tie
			break
	if(!istype(src))
		return
	do_toggle(usr)

/obj/item/clothing/tie/bow/proc/do_toggle(mob/user)
	user.visible_message("\The [user] [tied ? "un" : ""]ties \the [src].", "You [tied ? "un" : ""]tie \the [src].")
	tied = !tied
	update_icon()

/obj/item/clothing/tie/bow/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay && !tied && check_state_in_icon("[overlay.icon_state]-untied", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-untied"
	. = ..()

/obj/item/clothing/tie/bow/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(!tied && check_state_in_icon("[icon_state]-untied", icon))
		icon_state = "[icon_state]-untied"

/obj/item/clothing/tie/bow/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon = 'icons/clothing/accessories/ties/bowtie.dmi'

/obj/item/clothing/tie/bow/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon = 'icons/clothing/accessories/ties/bowtie_ugly.dmi'
