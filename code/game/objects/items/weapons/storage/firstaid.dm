/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'

/obj/item/storage/firstaid/empty
	icon_state = "firstaid"
	name = "First-Aid (empty)"

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/antibiotics,
		/obj/item/storage/pill_bottle/painkillers,
		/obj/item/stack/medical/splint
		)

/obj/item/storage/firstaid/trauma
	name = "trauma first-aid kit"
	desc = "It's an emergency medical kit for when people brought ballistic weapons to a laser fight."
	icon_state = "radfirstaid"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/storage/med_pouch/trauma = 4
		)

/obj/item/storage/firstaid/trauma/Initialize()
	. = ..()
	icon_state = pick("radfirstaid", "radfirstaid2", "radfirstaid3")

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/storage/med_pouch/burn = 4
		)

/obj/item/storage/firstaid/fire/Initialize()
	. = ..()
	icon_state = pick("ointment","firefirstaid")

/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	startswith = list(
		/obj/item/storage/med_pouch/toxin = 4
		)

/obj/item/storage/firstaid/toxin/Initialize()
	. = ..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	startswith = list(
		/obj/item/storage/med_pouch/oxyloss = 4
		)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/pill_bottle/assorted,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint
		)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/pill_bottle/brute_meds,
		/obj/item/storage/pill_bottle/burn_meds,
		/obj/item/storage/pill_bottle/oxygen,
		/obj/item/storage/pill_bottle/antitoxins,
		/obj/item/storage/pill_bottle/painkillers,
		/obj/item/storage/pill_bottle/antibiotics,
		/obj/item/stack/medical/splint,
		)

/obj/item/storage/firstaid/stab
	name = "stabilisation first aid"
	desc = "Stocked with medical pouches."
	icon_state = "stabfirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin,
		/obj/item/storage/med_pouch/radiation,
		)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"

	storage_slots = 14
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = null
	use_sound = 'sound/effects/storage/briefcase.ogg'

	can_hold = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/sutures,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste
		)

	startswith = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/sutures,
		/obj/item/stack/medical/advanced/bruise_pack,
		)

/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 21
	can_hold = list(/obj/item/chems/pill,/obj/item/dice,/obj/item/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/effects/storage/pillbottle.ogg'
	matter = list(MAT_PLASTIC = 250)
	var/wrapper_color
	var/label

/obj/item/storage/pill_bottle/afterattack(mob/living/target, mob/living/user, proximity_flag)
	if(!proximity_flag || !istype(target) || target != user)
		return 1
	if(!contents.len)
		to_chat(user, "<span class='warning'>It's empty!</span>")
		return 1
	var/zone = user.zone_sel.selecting
	if(zone == BP_MOUTH && target.can_eat())
		user.visible_message("<span class='notice'>[user] pops a pill from \the [src].</span>")
		playsound(get_turf(src), 'sound/effects/peelz.ogg', 50)
		var/list/peelz = filter_list(contents,/obj/item/chems/pill/)
		if(peelz.len)
			var/obj/item/chems/pill/P = pick(peelz)
			remove_from_storage(P)
			P.attack(target,user)
			return 1

/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	if(user.get_inactive_hand())
		to_chat(user, "<span class='notice'>You need an empty hand to take something out.</span>")
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		if(!remove_from_storage(I,user))
			return
		if(user.put_in_inactive_hand(I))
			to_chat(user, "<span class='notice'>You take \the [I] out of \the [src].</span>")
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
		else
			I.dropInto(loc)
			to_chat(user, "<span class='notice'>You fumble around with \the [src] and drop \the [I] on the floor.</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")


/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/pill_bottle/on_update_icon()
	overlays.Cut()
	if(wrapper_color)
		var/image/I = image(icon, "pillbottle_wrap")
		I.color = wrapper_color
		overlays += I

/obj/item/storage/pill_bottle/antitox
	name = "pill bottle (antitoxins)"
	desc = "Contains pills used to counter toxins."

	startswith = list(/obj/item/chems/pill/antitox = 21)
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/brute_meds
	name = "pill bottle (styptic)"
	desc = "Contains pills used to stabilize the severely injured."

	startswith = list(/obj/item/chems/pill/brute_meds = 21)
	wrapper_color = COLOR_MAROON

/obj/item/storage/pill_bottle/oxygen
	name = "pill bottle (oxygen)"
	desc = "Contains pills used to treat oxygen deprivation."

	startswith = list(/obj/item/chems/pill/oxygen = 21)
	wrapper_color = COLOR_LIGHT_CYAN

/obj/item/storage/pill_bottle/antitoxins
	name = "pill bottle (antitoxins)"
	desc = "Contains pills used to treat toxic substances in the blood."

	startswith = list(/obj/item/chems/pill/antitoxins = 21)
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/adrenaline
	name = "pill bottle (adrenaline)"
	desc = "Contains pills used to stabilize patients."

	startswith = list(/obj/item/chems/pill/adrenaline = 21)
	wrapper_color = COLOR_PALE_BLUE_GRAY

/obj/item/storage/pill_bottle/burn_meds
	name = "pill bottle (Kelotane)"
	desc = "Contains pills used to treat burns."

	startswith = list(/obj/item/chems/pill/burn_meds = 21)
	wrapper_color = COLOR_SUN

/obj/item/storage/pill_bottle/antibiotics
	name = "pill bottle (antibiotics)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

	startswith = list(/obj/item/chems/pill/antibiotics = 14)
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/storage/pill_bottle/painkillers
	name = "pill bottle (painkillers)"
	desc = "Contains pills used to relieve pain."

	startswith = list(/obj/item/chems/pill/painkillers = 14)
	wrapper_color = COLOR_PURPLE_GRAY

//Baycode specific Psychiatry pills.
/obj/item/storage/pill_bottle/antidepressants
	name = "pill bottle (antidepressants)"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."

	startswith = list(/obj/item/chems/pill/antidepressants = 21)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/stimulants
	name = "pill bottle (stimulants)"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."

	startswith = list(/obj/item/chems/pill/stimulants = 21)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/assorted
	name = "pill bottle (assorted)"
	desc = "Commonly found on paramedics, these assorted pill bottles contain all the basics."

	startswith = list(
			/obj/item/chems/pill/adrenaline = 6,
			/obj/item/chems/pill/antitoxins = 6,
			/obj/item/chems/pill/sugariron = 2,
			/obj/item/chems/pill/painkillers = 2,
			/obj/item/chems/pill/oxygen = 2,
			/obj/item/chems/pill/burn_meds = 2,
			/obj/item/chems/pill/antirads
		)
