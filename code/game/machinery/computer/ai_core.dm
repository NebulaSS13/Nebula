var/global/list/empty_playable_ai_cores = list()

/obj/structure/aicore
	density = 1
	anchored = 0
	name = "\improper AI core"
	icon = 'icons/mob/AI.dmi'
	icon_state = "0"
	tool_interaction_flags = TOOL_INTERACTION_ALL
	material = /decl/material/solid/metal/plasteel

	var/datum/ai_laws/laws
	var/obj/item/stock_parts/circuitboard/circuit
	var/obj/item/mmi/brain
	var/authorized

	var/circuit_secured = FALSE
	var/glass_installed = FALSE

/obj/structure/aicore/Initialize()
	if(!laws)
		laws = new global.using_map.default_law_type
	. = ..()

/obj/structure/aicore/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	if(!authorized)
		to_chat(user, SPAN_WARNING("You swipe [emag_source] at [src] and jury rig it into the systems of [global.using_map.full_name]!"))
		authorized = 1
		return 1
	. = ..()

/obj/structure/aicore/handle_default_screwdriver_attackby(var/mob/user, var/obj/item/screwdriver)
	if(anchored && wired && circuit)
		if(!glass_installed)
			if(brain)
				to_chat(user, SPAN_WARNING("Get that brain out of there first."))
			else
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				circuit_secured = !circuit_secured
				to_chat(user, SPAN_NOTICE("You [circuit_secured ? "screw the circuit board into place" : "unscrew the circuit board"]."))
			return TRUE
		else if(circuit_secured)
			if(!authorized)
				to_chat(user, SPAN_WARNING("Core fails to connect to the systems of [global.using_map.full_name]!"))
				return TRUE
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You connect the monitor."))
			if(!brain)
				var/open_for_latejoin = alert(user, "Would you like this core to be open for latejoining AIs?", "Latejoin", "Yes", "Yes", "No") == "Yes"
				var/obj/structure/aicore/deactivated/D = new(loc)
				if(open_for_latejoin)
					empty_playable_ai_cores += D
			else
				var/mob/living/silicon/ai/A = new /mob/living/silicon/ai ( loc, laws, brain )
				if(A) //if there's no brain, the mob is deleted and a structure/AIcore is created
					A.on_mob_init()
					A.rename_self("ai", 1)
			SSstatistics.add_field("cyborg_ais_created",1)
			qdel(src)
			return TRUE
	. = ..()

/obj/structure/aicore/handle_default_crowbar_attackby(var/mob/user, var/obj/item/crowbar)
	if(anchored)
		if(glass_installed)
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You remove the glass panel."))
			SSmaterials.create_object(/decl/material/solid/glass, loc, 2, null, /decl/material/solid/metal/steel)
			glass_installed = FALSE
			return TRUE
		if(brain)
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You remove the brain."))
			brain.dropInto(loc)
			brain = null
			return TRUE
		if(circuit)
			if(circuit_secured)
				to_chat(user, SPAN_WARNING("Unsecure the circuit board first."))
				return TRUE
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You remove the circuit board."))
			circuit.dropInto(loc)
			circuit = null
			return TRUE
	. = ..()

/obj/structure/aicore/handle_default_cable_attackby(var/mob/user, var/obj/item/stack/cable_coil/coil)
	. = !glass_installed && ..()

/obj/structure/aicore/handle_default_wirecutter_attackby(var/mob/user, var/obj/item/wirecutters/wirecutters)
	if(anchored && !glass_installed && wired)
		if(brain)
			to_chat(user, SPAN_WARNING("Get that brain out of there first."))
			return TRUE
		. = ..()

/obj/structure/aicore/on_update_icon()
	..()
	if(glass_installed)
		icon_state = "4"
	else if(brain)
		icon_state = "3b"
	else if(circuit)
		icon_state = circuit_secured ? "2" : "1"
	else if(wired)
		icon_state = "3"
	else
		icon_state = "0"

/obj/structure/aicore/attackby(obj/item/P, mob/user)

	. = ..()
	if(.)
		update_icon()
	else
		if(!authorized)
			if(access_ai_upload in P.GetAccess())
				to_chat(user, SPAN_NOTICE("You swipe [P] at [src] and authorize it to connect into the systems of [global.using_map.full_name]."))
				authorized = 1

		if(anchored)

			if(!glass_installed && wired)

				if(istype(P, /obj/item/stock_parts/circuitboard/aicore))
					if(circuit)
						to_chat(user, SPAN_WARNING("There is already a circuit installed in \the [src]."))
						return TRUE
					if(!wired)
						to_chat(user, SPAN_WARNING("Wire \the [src] first."))
						return TRUE
					if(user.try_unequip(P, src))
						playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
						to_chat(user, SPAN_NOTICE("You place the circuit board inside the frame."))
						circuit = P
						update_icon()
					return TRUE

				if(circuit && circuit_secured)

					if((istype(P, /obj/item/mmi) || istype(P, /obj/item/organ/internal/posibrain)) && wired && circuit && circuit_secured)
						var/mob/living/carbon/brain/B
						if(istype(P, /obj/item/mmi))
							var/obj/item/mmi/M = P
							B = M.brainmob
						else
							var/obj/item/organ/internal/posibrain/PB = P
							B = PB.brainmob
						if(!B)
							to_chat(user, SPAN_WARNING("Sticking an empty [P] into the frame would sort of defeat the purpose."))
							return
						if(B.stat == 2)
							to_chat(user, SPAN_WARNING("Sticking a dead [P] into the frame would sort of defeat the purpose."))
							return
						if(jobban_isbanned(B, "AI"))
							to_chat(user, SPAN_WARNING("This [P] does not seem to fit."))
							return
						if(!user.try_unequip(P, src))
							return
						if(B.mind)
							clear_antag_roles(B.mind, 1)
						brain = P
						to_chat(usr, "Added [P].")
						update_icon()
						return TRUE

					if(istype(P, /obj/item/stack/material))
						var/obj/item/stack/material/RG = P
						if(RG.material.type != /decl/material/solid/glass || !RG.reinf_material || RG.get_amount() < 2)
							to_chat(user, SPAN_WARNING("You need two sheets of reinforced glass to put in the glass panel."))
							return TRUE
						if(!wired)
							to_chat(user, SPAN_WARNING("Wire \the [src] first."))
							return TRUE
						to_chat(user, SPAN_NOTICE("You start to put in the glass panel."))
						playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
						if(do_after(user, 20, src) && wired && anchored && !glass_installed && RG.use(2))
							to_chat(user, SPAN_NOTICE("You put in the glass panel."))
							glass_installed = TRUE
							update_icon()
						return TRUE

			if(istype(P, /obj/item/aiModule/freeform))
				var/obj/item/aiModule/freeform/M = P
				laws.add_inherent_law(M.newFreeFormLaw)
				to_chat(usr, "Added a freeform law.")
				return TRUE

			if(istype(P, /obj/item/aiModule))
				var/obj/item/aiModule/module = P
				laws.clear_inherent_laws()
				if(module.laws)
					for(var/datum/ai_law/AL in module.laws.inherent_laws)
						laws.add_inherent_law(AL.law)
				to_chat(usr, "Law module applied.")
				return TRUE

var/global/list/deactivated_ai_cores = list()
/obj/structure/aicore/deactivated
	name = "inactive AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai-empty"
	anchored = 1
	tool_interaction_flags =  (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)

/obj/structure/aicore/deactivated/Initialize()
	. = ..()
	global.deactivated_ai_cores += src

/obj/structure/aicore/deactivated/Destroy()
	global.deactivated_ai_cores -= src
	empty_playable_ai_cores -= src
	. = ..()

/obj/structure/aicore/deactivated/proc/load_ai(var/mob/living/silicon/ai/transfer, var/obj/item/aicard/card, var/mob/user)

	if(!istype(transfer) || locate(/mob/living/silicon/ai) in src)
		return

	transfer.aiRestorePowerRoutine = 0
	transfer.control_disabled = 0
	transfer.ai_radio.disabledAi = 0
	transfer.dropInto(src)
	transfer.create_eyeobj()
	transfer.cancel_camera()
	to_chat(user, SPAN_NOTICE("Transfer successful: [transfer.name] ([rand(1000,9999)].exe) downloaded to host terminal. Local copy wiped."))
	to_chat(transfer, "You have been uploaded to a stationary terminal. Remote device connection restored.")
	if(card)
		card.clear()
	qdel(src)

/obj/structure/aicore/deactivated/attackby(var/obj/item/W, var/mob/user)
	if(IS_WRENCH(W) || IS_WELDER(W))
		. = ..()
	else if(istype(W, /obj/item/aicard))
		var/obj/item/aicard/card = W
		var/mob/living/silicon/ai/transfer = locate() in card
		if(transfer)
			load_ai(transfer,card,user)
		else
			to_chat(user, SPAN_DANGER("ERROR: Unable to locate artificial intelligence."))
		return TRUE

/client/proc/empty_ai_core_toggle_latejoin()
	set name = "Toggle AI Core Latejoin"
	set category = "Admin"

	var/list/cores = list()
	for(var/obj/structure/aicore/deactivated/D in global.deactivated_ai_cores)
		cores["[D] ([get_area_name(D)])"] = D

	var/id = input("Which core?", "Toggle AI Core Latejoin", null) as null|anything in cores
	if(!id) return

	var/obj/structure/aicore/deactivated/D = cores[id]
	if(!istype(D) || QDELETED(D) || !(D in global.deactivated_ai_cores))
		return

	if(D in empty_playable_ai_cores)
		empty_playable_ai_cores -= D
		to_chat(src, "\The [id] is now [SPAN_BAD("not available")] for latejoining AIs.")
	else
		empty_playable_ai_cores += D
		to_chat(src, "\The [id] is now [SPAN_GOOD("available")] for latejoining AIs.")
