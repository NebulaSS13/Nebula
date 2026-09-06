var/global/list/obj/abstract/landmark/all_landmarks = list()
/obj/abstract/landmark
	name = "landmark"
	var/delete_me = 0

/obj/abstract/landmark/Initialize()
	. = ..()
	tag = "landmark*[name]"
	if(delete_me)
		return INITIALIZE_HINT_QDEL
	global.all_landmarks += src

/obj/abstract/landmark/proc/delete()
	delete_me = TRUE

/obj/abstract/landmark/Destroy()
	global.all_landmarks -= src
	return ..()

/obj/abstract/landmark/start
	name = "start"
	icon = 'icons/effects/markers.dmi'
	icon_state = "x"
	anchored = TRUE
	invisibility = INVISIBILITY_ABSTRACT

/obj/abstract/landmark/start/Initialize()
	tag = "start*[name]"
	return ..()

//Costume spawner landmarks
/obj/abstract/landmark/costume
	delete_me = TRUE

/obj/abstract/landmark/costume/Initialize()
	make_costumes()
	. = ..() //costume spawner, selects a random subclass and disappears

/obj/abstract/landmark/costume/proc/make_costumes()
	var/list/options = typesof(/obj/abstract/landmark/costume)
	var/costume = pick(options)
	new costume(loc)

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/abstract/landmark/costume/chameleon/make_costumes()
	new /obj/item/clothing/mask/chameleon(loc)
	new /obj/item/clothing/jumpsuit/chameleon(loc)
	new /obj/item/clothing/shirt/chameleon(loc)
	new /obj/item/clothing/pants/chameleon(loc)
	new /obj/item/clothing/glasses/chameleon(loc)
	new /obj/item/clothing/shoes/chameleon(loc)
	new /obj/item/clothing/gloves/chameleon(loc)
	new /obj/item/clothing/suit/chameleon(loc)
	new /obj/item/clothing/head/chameleon(loc)
	new /obj/item/backpack/chameleon(loc)

/obj/abstract/landmark/costume/gladiator/make_costumes()
	new /obj/item/clothing/costume/gladiator(loc)
	new /obj/item/clothing/head/helmet/gladiator(loc)

/obj/abstract/landmark/costume/madscientist/make_costumes()
	new /obj/item/clothing/costume/captain_suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/suit/toggle/labcoat/mad(loc)
	new /obj/item/clothing/glasses/prescription/gglasses(loc)

/obj/abstract/landmark/costume/elpresidente/make_costumes()
	new /obj/item/clothing/costume/captain_suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(loc)
	new /obj/item/clothing/shoes/jackboots(loc)

/obj/abstract/landmark/costume/nyangirl/make_costumes()
	new /obj/item/clothing/costume/schoolgirl(loc)
	new /obj/item/clothing/head/kitty(loc)

/obj/abstract/landmark/costume/maid/make_costumes()
	new /obj/item/clothing/skirt/red/blouse(loc)
	var/CHOICE = pick(/obj/item/clothing/head/beret, /obj/item/clothing/head/rabbitears)
	new CHOICE(loc)
	new /obj/item/clothing/glasses/blindfold(loc)

/obj/abstract/landmark/costume/butler/make_costumes()
	new /obj/item/clothing/pants/slacks(loc)
	new /obj/item/clothing/shirt/button(loc)
	new /obj/item/clothing/suit/jacket/waistcoat/black(loc)
	new /obj/item/clothing/head/that(loc)

/obj/abstract/landmark/costume/prig/make_costumes()
	new /obj/item/clothing/suit/jacket/waistcoat/black(loc)
	new /obj/item/clothing/glasses/eyepatch/monocle(loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(loc)
	new /obj/item/clothing/shoes/color/black(loc)
	new /obj/item/cane(loc)
	new /obj/item/clothing/pants/slacks/black(loc)
	new /obj/item/clothing/shirt/button(loc)
	new /obj/item/clothing/mask/fakemoustache(loc)

/obj/abstract/landmark/costume/plaguedoctor/make_costumes()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(loc)
	new /obj/item/clothing/head/plaguedoctorhat(loc)

/obj/abstract/landmark/costume/nightowl/make_costumes()
	new /obj/item/clothing/costume/owl(loc)
	new /obj/item/clothing/mask/gas/owl_mask(loc)

/obj/abstract/landmark/costume/waiter/make_costumes()
	new /obj/item/clothing/pants/slacks/black(loc)
	new /obj/item/clothing/shirt/button(loc)
	new /obj/item/clothing/neck/tie/bow/red(loc)
	new /obj/item/clothing/suit/jacket/vest/blue(loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(loc)
	new /obj/item/clothing/suit/apron(loc)

/obj/abstract/landmark/costume/pirate/make_costumes()
	new /obj/item/clothing/costume/pirate(loc)
	new /obj/item/clothing/suit/pirate(loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/mask/bandana/red)
	new CHOICE(loc)
	new /obj/item/clothing/glasses/eyepatch(loc)

/obj/abstract/landmark/costume/commie/make_costumes()
	new /obj/item/clothing/costume/soviet(loc)
	new /obj/item/clothing/head/ushanka(loc)

/obj/abstract/landmark/costume/imperium_monk/make_costumes()
	new /obj/item/clothing/suit/imperium_monk(loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(loc)

/obj/abstract/landmark/costume/holiday_priest/make_costumes()
	new /obj/item/clothing/suit/holidaypriest(loc)

/obj/abstract/landmark/costume/marisawizard/make_costumes()
	new /obj/item/clothing/head/wizard/marisa(loc)
	new/obj/item/clothing/suit/wizrobe/marisa(loc)

/obj/abstract/landmark/costume/cutewitch/make_costumes()
	new /obj/item/clothing/dress/sun(loc)
	new /obj/item/clothing/head/witchwig(loc)
	new /obj/item/staff/broom(loc)

/obj/abstract/landmark/costume/wizard/make_costumes()
	new /obj/item/clothing/suit/wizrobe(loc)
	new /obj/item/clothing/head/wizard/beard(loc)
	new /obj/item/staff/(loc)

/obj/abstract/landmark/costume/sexyclown/make_costumes()
	new /obj/item/clothing/mask/gas/sexyclown(loc)
	new /obj/item/clothing/costume/sexyclown(loc)

/obj/abstract/landmark/costume/sexymime/make_costumes()
	new /obj/item/clothing/mask/gas/sexymime(loc)
	new /obj/item/clothing/costume/sexymime(loc)

/obj/abstract/landmark/costume/savagehunter/make_costumes()
	new /obj/item/clothing/mask/spirit(loc)
	new /obj/item/clothing/costume/savage_hunter(loc)

/obj/abstract/landmark/costume/savagehuntress/make_costumes()
	new /obj/item/clothing/mask/spirit(loc)
	new /obj/item/clothing/costume/savage_hunter/female(loc)
