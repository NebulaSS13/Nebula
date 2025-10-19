/proc/issmall(A)
	if(isliving(A))
		var/mob/living/L = A
		return L.mob_size <= MOB_SIZE_SMALL
	return 0

//returns the number of size categories between two mob_sizes, rounded. Positive means A is larger than B
/proc/mob_size_difference(var/mob_size_A, var/mob_size_B)
	return round(log(2, mob_size_A/mob_size_B), 1)

/mob/proc/isMonkey()
	return 0

/mob/living/human/isMonkey()
	return istype(species, /decl/species/monkey)


/**
 * Checks if the target has a grab from the user
 */
/mob/proc/has_danger_grab(mob/user)
	if (user == src || isrobot(user) || isbot(user))
		return TRUE
	for (var/obj/item/grab/grab as anything in grabbed_by)
		if (grab.force_danger())
			return TRUE

/proc/isdeaf(A)
	if(isliving(A))
		var/mob/living/M = A
		return M.has_genetic_condition(GENE_COND_DEAFENED) || GET_STATUS(M, STAT_DEAF)
	return 0

/proc/iscuffed(var/mob/mob)
	return ismob(mob) && !!mob.get_equipped_item(slot_handcuffed_str)

/proc/hassensorlevel(A, var/level)
	return getsensorlevel(A) >= level

/proc/getsensorlevel(A)
	var/mob/M = A
	if(!istype(M))
		return VITALS_SENSOR_OFF
	var/obj/item/clothing/sensor/vitals/sensor = M.get_vitals_sensor()
	if(sensor)
		return sensor.sensor_mode
	return VITALS_SENSOR_OFF

/proc/is_admin(var/mob/user)
	return check_rights(R_ADMIN, 0, user) != 0

/*
	Miss Chance
*/

//TODO: Integrate defence zones and targeting body parts with the actual organ system, move these into organ definitions.

//The base miss chance for the different defence zones
var/global/list/global/base_miss_chance = list(
	BP_HEAD = 70,
	BP_CHEST = 10,
	BP_GROIN = 20,
	BP_L_LEG = 60,
	BP_R_LEG = 60,
	BP_L_ARM = 30,
	BP_R_ARM = 30,
	BP_L_HAND = 50,
	BP_R_HAND = 50,
	BP_L_FOOT = 70,
	BP_R_FOOT = 70,
)

//Used to weight organs when an organ is hit randomly (i.e. not a directed, aimed attack).
//Also used to weight the protection value that armour provides for covering that body part when calculating protection from full-body effects.
var/global/list/global/organ_rel_size = list(
	BP_HEAD = 25,
	BP_CHEST = 70,
	BP_GROIN = 30,
	BP_L_LEG = 25,
	BP_R_LEG = 25,
	BP_L_ARM = 25,
	BP_R_ARM = 25,
	BP_L_HAND = 10,
	BP_R_HAND = 10,
	BP_L_FOOT = 10,
	BP_R_FOOT = 10,
)

/proc/check_zone(zone, mob/target, var/base_zone_only)
	. = zone || BP_CHEST
	if(. == BP_EYES || . == BP_MOUTH)
		. = BP_HEAD
	if(!base_zone_only && target)
		. = target.get_bodytype()?.get_limb_from_zone(.) || .

// Returns zone with a certain probability. If the probability fails, or no zone is specified, then a random body part is chosen.
// Do not use this if someone is intentionally trying to hit a specific body part.
// Use get_zone_with_miss_chance() for that.
/proc/ran_zone(zone, probability, target)
	if(zone)
		zone = check_zone(zone, target)
		if(prob(probability))
			return zone
	var/ran_zone = zone
	while (ran_zone == zone)
		ran_zone = pickweight(organ_rel_size)
	return ran_zone

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, var/mob/target, var/miss_chance_mod = 0, var/ranged_attack=0)
	zone = check_zone(zone, target)

	if(!ranged_attack)
		// target isn't trying to fight
		if(target.check_intent(I_FLAG_HELP))
			return zone
		// you cannot miss if your target is prone or restrained
		if(target.buckled || target.current_posture.prone)
			return zone
		// if your target is being grabbed aggressively by someone you cannot miss either
		for(var/obj/item/grab/grab as anything in target.grabbed_by)
			if(grab.stop_move())
				return zone

	var/miss_chance = 10
	var/scatter_chance
	if (zone in base_miss_chance)
		miss_chance = base_miss_chance[zone]
	miss_chance = max(miss_chance + miss_chance_mod, 0)
	scatter_chance = min(95, miss_chance + 60)
	if(prob(miss_chance))
		if(ranged_attack && prob(scatter_chance))
			return null
		else if(prob(70))
			return null
		return (ran_zone())
	return zone

//Replaces some of the characters with *, used in whispers. pr = probability of no star.
//Will try to preserve HTML formatting. re_encode controls whether the returned text is HTML encoded outside tags.
/proc/stars(n, pr = 25, re_encode = 1)
	if (pr < 0)
		return null
	else if (pr >= 100)
		return n

	var/intag = 0
	var/block = list()
	. = list()
	for(var/i = 1, i <= length_char(n), i++)
		var/char = copytext_char(n, i, i+1)
		if(!intag && (char == "<"))
			intag = 1
			. += stars_no_html(JOINTEXT(block), pr, re_encode) //stars added here
			block = list()
		block += char
		if(intag && (char == ">"))
			intag = 0
			. += block //We don't mess up html tags with stars
			block = list()
	. += (intag ? block : stars_no_html(JOINTEXT(block), pr, re_encode))
	. = JOINTEXT(.)

//Ingnores the possibility of breaking tags.
/proc/stars_no_html(text, pr, re_encode)
	text = html_decode(text) //We don't want to screw up escaped characters
	. = list()
	for(var/i = 1, i <= length_char(text), i++)
		var/char = copytext_char(text, i, i+1)
		if(char == " " || prob(pr))
			. += char
		else
			. += "*"
	. = JOINTEXT(.)
	if(re_encode)
		. = html_encode(.)

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length_char(phrase)
	var/counter=length_char(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext_char(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,15))
			if(1 to 4)	newletter="[lowertext(newletter)]"
			if(5 to 8)	newletter="[uppertext(newletter)]"
			if(9)	newletter+="'"
			else	newletter = newletter
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i in 1 to length_char(t))

		var/letter = copytext_char(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j in 1 to rand(0, 2))
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext

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

#define TICKS_PER_RECOIL_ANIM 2
#define PIXELS_PER_STRENGTH_VAL 16

/proc/shake_camera(mob/M, duration, strength=1)
	var/current_time = world.time
	if(!M || !M.client || (M.shakecamera > current_time)|| M.stat || isEye(M) || isAI(M))
		return
	M.shakecamera = current_time + max(TICKS_PER_RECOIL_ANIM, duration)
	strength = abs(strength)*PIXELS_PER_STRENGTH_VAL
	var/steps = min(1, floor(duration/TICKS_PER_RECOIL_ANIM))-1
	animate(M.client, pixel_x = rand(-(strength), strength), pixel_y = rand(-(strength), strength), time = TICKS_PER_RECOIL_ANIM, easing = JUMP_EASING|EASE_IN)
	if(steps)
		for(var/i = 1 to steps)
			animate(pixel_x = (M.client?.default_pixel_x || 0) + rand(-(strength), strength), pixel_y = (M.client?.default_pixel_y || 0) + rand(-(strength), strength), time = TICKS_PER_RECOIL_ANIM, easing = JUMP_EASING|EASE_IN)
	animate(pixel_x = (M.client.default_pixel_x || 0), pixel_y = (M.client.default_pixel_y || 0), time = TICKS_PER_RECOIL_ANIM)

#undef TICKS_PER_RECOIL_ANIM
#undef PIXELS_PER_STRENGTH_VAL

/mob/proc/abiotic(var/full_body = FALSE)
	. = FALSE
	for(var/obj/item/thing in get_held_items())
		if(thing.simulated)
			return TRUE
	if(full_body && (get_equipped_item(slot_back_str) || get_equipped_item(slot_wear_mask_str)))
		return TRUE

/mob/proc/welding_eyecheck()
	return

/proc/broadcast_security_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, global.sec_hud_users, /obj/item/clothing/glasses/hud/security)

/proc/broadcast_medical_hud_message(var/message, var/broadcast_source)
	broadcast_hud_message(message, broadcast_source, global.med_hud_users, /obj/item/clothing/glasses/hud/health)

/proc/broadcast_hud_message(var/message, var/broadcast_source, var/list/targets, var/icon)
	var/turf/sourceturf = get_turf(broadcast_source)
	for(var/mob/M in targets)
		if(!sourceturf || (get_z(M) in SSmapping.get_connected_levels(sourceturf.z)))
			M.show_message("<span class='info'>[html_icon(icon)] [message]</span>", 1)

/proc/mobs_in_area(var/area/A)
	var/list/mobs = new
	for(var/mob/living/M in SSmobs.mob_list)
		if(get_area(M) == A)
			mobs += M
	return mobs

//Announces that a ghost has joined/left, mainly for use with wizards
/proc/announce_ghost_joinleave(O, var/joined_ghosts = 1, var/message = "")
	var/client/C
	//Accept any type, sort what we want here
	if(ismob(O))
		var/mob/M = O
		if(M.client)
			C = M.client
	else if(istype(O, /client))
		C = O
	else if(istype(O, /datum/mind))
		var/datum/mind/M = O
		if(M.current && M.current.client)
			C = M.current.client

	if(C)
		if(C.get_preference_value(/datum/client_preference/anon_say) == PREF_YES)
			return
		var/name
		if(C.mob)
			var/mob/M = C.mob
			if(M.mind && M.mind.name)
				name = M.mind.name
			if(M.real_name && M.real_name != name)
				if(name)
					name += " ([M.real_name])"
				else
					name = M.real_name
		if(!name)
			name = C.key
		var/diedat = ""
		if(C.mob.lastarea)
			diedat = " at [C.mob.lastarea]"
		if(joined_ghosts)
			message = "The ghost of <span class='name'>[name]</span> now [pick("skulks","lurks","prowls","creeps","stalks")] among the dead[diedat]. [message]"
		else
			message = "<span class='name'>[name]</span> no longer [pick("skulks","lurks","prowls","creeps","stalks")] in the realm of the dead. [message]"
		communicate(/decl/communication_channel/dsay, C || O, message, /decl/dsay_communication/direct)

/mob/proc/switch_to_camera(var/obj/machinery/camera/C)
	if (!C.can_use() || stat || (get_dist(C, src) > 1 || machine != src || is_blind()))
		return 0
	check_eye(src)
	return 1

/mob/living/silicon/ai/switch_to_camera(var/obj/machinery/camera/C)
	if(!C.can_use() || !is_in_chassis())
		return 0

	eyeobj.setLoc(C)
	return 1

// Returns true if the mob has a client which has been active in the last given X minutes.
/mob/proc/is_client_active(var/active = 1)
	return client && client.inactivity < active MINUTES

#define SAFE_PERP -50
/mob/living/proc/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest, var/check_network)

	if(stat == DEAD)
		return SAFE_PERP
	if(get_equipped_item(slot_handcuffed_str))
		return SAFE_PERP

	//Agent cards lower threatlevel.
	var/threatcount = 0
	var/obj/item/card/id/id = GetIdCard()

	// A proper	CentCom id is hard currency.
	if(istype(id, /obj/item/card/id/centcom))
		return SAFE_PERP

	// Syndicate IDs have masking I guess.
	if(istype(id, /obj/item/card/id/syndicate))
		threatcount -= 2

	if(check_access && !access_obj.allowed(src))
		threatcount += 4

	if(auth_weapons && !access_obj.allowed(src))
		for(var/thing in get_held_items())
			if(istype(thing, /obj/item/gun) || istype(thing, /obj/item/energy_blade) || istype(thing, /obj/item/baton))
				threatcount += 4

		var/obj/item/belt = get_equipped_item(slot_belt_str)
		if(istype(belt, /obj/item/gun) || istype(belt, /obj/item/energy_blade) || istype(belt, /obj/item/baton))
			threatcount += 2

		if(get_species()?.uid != global.using_map.default_species)
			threatcount += 2

	if(check_records || check_arrest)
		var/perpname = name
		if(id)
			perpname = id.registered_name

		var/datum/computer_file/report/crew_record/CR
		if(check_network)
			var/datum/extension/network_device/obj_device = get_extension(access_obj, /datum/extension/network_device)
			var/datum/computer_network/obj_network = obj_device?.get_network(NET_FEATURE_SECURITY)
			CR = obj_network?.get_crew_record_by_name(perpname)
		else
			CR = get_crewmember_record(perpname)

		if(check_records && !CR && !isMonkey())
			threatcount += 4

		if(check_arrest && CR && (CR.get_criminalStatus() == global.arrest_security_status))
			threatcount += 4

	return threatcount

/mob/living/simple_animal/hostile/assess_perp(var/obj/access_obj, var/check_access, var/auth_weapons, var/check_records, var/check_arrest, var/check_network)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	if(!istype(src, /mob/living/simple_animal/hostile/goat))
		threatcount += 4
	return threatcount

#undef SAFE_PERP

/mob/proc/get_multitool(var/obj/item/multitool/P)
	if(istype(P))
		return P

/mob/observer/ghost/get_multitool()
	return can_admin_interact() && ..(ghost_multitool)

/mob/living/human/get_multitool()
	return ..(get_active_held_item())

/mob/living/silicon/robot/get_multitool()
	return ..(get_active_held_item())

/mob/living/silicon/ai/get_multitool()
	return ..(aiMulti)

/mob/proc/refresh_client_images()
	if(client && LAZYLEN(client_images))
		client.images |= client_images

/mob/proc/hide_client_images()
	if(client && LAZYLEN(client_images))
		client.images -= client_images

/mob/proc/add_client_image(var/image)
	if(image in client_images)
		return
	LAZYADD(client_images, image)
	if(client)
		client.images += image

/mob/proc/remove_client_image(var/image)
	LAZYREMOVE(client_images, image)
	if(client)
		client.images -= image

/mob/proc/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	for(var/mob/M in contents)
		M.flash_eyes(intensity, override_blindness_check, affect_silicon, visual, type)

/mob/proc/fully_replace_character_name(var/new_name, var/in_depth = TRUE)
	if(!new_name || new_name == real_name)	return 0
	real_name = new_name
	SetName(new_name)
	if(mind)
		mind.name = new_name
	return 1

/mob/proc/ssd_check()
	return !client && !teleop && (last_ckey || !ai)

/mob/proc/try_teleport(var/area/thearea)
	if(istype(thearea, /list))
		var/list/area_list = thearea
		thearea = area_list[1]
	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea))
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(buckled)
		buckled = null

	var/attempt = null
	var/success = 0
	var/turf/end
	var/candidates = L.Copy()
	while(L.len)
		attempt = pick(L)
		success = Move(attempt)
		if(!success)
			L.Remove(attempt)
		else
			end = attempt
			break

	if(!success)
		end = pick(candidates)
		forceMove(end)

	return end

//Tries to find the mob's email.
/proc/find_email(real_name)
	for(var/mob/mob in global.living_mob_list_)
		if(mob.real_name == real_name)
			if(!mob.mind)
				return
			return mob.mind.initial_account_login["login"] + "@[mob.mind.account_network]"

//This gets an input while also checking a mob for whether it is incapacitated or not.
/mob/proc/get_input(var/message, var/title, var/default, var/choice_type, var/obj/required_item)
	if(src.incapacitated() || (required_item && !global.hands_topic_state.can_use_topic(required_item,src)))
		return null
	var/choice
	if(islist(choice_type))
		choice = input(src, message, title, default) as null|anything in choice_type
	else
		switch(choice_type)
			if(MOB_INPUT_TEXT)
				choice = input(src, message, title, default) as null|text
			if(MOB_INPUT_NUM)
				choice = input(src, message, title, default) as null|num
			if(MOB_INPUT_MESSAGE)
				choice = input(src, message, title, default) as null|message
	if(isnull(choice) || src.incapacitated() || (required_item && !global.hands_topic_state.can_use_topic(required_item,src)))
		return null
	return choice

/mob/proc/get_accumulated_vision_handlers()
	var/result[2]
	var/asight = 0
	var/ainvis = 0
	for(var/atom/vision_handler in additional_vision_handlers)
		//Grab their flags
		asight |= vision_handler.additional_sight_flags()
		ainvis = max(ainvis, vision_handler.additional_see_invisible())
	result[1] = asight
	result[2] = ainvis

	return result

/mob/proc/get_admin_job_string()
	return "Unknown ([type])"

/mob/proc/get_visual_colour_substitutions()
	. = list()
	for(var/thing in client_colors)
		var/datum/client_color/col = thing
		for(var/col_name in col.wire_colour_substitutions)
			.[col_name] = col.wire_colour_substitutions[col_name]

/**
 * Tries to find a readily accessible pen in the user's held items, and in some of its inventory slots.
 * Shouldn't search recursively.
 */
/mob/proc/get_accessible_pen()
	//We might save a few loop iterations by just looking in the active hand first
	var/obj/item/I = get_active_held_item()
	if(IS_PEN(I))
		return I
	//Look if we're holding a pen elsewhere
	for(I in get_held_items())
		if(IS_PEN(I))
			return I
	//Try looking if we got a rig module with integrated pen
	var/obj/item/rig/rig = get_rig()
	if(rig && !rig.offline)
		var/pen = locate(/obj/item/rig_module/device/pen) in rig.installed_modules
		if(pen)
			return pen
	//Look for other slots
	var/static/list/PEN_CHECK_SLOTS = list(slot_l_ear_str, slot_r_ear_str, slot_l_store_str, slot_r_store_str, slot_s_store_str)
	for(var/slot in PEN_CHECK_SLOTS)
		I = get_equipped_item(slot)
		if(IS_PEN(I))
			return I
