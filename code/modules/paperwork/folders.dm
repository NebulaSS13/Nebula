///////////////////////////////////////////////
// Folder
///////////////////////////////////////////////
/obj/item/folder
	name         = "folder"
	desc         = "A folder."
	icon         = 'icons/obj/items/folders.dmi'
	icon_state   = "folder"
	w_class      = ITEM_SIZE_SMALL
	throwforce   = 0
	drop_sound   = 'sound/foley/paperpickup1.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'
	material     = /decl/material/solid/cardboard
	item_flags   = ITEM_FLAG_CAN_TAPE

/obj/item/folder/blue
	desc       = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/red
	desc       = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc       = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/cyan
	desc       = "A cyan folder."
	icon_state = "folder_cyan"

/obj/item/folder/on_update_icon(var/paper_overlay = TRUE)
	. = ..()
	if(paper_overlay && length(contents))
		add_overlay("folder_paper")

/obj/item/folder/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/paper_bundle))
		if(!user.try_unequip(W, src))
			return
		to_chat(user, SPAN_NOTICE("You put the [W] into \the [src]."))
		updateUsrDialog()
		update_icon()
		return TRUE

	else if(IS_PEN(W))
		updateUsrDialog()
		var/n_name = sanitize_safe(input(usr, "What would you like to label the folder?", "Folder Labelling", null)  as text, MAX_NAME_LEN)
		if(!CanPhysicallyInteractWith(user, src))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]."))
			return
		SetName("folder[(n_name ? text("- '[n_name]'") : null)]")
		return TRUE
	return

/obj/item/folder/attack_self(mob/user)
	return interact(user)

/obj/item/folder/interact(mob/user)
	var/dat = "<title>[name]</title>"
	for(var/obj/item/I in src)
		dat += "<A href='?src=\ref[src];remove=\ref[I]'>Remove</A> <A href='?src=\ref[src];rename=\ref[I]'>Rename</A> - <A href='?src=\ref[src];examine=\ref[I]'>[I.name]</A><BR>"

	user.set_machine(src)
	show_browser(user, dat, "window=[initial(name)]")
	onclose(user, initial(name))
	return TRUE

/obj/item/folder/DefaultTopicState()
	return global.physical_topic_state

/obj/item/folder/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["remove"])
		var/obj/item/P = locate(href_list["remove"])
		user.put_in_hands(P)
		. = TOPIC_REFRESH
	else
		. = handle_paper_stack_shared_topics(user, href_list)

	//Update everything
	if(. & TOPIC_REFRESH)
		updateUsrDialog()
		update_icon()

///////////////////////////////////////////////
//	Envelope
///////////////////////////////////////////////
/obj/item/folder/envelope
	name = "envelope"
	desc = "A thick envelope. You can't see what's inside."
	icon_state = "envelope_sealed"
	var/sealed = 1

/obj/item/folder/envelope/on_update_icon()
	. = ..(paper_overlay = FALSE)
	if(sealed)
		icon_state = "envelope_sealed"
	else
		icon_state = "envelope[contents.len > 0]"

/obj/item/folder/envelope/examine(mob/user)
	. = ..()
	to_chat(user, "The seal is [sealed ? "intact" : "broken"].")

/obj/item/folder/envelope/proc/sealcheck(user)
	var/ripperoni = alert("Are you sure you want to break the seal on \the [src]?", "Confirmation","Yes", "No")
	if(ripperoni == "Yes")
		visible_message("[user] breaks the seal on \the [src], and opens it.")
		sealed = 0
		update_icon()
		return 1

/obj/item/folder/envelope/attack_self(mob/user)
	if(sealed)
		sealcheck(user)
		return
	else
		..()

/obj/item/folder/envelope/attackby(obj/item/W, mob/user)
	if(sealed)
		sealcheck(user)
		return
	else
		..()