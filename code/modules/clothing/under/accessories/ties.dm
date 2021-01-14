/obj/item/clothing/accessory/long
	icon = 'icons/clothing/accessories/ties/tie_long.dmi'

/obj/item/clothing/accessory/long/red
	name = "long red tie"
	color = "#a02929"

/obj/item/clothing/accessory/black
	name = "black tie"
	color = "#1e1e1e"

/obj/item/clothing/accessory/red
	name = "red tie"
	color = "#800000"

/obj/item/clothing/accessory/blue
	name = "blue tie"
	color = "#123c5a"

/obj/item/clothing/accessory/blue_clip
	name = "blue tie with a clip"
	icon = 'icons/clothing/accessories/ties/tie_clip.dmi'

/obj/item/clothing/accessory/long/yellow
	name = "long yellow tie"
	color = "#c4c83d"

/obj/item/clothing/accessory/navy
	name = "navy tie"
	color = "#182e44"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon = 'icons/clothing/accessories/ties/tie_horrible.dmi'

/obj/item/clothing/accessory/brown
	name = "brown tie"
	icon = 'icons/clothing/accessories/ties/tie_long.dmi'
	color = "#b18345"

//Bowties
/obj/item/clothing/accessory/bowtie
	var/tied = TRUE

/obj/item/clothing/accessory/bowtie/on_attached(obj/item/clothing/under/S, mob/user)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/bowtie/verb/toggle

/obj/item/clothing/accessory/bowtie/on_removed(mob/user)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/bowtie/verb/toggle
	..()

/obj/item/clothing/accessory/bowtie/verb/toggle()
	set name = "Toggle Bowtie"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return 0
	if(!istype(src)) // This verb is given to our holding clothing item and called on it, so src might not be the bowtie.
		for(var/obj/item/clothing/accessory/bowtie/tie in accessories)
			src = tie
			break
	if(!istype(src))
		return
	do_toggle(usr)

/obj/item/clothing/accessory/bowtie/proc/do_toggle(mob/user)
	user.visible_message("\The [user] [tied ? "un" : ""]ties \the [src].", "You [tied ? "un" : ""]tie \the [src].")
	tied = !tied
	update_icon()

/obj/item/clothing/accessory/bowtie/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	if(ret && !tied && check_state_in_icon("[ret.icon_state]-untied", ret.icon))
		ret.icon_state = "[ret.icon_state]-untied"
	return ret

/obj/item/clothing/accessory/bowtie/on_update_icon()
	icon_state = get_world_inventory_state()
	if(!tied && check_state_in_icon("[icon_state]-untied", icon))
		icon_state = "[icon_state]-untied"

/obj/item/clothing/accessory/bowtie/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon = 'icons/clothing/accessories/ties/bowtie.dmi'

/obj/item/clothing/accessory/bowtie/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon = 'icons/clothing/accessories/ties/bowtie_ugly.dmi'
