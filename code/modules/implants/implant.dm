#define MALFUNCTION_NONE      0
#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2


/obj/item/implant
	name = "implant"
	icon = 'icons/obj/items/implant/implant.dmi'
	icon_state = "implant"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/titanium
	var/implanted = FALSE
	var/mob/imp_in
	var/obj/item/organ/external/part
	var/implant_color = "b"
	var/malfunction = MALFUNCTION_NONE
	/// if TRUE, advanced scanners will directly name the implant in results
	var/known = FALSE
	/// if FALSE, scanners will not locate this implant at all
	var/hidden = FALSE

/obj/item/implant/proc/trigger(emote, source)
	return

/obj/item/implant/proc/hear(message)
	return

/obj/item/implant/proc/activate()
	return

/obj/item/implant/proc/disable(var/time = 10 SECONDS)
	if(malfunction)
		return FALSE

	malfunction = MALFUNCTION_TEMPORARY
	addtimer(CALLBACK(src,PROC_REF(restore)),time)
	return TRUE

/obj/item/implant/proc/restore()
	if(malfunction == MALFUNCTION_PERMANENT || !malfunction)
		return FALSE

	malfunction = MALFUNCTION_NONE
	return TRUE

// What does the implant do upon injection?
// return FALSE if the implant fails (ex. Revhead and loyalty implant.)
// return TRUE if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/implant/proc/implanted(var/mob/living/source)
	return TRUE

/obj/item/implant/proc/can_implant(mob/living/victim, mob/user, var/target_zone)
	var/mob/living/human/human_victim = victim
	if(istype(human_victim) && !GET_EXTERNAL_ORGAN(human_victim, target_zone))
		to_chat(user, SPAN_WARNING("\The [human_victim] is missing that body part."))
		return FALSE
	return TRUE

/obj/item/implant/proc/implant_in_mob(mob/living/victim, mob/living/user, var/target_zone)
	if (ishuman(victim))
		var/mob/living/human/human_victim = victim
		var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(human_victim, target_zone)
		if(affected)
			LAZYADD(affected.implants, src)
			part = affected

	forceMove(victim)
	imp_in = victim
	implanted = TRUE
	implanted(victim)

	return TRUE

/obj/item/implant/proc/removed()
	imp_in = null
	if(part)
		LAZYREMOVE(part.implants, src)
		part = null
	implanted = FALSE

//Called in surgery when incision is retracted open / ribs are opened - basically before you can take implant out
/obj/item/implant/proc/exposed()
	return

/obj/item/implant/proc/get_data()
	return "No information available"

/obj/item/implant/interact(user)
	var/datum/browser/popup = new(user, capitalize(name), capitalize(name), 300, 700, src)
	var/dat = get_data()
	if(malfunction)
		popup.title = "??? implant"
		dat = stars(dat,10)
	popup.set_content(dat)
	popup.open()

/obj/item/implant/proc/islegal()
	return FALSE

/obj/item/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	if(malfunction == MALFUNCTION_PERMANENT)
		return
	to_chat(imp_in, SPAN_DANGER("You feel something melting inside [part ? "your [part.name]" : "you"]!"))
	imp_in.apply_damage(15, BURN, used_weapon = "Electronics meltdown", given_organ = part) // used_weapon can be a string or an item, for some reason
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/implant/emp_act(severity)
	var/power = 4 - severity
	if(prob(power * 15))
		meltdown()
	else if(prob(power * 25))
		activate()
	else if(prob(power * 33))
		disable(rand(power*10 SECONDS,power*100 SECONDS))

/obj/item/implant/Destroy()
	if(part)
		LAZYREMOVE(part.implants, src)
		part = null
	imp_in = null
	var/obj/item/implanter/implanter = loc
	if(istype(implanter) && implanter.imp == src)
		implanter.imp = null
	return ..()
