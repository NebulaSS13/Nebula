/****************
 true human verbs
****************/
/mob/living/carbon/human/verb/sniff_verb()
	set name = "Sniff"
	set desc = "Smell the local area."
	set category = "IC"
	set src = usr
	if(!incapacitated())
		if(species.sniff_message_3p && species.sniff_message_1p)
			visible_message(SPAN_NOTICE("\The [src] [species.sniff_message_3p]."), SPAN_NOTICE(species.sniff_message_1p))
		LAZYCLEARLIST(smell_cooldown)

/mob/living/carbon/human/proc/tie_hair()
	set name = "Tie Hair"
	set desc = "Style your hair."
	set category = "IC"

	if(incapacitated())
		to_chat(src, "<span class='warning'>You can't mess with your hair right now!</span>")
		return

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = global.hair_styles_list[h_style]
		var/selected_string
		if(!(hair_style.flags & HAIR_TIEABLE))
			to_chat(src, "<span class ='warning'>Your hair isn't long enough to tie.</span>")
			return
		else
			var/list/datum/sprite_accessory/hair/valid_hairstyles = list()
			for(var/hair_string in global.hair_styles_list)
				var/datum/sprite_accessory/hair/test = global.hair_styles_list[hair_string]
				if(test.flags & HAIR_TIEABLE)
					valid_hairstyles.Add(hair_string)
			selected_string = input("Select a new hairstyle", "Your hairstyle", hair_style) as null|anything in valid_hairstyles
		if(incapacitated())
			to_chat(src, "<span class='warning'>You can't mess with your hair right now!</span>")
			return
		else if(selected_string && h_style != selected_string)
			h_style = selected_string
			refresh_visible_overlays()
			visible_message("<span class='notice'>[src] pauses a moment to style their hair.</span>")
		else
			to_chat(src, "<span class ='notice'>You're already using that style.</span>")

/****************
 misc alien verbs
****************/
/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(isghost(M) || M.stat == DEAD)
		to_chat(src, "<span class='warning'>Not even a [src.species.name] can speak to the dead.</span>")
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	to_chat(M, "<span class='notice'>Like lead slabs crashing into the ocean, alien thoughts drop into your mind: <i>[text]</i></span>")
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		if(prob(75))
			to_chat(H, "<span class='warning'>Your nose begins to bleed...</span>")
			H.drip(1)

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		to_chat(M, "<span class='alium'>You hear a strange, alien voice in your head... <i>[msg]</i></span>")
		to_chat(src, "<span class='alium'>You channel a message: \"[msg]\" to [M]</span>")
	return

/mob/living/carbon/human/proc/change_colour()
	set category = "Abilities"
	set name = "Change Colour"
	set desc = "Choose the colour of your skin."

	var/new_skin = input(usr, "Choose your new skin colour: ", "Change Colour", skin_colour) as color|null
	change_skin_color(new_skin)
