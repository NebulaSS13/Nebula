#define NO_GUARANTEE_NO_EXTRA_COST_DESC(X) "Installs an uplink into [X] if, and only if, found on your person. Has no TC cost."

#define SETUP_FAILED TRUE

var/global/list/default_uplink_source_priority = list(
	/decl/uplink_source/pda,
	/decl/uplink_source/radio,
	/decl/uplink_source/unit
)

/decl/uplink_source
	var/name
	var/desc

/decl/uplink_source/proc/setup_uplink_source(var/mob/M, var/amount)
	return SETUP_FAILED

/decl/uplink_source/pda
	name = "PDA"

/decl/uplink_source/pda/Initialize()
	desc = NO_GUARANTEE_NO_EXTRA_COST_DESC("a PDA")
	. = ..()

/decl/uplink_source/pda/setup_uplink_source(var/mob/M, var/amount)

	var/obj/item/modular_computer/pda/P = find_in_mob(M, /obj/item/modular_computer/pda)
	if(!P)
		return SETUP_FAILED

	var/datum/extension/assembly/assembly = get_extension(P, /datum/extension/assembly)
	if(!assembly)
		return SETUP_FAILED

	var/obj/item/stock_parts/computer/hard_drive/HDD = assembly.get_component(PART_HDD)
	if(!HDD)
		return SETUP_FAILED

	var/pda_pass = "[rand(100,999)] [pick(global.greek_letters)]"
	var/obj/item/uplink/T = new(P, M.mind, amount)
	P.hidden_uplink = T
	var/datum/computer_file/program/uplink/program = new(pda_pass)
	var/datum/computer_file/directory/program_dir = HDD.parse_directory(OS_PROGRAMS_DIR, TRUE) // This is almost certainly already created, but just in case.
	if(HDD.store_file(program, program_dir, TRUE, overwrite = TRUE) != OS_FILE_SUCCESS)
		return SETUP_FAILED	//Not enough space or other issues.
	to_chat(M, "<span class='notice'>A portable object teleportation relay has been installed in your [P.name]. Simply enter the code \"[pda_pass]\" in TaxQuickly program to unlock its hidden features.</span>")
	M.StoreMemory("<B>Uplink passcode:</B> [pda_pass] ([P.name]).", /decl/memory_options/system)

/decl/uplink_source/radio
	name = "Radio"

/decl/uplink_source/radio/Initialize()
	desc = NO_GUARANTEE_NO_EXTRA_COST_DESC("a radio")
	. = ..()

/decl/uplink_source/radio/setup_uplink_source(var/mob/M, var/amount)
	var/obj/item/radio/R = find_in_mob(M, /obj/item/radio)
	if(!R)
		return SETUP_FAILED

	var/obj/item/uplink/T = new(R, M.mind, amount)
	R.hidden_uplink = T
	R.traitor_frequency = sanitize_frequency(rand(PUBLIC_LOW_FREQ+1, PUB_FREQ-1))
	to_chat(M, "<span class='notice'>A portable object teleportation relay has been installed in your [R.name]. Simply dial the frequency [format_frequency(R.traitor_frequency)] to unlock its hidden features.</span>")
	M.StoreMemory("<B>Radio Freq:</B> [format_frequency(R.traitor_frequency)] ([R.name]).", /decl/memory_options/system)

/decl/uplink_source/implant
	name = "Implant"
	desc = "Teleports an uplink implant into your head. Costs 20% of the initial TC amount."

/decl/uplink_source/implant/setup_uplink_source(var/mob/living/carbon/human/H, var/amount)
	if(!istype(H))
		return SETUP_FAILED

	var/obj/item/organ/external/head = GET_EXTERNAL_ORGAN(H, BP_HEAD)
	if(!head)
		return SETUP_FAILED

	var/obj/item/implant/uplink/U = new(H, round(amount * 0.8))
	U.imp_in = H
	U.implanted = TRUE
	U.part = head
	LAZYADD(head.implants, U)

	U.implanted(H) // This proc handles the installation feedback

/decl/uplink_source/unit
	name = "Uplink Unit"
	desc = "Teleports an uplink unit to your location. Has 30% more TC."

/decl/uplink_source/unit/setup_uplink_source(var/mob/M, var/amount)
	var/obj/item/radio/uplink/U = new(M, M.mind, round(amount * 1.3))
	put_on_mob(M, U, "\A [U]")

/decl/uplink_source/telecrystals
	name = "Telecrystals"
	desc = "Get your telecrystals in pure form, without the means to trade them for goods, Gives 150% of initial TC amount"

/decl/uplink_source/telecrystals/setup_uplink_source(var/mob/M, var/amount)
	amount = round(amount * 1.5)
	var/obj/item/stack/telecrystal/TC = new(M, amount)
	put_on_mob(M, TC, "[amount] telecrystal\s")

/decl/uplink_source/proc/find_in_mob(var/mob/M, var/type)
	for(var/item in M.get_equipped_items(TRUE))
		if(!istype(item, type))
			continue
		var/obj/item/I = item
		if(!I.hidden_uplink)
			return I

/decl/uplink_source/proc/put_on_mob(var/mob/M, var/atom/movable/AM, var/text)
	var/obj/O = M.equip_to_storage(AM)
	if(O)
		to_chat(M, "<span class='notice'>[text] can be found in your [O.name].</span>")
	else if(M.put_in_hands(AM))
		to_chat(M, "<span class='notice'>[text] appear in your hands.</span>")
	else
		AM.dropInto(M.loc)
		to_chat(M, "<span class='notice'>[text] appear at your location.</span>")

/proc/setup_uplink_source(var/mob/M, var/amount = DEFAULT_TELECRYSTAL_AMOUNT)
	if(!istype(M) || !M.mind)
		return FALSE

	var/list/priority_order
	if(M.client && M.client.prefs)
		priority_order = M.client.prefs.uplink_sources

	if(!priority_order || !priority_order.len)
		priority_order = list()
		for(var/entry in global.default_uplink_source_priority)
			priority_order |= GET_DECL(entry)

	for(var/entry in priority_order)
		var/decl/uplink_source/US = entry
		if(US.setup_uplink_source(M, amount) != SETUP_FAILED)
			return TRUE

	to_chat(M, "<span class='warning'>Either by choice or circumstance you will be without an uplink.</span>")
	return FALSE

#undef NO_GUARANTEE_NO_EXTRA_COST_DESC
#undef SETUP_FAILED
