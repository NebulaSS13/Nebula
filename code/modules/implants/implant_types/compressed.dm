/obj/item/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"
	origin_tech = @'{"materials":4,"biotech":2,"esoteric":2}'
	hidden = 1
	var/activation_emote
	var/obj/item/scanned

/obj/item/implant/compressed/trigger(emote, mob/source)
	if (!scanned)
		return FALSE

	if (emote == activation_emote)
		to_chat(source, "The air glows as \the [scanned] uncompresses.")
		activate()

/obj/item/implant/compressed/activate()
	if(malfunction)
		return
	var/turf/our_turf = get_turf(src)
	if (imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.forceMove(our_turf)
	qdel(src)

/obj/item/implant/compressed/implanted(mob/source)
	activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	var/activation_string = "can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate."
	if (source.mind)
		source.StoreMemory("\A [src] [activation_string]", /decl/memory_options/system)
	to_chat(source, "\The [src] [activation_string].")
	return TRUE

/obj/item/implanter/compressed
	name = "implanter (C)"
	icon = 'icons/obj/items/implant/compressed_implant.dmi'
	icon_state = "cimplanter1"
	desc = "The matter compressor safety is on."
	imp = /obj/item/implant/compressed
	var/const/SAFETY_OFF = 0
	var/const/SAFETY_ON = 1
	var/const/SAFETY_USED = 2
	var/safe = SAFETY_ON

/obj/item/implanter/compressed/on_update_icon()
	. = ..()
	if (istype(imp, /obj/item/implant/compressed))
		var/obj/item/implant/compressed/compression_implant = imp
		icon_state = compression_implant.scanned ? "cimplanter2" : "cimplanter1"
	else
		icon_state = "cimplanter0"

/obj/item/implanter/compressed/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	var/obj/item/implant/compressed/compression_implant = imp
	if(!istype(compression_implant) || compression_implant.scanned == null)
		to_chat(user, SPAN_WARNING("Please compress an object with the implanter first."))
		return TRUE
	return ..()

/obj/item/implanter/compressed/afterattack(obj/item/used_item, mob/user, proximity)
	if(!proximity)
		return
	if(!istype(imp, /obj/item/implant/compressed))
		to_chat(user, SPAN_WARNING("There is no compressed matter implant in \the [src]!"))
		return
	var/obj/item/implant/compressed/compression_implant = imp
	if (compression_implant.scanned)
		if (!used_item.storage)
			to_chat(user, SPAN_WARNING("Something is already compressed inside the implant!"))
		return
	else if(safe >= SAFETY_ON)
		if (!used_item.storage)
			to_chat(user, SPAN_WARNING("The matter compressor safeties prevent you from doing that."))
		return
	var/atom/used_item_loc = used_item.loc
	var/mob/living/human/holder = used_item_loc
	if(istype(holder) && !holder.try_unequip(used_item))
		return
	if(used_item_loc.storage)
		used_item_loc.storage.remove_from_storage(user, used_item)
	compression_implant.scanned = used_item
	used_item.forceMove(src)  //Store it inside
	safe = SAFETY_USED
	desc = "It currently contains some matter."
	update_icon()

/obj/item/implanter/compressed/attack_self(var/mob/user)
	if(!imp || safe == SAFETY_USED)
		return ..()
	safe = !safe
	to_chat(user, SPAN_NOTICE("You [safe ? "enable" : "disable"] the matter compressor safety."))
	src.desc = "The matter compressor safety is [safe ? "on" : "off"]."