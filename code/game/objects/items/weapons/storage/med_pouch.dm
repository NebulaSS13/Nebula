/*
Single Use Emergency Pouches
 */

/obj/item/storage/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'icons/obj/med_pouch.dmi'
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	icon_state = "pack0"
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'
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

/obj/item/storage/med_pouch/Initialize()
	. = ..()
	name = "emergency [injury_type] pouch"
	make_exact_fit()
	for(var/obj/item/chems/hypospray/autoinjector/A in contents)
		A.band_color = color
		A.update_icon()

/obj/item/storage/med_pouch/on_update_icon()
	overlays.Cut()
	if(!cross_overlay)
		cross_overlay = image(icon, "cross")
		cross_overlay.appearance_flags = RESET_COLOR
	overlays += cross_overlay
	icon_state = "pack[opened]"

/obj/item/storage/med_pouch/examine(mob/user)
	. = ..()
	to_chat(user, "<A href='?src=\ref[src];show_info=1'>Please read instructions before use.</A>")

/obj/item/storage/med_pouch/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/item/storage/med_pouch/OnTopic(var/user, var/list/href_list)
	if(href_list["show_info"])
		to_chat(user, instructions)
		return TOPIC_HANDLED

/obj/item/storage/med_pouch/attack_self(mob/user)
	open(user)

/obj/item/storage/med_pouch/open(mob/user)
	if(!opened)
		user.visible_message("<span class='notice'>\The [user] tears open [src], breaking the vacuum seal!</span>", "<span class='notice'>You tear open [src], breaking the vacuum seal!</span>")
	. = ..()

/obj/item/storage/med_pouch/trauma
	name = "trauma pouch"
	injury_type = "trauma"
	color = COLOR_RED

	startswith = list(
	/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer,
	/obj/item/chems/pill/pouch_pill/stabilizer,
	/obj/item/chems/pill/pouch_pill/painkillers,
	/obj/item/stack/medical/bruise_pack = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Contact the medical team with your location.
	7) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/burn
	name = "burn pouch"
	injury_type = "burn"
	color = COLOR_SEDONA

	startswith = list(
	/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer,
	/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers,
	/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline,
	/obj/item/chems/pill/pouch_pill/painkillers,
	/obj/item/stack/medical/ointment = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Use ointment on any burns if required\n\
	\t6) Contact the medical team with your location.
	7) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/oxyloss
	name = "low oxygen pouch"
	injury_type = "low oxygen"
	color = COLOR_BLUE

	startswith = list(
		/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer,
		/obj/item/chems/hypospray/autoinjector/pouch_auto/oxy_meds,
		/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline,
		/obj/item/chems/pill/pouch_pill/stabilizer,
		/obj/item/chems/pill/pouch_pill/oxy_meds
	)
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

/obj/item/storage/med_pouch/toxin
	name = "toxin pouch"
	injury_type = "toxin"
	color = COLOR_GREEN

	startswith = list(
	/obj/item/chems/hypospray/autoinjector/pouch_auto/antitoxins,
	/obj/item/chems/pill/pouch_pill/antitoxins
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/radiation
	name = "radiation pouch"
	injury_type = "radiation"
	color = COLOR_AMBER

	startswith = list(
	/obj/item/chems/hypospray/autoinjector/antirad,
	/obj/item/chems/pill/pouch_pill/antitoxins
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/chems/pill/pouch_pill
	name = "emergency pill"
	desc = "An emergency pill from an emergency medical pouch"
	icon_state = "pill2"
	var/decl/material/chem_type
	var/chem_amount = 15

/obj/item/chems/pill/pouch_pill/stabilizer
	chem_type = /decl/material/liquid/stabilizer

/obj/item/chems/pill/pouch_pill/antitoxins
	chem_type = /decl/material/liquid/antitoxins

/obj/item/chems/pill/pouch_pill/oxy_meds
	chem_type = /decl/material/liquid/oxy_meds

/obj/item/chems/pill/pouch_pill/painkillers
	chem_type = /decl/material/liquid/painkillers

/obj/item/chems/pill/pouch_pill/initialize_reagents()
	reagents.add_reagent(chem_type, chem_amount)
	var/decl/material/reagent = GET_DECL(chem_type)
	SetName("emergency [reagent.liquid_name] pill ([reagents.total_volume]u)")

/obj/item/chems/hypospray/autoinjector/pouch_auto
	name = "emergency autoinjector"
	desc = "An emergency autoinjector from an emergency medical pouch"

/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer
	name = "emergency stabilizer autoinjector"
	starts_with = list(/decl/material/liquid/stabilizer = 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers
	name = "emergency painkiller autoinjector"
	starts_with = list(/decl/material/liquid/painkillers = 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/antitoxins
	name = "emergency antitoxins autoinjector"
	starts_with = list(/decl/material/liquid/antitoxins = 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/oxy_meds
	name = "emergency oxygel autoinjector"
	starts_with = list(/decl/material/liquid/oxy_meds = 5)

/obj/item/chems/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	amount_per_transfer_from_this = 8
	starts_with = list(/decl/material/liquid/adrenaline = 8)
