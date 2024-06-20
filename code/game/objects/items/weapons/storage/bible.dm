/obj/item/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon = 'icons/obj/items/storage/bible.dmi'
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_REINFORCEMENT
	)
	storage = /datum/storage/bible
	var/renamed = 0
	var/icon_changed = 0

/obj/item/bible/Initialize()
	. = ..()
	if(length(contents) && storage)
		storage.make_exact_fit()

/obj/item/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

/obj/item/bible/booze/WillContain()
	return list(
		/obj/item/chems/drinks/bottle/small/beer,
		/obj/item/cash/c50,
		/obj/item/cash/c50,
	)

/obj/item/bible/bible
	name = "\improper Bible"
	desc = "The central religious text of Christianity."
	renamed = 1
	icon_changed = 1

/obj/item/bible/tanakh
	name = "\improper Tanakh"
	desc = "The central religious text of Judaism."
	icon_state = "torah"
	renamed = 1
	icon_changed = 1

/obj/item/bible/quran
	name = "\improper Quran"
	desc = "The central religious text of Islam."
	icon_state = "koran"
	renamed = 1
	icon_changed = 1

/obj/item/bible/kojiki
	name = "\improper Kojiki"
	desc = "A collection of myths from ancient Japan."
	icon_state = "kojiki"
	renamed = 1
	icon_changed = 1

/obj/item/bible/aqdas
	name = "\improper Kitab-i-Aqdas"
	desc = "The central religious text of the Baha'i Faith."
	icon_state = "ninestar"
	renamed = 1
	icon_changed = 1

/obj/item/bible/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(user == target || !ishuman(user) || !ishuman(target))
		return ..()

	if(user.mind?.assigned_job?.is_holy)
		user.visible_message(SPAN_NOTICE("\The [user] places \the [src] on \the [target]'s forehead, reciting a prayer..."))
		if(do_after(user, 5 SECONDS) && user.Adjacent(target))
			var/decl/pronouns/G = user.get_pronouns()
			user.visible_message(
				SPAN_NOTICE("\The [user] finishes reciting [G.his] prayer, removing \the [src] from \the [target]'s forehead."),
				SPAN_NOTICE("You finish reciting your prayer, removing \the [src] from \the [target]'s forehead."))
			if(user.get_cultural_value(TAG_RELIGION) == target.get_cultural_value(TAG_RELIGION))
				to_chat(target, SPAN_NOTICE("You feel calm and relaxed, at one with the universe."))
			else
				to_chat(target, "Nothing happened.")
		return TRUE

	return ..()

/obj/item/bible/afterattack(atom/A, mob/user, proximity)
	if(proximity && user?.mind?.assigned_job?.is_holy)
		if(A.reagents && A.reagents.has_reagent(/decl/material/liquid/water)) //blesses all the water in the holder
			to_chat(user, SPAN_NOTICE("You bless \the [A].")) // I wish it was this easy in nethack
			LAZYSET(A.reagents.reagent_data, /decl/material/liquid/water, list("holy" = TRUE))

/obj/item/bible/attackby(obj/item/W, mob/user)
	if(storage?.use_sound)
		playsound(loc, storage.use_sound, 50, 1, -5)
	return ..()

/obj/item/bible/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/human/preacher = user
	if(preacher.mind?.assigned_job?.is_holy)
		preacher.visible_message("\The [preacher] begins to read a passage from \the [src]...", "You begin to read a passage from \the [src]...")
		if(do_after(preacher, 5 SECONDS))
			preacher.visible_message("\The [preacher] reads a passage from \the [src].", "You read a passage from \the [src].")
			for(var/mob/living/human/H in view(preacher))
				if(preacher.get_cultural_value(TAG_RELIGION) == H.get_cultural_value(TAG_RELIGION))
					to_chat(H, SPAN_NOTICE("You feel calm and relaxed, at one with the universe."))

/obj/item/bible/verb/rename_bible()
	set name = "Rename Bible"
	set category = "Object"
	set desc = "Click to rename your bible."

	if(!renamed)
		var/input = sanitize_safe(input("What do you want to rename your bible to? You can only do this once.", ,""), MAX_NAME_LEN)

		var/mob/M = usr
		if(src && input && !M.stat && in_range(M,src))
			SetName(input)
			to_chat(M, "You name your religious book [input].")
			renamed = 1
			return 1

/obj/item/bible/verb/set_icon()
	set name = "Change Icon"
	set category = "Object"
	set desc = "Click to change your book's icon."

	if(!icon_changed)
		var/mob/M = usr

		for(var/i = 10; i >= 0; i -= 1)
			if(src && !M.stat && in_range(M,src))
				var/icon_picked = input(M, "Icon?", "Book Icon", null) in list("don't change", "bible", "koran", "scrapbook", "white", "holylight", "atheist", "kojiki", "torah", "kingyellow", "ithaqua", "necronomicon", "ninestar")
				if(icon_picked != "don't change" && icon_picked)
					icon_state = icon_picked
				if(i != 0)
					var/confirm = alert(M, "Is this what you want? Chances remaining: [i]", "Confirmation", "Yes", "No")
					if(confirm == "Yes")
						icon_changed = 1
						break
				if(i == 0)
					icon_changed = 1
