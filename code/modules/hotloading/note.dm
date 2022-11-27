/datum/secret_note
	var/title
	var/text
	var/icon

/datum/secret_note/New(var/list/loaded_data)

	// Load data if supplied.
	title = loaded_data["note_title"] || title
	text =  loaded_data["note_body"]  || text
	icon =  loaded_data["icon"]       || icon

	// Grab icon file.
	if(loaded_data["_source_dir"] && icon)
		icon = SSsecrets.get_file("[loaded_data["_source_dir"]]/[icon]")

/obj/item/paper/secret_note
	is_spawnable_type = FALSE // Don't spawn this manually.
	var/secret_key

/obj/item/paper/secret_note/Initialize()
	..()
	return validate_secret()

/obj/item/paper/secret_note/proc/validate_secret()
	var/my_coords = "[x || loc?.x || "NULL"], [y || loc?.y || "NULL"], [z || loc?.z || "NULL"]"
	if(!secret_key)
		PRINT_STACK_TRACE("No secret_key set on note at [my_coords]!")
		return INITIALIZE_HINT_QDEL
	var/datum/secret_note/secret = get_secret()
	if(!istype(secret))
		PRINT_STACK_TRACE("Invalid or mistyped secret for secret_key [secret_key] on note at [my_coords]!")
		return INITIALIZE_HINT_QDEL
	return load_secret_data(secret)

/obj/item/paper/secret_note/proc/get_secret()
	return SSsecrets.retrieve_secret(secret_key, /datum/secret_note)

/obj/item/paper/secret_note/proc/load_secret_data(var/datum/secret_note/secret)
	if(!istype(secret))
		return INITIALIZE_HINT_QDEL
	if(secret.icon)
		icon = secret.icon
		if(!check_state_in_icon(icon_state, icon))
			PRINT_STACK_TRACE("Icon file for secret_key [secret_key] does not contain pre-content icon_state [icon_state].")
			return INITIALIZE_HINT_QDEL
	set_content(secret.text, secret.title)
	if(secret.icon && !check_state_in_icon(icon_state, icon))
		PRINT_STACK_TRACE("Icon file for secret_key [secret_key] does not contain post-content icon_state [icon_state].")
		return INITIALIZE_HINT_QDEL
	return INITIALIZE_HINT_NORMAL

/obj/item/paper/secret_note/random
	var/secrets_should_not_repeat = TRUE

/obj/item/paper/secret_note/random/get_secret()
	return SSsecrets.retrieve_random_secret(secret_key, secrets_should_not_repeat, /datum/secret_note)
