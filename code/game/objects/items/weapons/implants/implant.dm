#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2


/obj/item/implant
	name = "implant"
	icon = 'icons/obj/items/implant/implant.dmi'
	icon_state = "implant"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/titanium
	var/implanted = null
	var/mob/imp_in = null
	var/obj/item/organ/external/part = null
	var/implant_color = "b"
	var/malfunction = 0
	var/known //if advanced scanners would name these in results
	var/hidden //if scanners will locate this implant at all

/obj/item/implant/proc/trigger(emote, source)
	return

/obj/item/implant/proc/hear(message)
	return

/obj/item/implant/proc/activate()
	return

/obj/item/implant/proc/disable(var/time = 100)
	if(malfunction)
		return 0

	malfunction = MALFUNCTION_TEMPORARY
	addtimer(CALLBACK(src,PROC_REF(restore)),time)
	return 1

/obj/item/implant/proc/restore()
	if(malfunction == MALFUNCTION_PERMANENT || !malfunction)
		return 0

	malfunction = 0
	return 1

// What does the implant do upon injection?
// return 0 if the implant fails (ex. Revhead and loyalty implant.)
// return TRUE if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/implant/proc/implanted(var/mob/source)
	return TRUE

/obj/item/implant/proc/can_implant(mob/M, mob/user, var/target_zone)
	var/mob/living/carbon/human/H = M
	if(istype(H) && !GET_EXTERNAL_ORGAN(H, target_zone))
		to_chat(user, "<span class='warning'>\The [M] is missing that body part.</span>")
		return FALSE
	return TRUE

/obj/item/implant/proc/implant_in_mob(mob/M, var/target_zone)
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affected = GET_EXTERNAL_ORGAN(H, target_zone)
		if(affected)
			LAZYADD(affected.implants, src)
			part = affected

		BITSET(H.hud_updateflag, IMPLOYAL_HUD)

	forceMove(M)
	imp_in = M
	implanted = 1
	implanted(M)

	return TRUE

/obj/item/implant/proc/removed()
	imp_in = null
	if(part)
		LAZYREMOVE(part.implants, src)
		part = null
	implanted = 0

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
	if(malfunction == MALFUNCTION_PERMANENT) return
	to_chat(imp_in, SPAN_DANGER("You feel something melting inside [part ? "your [part.name]" : "you"]!"))
	if (part)
		part.take_damage(15, BURN, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.take_damage(15, BURN)
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
		disable(rand(power*100,power*1000))

/obj/item/implant/Destroy()
	if(part)
		LAZYREMOVE(part.implants, src)
	var/obj/item/implanter/implanter = loc
	if(istype(implanter) && implanter.imp == src)
		implanter.imp = null
	return ..()
