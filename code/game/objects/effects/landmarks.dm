/obj/effect/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101
	var/delete_me = 0

/obj/effect/landmark/Initialize()
	. = ..()
	tag = "landmark*[name]"
	if(delete_me)
		return INITIALIZE_HINT_QDEL
	landmarks_list |= src

/obj/effect/landmark/proc/delete()
	delete_me = TRUE

/obj/effect/landmark/Destroy()
	landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0
	invisibility = 101

/obj/effect/landmark/start/Initialize()
	tag = "start*[name]"
	return ..()

//Costume spawner landmarks
/obj/effect/landmark/costume
	delete_me = TRUE

/obj/effect/landmark/costume/Initialize()
	make_costumes()
	. = ..() //costume spawner, selects a random subclass and disappears

/obj/effect/landmark/costume/proc/make_costumes()
	var/list/options = typesof(/obj/effect/landmark/costume)
	var/PICK= options[rand(1,options.len)]
	new PICK(loc)

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chameleon/make_costumes()
	new /obj/item/clothing/mask/chameleon(src.loc)
	new /obj/item/clothing/under/chameleon(src.loc)
	new /obj/item/clothing/glasses/chameleon(src.loc)
	new /obj/item/clothing/shoes/chameleon(src.loc)
	new /obj/item/clothing/gloves/chameleon(src.loc)
	new /obj/item/clothing/suit/chameleon(src.loc)
	new /obj/item/clothing/head/chameleon(src.loc)
	new /obj/item/storage/backpack/chameleon(src.loc)

/obj/effect/landmark/costume/gladiator/make_costumes()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)

/obj/effect/landmark/costume/madscientist/make_costumes()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/prescription/gglasses(src.loc)

/obj/effect/landmark/costume/elpresidente/make_costumes()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/jackboots(src.loc)

/obj/effect/landmark/costume/nyangirl/make_costumes()
	new /obj/item/clothing/under/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)

/obj/effect/landmark/costume/maid/make_costumes()
	new /obj/item/clothing/under/blackskirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/blindfold(src.loc)

/obj/effect/landmark/costume/butler/make_costumes()
	new /obj/item/clothing/accessory/wcoat/black(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)

/obj/effect/landmark/costume/prig/make_costumes()
	new /obj/item/clothing/accessory/wcoat/black(src.loc)
	new /obj/item/clothing/glasses/eyepatch/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/color/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)

/obj/effect/landmark/costume/plaguedoctor/make_costumes()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)

/obj/effect/landmark/costume/nightowl/make_costumes()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)

/obj/effect/landmark/costume/waiter/make_costumes()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/apron(src.loc)

/obj/effect/landmark/costume/pirate/make_costumes()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/mask/bandana/red)
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)

/obj/effect/landmark/costume/commie/make_costumes()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)

/obj/effect/landmark/costume/imperium_monk/make_costumes()
	new /obj/item/clothing/suit/imperium_monk(src.loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(src.loc)

/obj/effect/landmark/costume/holiday_priest/make_costumes()
	new /obj/item/clothing/suit/holidaypriest(src.loc)

/obj/effect/landmark/costume/marisawizard/fake/make_costumes()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)

/obj/effect/landmark/costume/cutewitch/make_costumes()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)

/obj/effect/landmark/costume/fakewizard/make_costumes()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)

/obj/effect/landmark/costume/sexyclown/make_costumes()
	new /obj/item/clothing/mask/gas/sexyclown(src.loc)
	new /obj/item/clothing/under/sexyclown(src.loc)

/obj/effect/landmark/costume/sexymime/make_costumes()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)

/obj/effect/landmark/costume/savagehunter/make_costumes()
	new /obj/item/clothing/mask/spirit(src.loc)
	new /obj/item/clothing/under/savage_hunter(src.loc)

/obj/effect/landmark/costume/savagehuntress/make_costumes()
	new /obj/item/clothing/mask/spirit(src.loc)
	new /obj/item/clothing/under/savage_hunter/female(src.loc)

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/Initialize(mapload, my_ruin_template)
	name = "ruin_[sequential_id(/obj/effect/landmark/ruin)]"
	. = ..()
	ruin_template = my_ruin_template
	global.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	global.ruin_landmarks -= src
	ruin_template = null
	. = ..()
