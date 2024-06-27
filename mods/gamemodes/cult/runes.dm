/obj/effect/rune
	name = "rune"
	desc = "A strange collection of symbols drawn in blood."
	anchored = TRUE
	icon = 'icons/effects/uristrunes.dmi'
	icon_state = "blank"
	layer = RUNE_LAYER

	var/blood
	var/bcolor
	var/strokes = 2 // IF YOU EVER SET THIS TO MORE THAN TEN, EVERYTHING WILL BREAK
	var/cultname = ""

/obj/effect/rune/Initialize(mapload, var/blcolor = "#c80000", var/nblood = "blood")
	. = ..()
	bcolor = blcolor
	blood = nblood
	update_icon()
	set_extension(src, /datum/extension/turf_hand, 10)

/obj/effect/rune/on_update_icon()
	overlays.Cut()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	if(cult.rune_strokes[type])
		var/list/f = cult.rune_strokes[type]
		for(var/i in f)
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[i]")
			overlays += t
	else
		var/list/q = list(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
		var/list/f = list()
		for(var/i = 1 to strokes)
			var/j = pick(q)
			f += j
			q -= f
			var/image/t = image('icons/effects/uristrunes.dmi', "rune-[j]")
			overlays += t
		cult.rune_strokes[type] = f.Copy()
	color = bcolor
	desc = "A strange collection of symbols drawn in [blood]."

/obj/effect/rune/examine(mob/user)
	. = ..()
	if(iscultist(user))
		to_chat(user, "This is \a [cultname] rune.")

/obj/effect/rune/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/book/tome) && iscultist(user))
		user.visible_message(SPAN_NOTICE("[user] rubs \the [src] with \the [I], and \the [src] is absorbed by it."), "You retrace your steps, carefully undoing the lines of \the [src].")
		qdel(src)
		return
	else if(istype(I, /obj/item/nullrod))
		user.visible_message(SPAN_NOTICE("[user] hits \the [src] with \the [I], and it disappears, fizzling."), SPAN_NOTICE("You disrupt the vile magic with the deadening field of \the [I]."), "You hear a fizzle.")
		qdel(src)
		return

/obj/effect/rune/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(!iscultist(user))
		to_chat(user, "You can't mouth the arcane scratchings without fumbling over them.")
		return TRUE
	if(user.is_silenced())
		to_chat(user, "You are unable to speak the words of the rune.")
		return TRUE
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	if(cult.powerless)
		to_chat(user, "You read the words, but nothing happens.")
		fizzle(user)
		return TRUE
	cast(user)
	return TRUE

/obj/effect/rune/attack_ai(var/mob/user) // Cult borgs!
	return attack_hand_with_interaction_checks(user)

/obj/effect/rune/proc/cast(var/mob/living/user)
	fizzle(user)

/obj/effect/rune/proc/get_cultists()
	. = list()
	for(var/mob/living/M in range(1))
		if(iscultist(M))
			. += M

/obj/effect/rune/proc/fizzle(var/mob/living/user)
	visible_message(SPAN_WARNING("The markings pulse with a small burst of light, then fall dark."), "You hear a fizzle.")

//Makes the speech a proc so all verbal components can be easily manipulated as a whole, or individually easily
/obj/effect/rune/proc/speak_incantation(var/mob/living/user, var/incantation)
	var/decl/language/L = GET_DECL(/decl/language/cultcommon)
	if(istype(L) && incantation && (L in user.languages))
		user.say(incantation, L)

/obj/effect/rune/get_surgery_success_modifier(delicate)
	return delicate ? -10 : 0

/obj/effect/rune/get_surgery_surface_quality(mob/living/victim, mob/living/user)
	return OPERATE_PASSABLE

/turf/remove_cleanables()
	for(var/obj/effect/rune/rune in src)
		qdel(rune)

/* Tier 1 runes below */

/obj/effect/rune/convert
	cultname = "convert"
	var/spamcheck = 0

/obj/effect/rune/convert/cast(var/mob/living/user)
	if(spamcheck)
		return

	var/mob/living/target = null
	for(var/mob/living/M in get_turf(src))
		if(!iscultist(M) && M.stat != DEAD)
			target = M
			break

	if(!target)
		return fizzle(user)

	speak_incantation(user, "Mah[pick("'","`")]weyh pleggh at e'ntrath!")
	target.visible_message(SPAN_WARNING("The markings below [target] glow a bloody red."))

	to_chat(target, SPAN_OCCULT("Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root."))
	var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
	if(!cult.can_become_antag(target.mind, 1))
		to_chat(target, SPAN_DANGER("Are you going insane?"))
	else
		to_chat(target, SPAN_OCCULT("Do you want to join the cult of Nar'Sie? You can choose to ignore offer... <a href='byond://?src=\ref[src];join=1'>Join the cult</a>."))

	spamcheck = 1
	spawn(40)
		spamcheck = 0
		if(!iscultist(target) && target.loc == get_turf(src)) // They hesitated, resisted, or can't join, and they are still on the rune - burn them
			if(target.stat == CONSCIOUS)
				target.take_overall_damage(0, 10)
				switch(target.get_damage(BURN))
					if(0 to 25)
						to_chat(target, SPAN_DANGER("Your blood boils as you force yourself to resist the corruption invading every corner of your mind."))
					if(25 to 45)
						to_chat(target, SPAN_DANGER("Your blood boils and your body burns as the corruption further forces itself into your body and mind."))
						target.take_overall_damage(0, 3)
					if(45 to 75)
						to_chat(target, SPAN_DANGER("You begin to hallucinate images of a dark and incomprehensible being and your entire body feels like its engulfed in flame as your mental defenses crumble."))
						target.take_overall_damage(0, 5)
					if(75 to 100)
						to_chat(target, SPAN_OCCULT("Your mind turns to ash as the burning flames engulf your very soul and images of an unspeakable horror begin to bombard the last remnants of mental resistance."))
						target.take_overall_damage(0, 10)

/obj/effect/rune/convert/Topic(href, href_list)
	if(href_list["join"] && usr.loc == loc && !iscultist(usr))
		var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
		cult.add_antagonist(usr.mind, ignore_role = 1, do_not_equip = 1)

/obj/effect/rune/teleport
	cultname = "teleport"
	var/destination

/obj/effect/rune/teleport/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(!A)
		return INITIALIZE_HINT_QDEL
	destination = A.proper_name
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.teleport_runes += src

/obj/effect/rune/teleport/Destroy()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.teleport_runes -= src
	var/turf/T = get_turf(src)
	if(T)
		for(var/atom/movable/A in contents)
			A.forceMove(T)
	return ..()

/obj/effect/rune/teleport/examine(mob/user)
	. = ..()
	if(iscultist(user))
		to_chat(user, "Its name is [destination].")

/obj/effect/rune/teleport/cast(var/mob/living/user)
	if(user.loc == src)
		showOptions(user)
	else if(user.loc == get_turf(src))
		speak_incantation(user, "Sas[pick("'","`")]so c'arta forbici!")
		if(do_after(user, 30))
			user.visible_message(SPAN_WARNING("\The [user] disappears in a flash of red light!"), SPAN_WARNING("You feel as your body gets dragged into the dimension of Nar-Sie!"), "You hear a sickening crunch.")
			user.forceMove(src)
			showOptions(user)
			var/warning = 0
			while(user.loc == src)
				user.take_organ_damage(0, 2)
				if(user.get_damage(BURN) > 50)
					to_chat(user, SPAN_DANGER("Your body can't handle the heat anymore!"))
					leaveRune(user)
					return
				if(warning == 0)
					to_chat(user, SPAN_WARNING("You feel the immerse heat of the realm of Nar-Sie..."))
					++warning
				if(warning == 1 && user.get_damage(BURN) > 15)
					to_chat(user, SPAN_WARNING("Your burns are getting worse. You should return to your realm soon..."))
					++warning
				if(warning == 2 && user.get_damage(BURN) > 35)
					to_chat(user, SPAN_WARNING("The heat! It burns!"))
					++warning
				sleep(10)
	else
		var/input = input(user, "Choose a new rune name.", "Destination", "") as text|null
		if(!input)
			return
		destination = sanitize(input)

/obj/effect/rune/teleport/Topic(href, href_list)
	if(usr.loc != src)
		return
	if(href_list["target"])
		var/obj/effect/rune/teleport/targ = locate(href_list["target"])
		if(istype(targ)) // Checks for null, too
			usr.forceMove(targ)
			targ.showOptions(usr)
	else if(href_list["leave"])
		leaveRune(usr)

/obj/effect/rune/teleport/proc/showOptions(var/mob/living/user)
	var/list/t = list()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	for(var/obj/effect/rune/teleport/T in cult.teleport_runes)
		if(T == src)
			continue
		t += "<a href='byond://?src=\ref[src];target=\ref[T]'>[T.destination]</a>"
	to_chat(user, "Teleport runes: [english_list(t, nothing_text = "no other runes exist")]... or <a href='byond://?src=\ref[src];leave=1'>return from this rune</a>.")

/obj/effect/rune/teleport/proc/leaveRune(var/mob/living/user)
	if(user.loc != src)
		return
	user.dropInto(loc)
	user.visible_message(SPAN_WARNING("\The [user] appears in a flash of red light!"), SPAN_WARNING("You feel as your body gets thrown out of the dimension of Nar-Sie!"), "You hear a pop.")

/obj/effect/rune/tome
	cultname = "summon tome"

/obj/effect/rune/tome/cast(var/mob/living/user)
	new /obj/item/book/tome(get_turf(src))
	speak_incantation(user, "N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
	visible_message(SPAN_NOTICE("\The [src] disappears with a flash of red light, and in its place now a book lies."), "You hear a pop.")
	qdel(src)

/obj/effect/rune/wall
	cultname = "wall"

	var/obj/effect/cultwall/wall = null

/obj/effect/rune/wall/Destroy()
	QDEL_NULL(wall)
	return ..()

/obj/effect/rune/wall/cast(var/mob/living/user)
	var/t
	if(wall)
		var/wall_max_health = wall.get_max_health()
		if(wall.current_health >= wall_max_health)
			to_chat(user, SPAN_NOTICE("The wall doesn't need mending."))
			return
		t = wall_max_health - wall.current_health
		wall.current_health += t
	else
		wall = new /obj/effect/cultwall(get_turf(src), bcolor)
		wall.rune = src
		t = wall.current_health
	user.remove_blood(t / 50, absolute = TRUE)
	speak_incantation(user, "Khari[pick("'","`")]d! Eske'te tannin!")
	to_chat(user, SPAN_WARNING("Your blood flows into the rune, and you feel that the very space over the rune thickens."))

/obj/effect/cultwall
	name = "red mist"
	desc = "A strange red mist emanating from a rune below it."
	icon = 'icons/effects/effects.dmi'//TODO: better icon
	icon_state = "smoke"
	color = "#ff0000"
	anchored = TRUE
	density = TRUE
	max_health = 200
	var/obj/effect/rune/wall/rune

/obj/effect/cultwall/Initialize(mapload, var/bcolor)
	. = ..()
	if(bcolor)
		color = bcolor

/obj/effect/cultwall/Destroy()
	if(rune)
		rune.wall = null
		rune = null
	return ..()

/obj/effect/cultwall/examine(mob/user)
	. = ..()
	if(iscultist(user))
		var/current_max_health = get_max_health()
		if(current_health == current_max_health)
			to_chat(user, SPAN_NOTICE("It is fully intact."))
		else if(current_health > current_max_health * 0.5)
			to_chat(user, SPAN_WARNING("It is damaged."))
		else
			to_chat(user, SPAN_DANGER("It is about to dissipate."))

/obj/effect/cultwall/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(iscultist(user))
		user.visible_message(SPAN_NOTICE("\The [user] touches \the [src], and it fades."), SPAN_NOTICE("You touch \the [src], whispering the old ritual, making it disappear."))
		qdel(src)
	else
		to_chat(user, SPAN_NOTICE("You touch \the [src]. It feels wet and becomes harder the further you push your arm."))
	return TRUE

/obj/effect/cultwall/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/nullrod))
		user.visible_message(SPAN_NOTICE("\The [user] touches \the [src] with \the [I], and it disappears."), SPAN_NOTICE("You disrupt the vile magic with the deadening field of \the [I]."))
		qdel(src)
	else if(I.force)
		user.visible_message(SPAN_NOTICE("\The [user] hits \the [src] with \the [I]."), SPAN_NOTICE("You hit \the [src] with \the [I]."))
		take_damage(I.force, I.atom_damage_type)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)

/obj/effect/cultwall/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.atom_damage_type == BRUTE || Proj.atom_damage_type == BURN))
		return
	take_damage(Proj.damage, Proj.atom_damage_type)
	..()

/obj/effect/cultwall/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	current_health -= damage
	if(current_health <= 0)
		visible_message(SPAN_WARNING("\The [src] dissipates."))
		qdel(src)

/obj/effect/rune/ajorney
	cultname = "astral journey"

/obj/effect/rune/ajorney/cast(var/mob/living/user)
	var/tmpkey = user.key
	if(user.loc != get_turf(src))
		return
	speak_incantation(user, "Fwe[pick("'","`")]sh mah erl nyag r'ya!")
	var/decl/pronouns/G = user.get_pronouns()

	user.visible_message( \
		SPAN_NOTICE("\The [user]'s eyes glow blue as [G.he] freeze[G.s] in place, absolutely motionless."), \
		SPAN_OCCULT("The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry..."), \
		SPAN_NOTICE("You hear only complete silence for a moment."))

	announce_ghost_joinleave(user.ghostize(1), 1, "You feel that they had to use some [pick("dark", "black", "blood", "forgotten", "forbidden")] magic to [pick("invade", "disturb", "disrupt", "infest", "taint", "spoil", "blight")] this place!")
	var/mob/observer/ghost/soul
	for(var/mob/observer/ghost/O in global.ghost_mob_list)
		if(O.key == tmpkey)
			soul = O
			break
	while(user)
		if(user.stat == DEAD)
			return
		if(user.key)
			return
		else if(user.loc != get_turf(src) && soul)
			soul.reenter_corpse()
		else
			user.take_organ_damage(0, 1)
		sleep(20)
	fizzle(user)

/obj/effect/rune/defile
	cultname = "defile"

/obj/effect/rune/defile/cast(var/mob/living/user)
	speak_incantation(user, "Ia! Ia! Zasan therium viortia!")
	for(var/turf/T in range(1, src))
		if(is_holy_turf(T))
			T.turf_flags &= ~TURF_FLAG_HOLY
		else
			T.on_defilement()
	visible_message(SPAN_WARNING("\The [src] embeds into the floor and walls around it, changing them!"), "You hear liquid flow.")
	qdel(src)

/obj/effect/rune/obscure
	cultname = "obscure"

/obj/effect/rune/obscure/cast(var/mob/living/user)
	var/runecheck = 0
	for(var/obj/effect/rune/R in orange(1, src))
		if(R != src)
			R.set_invisibility(INVISIBILITY_OBSERVER)
		runecheck = 1
	if(runecheck)
		speak_incantation(user, "Kla[pick("'","`")]atu barada nikt'o!")
		visible_message(SPAN_WARNING("\ The rune turns into gray dust that conceals the surrounding runes."))
		qdel(src)

/obj/effect/rune/reveal
	cultname = "reveal"

/obj/effect/rune/reveal/cast(var/mob/living/user)
	var/irunecheck = 0
	for(var/obj/effect/rune/R in orange(1, src))
		if(R != src)
			R.set_invisibility(SEE_INVISIBLE_NOLIGHTING)
		irunecheck = 1
	if(irunecheck)
		speak_incantation(user, "Nikt[pick("'","`")]o barada kla'atu!")
		visible_message(SPAN_WARNING("\ The rune turns into red dust that reveals the surrounding runes."))
		qdel(src)

/* Tier 2 runes */


/obj/effect/rune/armor
	cultname = "summon robes"
	strokes = 3

/obj/effect/rune/armor/cast(var/mob/living/user)
	speak_incantation(user, "N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	visible_message(SPAN_WARNING("\The [src] disappears with a flash of red light, and a set of armor appears on \the [user]."), SPAN_WARNING("You are blinded by the flash of red light. After you're able to see again, you see that you are now wearing a set of armor."))

	var/obj/O = user.get_equipped_item(slot_head_str) // This will most likely kill you if you are wearing a spacesuit, and it's 100% intended
	if(O && !istype(O, /obj/item/clothing/head/culthood) && user.try_unequip(O))
		user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head_str)
	O = user.get_equipped_item(slot_wear_suit_str)
	if(O && !istype(O, /obj/item/clothing/suit/cultrobes) && user.try_unequip(O))
		user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit_str)
	O = user.get_equipped_item(slot_shoes_str)
	if(O && !istype(O, /obj/item/clothing/shoes/cult) && user.try_unequip(O))
		user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes_str)

	O = user.get_equipped_item(slot_back_str)
	if(O.storage && !istype(O, /obj/item/backpack/cultpack) && user.try_unequip(O))
		var/obj/item/backpack/cultpack/C = new /obj/item/backpack/cultpack(user)
		user.equip_to_slot_or_del(C, slot_back_str)
		if(C)
			for(var/obj/item/I in O)
				I.forceMove(C)
	else if(!O)
		var/obj/item/backpack/cultpack/C = new /obj/item/backpack/cultpack(user)
		user.equip_to_slot_or_del(C, slot_back_str)

	user.update_icon()

	qdel(src)

/obj/effect/rune/offering
	cultname = "offering"
	strokes = 3
	var/mob/living/victim

/obj/effect/rune/offering/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(victim)
		to_chat(user, SPAN_WARNING("You are already sarcificing \the [victim] on this rune."))
		return
	if(cultists.len < 3)
		to_chat(user, SPAN_WARNING("You need three cultists around this rune to make it work."))
		return fizzle(user)
	var/turf/T = get_turf(src)
	for(var/mob/living/M in T)
		if(M.stat != DEAD && !iscultist(M))
			victim = M
			break
	if(!victim)
		return fizzle(user)

	for(var/mob/living/M in cultists)
		M.say("Barhah hra zar[pick("'","`")]garis!")

	while(victim && victim.loc == T && victim.stat != DEAD)
		var/list/mob/living/casters = get_cultists()
		if(casters.len < 3)
			break
		//T.turf_animation('icons/effects/effects.dmi', "rune_sac")
		victim.fire_stacks = max(2, victim.fire_stacks)
		victim.IgniteMob()
		var/dam_amt = 2 + length(casters)
		victim.take_organ_damage(dam_amt, dam_amt) // This is to speed up the process and also damage mobs that don't take damage from being on fire, e.g. borgs
		if(ishuman(victim))
			var/mob/living/human/H = victim
			if(H.is_asystole())
				H.take_damage(2 + casters.len, BRAIN)
		sleep(40)
	if(victim && victim.loc == T && victim.stat == DEAD)
		var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
		cult.add_cultiness(CULTINESS_PER_SACRIFICE)
		var/obj/item/soulstone/full/F = new(get_turf(src))
		for(var/mob/M in cultists | get_cultists())
			to_chat(M, SPAN_WARNING("The Geometer of Blood accepts this offering."))
		visible_message(SPAN_NOTICE("\The [F] appears over \the [src]."))
		cult.sacrificed += victim.mind
		if(victim.mind == cult.sacrifice_target)
			for(var/datum/mind/H in cult.current_antagonists)
				if(H.current)
					to_chat(H.current, SPAN_OCCULT("Your objective is now complete."))
		to_chat(victim, SPAN_OCCULT("The Geometer of Blood claims your body."))
		victim.dust()
	if(victim)
		victim.ExtinguishMob() // Technically allows them to put the fire out by sacrificing them and stopping immediately, but I don't think it'd have much effect
		victim = null


/obj/effect/rune/drain
	cultname = "blood drain"
	strokes = 3

/obj/effect/rune/drain/cast(var/mob/living/user)
	var/mob/living/human/victim
	for(var/mob/living/human/M in get_turf(src))
		if(iscultist(M))
			continue
		victim = M
	if(!victim)
		return fizzle(user)
	if(victim.vessel.total_volume < 20)
		to_chat(user, SPAN_WARNING("This body has no blood in it."))
		return fizzle(user)
	victim.vessel.remove_any(20)
	admin_attack_log(user, victim, "Used a blood drain rune.", "Was victim of a blood drain rune.", "used a blood drain rune on")
	speak_incantation(user, "Yu[pick("'","`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
	user.visible_message(SPAN_WARNING("Blood flows from \the [src] into \the [user]!"), SPAN_OCCULT("The blood starts flowing from \the [src] into your frail mortal body. [capitalize(english_list(heal_user(user), nothing_text = "you feel no different"))]."), "You hear liquid flow.")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/effect/rune/drain/proc/heal_user(var/mob/living/human/user)
	if(!istype(user))
		return list("you feel no different")
	var/list/statuses = list()
	var/charges = 20
	var/use
	use = min(charges, user.species.blood_volume - user.vessel.total_volume)
	if(use > 0)
		user.adjust_blood(use)
		charges -= use
		statuses += "you regain lost blood"
		if(!charges)
			return statuses
	if(user.get_damage(BRUTE) || user.get_damage(BURN))
		var/healbrute = user.get_damage(BRUTE)
		var/healburn = user.get_damage(BURN)
		if(healbrute < healburn)
			healbrute = min(healbrute, charges / 2)
			charges -= healbrute
			healburn = min(healburn, charges)
			charges -= healburn
		else
			healburn = min(healburn, charges / 2)
			charges -= healburn
			healbrute = min(healbrute, charges)
			charges -= healbrute
		user.heal_organ_damage(healbrute, healburn, 1)
		statuses += "your wounds mend"
		if(!charges)
			return statuses
	if(user.get_damage(TOX))
		use = min(user.get_damage(TOX), charges)
		user.heal_damage(TOX, use)
		charges -= use
		statuses += "your body stings less"
		if(!charges)
			return statuses
	if(charges >= 15)
		for(var/obj/item/organ/external/e in user.get_external_organs())
			if(e && e.status & ORGAN_BROKEN)
				e.status &= ~ORGAN_BROKEN
				statuses += "bones in your [e.name] snap into place"
				charges -= 15
				if(charges < 15)
					break
	if(!charges)
		return statuses
	var/list/obj/item/organ/damaged = list()
	for(var/obj/item/organ/I in user.internal_organs)
		if(I.damage)
			damaged += I
	if(damaged.len)
		statuses += "you feel pain inside for a moment that passes quickly"
		while(charges && damaged.len)
			var/obj/item/organ/fix = pick(damaged)
			fix.damage = max(0, fix.damage - min(charges, 1))
			charges = max(charges - 1, 0)
			if(fix.damage == 0)
				damaged -= fix
	return statuses

/obj/effect/rune/emp
	cultname = "emp"
	strokes = 4

/obj/effect/rune/emp/cast(var/mob/living/user)
	empulse(get_turf(src), 4, 2, 1)
	speak_incantation(user, "Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	qdel(src)

/obj/effect/rune/massdefile //Defile but with a huge range. Bring a buddy for this, you're hitting the floor.
	cultname = "mass defile"

/obj/effect/rune/massdefile/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 3)
		to_chat(user, SPAN_WARNING("You need three cultists around this rune to make it work."))
		return fizzle(user)
	else
		for(var/mob/living/M in cultists)
			M.say("Ia! Ia! Zasan therium viortia! Razan gilamrua kioha!")
		for(var/turf/T in range(5, src))
			if(is_holy_turf(T))
				T.turf_flags &= ~TURF_FLAG_HOLY
			else
				T.on_defilement()
	visible_message(SPAN_WARNING("\The [src] embeds into the floor and walls around it, changing them!"), "You hear liquid flow.")
	qdel(src)

/* Tier 3 runes */

/obj/effect/rune/weapon
	cultname = "summon weapon"
	strokes = 4

/obj/effect/rune/weapon/cast(var/mob/living/user)
	if(!istype(user.get_equipped_item(slot_head_str), /obj/item/clothing/head/culthood) || !istype(user.get_equipped_item(slot_wear_suit_str), /obj/item/clothing/suit/cultrobes) || !istype(user.get_equipped_item(slot_shoes_str), /obj/item/clothing/shoes/cult))
		to_chat(user, SPAN_WARNING("You need to be wearing your robes to use this rune."))
		return fizzle(user)
	var/turf/T = get_turf(src)
	if(!T.is_defiled())
		to_chat(user, SPAN_WARNING("This rune needs to be placed on the defiled ground."))
		return fizzle(user)
	speak_incantation(user, "N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
	user.put_in_hands(new /obj/item/sword/cultblade(user))
	qdel(src)

/obj/effect/rune/shell
	cultname = "summon shell"
	strokes = 4

/obj/effect/rune/shell/cast(var/mob/living/user)
	var/turf/T = get_turf(src)
	if(!T.is_defiled())
		to_chat(user, SPAN_WARNING("This rune needs to be placed on the defiled ground."))
		return fizzle(user)

	var/obj/item/stack/material/target
	for(var/obj/item/stack/material/S in get_turf(src))
		if(S.material?.type == /decl/material/solid/metal/steel && S.get_amount() >= 10)
			target = S
			break

	if(!target)
		to_chat(user, SPAN_WARNING("You need ten sheets of steel to fold them into a construct shell."))
		return fizzle(user)

	speak_incantation(user, "Da A[pick("'","`")]ig Osk!")
	target.use(10)
	var/obj/O = new /obj/structure/constructshell/cult(get_turf(src))
	visible_message(SPAN_WARNING("The metal bends into \the [O], and \the [src] imbues into it."), "You hear a metallic sound.")
	qdel(src)

/obj/effect/rune/confuse
	cultname = "confuse"
	strokes = 4

/obj/effect/rune/confuse/cast(var/mob/living/user)
	speak_incantation(user, "Fuu ma[pick("'","`")]jin!")
	visible_message(SPAN_DANGER("\The [src] explodes in a bright flash."))
	var/list/mob/affected = list()
	for(var/mob/living/M in viewers(src))
		if(iscultist(M))
			continue
		var/obj/item/nullrod/N = locate() in M
		if(N)
			continue
		affected |= M
		if(issilicon(M))
			SET_STATUS_MAX(M, STAT_WEAK, 10)
		else
			SET_STATUS_MAX(M, STAT_BLURRY, 50)
			SET_STATUS_MAX(M, STAT_WEAK, 3)
			SET_STATUS_MAX(M, STAT_STUN, 5)

	admin_attacker_log_many_victims(user, affected, "Used a confuse rune.", "Was victim of a confuse rune.", "used a confuse rune on")
	qdel(src)

/obj/effect/rune/revive
	cultname = "revive"
	strokes = 4

/obj/effect/rune/revive/cast(var/mob/living/user)
	var/mob/living/human/target
	var/obj/item/soulstone/source
	for(var/mob/living/human/M in get_turf(src))
		if(M.stat == DEAD)
			if(iscultist(M))
				if(M.key)
					target = M
					break
	if(!target)
		return fizzle(user)
	for(var/obj/item/soulstone/S in get_turf(src))
		if(S.full && !S.shade.key)
			source = S
			break
	if(!source)
		return fizzle(user)
	target.rejuvenate()
	source.set_full(0)
	speak_incantation(user, "Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")

	var/decl/pronouns/G = target.get_pronouns()
	target.visible_message( \
		SPAN_OCCULT("\The [target]'s eyes glow with a faint red as [G.he] stand[G.s] up, slowly starting to breathe again."), \
		SPAN_OCCULT("Life... I'm alive again..."), \
		"You hear a flowing liquid.")

/obj/effect/rune/blood_boil
	cultname = "blood boil"
	strokes = 4

/obj/effect/rune/blood_boil/cast(var/mob/living/user)
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 3)
		return fizzle()

	for(var/mob/living/M in cultists)
		M.say("Dedo ol[pick("'","`")]btoh!")

	var/list/mob/living/previous = list()
	var/list/mob/living/current = list()
	while(cultists.len >= 3)
		cultists = get_cultists()
		for(var/mob/living/M in viewers(src))
			if(iscultist(M))
				continue
			current |= M
			var/obj/item/nullrod/N = locate() in M
			if(N)
				continue
			M.take_overall_damage(5, 5)
			if(!(M in previous))
				if(M.should_have_organ(BP_HEART))
					to_chat(M, SPAN_DANGER("Your blood boils!"))
				else
					to_chat(M, SPAN_DANGER("You feel searing heat inside!"))
		previous = current.Copy()
		current.Cut()
		sleep(10)

/* Tier NarNar runes */

/obj/effect/rune/tearreality
	cultname = "tear reality"
	var/the_end_comes = 0
	var/the_time_has_come = 300
	var/obj/effect/narsie/summoning_entity = null
	strokes = 9

/obj/effect/rune/tearreality/cast(var/mob/living/user)
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	if(!cult.allow_narsie)
		return
	if(the_end_comes)
		to_chat(user, SPAN_OCCULT("You are already summoning! Be patient!"))
		return
	var/list/mob/living/cultists = get_cultists()
	if(cultists.len < 5)
		return fizzle()
	for(var/mob/living/M in cultists)
		M.say("Tok-lyr rqa'nap g[pick("'","`")]lt-ulotf!")
		to_chat(M, SPAN_OCCULT("You are starting to tear through the veil, opening the way to bring Him back... stay around the rune!"))
	log_and_message_admins_many(cultists, "started summoning Nar-sie.")

	var/area/A = get_area(src)
	command_announcement.Announce("High levels of gravitational disruption detected at \the [A.proper_name]. Suspected wormhole forming. Investigate it immediately.")
	while(cultists.len > 4 || the_end_comes)
		cultists = get_cultists()
		if(cultists.len > 8)
			++the_end_comes
		if(cultists.len > 4)
			++the_end_comes
		else
			--the_end_comes
		if(the_end_comes >= the_time_has_come)
			break
		for(var/mob/living/M in cultists)
			if(prob(5))
				M.say(pick("Hakkrutju gopoenjim.", "Nherasai pivroiashan.", "Firjji prhiv mazenhor.", "Tanah eh wakantahe.", "Obliyae na oraie.", "Miyf hon vnor'c.", "Wakabai hij fen juswix."))

		for(var/turf/T in range(min(the_end_comes, 15)))
			if(prob(the_end_comes / 3))
				T.on_defilement()
		sleep(10)

	if(the_end_comes >= the_time_has_come)
		summoning_entity = new /obj/effect/narsie(get_turf(src))
	else
		command_announcement.Announce("Gravitational anomaly has ceased.")
		qdel(src)

/obj/effect/rune/tearreality/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(!summoning_entity || iscultist(user))
		return FALSE
	var/input = input(user, "Are you SURE you want to sacrifice yourself?", "DO NOT DO THIS") in list("Yes", "No")
	if(input != "Yes")
		return TRUE
	speak_incantation(user, "Uhrast ka'hfa heldsagen ver[pick("'","`")]lot!")
	to_chat(user, SPAN_WARNING("In the last moment of your humble life, you feel an immense pain as fabric of reality mends... with your blood."))
	for(var/mob/M in global.living_mob_list_)
		if(iscultist(M))
			var/decl/pronouns/G = user.get_pronouns()
			to_chat(M, "You see a vision of \the [user] keeling over dead, his blood glowing blue as it escapes [G.his] body and dissipates into thin air; you hear an otherwordly scream and feel that a great disaster has just been averted.")
		else
			to_chat(M, "You see a vision of [name] keeling over dead, his blood glowing blue as it escapes his body and dissipates into thin air; you hear an otherwordly scream and feel very weak for a moment.")
	log_and_message_admins("mended reality with the greatest sacrifice", user)
	user.dust()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.powerless = 1
	qdel(summoning_entity)
	qdel(src)
	return TRUE

/obj/effect/rune/tearreality/attackby()
	if(the_end_comes)
		return
	..()

/* Imbue runes */

/obj/effect/rune/imbue
	cultname = "otherwordly abomination that shouldn't exist and that you should report to your local god as soon as you see it, along with the instructions for making this"
	var/papertype

/obj/effect/rune/imbue/cast(var/mob/living/user)
	var/obj/item/paper/target
	var/tainted = 0
	for(var/obj/item/paper/P in get_turf(src))
		if(!P.info)
			target = P
			break
		else
			tainted = 1
	if(!target)
		if(tainted)
			to_chat(user, SPAN_WARNING("The blank is tainted. It is unsuitable."))
		return fizzle(user)
	speak_incantation(user, "H'drak v[pick("'","`")]loso, mir'kanas verbot!")
	visible_message(SPAN_WARNING("The rune forms into an arcane image on the paper."))
	new papertype(get_turf(src))
	qdel(target)
	qdel(src)

/obj/effect/rune/imbue/stun
	cultname = "stun imbue"
	papertype = /obj/item/paper/talisman/stun

/obj/effect/rune/imbue/emp
	cultname = "destroy technology imbue"
	papertype = /obj/item/paper/talisman/emp
