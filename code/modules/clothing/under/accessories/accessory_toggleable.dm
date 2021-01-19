/obj/item/clothing/accessory/toggleable
	name = "vest"
	desc = "A slick suit vest."
	icon = 'icons/clothing/accessories/clothing/vest.dmi'
	icon_state = ICON_STATE_WORLD
	var/open = FALSE

/obj/item/clothing/accessory/toggleable/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(ret && open && check_state_in_icon("[ret.icon_state]-open", ret.icon))
		ret.icon_state = "[ret.icon_state]-open"
	return ret

/obj/item/clothing/accessory/toggleable/on_attached(obj/item/clothing/under/S, mob/user)
	..()
	if(has_suit)
		has_suit.verbs |= /obj/item/clothing/accessory/toggleable/verb/toggle

/obj/item/clothing/accessory/toggleable/on_removed(mob/user)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/toggleable/verb/toggle
	..()

/obj/item/clothing/accessory/toggleable/attack_self(mob/user)
	do_toggle()
	. = ..()

/obj/item/clothing/accessory/toggleable/verb/toggle()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr
	if(!usr.incapacitated())
		var/obj/item/clothing/accessory/toggleable/H = (istype(src, /obj/item/clothing/accessory/toggleable)) ? src : (locate() in src)
		if(H)
			H.do_toggle(usr)

/obj/item/clothing/accessory/toggleable/on_update_icon()
	icon_state = get_world_inventory_state()
	if(open && check_state_in_icon("[icon_state]-open", icon))
		icon_state = "[icon_state]-open"

/obj/item/clothing/accessory/toggleable/proc/do_toggle(user)
	open = !open
	to_chat(user, SPAN_NOTICE("You [open ? "unbutton" : "button up"] \the [src]."))
	update_icon()
	update_clothing_icon()

/obj/item/clothing/accessory/toggleable/black_vest
	name = "black vest"
	color = COLOR_GRAY15

/obj/item/clothing/accessory/toggleable/tan_jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_tan.dmi'

/obj/item/clothing/accessory/toggleable/tan_jacket/Initialize()
	. = ..()
	do_toggle()

/obj/item/clothing/accessory/toggleable/charcoal_jacket
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_charcoal.dmi'

/obj/item/clothing/accessory/toggleable/navy_jacket
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_navy.dmi'

/obj/item/clothing/accessory/toggleable/burgundy_jacket
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_burgundy.dmi'

/obj/item/clothing/accessory/toggleable/checkered_jacket
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon = 'icons/clothing/accessories/clothing/jacket_checkered.dmi'

/obj/item/clothing/accessory/toggleable/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon = 'icons/clothing/accessories/clothing/hawaiian.dmi'

/obj/item/clothing/accessory/toggleable/hawaii/red
	icon = 'icons/clothing/accessories/clothing/hawaiian_alt.dmi'

/obj/item/clothing/accessory/toggleable/hawaii/random/Initialize()
	. = ..()
	icon = pick('icons/clothing/accessories/clothing/hawaiian.dmi', 'icons/clothing/accessories/clothing/hawaiian_alt.dmi')
	color = color_rotation(rand(-11,12)*15)

/obj/item/clothing/accessory/toggleable/zhongshan
	name = "zhongshan suit jacket"
	desc = "A stylish Chinese tunic suit jacket."
	icon = 'icons/clothing/accessories/clothing/zhongshan.dmi'

/obj/item/clothing/accessory/toggleable/flannel
	name = "flannel shirt"
	desc = "A comfy, plaid flannel shirt."
	icon = 'icons/clothing/accessories/clothing/flannel.dmi'
	var/rolled = FALSE
	var/tucked = FALSE

/obj/item/clothing/accessory/toggleable/flannel/on_attached(obj/item/clothing/under/S, mob/user)
	..()
	if(has_suit)
		has_suit.verbs |= /obj/item/clothing/accessory/toggleable/flannel/verb/tuck
		has_suit.verbs |= /obj/item/clothing/accessory/toggleable/flannel/verb/roll_up_sleeves

/obj/item/clothing/accessory/toggleable/flannel/on_removed(mob/user)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/toggleable/flannel/verb/tuck
		has_suit.verbs -= /obj/item/clothing/accessory/toggleable/flannel/verb/roll_up_sleeves
	..()

/obj/item/clothing/accessory/toggleable/flannel/verb/roll_up_sleeves()
	set name = "Roll Flannel Sleeves"
	set category = "Object"
	set src in usr
	if(usr.incapacitated())
		return FALSE
	var/obj/item/clothing/accessory/toggleable/flannel/H = (istype(src, /obj/item/clothing/accessory/toggleable)) ? src : (locate() in src)
	if(H)
		H.rolled = !H.rolled
		to_chat(usr, SPAN_NOTICE("You roll [H.rolled ? "up" : "down"] the sleeves of \the [H]."))
		H.update_icon()
		H.update_clothing_icon()

/obj/item/clothing/accessory/toggleable/flannel/verb/tuck()
	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr
	if(usr.incapacitated())
		return FALSE
	if(usr.incapacitated())
		return FALSE
	var/obj/item/clothing/accessory/toggleable/flannel/H = (istype(src, /obj/item/clothing/accessory/toggleable)) ? src : (locate() in src)
	if(H)
		H.tucked = !H.tucked
		to_chat(usr, SPAN_NOTICE("You [H.tucked ? "tuck in" : "untuck"] \the [H]."))
		H.update_icon()
		H.update_clothing_icon()

/obj/item/clothing/accessory/toggleable/flannel/on_update_icon()
	..()
	if(rolled && check_state_in_icon("[icon_state]-rolled", icon))
		icon_state = "[icon_state]-rolled"
	if(tucked && check_state_in_icon("[icon_state]-tucked", icon))
		icon_state = "[icon_state]-tucked"
	update_clothing_icon()

/obj/item/clothing/accessory/toggleable/flannel/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(ret)
		if(rolled && check_state_in_icon("[ret.icon_state]-rolled", ret.icon))
			ret.icon_state = "[ret.icon_state]-rolled"
		if(tucked && check_state_in_icon("[ret.icon_state]-tucked", ret.icon))
			ret.icon_state = "[ret.icon_state]-tucked"
	return ret
