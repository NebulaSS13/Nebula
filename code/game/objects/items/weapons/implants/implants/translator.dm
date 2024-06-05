//Implant that lets you learn languages by hearing them
/obj/item/implant/translator
	name = "babel implant"
	desc = "A small implant with a microphone on it."
	icon_state = "implant_evil"
	origin_tech = @'{"materials":1,"biotech":2,"esoteric":3}'
	hidden = 1
	var/list/languages = list()
	var/learning_threshold = 20 //need to hear language spoken this many times to learn it
	var/max_languages = 5

/obj/item/implant/translator/get_data()
	return "WARNING: No match found in the database."

/obj/item/implant/translator/Initialize()
	. = ..()
	global.listening_objects += src

/obj/item/implant/translator/hear_talk(mob/M, msg, verb, decl/language/speaking)
	if(!imp_in)
		return
	if(length(languages) == max_languages)
		return
	if(!languages[speaking.name])
		languages[speaking.name] = 1
	languages[speaking.name] = languages[speaking.name] + 1
	if(!imp_in.say_understands(M, speaking) && languages[speaking.name] > learning_threshold)
		to_chat(imp_in, SPAN_NOTICE("You feel like you can understand [speaking.name] now..."))
		imp_in.add_language(speaking.type)

/obj/item/implant/translator/implanted(mob/target)
	return TRUE

/obj/item/implant/translator/Destroy()
	removed()
	return ..()

/obj/item/implanter/translator
	name = "babel implanter"
	imp = /obj/item/implant/translator

/obj/item/implant/translator/natural
	name = "lingophagic node"
	desc = "A chunk of what could be discolored crystalized brain matter. It seems to pulse occasionally."
	icon_state = "implant_melted"
	origin_tech = @'{"biotech":5}'
	learning_threshold = 10
	max_languages = 3