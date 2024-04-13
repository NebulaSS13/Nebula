//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/proc/NewStutter(phrase,stunned)
	phrase = html_decode(phrase)

	var/list/split_phrase = splittext(phrase," ") //Split it up into words.

	var/list/unstuttered_words = split_phrase.Copy()
	var/i = rand(1,3)
	if(stunned) i = split_phrase.len
	for(,i > 0,i--) //Pick a few words to stutter on.

		if (!unstuttered_words.len)
			break
		var/word = pick(unstuttered_words)
		unstuttered_words -= word //Remove from unstuttered words so we don't stutter it again.
		var/index = split_phrase.Find(word) //Find the word in the split phrase so we can replace it.

		//Search for dipthongs (two letters that make one sound.)
		var/first_sound = copytext_char(word,1,3)
		var/first_letter = copytext_char(word,1,2)
		if(lowertext(first_sound) in list("ch","th","sh"))
			first_letter = first_sound

		//Repeat the first letter to create a stutter.
		var/rnum = rand(1,3)
		switch(rnum)
			if(1)
				word = "[first_letter]-[word]"
			if(2)
				word = "[first_letter]-[first_letter]-[word]"
			if(3)
				word = "[first_letter]-[word]"

		split_phrase[index] = word

	return sanitize(jointext(split_phrase," "))

/*
RadioChat Filter.
args:
message - returns a distorted version of this
distortion_chance - the chance of a filter being applied to each character.
distortion_speed - multiplier for the chance increase.
distortion - starting distortion.
english_only - whether to use traditional english letters only (for use in NanoUI)
*/
/proc/RadioChat(mob/living/user, message, distortion_chance = 60, distortion_speed = 1, distortion = 1, english_only = 0)
	var/decl/language/language = user?.get_default_language()
	message = html_decode(message)
	var/new_message = ""
	var/input_size = length(message)
	var/cursor_position = 0
	if(input_size < 20) // Short messages get distorted too. Bit hacksy.
		distortion += (20-input_size)/2
	while(cursor_position <= input_size)
		var/newletter=copytext_char(message, cursor_position, cursor_position+1)
		if(!prob(distortion_chance))
			new_message += newletter
			cursor_position += 1
			continue
		if(newletter != " ")
			if(prob(0.08 * distortion)) // Major cutout
				newletter = "*zzzt*"
				cursor_position += rand(1, (length(message) - cursor_position)) // Skip some characters
				distortion += 1 * distortion_speed
			else if(prob(0.8 * distortion)) // Minor cut out
				if(prob(25))
					newletter = ".."
				else if(prob(25))
					newletter = " "
				else
					newletter = ""
				distortion += 0.25 * distortion_speed
			else if(prob(2 * distortion)) // Mishearing
				if(language && language.syllables && prob(50))
					newletter = pick(language.syllables)
				else
					newletter =	pick("a","e","i","o","u")
				distortion += 0.25 * distortion_speed
			else if(prob(1.5 * distortion)) // Mishearing
				if(language && prob(50))
					if(language.syllables)
						newletter = pick (language.syllables)
					else
						newletter = "*"
				else
					if(english_only)
						newletter += "*"
					else
						newletter = pick("ø", "Ð", "%", "æ", "µ")
				distortion += 0.5 * distortion_speed
			else if(prob(0.75 * distortion)) // Incomprehensible
				newletter = pick("<", ">", "!", "$", "%", "^", "&", "*", "~", "#")
				distortion += 0.75 * distortion_speed
			else if(prob(0.05 * distortion)) // Total cut out
				if(!english_only)
					newletter = "¦w¡¼b»%> -BZZT-"
				else
					newletter = "srgt%$hjc< -BZZT-"
				new_message += newletter
				break
			else if(prob(2.5 * distortion)) // Sound distortion. Still recognisable, mostly.
				switch(lowertext(newletter))
					if("s")
						newletter = "$"
					if("e")
						newletter = "£"
					if("w")
						newletter = "ø"
					if("y")
						newletter = "¡"
					if("x")
						newletter = "æ"
					if("u")
						newletter = "µ"
		else
			if(prob(0.2 * distortion))
				newletter = " *crackle* "
				distortion += 0.25 * distortion_speed
		if(prob(20))
			capitalize(newletter)
		new_message += newletter
		cursor_position += 1
	return new_message
