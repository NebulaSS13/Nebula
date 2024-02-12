/*
 * Secret content/hotloaded content subsystem. 
 * 
 * Very barebones at the moment, just slapping it down so there's something there to work with.
 * 
 * Simple guide:
 * - Create a .json file in data/secrets/ or any child subfolder.
 * - Put a json dictionary in there with a field "path" pointing to a valid datum type.
 * - Put a field "secret_key" in the dictionary with a GLOBALLY UNIQUE string value.
 * - Put a field "secret_categories" in the dictionary with a list of categories to file it under.
 * - Put a field "secret_category" in the dictionary with a single text category to file it in one.
 * - The JSON will be loaded early in init and can be retrieved for use in lore notes or whatever.
 *
 * Keep in mind that this system can SERIOUSLY MESS YOU UP - there are datum types that will CRASH 
 * YOUR SERVER if improperly created/initialized, and this system ignores all named arguments or 
 * argument ordering when it passes the loaded JSON to the datum instance. DO NOT TRY TO CREATE A 
 * PATH THAT YOU DO NOT FULLY UNDERSTAND TO BE SAFE TO CREATE. YOUR INSURANCE WILL NOT COVER IT.
 * 
 * Vague todo with ideas for future conversion/use:
 * - Map templates
 * - Materials
 * - Chemical recipes
 * - Verb to load arbitrary json content from a file on local storage.
 * 
 * Secrets can be retrieved with:
 *  var/datum/secret_stuff = SSsecrets.retrieve_secret("your unique key", /some/path/for/compile/time/validation)
 *  var/datum/random_secret_stuff = SSsecrets.retrieve_random_secret("your unique category", bool_if_you_want_no_duplicates, /some/path/for/compile/time/validation)
 *  var/list/bunch_of_secrets = SSsecrets.retrieve_secrets_by_category("your unique category")
 * 
 * You can refer to the /datum/secret_note and /obj/item/paper/secret_note types in 
 * code/modules/hotloading/note.dm for a practical example of how this system can be used.
 * 
 */

SUBSYSTEM_DEF(secrets)
	name = "Secret Content"
	init_order = SS_INIT_SECRETS
	flags = SS_NO_FIRE

	/// Root locations of content to load; terminating / is important for example dir check. Maps and mods inject their own directories into this list pre-init.
	var/static/list/load_directories = list("data/secrets/")

	/// Defines a list of paths that secrets are allowed to create. Anything loaded that isn't of a type or subtype in this list will throw an error.
	var/static/list/permitted_paths = list(/datum/secret_note)
	/// Defines a list of paths that secrets are not allowed to create. Anything loaded that is of a type or subtype in this list will throw an error.
	var/static/list/forbidden_paths = list()
	// Defines a list of types that should be logged on creation for later admin reference (ex. random chemical recipes or exploitable secrets)
	var/static/list/dangerous_paths = list()

	// Secrets indexed by category that have already been randomly selected before.
	var/list/retrieved_secrets =   list()
	/// Secrets indexed by key for specific retrieval.
	var/list/secrets_by_key =      list()
	// Secrets indexed by category for mass retrieval.
	var/list/secrets_by_category = list()
	/// Cache for files retrieved (such as icons)
	var/list/file_cache =          list()

	/// List of vars to hide from View Variables as this system is supposed to be full of secrets.
	var/static/list/protected_lists = list(
		"protected_lists",
		"retrieved_secrets",
		"secrets_by_key",
		"secrets_by_category",
		"permitted_paths",
		"forbidden_paths",
		"load_directories"
	)

/datum/controller/subsystem/secrets/VV_hidden()
	. = ..() | protected_lists

/datum/controller/subsystem/secrets/Recover(var/datum/controller/subsystem/secrets/S)

	// No point reloading references.
	retrieved_secrets =   S.retrieved_secrets
	secrets_by_key =      S.secrets_by_key
	secrets_by_category = S.secrets_by_category

	// In case someone purges it and it hasn't set SSsecrets yet. No idea if this can happen.
	S.retrieved_secrets =   list()
	S.secrets_by_key =      list()
	S.secrets_by_category = list()

	. = ..()
	
// Copied from customitems loading; scrapes entire file tree for json files.
/datum/controller/subsystem/secrets/Initialize()

	// Prune non-existent directories.
	for(var/directory in load_directories)
		if(!fexists(directory))
			log_warning("Invalid or non-existent directory [directory] during secret content load.")
			load_directories -= directory

	// Kick off content load.
	load_content()

	. = ..()

/datum/controller/subsystem/secrets/proc/load_content(var/nuke_existing = FALSE)

	// Admin verb will destroy existing secrets and reload.
	if(nuke_existing)
		retrieved_secrets =   list()
		secrets_by_category = list()
		for(var/secret_key in secrets_by_key)
			qdel(secrets_by_key[secret_key])
		secrets_by_key = list()

	if(!length(load_directories))
		report_progress("Could not find any secret content directories; no secret content will be available this run.")
		return

	var/list/loaded_directories = list()
	var/list/directories_to_check = load_directories.Copy()
	while(length(directories_to_check))

		// What's our next dir to check?
		var/checkdir = directories_to_check[1]
		directories_to_check -= checkdir

		// Ignore directories we've seen before (loops) and the example dir.
		if((checkdir in loaded_directories) || copytext(checkdir, -8) == "example/")
			continue

		// Scrape the directory for files.
		loaded_directories |= checkdir
		for(var/relative_checkfile in flist(checkdir))

			// flist() returns relative filenames rather than the full directory we're looking at.
			var/checkfile = "[checkdir][relative_checkfile]"

			// Directories just get noted down for later scraping.
			if(copytext(checkfile, -1) == "/")
				// Should hopefully prevent symlinks or recursive file structures breaking.
				if(!(checkfile in loaded_directories))
					directories_to_check |= checkfile
				continue

			// If this is a .bak or something, ignore it.
			if(lowertext(copytext(relative_checkfile, 1, 8)) != "secret_" || lowertext(copytext(checkfile, -5)) != ".json")
				continue

			// Load, validate and create the secret.
			var/list/loaded_data = cached_json_decode(safe_file2text(checkfile))
			if(!length(loaded_data))
				log_warning("Invalid or empty json loaded from [checkfile]!")
				continue

			var/secret_key = loaded_data["secret_key"]
			if(!istext(secret_key))
				log_warning("Undefined or invalid secret_key in [checkfile] ([isnull(secret_key) ? "NULL" : secret_key])!")
				continue
			secret_key = trim(lowertext(sanitize(secret_key)))
			if(!length(secret_key))
				log_warning("Zero-length post-sanitize secret key in [checkfile]!")
				continue
			if(secrets_by_key[secret_key])
				log_warning("Duplicate secret_key [secret_key] in [checkfile]!")
				continue

			// Validate the path.
			var/datum_path = text2path(loaded_data["path"])
			if(!ispath(datum_path))
				log_warning("Invalid or empty datum path ([datum_path || "NULL"]) loaded from [checkfile]!")
				continue
			var/checking_path_result = FALSE
			for(var/checkpath in permitted_paths)
				if(ispath(datum_path, checkpath))
					checking_path_result = TRUE
					break
			if(!checking_path_result)
				log_warning("Non-permitted path ([datum_path]) loaded from [checkfile]!")
				continue
			checking_path_result = FALSE
			for(var/checkpath in forbidden_paths)
				if(ispath(datum_path, checkpath))
					checking_path_result = TRUE
					break
			if(checking_path_result)
				log_warning("Forbidden path ([datum_path]) loaded from [checkfile]!")
				continue

			for(var/checkpath in dangerous_paths)
				if(ispath(datum_path, checkpath))
					// Not a dealbreaker, but something that should be logged for reference.
					to_world_log("## SECRETS ##: Dangerous type [datum_path] instanced from [checkfile] with payload '[json_encode(loaded_data)]'.")
					break

			// Set our metadata (used in theory by secrets like map templates or things loading icons/text files from a directory).
			if(loaded_data["_source_dir"])
				log_warning("Double-setting of _source_dir field in loaded secret from [checkfile]!")
			loaded_data["_source_dir"] = checkdir
			if(loaded_data["_source_file"])
				log_warning("Double-setting of _source_file field in loaded secret from [checkfile]!")
			loaded_data["_source_file"] = relative_checkfile

			// Store the loaded secret in our cache
			var/datum/secret = new datum_path(loaded_data)
			secrets_by_key[secret_key] = secret

			var/list/cats = loaded_data["secret_categories"] || list()
			if(loaded_data["secret_category"])
				cats |= loaded_data["secret_category"]

			for(var/cat in cats) // :3

				if(!istext(cat))
					log_warning("Invalid category string '[cat]' supplied in [checkfile].")
					continue

				var/unclean_cat = cat // :33
				cat = lowertext(sanitize(trim(cat)))
				if(!length(cat))
					log_warning("Post-sanitize zero-length category string '[unclean_cat]' supplied in [checkfile].")
					continue

				LAZYDISTINCTADD(secrets_by_category[cat], secret)

	var/dir_count = length(loaded_directories)
	var/cat_count = length(secrets_by_category)
	report_progress("Loaded [length(secrets_by_key)] secret\s, across [cat_count] categor[cat_count == 1 ? "y" : "ies"], from [dir_count] director[dir_count == 1 ? "y" : "ies"].")

/datum/controller/subsystem/secrets/proc/retrieve_random_secret(var/secret_cat, var/prune_already_retrieved = FALSE, var/expected_path)

	secret_cat = trim(lowertext(sanitize(secret_cat))) // Groom the cat.

	// Get all possibilities, and copy to avoid mutating the cache.
	var/list/cat_secrets = retrieve_secrets_by_category(secret_cat)
	if(!length(cat_secrets))
		return null

	// If we're not pruning options, then this is ez pz.
	if(!prune_already_retrieved)
		. = pick(cat_secrets)
	else
		// If we're going for a round robin no-duplicates approach, prune out already-retrieved secrets.
		var/list/available_secrets = cat_secrets?.Copy() || list()
		if(length(retrieved_secrets[secret_cat]))
			available_secrets -= retrieved_secrets[secret_cat]
			// If we have no available secrets after pruning, kill the retrieved list and start over.
			if(!length(available_secrets))
				available_secrets = cat_secrets
				retrieved_secrets -= secret_cat
		. = pick(available_secrets)

	// If we're returning a secret, mark it as retrieved for next time.
	if(.)
		LAZYDISTINCTADD(retrieved_secrets[secret_cat], .)
	. = validate_secret(secret_cat, ., expected_path, "category")

/datum/controller/subsystem/secrets/proc/retrieve_secrets_by_category(var/secret_cat)
	. = secrets_by_category[trim(lowertext(sanitize(secret_cat)))]

/datum/controller/subsystem/secrets/proc/retrieve_secret(var/secret_key, var/expected_path)
	secret_key = trim(lowertext(sanitize(secret_key)))
	. = validate_secret(secret_key, secrets_by_key[secret_key], expected_path)

/datum/controller/subsystem/secrets/proc/validate_secret(var/secret_key, var/datum/secret, var/expected_path, var/key_string = "key")
	if(isnull(secret))
		PRINT_STACK_TRACE("Could not find a loaded secret for secret [key_string] [secret_key]!")
	else if(!istype(secret))
		PRINT_STACK_TRACE("Non-datum/invalid secret loaded for secret [key_string] [secret_key]!")
	else if(expected_path && !istype(secret, expected_path))
		PRINT_STACK_TRACE("Secret for [key_string] [secret_key] was expected to be type [expected_path], instead was [secret.type].")
	return secret

// Simple proc for caching/retrieving files, generally icons, for secrets.
/datum/controller/subsystem/secrets/proc/get_file(var/file_location)
	if(!file_cache[file_location])
		try
			file_cache[file_location] = file(file_location)
		catch(var/exception/e)
			error("SSsecrets get_file caught exception: [EXCEPTION_TEXT(e)]")
	return file_cache[file_location]
