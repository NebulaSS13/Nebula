/obj/item/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon = 'icons/obj/items/storage/bible.dmi'
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 4
	var/mob/affecting = null
	var/deity_name = "Christ"
	var/renamed = 0
	var/icon_changed = 0

/obj/item/storage/bible/Initialize()
	. = ..()
	if(length(startswith))
		make_exact_fit()

/obj/item/storage/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

	startswith = list(
		/obj/item/chems/drinks/bottle/small/beer,
		/obj/item/cash/c50,
		/obj/item/cash/c50,
	)

/obj/item/storage/bible/bible
	name = "\improper Bible"
	desc = "The central religious text of Christianity."
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/tanakh
	name = "\improper Tanakh"
	desc = "The central religious text of Judaism."
	icon_state = "torah"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/quran
	name = "\improper Quran"
	desc = "The central religious text of Islam."
	icon_state = "koran"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/kojiki
	name = "\improper Kojiki"
	desc = "A collection of myths from ancient Japan."
	icon_state = "kojiki"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/aqdas
	name = "\improper Kitab-i-Aqdas"
	desc = "The central religious text of the Baha'i Faith."
	icon_state = "ninestar"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(user == M || !ishuman(user) || !ishuman(M))
		return
	if(user?.mind?.assigned_job?.is_holy)
		user.visible_message(SPAN_NOTICE("\The [user] places \the [src] on \the [M]'s forehead, reciting a prayer..."))
		if(do_after(user, 5 SECONDS) && user.Adjacent(M))
			var/decl/pronouns/G = user.get_pronouns()
			user.visible_message( \
				SPAN_NOTICE("\The [user] finishes reciting [G.his] prayer, removing \the [src] from \the [M]'s forehead."), \
				SPAN_NOTICE("You finish reciting your prayer, removing \the [src] from \the [M]'s forehead."))
			if(user.get_cultural_value(TAG_RELIGION) == M.get_cultural_value(TAG_RELIGION))
				to_chat(M, SPAN_NOTICE("You feel calm and relaxed, at one with the universe."))
			else
				to_chat(M, "Nothing happened.")
		..()

/obj/item/storage/bible/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(user?.mind?.assigned_job?.is_holy)
		if(A.reagents && A.reagents.has_reagent(/decl/material/liquid/water)) //blesses all the water in the holder
			to_chat(user, SPAN_NOTICE("You bless \the [A].")) // I wish it was this easy in nethack
			LAZYSET(A.reagents.reagent_data, /decl/material/liquid/water, list("holy" = TRUE))

/obj/item/storage/bible/attackby(obj/item/W, mob/user)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	return ..()

/obj/item/storage/bible/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/preacher = user
	if(preacher.mind?.assigned_job?.is_holy)
		preacher.visible_message("\The [preacher] begins to read a passage from \the [src]...", "You begin to read a passage from \the [src]...")
		if(do_after(preacher, 5 SECONDS))
			preacher.visible_message("\The [preacher] reads a passage from \the [src].", "You read a passage from \the [src].")
			for(var/mob/living/carbon/human/H in view(preacher))
				if(preacher.get_cultural_value(TAG_RELIGION) == H.get_cultural_value(TAG_RELIGION))
					to_chat(H, SPAN_NOTICE("You feel calm and relaxed, at one with the universe."))

/obj/item/storage/bible/verb/rename_bible()
	set name = "Rename Bible"
	set category = "Object"
	set desc = "Click to rename your bible."

	if(!renamed)
		var/input = sanitizeSafe(input("What do you want to rename your bible to? You can only do this once.", ,""), MAX_NAME_LEN)

		var/mob/M = usr
		if(src && input && !M.stat && in_range(M,src))
			SetName(input)
			to_chat(M, "You name your religious book [input].")
			renamed = 1
			return 1

/obj/item/storage/bible/verb/set_icon()
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
