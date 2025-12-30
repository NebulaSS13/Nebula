/obj/item/disk/secret_project
	name = "'classified' project data disk"
	desc = "A special disk for storing massive amounts of data. It is marked as classified, and has an ID card slot on top."
	color = COLOR_GRAY20
	label = "label_warning"
	req_access = list(access_ce)
	var/subject = "some strange, incomprehensible design"
	var/locked = 1

/obj/item/disk/secret_project/science
	color = COLOR_INDIGO
	desc = "A special disk for storing massive amounts of data. It is marked as classified, and has an ID card slot on top. \
	This one has a lengthy legal label on it denoting it the private, copyrighted property of the Expeditionary Corps Organisation."
	req_access = list(access_rd)

/obj/item/disk/secret_project/proc/get_secret_project_codenames()
	var/static/list/codenames = list(
		"gamma", "delta", "epsilon", "zeta", "theta", "lambda", "omicron", "sigma", "tau",
		"upsilon", "omega", "echelon", "prism", "calypso", "bernoulli", "harmony", "nyx", "fresnel"
	)

/obj/item/disk/secret_project/proc/get_secret_project_types()
	var/static/list/types = list(
		"an experimental design for",
		"a blueprint to build",
		"a long set of theoretical formulas detailing the functioning of"
	)
	return types

/obj/item/disk/secret_project/proc/get_secret_project_nouns()
	var/static/list/nouns = list(
		"a superluminal artillery cannon", "a fusion engine", "an atmospheric scrubber",\
		"a human cloning pod", "a microwave oven", "a wormhole generator", "a laser carbine", "an energy pistol",\
		"a wormhole", "a teleporter", "a huge mining drill", "a strange spacecraft", "a space station",\
		"a sleek-looking fighter spacecraft", "a ballistic rifle", "an energy sword", "an inanimate carbon rod"
	)
	return nouns

/obj/item/disk/secret_project/proc/get_secret_project_descriptors()
	var/static/list/descriptors = list(
		"that is extremely powerful", "which is highly efficient", "which is incredibly compact", "created by aliens",
		"that runs off of an exotic form of matter", "that runs off of hydrogen gas", "that just looks really cool"
	)

/obj/item/disk/secret_project/Initialize()
	. = ..()
	name = "'[pick(get_secret_project_codenames())]' project data disk"
	subject = "[pick(get_secret_project_types())] [pick(get_secret_project_nouns())] [pick(get_secret_project_descriptors())]"

/obj/item/disk/secret_project/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(locked)
		. += "The disk is locked, you cannot see its contents."
	else
		. += "With the disk's classified contents unlocked, you peer into its preview screen and see <span class='notice'>[subject]</span>."

/obj/item/disk/secret_project/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, "<span class='warning'>The cryptographic lock on this disk is far too complex. Your sequencer can't break the code.</span>")
	return 0

/obj/item/disk/secret_project/attackby(obj/item/used_item, mob/user)
	if(istype(used_item,/obj/item/card/id))
		var/obj/item/card/id/ID = used_item
		if(check_access(ID))
			locked = !locked
			to_chat(user, "<span class='notice'>You swipe your card and [locked ? "lock":"unlock"] the disk.</span>")
		else
			to_chat(user, "<span class='warning'>The disk's screen flashes 'Access Denied'.</span>")
		return TRUE
	. = ..()

/obj/item/disk/secret_project/verb/change_codename()
	set name = "Change project codename"
	set category = "Object"
	set src in view(0)

	if(!locked)
		var/input = sanitize(input(usr, "What would you like to change the project codename to?", "Classified Project Data Disk"))
		if(!input || input == "")
			return
		SetName("'[input]' project data disk")
	else
		to_chat(usr, "<span class='warning'>The disk's screen flashes 'Access Denied'. It is locked.</span>")

/obj/item/box/secret_project_disks
	name = "box of classified data disks"
	desc = "A box full of disks. Marked with a red 'Top Secret' label. Looks rather ominous."

/obj/item/box/secret_project_disks/WillContain()
	return list(/obj/item/disk/secret_project = 5)

/obj/item/box/secret_project_disks/science/WillContain()
	return list(/obj/item/disk/secret_project/science = 5)