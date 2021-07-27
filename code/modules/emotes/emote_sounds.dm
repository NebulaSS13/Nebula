/*
* Declare for storing species and gender specific emote sounds and make them overridable between species. 
* Also the soundlist is loaded from a json array that sorts lists of sounds by emote name and optionally gender.
*/

//Mainly used for debugging and verifying everything loaded properly
var/global/list/decl/emote_sounds/all_emote_decl = list()

//merging proc for the merge assoc list proc
/proc/merge_replace_if_not_null(var/a, var/b)
	return b? b : a

//A set of sounds for a set of emotes
/decl/emote_sounds
	var/list/soundbank = list() // 2d array, first is emote_name, second level contains sounds list by gender, or just a soundlist if there's no need for gender

/decl/emote_sounds/New()
	..()
	init_soundlist()
	all_emote_decl += src

/decl/emote_sounds/Destroy()
	all_emote_decl -= src
	. = ..()

/decl/emote_sounds/proc/init_soundlist()
	load_sound_config(sound_config_paths())

//Override and pass the soundlist when calling the parent version to add the file to the list of files to parse
/decl/emote_sounds/proc/sound_config_paths(var/list/paths_list = list())
	paths_list |= "[EMOTE_SOUNDS_CONFIG_PATH]/default.json"
	return reverselist(paths_list) //Reverse the list so we properly have the earliest implementation first, and the latest last

/decl/emote_sounds/proc/load_sound_config(var/list/paths)
	for(var/path in paths)
		var/file_contents = file2text(path)
		if(!file_contents)
			log_error("Missing sound config file for path [path]!")
		var/list/parsed =  json_decode(file_contents)
		if(!istype(parsed))
			log_error("Couldn't parse sound config file for path [path]!")
		soundbank = merge_assoc_lists(soundbank, parsed, /proc/merge_replace_if_not_null)
		log_debug("Loaded sound config from path [path]!")

//Returns a list of sounds for the given parameters
/decl/emote_sounds/proc/get_sound(var/emote_name, var/gender)
	var/emote_sounds = soundbank[emote_name]
	if(islist(emote_sounds))
		if(emote_sounds[gender]) //check if the gender is in the list at all
			return emote_sounds[gender]
	//Otherwise its just a list of sounds not sorted by genders
	return emote_sounds
