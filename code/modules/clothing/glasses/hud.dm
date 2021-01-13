/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	origin_tech = "{'magnets':3,'biotech':2}"
	electric = 1
	gender = NEUTER
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	bodytype_restricted = null
	var/list/icon/current = list() //the current hud icons

/obj/item/clothing/glasses/proc/process_hud(var/mob/M)
	if(hud)
		hud.process_hud(M)

/obj/item/clothing/glasses/hud/process_hud(var/mob/M)
	return

/obj/item/clothing/glasses/hud/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device/lazy)
	var/obj/verb_holder = src
	if(istype(loc, /obj/item/clothing/glasses)) //we're a HUD inside other glasses
		verb_holder = loc
	verb_holder.verbs |= /obj/item/clothing/glasses/proc/network_setup

/obj/item/clothing/glasses/hud/health
	name = "health scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon = 'icons/clothing/eyes/hud_medical.dmi'
	hud_type = HUD_MEDICAL
	body_parts_covered = 0

/obj/item/clothing/glasses/hud/health/process_hud(var/mob/M)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	process_med_hud(M, 1, network = D?.get_network())

/obj/item/clothing/glasses/hud/health/prescription
	name = "prescription health scanner HUD"
	desc = "A medical HUD integrated with a set of prescription glasses."
	prescription = 7
	icon = 'icons/clothing/eyes/hud_medical_prescription.dmi'

/obj/item/clothing/glasses/hud/health/visor
	name = "medical HUD visor"
	desc = "A medical HUD integrated with a wide visor."
	icon = 'icons/clothing/eyes/hud_medical_visor.dmi'

/obj/item/clothing/glasses/hud/security
	name = "security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon = 'icons/clothing/eyes/hud_security.dmi'
	hud_type = HUD_SECURITY
	body_parts_covered = 0
	var/global/list/jobs[0]
	
/obj/item/clothing/glasses/hud/security/prescription
	name = "prescription security HUD"
	desc = "A security HUD integrated with a set of prescription glasses."
	prescription = 7
	icon = 'icons/clothing/eyes/hud_security_prescription.dmi'

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	gender = PLURAL
	icon = 'icons/clothing/eyes/hud_security_shades.dmi'
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING


/obj/item/clothing/glasses/hud/security/process_hud(var/mob/M)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	process_sec_hud(M, 1, network = D?.get_network())

/obj/item/clothing/glasses/hud/janitor
	name = "janiHUD"
	desc = "A heads-up display that scans for messes and alerts the user. Good for finding puddles hiding under catwalks."
	icon = 'icons/clothing/eyes/hud_janitor.dmi'
	body_parts_covered = 0
	hud_type = HUD_JANITOR

/obj/item/clothing/glasses/hud/janitor/prescription
	name = "prescription janiHUD"
	icon = 'icons/clothing/eyes/hud_janitor_prescription.dmi'
	desc = "A janitor HUD integrated with a set of prescription glasses."
	prescription = 7

/obj/item/clothing/glasses/hud/janitor/process_hud(var/mob/M)
	process_jani_hud(M)