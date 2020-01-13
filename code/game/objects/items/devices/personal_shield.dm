/obj/item/personal_shield
	name = "personal shield"
	desc = "Truely a life-saver: this device protects its user from being hit by objects moving very, very fast, though only for a few shots."
	icon = 'icons/obj/items.dmi'
	icon_state = "batterer"
	var/uses = 5
	var/obj/aura/personal_shield/device/shield

/obj/item/personal_shield/attack_self(var/mob/living/user)
	if(uses && !shield)
		shield = new(user,src)
	else
		QDEL_NULL(shield)

/obj/item/personal_shield/Move()
	QDEL_NULL(shield)
	return ..()

/obj/item/personal_shield/forceMove()
	QDEL_NULL(shield)
	return ..()

/obj/item/personal_shield/proc/take_charge()
	if(!--uses)
		QDEL_NULL(shield)
		to_chat(loc,"<span class='danger'>\The [src] begins to spark as it breaks!</span>")
		update_icon()
		return

/obj/item/personal_shield/on_update_icon()
	if(uses)
		icon_state = "batterer"
	else
		icon_state = "battererburnt"

/obj/item/personal_shield/Destroy()
	QDEL_NULL(shield)
	return ..()