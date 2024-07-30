/*
Single Use Emergency Pouches
 */

/obj/item/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'icons/obj/med_pouch.dmi'
	icon_state = "pack0"
	storage = /datum/storage/med_pouch
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/plastic
	var/injury_type = "generic"
	var/static/image/cross_overlay
	var/instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	8) Stay in place once they respond.\
		"}

/obj/item/med_pouch/Initialize(ml, material_key)
	. = ..()
	SetName("emergency [injury_type] pouch")
	if(length(contents) && storage)
		storage.make_exact_fit()
	for(var/obj/item/chems/C in contents)
		C.set_detail_color(color)

/obj/item/med_pouch/on_update_icon()
	. = ..()
	if(!cross_overlay)
		cross_overlay = overlay_image(icon, "cross", flags = RESET_COLOR)
	add_overlay(cross_overlay)
	icon_state = "pack[!!(storage?.opened)]"

/obj/item/med_pouch/examine(mob/user)
	. = ..()
	to_chat(user, "<A href='byond://?src=\ref[src];show_info=1'>Please read instructions before use.</A>")

/obj/item/med_pouch/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/item/med_pouch/OnTopic(var/user, var/list/href_list)
	if(href_list["show_info"])
		to_chat(user, instructions)
		return TOPIC_HANDLED

/obj/item/med_pouch/attack_self(mob/user)
	if(storage && !storage.opened)
		storage.open(user)
		return TRUE
	return ..()

/obj/item/med_pouch/trauma
	name = "trauma pouch"
	injury_type = "trauma"
	color = COLOR_RED
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Contact the medical team with your location.
	7) Stay in place once they respond.\
		"}

/obj/item/med_pouch/trauma/WillContain()
	return list(
			/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer,
			/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers,
			/obj/item/chems/pill/pouch_pill/stabilizer,
			/obj/item/chems/pill/pouch_pill/brute_meds,
			/obj/item/stack/medical/bandage = 2,
		)

/obj/item/med_pouch/burn
	name = "burn pouch"
	injury_type = "burn"
	color = COLOR_SEDONA
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Use ointment on any burns if required\n\
	\t6) Contact the medical team with your location.
	7) Stay in place once they respond.\
		"}

/obj/item/med_pouch/burn/WillContain()
	return list(
			/obj/item/chems/hypospray/autoinjector/pouch_auto/nanoblood,
			/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers,
			/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline,
			/obj/item/chems/pill/pouch_pill/burn_meds,
			/obj/item/stack/medical/ointment = 2,
		)

/obj/item/med_pouch/oxyloss
	name = "low oxygen pouch"
	injury_type = "low oxygen"
	color = COLOR_BLUE
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Find a source of oxygen if possible.\n\
	\t7) Update the medical team with your new location.\n\
	8) Stay in place once they respond.\
		"}

/obj/item/med_pouch/oxyloss/WillContain()
	return list(
		/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer,
		/obj/item/chems/inhaler/pouch_auto/oxy_meds,
		/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline,
		/obj/item/chems/pill/pouch_pill/stabilizer,
		/obj/item/chems/pill/pouch_pill/oxy_meds
	)

/obj/item/med_pouch/toxin
	name = "toxin pouch"
	injury_type = "toxin"
	color = COLOR_GREEN
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/med_pouch/toxin/WillContain()
	return list(
			/obj/item/chems/hypospray/autoinjector/pouch_auto/antitoxins,
			/obj/item/chems/pill/pouch_pill/antitoxins
		)

/obj/item/med_pouch/radiation
	name = "radiation pouch"
	injury_type = "radiation"
	color = COLOR_AMBER
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/med_pouch/radiation/WillContain()
	return list(
			/obj/item/chems/hypospray/autoinjector/antirad,
			/obj/item/chems/pill/pouch_pill/antitoxins
		)

/obj/item/med_pouch/overdose
	name = "overdose treatment pouch"
	injury_type = "overdose"
	color = COLOR_PALE_BLUE_GRAY
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors and autoinhalers to the injured party. DO NOT give the injured party any pills, foods, or liquids.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Find a source of oxygen if possible.\n\
	\t7) Update the medical team with your new location.\n\
	8) Stay in place once they respond.\
		"}

/obj/item/med_pouch/overdose/WillContain()
	return list(
		/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer,
		/obj/item/chems/inhaler/pouch_auto/oxy_meds,
		/obj/item/chems/inhaler/pouch_auto/detoxifier,
		/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline
	)

// Pills

/obj/item/chems/pill/pouch_pill
	name       = "emergency pill"
	desc       = "An emergency pill from an emergency medical pouch."
	icon_state = "pill2"
	volume     = 15
	abstract_type = /obj/item/chems/pill/pouch_pill

/obj/item/chems/pill/pouch_pill/Initialize(ml, material_key)
	. = ..()
	if(!reagents?.total_volume)
		log_warning("[log_info_line(src)] was deleted for containing no reagents during init!")
		return INITIALIZE_HINT_QDEL

/obj/item/chems/pill/pouch_pill/initialize_reagents(populate = TRUE)
	. = ..()
	if(populate && reagents?.get_primary_reagent_name())
		SetName("emergency [reagents.get_primary_reagent_name()] pill ([reagents.total_volume]u)")

/obj/item/chems/pill/pouch_pill/stabilizer/populate_reagents()
	add_to_reagents(/decl/material/liquid/stabilizer, reagents.maximum_volume)
	. = ..()

/obj/item/chems/pill/pouch_pill/antitoxins/populate_reagents()
	add_to_reagents(/decl/material/liquid/antitoxins, reagents.maximum_volume)
	. = ..()

/obj/item/chems/pill/pouch_pill/oxy_meds/populate_reagents()
	add_to_reagents(/decl/material/liquid/oxy_meds, reagents.maximum_volume)
	. = ..()

/obj/item/chems/pill/pouch_pill/painkillers/populate_reagents()
	add_to_reagents(/decl/material/liquid/painkillers, reagents.maximum_volume)
	. = ..()

/obj/item/chems/pill/pouch_pill/brute_meds/populate_reagents()
	add_to_reagents(/decl/material/liquid/brute_meds, reagents.maximum_volume)
	. = ..()

/obj/item/chems/pill/pouch_pill/burn_meds/populate_reagents()
	add_to_reagents(/decl/material/liquid/burn_meds, reagents.maximum_volume)
	. = ..()

// Injectors

/obj/item/chems/hypospray/autoinjector/pouch_auto
	name = "emergency autoinjector"
	desc = "An emergency autoinjector from an emergency medical pouch."
	abstract_type = /obj/item/chems/hypospray/autoinjector/pouch_auto

/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer/populate_reagents()
	add_to_reagents(/decl/material/liquid/stabilizer, 5)
	. = ..()

/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers/populate_reagents()
	add_to_reagents(/decl/material/liquid/painkillers, 5)
	. = ..()

/obj/item/chems/hypospray/autoinjector/pouch_auto/antitoxins/populate_reagents()
	add_to_reagents(/decl/material/liquid/antitoxins, 5)
	. = ..()

/obj/item/chems/hypospray/autoinjector/pouch_auto/oxy_meds/populate_reagents()
	add_to_reagents(/decl/material/liquid/oxy_meds, 5)
	. = ..()

/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline
	amount_per_transfer_from_this = 8
/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline/populate_reagents()
	add_to_reagents(/decl/material/liquid/adrenaline, 8)
	. = ..()

/obj/item/chems/hypospray/autoinjector/pouch_auto/nanoblood/populate_reagents()
	add_to_reagents(/decl/material/liquid/nanoblood, 5)
	. = ..()

// Inhalers

/obj/item/chems/inhaler/pouch_auto
	name = "emergency autoinhaler"
	desc = "An emergency autoinhaler from an emergency medical pouch."

/obj/item/chems/inhaler/pouch_auto/oxy_meds
	name = "emergency oxygel autoinhaler"
	detail_color = COLOR_CYAN

/obj/item/chems/inhaler/pouch_auto/oxy_meds/populate_reagents()
	add_to_reagents(/decl/material/liquid/oxy_meds, 5)

/obj/item/chems/inhaler/pouch_auto/detoxifier
	name = "emergency detoxifier autoinhaler"
	detail_color = COLOR_GREEN

/obj/item/chems/inhaler/pouch_auto/detoxifier/populate_reagents()
	add_to_reagents(/decl/material/liquid/detoxifier, 5)
