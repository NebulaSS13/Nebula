/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/box
	name = "box"
	desc = "It's just an ordinary box."
	icon = 'icons/obj/items/storage/box.dmi'
	icon_state = "box"
	item_state = "syringe_kit"
	material = /decl/material/solid/organic/cardboard
	obj_flags = OBJ_FLAG_HOLLOW
	storage = /datum/storage/box
	var/foldable = /obj/item/stack/material/cardstock

/obj/item/box/large
	name = "large box"
	icon_state = "largebox"
	w_class = ITEM_SIZE_LARGE
	storage = /datum/storage/box/large

/obj/item/box/union_cards
	name = "box of union cards"
	desc = "A box of spare unsigned union membership cards."

/obj/item/box/union_cards/WillContain()
	return list(/obj/item/card/union = 7)

/obj/item/box/large/union_cards
	name = "large box of union cards"
	desc = "A large box of spare unsigned union membership cards."

/obj/item/box/large/union_cards/WillContain()
	return list(/obj/item/card/union = 14)

// BubbleWrap - A box can be folded up to make card
/obj/item/box/attack_self(mob/user)
	. = ..()
	if(. || length(contents) || !ispath(foldable) || !istype(material))
		return TRUE
	var/sheet_amount = floor(LAZYACCESS(matter, material.type) / SHEET_MATERIAL_AMOUNT)
	if(sheet_amount <= 0 || !user.try_unequip(src))
		return TRUE
	to_chat(user, SPAN_NOTICE("You fold \the [src] flat."))
	if(ispath(foldable, /obj/item/stack))
		new foldable(get_turf(src), sheet_amount, material.type)
	else
		new foldable(get_turf(src), material.type)
	qdel(src)
	return TRUE

/obj/item/box/survival
	name = "crew survival kit"
	desc = "A box decorated in warning colors that contains a limited supply of survival tools. The panel and white stripe indicate this one contains oxygen."
	icon_state = "survival"

/obj/item/box/survival/WillContain()
	return list(
				/obj/item/clothing/mask/breath,
				/obj/item/tank/emergency/oxygen,
				/obj/item/chems/hypospray/autoinjector/stabilizer,
				/obj/item/stack/medical/bandage,
				/obj/item/flashlight/flare/glowstick,
				/obj/item/food/candy/proteinbar,
				/obj/item/oxycandle,
				/obj/item/crowbar/cheap
			)

/obj/item/box/engineer
	name = "engineer survival kit"
	desc = "A box decorated in warning colors that contains a limited supply of survival tools. The panel and orange stripe indicate this one as the engineering variant."
	icon_state = "survivaleng"

/obj/item/box/engineer/WillContain()
	return list(
				/obj/item/clothing/mask/breath/scba,
				/obj/item/tank/emergency/oxygen/engi,
				/obj/item/chems/hypospray/autoinjector/stabilizer,
				/obj/item/chems/hypospray/autoinjector/antirad,
				/obj/item/stack/medical/bandage,
				/obj/item/flashlight/flare/glowstick,
				/obj/item/food/candy/proteinbar,
				/obj/item/oxycandle
			)

/obj/item/box/gloves
	name = "box of sterile gloves"
	desc = "Contains sterile gloves."
	icon_state = "latex"

/obj/item/box/gloves/WillContain()
	return list(
				/obj/item/clothing/gloves/latex = 5,
				/obj/item/clothing/gloves/latex/nitrile = 2
			)

/obj/item/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"

/obj/item/box/masks/WillContain()
	return list(/obj/item/clothing/mask/surgical = 7)


/obj/item/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	icon_state = "syringe"

/obj/item/box/syringes/WillContain()
	return list(/obj/item/chems/syringe = 7)

/obj/item/box/syringegun
	name = "box of syringe gun cartridges"
	desc = "A box full of compressed gas cartridges."
	icon_state = "syringe"

/obj/item/box/syringegun/WillContain()
	return list(/obj/item/syringe_cartridge = 7)


/obj/item/box/beakers
	name = "box of beakers"
	icon_state = "beaker"

/obj/item/box/beakers/WillContain()
	return list(/obj/item/chems/glass/beaker = 7)

/obj/item/box/beakers/insulated
	name = "box of insulated beakers"

/obj/item/box/beakers/insulated/WillContain()
	return list(/obj/item/chems/glass/beaker/insulated = 7)

/obj/item/box/ammo
	name = "ammo box"
	icon = 'icons/obj/items/storage/ammobox.dmi'
	icon_state = "ammo"
	desc = "A sturdy metal box with several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	storage = /datum/storage/box/metal

/obj/item/box/ammo/blanks
	name = "box of blank shells"
	desc = "It has a picture of a gun and several warning symbols on the front."

/obj/item/box/ammo/blanks/WillContain()
	return list(/obj/item/ammo_casing/shotgun/blank = 8)

/obj/item/box/ammo/practiceshells
	name = "box of practice shells"
/obj/item/box/ammo/practiceshells/WillContain()
	return list(/obj/item/ammo_casing/shotgun/practice = 8)

/obj/item/box/ammo/beanbags
	name = "box of beanbag shells"
/obj/item/box/ammo/beanbags/WillContain()
	return list(/obj/item/ammo_magazine/shotholder/beanbag = 2)

/obj/item/box/ammo/shotgunammo
	name = "box of shotgun slugs"
/obj/item/box/ammo/shotgunammo/WillContain()
	return list(/obj/item/ammo_magazine/shotholder = 2)

/obj/item/box/ammo/shotgunammo/large/WillContain()
	return list(/obj/item/ammo_magazine/shotholder = 4)

/obj/item/box/ammo/shotgunshells
	name = "box of shotgun shells"
/obj/item/box/ammo/shotgunshells/WillContain()
	return list(/obj/item/ammo_magazine/shotholder/shell = 2)

/obj/item/box/ammo/flashshells
	name = "box of illumination shells"
/obj/item/box/ammo/flashshells/WillContain()
	return list(/obj/item/ammo_magazine/shotholder/flash = 2)

/obj/item/box/ammo/stunshells
	name = "box of stun shells"
/obj/item/box/ammo/stunshells/WillContain()
	return list(/obj/item/ammo_magazine/shotholder/stun = 2)

/obj/item/box/ammo/stunshells/large/WillContain()
	return list(/obj/item/ammo_magazine/shotholder/stun = 4)

/obj/item/box/ammo/sniperammo
	name = "box of sniper shells"
/obj/item/box/ammo/sniperammo/WillContain()
	return list(/obj/item/ammo_casing/shell = 7)

/obj/item/box/ammo/sniperammo/apds
	name = "box of sniper APDS shells"
/obj/item/box/ammo/sniperammo/apds/WillContain()
	return list(/obj/item/ammo_casing/shell/apds = 3)

/obj/item/box/flashbangs
	name = "box of flashbangs"
	desc = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING: These devices are extremely dangerous and can cause blindness or deafness from repeated use."
	icon_state = "flashbang"
/obj/item/box/flashbangs/WillContain()
	return list(/obj/item/grenade/flashbang = 7)

/obj/item/box/teargas
	name = "box of pepperspray grenades"
	desc = "A box containing 7 tear gas grenades. A gas mask is printed on the label.<br> WARNING: Exposure carries risk of serious injury or death. Keep away from persons with lung conditions."
	icon_state = "flashbang"
/obj/item/box/teargas/WillContain()
	return list(/obj/item/grenade/chem_grenade/teargas = 7)

/obj/item/box/emps
	name = "box of EMP grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "flashbang"
/obj/item/box/emps/WillContain()
	return list(/obj/item/grenade/empgrenade = 5)

/obj/item/box/empslite
	name = "box of low-yield EMP grenades"
	desc = "A box containing 5 low yield EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "flashbang"
/obj/item/box/empslite/WillContain()
	return list(/obj/item/grenade/empgrenade/low_yield = 5)

/obj/item/box/frags
	name = "box of frag grenades"
	desc = "A box containing 5 military grade fragmentation grenades.<br> WARNING: Live explosives. Misuse may result in serious injury or death."
	icon_state = "flashbang"
/obj/item/box/frags/WillContain()
	return list(/obj/item/grenade/frag = 5)

/obj/item/box/fragshells
	name = "box of frag shells"
	desc = "A box containing 5 military grade fragmentation shells.<br> WARNING: Live explosive munitions. Misuse may result in serious injury or death."
	icon_state = "flashbang"
/obj/item/box/fragshells/WillContain()
	return list(/obj/item/grenade/frag/shell = 5)

/obj/item/box/smokes
	name = "box of smoke bombs"
	desc = "A box containing 5 smoke bombs."
	icon_state = "flashbang"
/obj/item/box/smokes/WillContain()
	return list(/obj/item/grenade/smokebomb = 5)

/obj/item/box/metalfoam
	name = "box of metal foam grenades"
	desc = "A box containing 5 metal foam grenades."
	icon_state = "flashbang"
/obj/item/box/metalfoam/WillContain()
	return list(/obj/item/grenade/chem_grenade/metalfoam = 5)

/obj/item/box/anti_photons
	name = "box of anti-photon grenades"
	desc = "A box containing 5 experimental photon disruption grenades."
	icon_state = "flashbang"
/obj/item/box/anti_photons/WillContain()
	return list(/obj/item/grenade/anti_photon = 5)

/obj/item/box/supermatters
	name = "box of supermatter grenades"
	desc = "A box containing 5 highly experimental supermatter grenades."
	icon_state = "radbox"
/obj/item/box/supermatters/WillContain()
	return list(/obj/item/grenade/supermatter = 5)

/obj/item/box/decompilers
	name = "box of decompiler grenades"
	desc = "A box containing 5 experimental decompiler grenades."
	icon_state = "flashbang"
/obj/item/box/decompilers/WillContain()
	return list(/obj/item/grenade/decompiler = 5)

/obj/item/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"
/obj/item/box/trackimp/WillContain()
	return list(/obj/item/implantcase/tracking = 4,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1)

/obj/item/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"
/obj/item/box/chemimp/WillContain()
	return list(/obj/item/implantcase/chem = 5,
					/obj/item/implanter = 1,
					/obj/item/implantpad = 1)

/obj/item/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"
/obj/item/box/rxglasses/WillContain()
	return list(/obj/item/clothing/glasses/prescription = 7)

/obj/item/box/cdeathalarm_kit
	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "syringe_kit"
/obj/item/box/cdeathalarm_kit/WillContain()
	return list(/obj/item/implanter = 1,
				/obj/item/implantcase/death_alarm = 6)

/obj/item/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
/obj/item/box/condimentbottles/WillContain()
	return list(/obj/item/chems/condiment = 6)

/obj/item/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."
/obj/item/box/cups/WillContain()
	return list(/obj/item/chems/drinks/sillycup = 7)

/obj/item/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
/obj/item/box/donkpockets/WillContain()
	return list(/obj/item/food/donkpocket = 6)

/obj/item/box/sinpockets
	name = "box of sin-pockets"
	desc = "<B>Instructions:</B> <I>Crush bottom of package to initiate chemical heating. Wait for 20 seconds before consumption. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
/obj/item/box/sinpockets/WillContain()
	return list(/obj/item/food/donkpocket/sinpocket = 6)

//cubed animals

/obj/item/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	storage = /datum/storage/box/monkey

/obj/item/box/monkeycubes/WillContain()
	return list(/obj/item/food/monkeycube/wrapped = 5)

/obj/item/box/monkeycubes/spidercubes
	name = "spiderling cube box"
	desc = "Drymate brand Instant spiders. WHY WOULD YOU ORDER THIS!?"
/obj/item/box/monkeycubes/spidercubes/WillContain()
	return list(/obj/item/food/monkeycube/wrapped/spidercube = 5)

/obj/item/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"

/obj/item/box/ids/WillContain()
	return list(/obj/item/card/id = 7)

/obj/item/box/large/ids
	name = "box of spare IDs"
	desc = "Has so, so many empty IDs."
	icon_state = "id_large"

/obj/item/box/large/ids/WillContain()
	return list(/obj/item/card/id = 14)

/obj/item/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"

/obj/item/box/handcuffs/WillContain()
	return list(/obj/item/handcuffs = 7)

/obj/item/box/mousetraps
	name = "box of Pest-B-Gon rat traps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."

/obj/item/box/mousetraps/WillContain()
	return list(/obj/item/assembly/mousetrap = 6)

/obj/item/box/mousetraps/empty/WillContain()
	return null

/obj/item/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."

/obj/item/box/pillbottles/WillContain()
	return list(/obj/item/pill_bottle = 7)

/obj/item/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy/toy.dmi'
	icon_state = "spbox"
	storage = /datum/storage/box/snappop

/obj/item/box/snappops/WillContain()
	return list(/obj/item/toy/snappop = 8)

/obj/item/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	icon_state = "syringe"

/obj/item/box/autoinjectors/WillContain()
	return list(/obj/item/chems/hypospray/autoinjector/stabilizer = 7)

/obj/item/box/lights
	name = "box of replacement bulbs"
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	storage = /datum/storage/box/lights

/obj/item/box/lights/Initialize(ml, material_key)
	. = ..()
	if(length(contents) && storage)
		storage.make_exact_fit()

/obj/item/box/lights/bulbs/WillContain()
	return list(/obj/item/light/bulb = 21)

/obj/item/box/lights/bulbs/empty/WillContain()
	return null

/obj/item/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"
/obj/item/box/lights/tubes/WillContain()
	return list(
			/obj/item/light/tube       = 17,
			/obj/item/light/tube/large = 4
		)

/obj/item/box/lights/tubes/random
	name = "box of replacement tubes -- party pack"
	icon_state = "lighttube"
/obj/item/box/lights/tubes/random/WillContain()
	return list(
			/obj/item/light/tube/party       = 17,
			/obj/item/light/tube/large/party = 4
		)

/obj/item/box/lights/tubes/empty/WillContain()
	return null

/obj/item/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"
/obj/item/box/lights/mixed/WillContain()
	return list(
			/obj/item/light/tube       = 12,
			/obj/item/light/tube/large = 4,
			/obj/item/light/bulb       = 5
		)

/obj/item/box/lights/mixed/empty/WillContain()
	return null

/obj/item/box/glowsticks
	name = "box of mixed glowsticks"
	icon_state = "box"
/obj/item/box/glowsticks/WillContain()
	return list(
			/obj/item/flashlight/flare/glowstick        = 1,
			/obj/item/flashlight/flare/glowstick/red    = 1,
			/obj/item/flashlight/flare/glowstick/blue   = 1,
			/obj/item/flashlight/flare/glowstick/orange = 1,
			/obj/item/flashlight/flare/glowstick/yellow = 1,
			/obj/item/flashlight/flare/glowstick/random = 1
		)

/obj/item/box/greenglowsticks
	name = "box of green glowsticks"
	icon_state = "box"
/obj/item/box/greenglowsticks/WillContain()
	return list(/obj/item/flashlight/flare/glowstick = 6)

/obj/item/box/flares
	name = "box of flares"
	icon_state = "box"

/obj/item/box/flares/WillContain()
	return list(/obj/item/flashlight/flare = 6)

/obj/item/box/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/items/storage/portafreezer.dmi'
	icon_state = "portafreezer"
	item_state = "medicalpack"
	foldable = null
	storage = /datum/storage/box/freezer
	w_class = ITEM_SIZE_LARGE
	temperature = -16 CELSIUS

/obj/item/box/freezer/ProcessAtomTemperature()
	return PROCESS_KILL

/obj/item/box/checkers
	name = "checkers box"
	desc = "This box holds a nifty portion of checkers. Foam-shaped on the inside so that only checkers may fit."
	icon_state = "checkers"
	storage = /datum/storage/box/checkers
	foldable = null

/obj/item/box/checkers/WillContain()
	return list(
			/obj/item/checker = 12,
			/obj/item/checker/red = 12
		)

/obj/item/box/checkers/chess
	name = "black chess box"
	desc = "This box holds all the pieces needed for the black side of the chess board."
	icon_state = "chess_b"
/obj/item/box/checkers/chess/WillContain()
	return list(
			/obj/item/checker/pawn   = 8,
			/obj/item/checker/knight = 2,
			/obj/item/checker/bishop = 2,
			/obj/item/checker/rook   = 2,
			/obj/item/checker/queen  = 1,
			/obj/item/checker/king   = 1
		)

/obj/item/box/checkers/chess/red
	name = "red chess box"
	desc = "This box holds all the pieces needed for the red side of the chess board."
	icon_state = "chess_r"
/obj/item/box/checkers/chess/red/WillContain()
	return list(
			/obj/item/checker/pawn/red   = 8,
			/obj/item/checker/knight/red = 2,
			/obj/item/checker/bishop/red = 2,
			/obj/item/checker/rook/red   = 2,
			/obj/item/checker/queen/red  = 1,
			/obj/item/checker/king/red   = 1
		)


/obj/item/box/headset
	name = "box of spare headsets"
	desc = "A box full of headsets."
/obj/item/box/headset/WillContain()
	return list(/obj/item/radio/headset = 7)

//Spare Armbands

/obj/item/box/armband/engine
	name = "box of spare engineering armbands"
	desc = "A box full of engineering armbands. For use in emergencies when provisional engineering peronnel are needed."
/obj/item/box/armband/engine/WillContain()
	return list(/obj/item/clothing/armband/engine = 5)

/obj/item/box/armband/med
	name = "box of spare medical armbands"
	desc = "A box full of medical armbands. For use in emergencies when provisional medical personnel are needed."
/obj/item/box/armband/med/WillContain()
	return list(/obj/item/clothing/armband/med = 5)

/obj/item/box/imprinting
	name = "box of education implants"
	desc = "A box full of neural implants for on-job training."
/obj/item/box/imprinting/WillContain()
	return list(
		/obj/item/implanter,
		/obj/item/implantpad,
		/obj/item/implantcase/imprinting = 3
		)

/obj/item/box/detergent
	name = "detergent pods bag"
	desc = "A bag full of juicy, yummy detergent pods. This bag has been labeled: Tod Pods, a Waffle Co. product."
	icon = 'icons/obj/items/storage/detergent.dmi'
	icon_state = "detergent"
/obj/item/box/detergent/WillContain()
	return list(/obj/item/chems/pill/detergent = 10)

//cargosia supply boxes - Primarily for restocking

/obj/item/box/tapes
	name = "box of spare tapes"
	desc = "A box full of blank tapes."
/obj/item/box/tapes/WillContain()
	return list(/obj/item/magnetic_tape/random = 14)

/obj/item/box/taperolls
	name = "box of spare taperolls"
	desc = "A box full of mixed barricade tapes."
/obj/item/box/taperolls/WillContain()
	return list(
			/obj/item/stack/tape_roll/barricade_tape/police,
			/obj/item/stack/tape_roll/barricade_tape/engineering,
			/obj/item/stack/tape_roll/barricade_tape/atmos,
			/obj/item/stack/tape_roll/barricade_tape/research,
			/obj/item/stack/tape_roll/barricade_tape/medical,
			/obj/item/stack/tape_roll/barricade_tape/bureaucracy
		)

/obj/item/box/bogrolls
	name = "box of spare bogrolls"
	desc = "A box full of toilet paper."
/obj/item/box/bogrolls/WillContain()
	return list(/obj/item/stack/tape_roll/barricade_tape/toilet = 6)

/obj/item/box/cola
	name = "box of sodas"
	desc = "A box full of soda cans."
/obj/item/box/cola/WillContain()
	return list(/obj/item/chems/drinks/cans/cola = 7)

/obj/item/box/water
	name = "box of water bottles"
	desc = "A box full of bottled water."
/obj/item/box/water/WillContain()
	return list(/obj/item/chems/drinks/cans/waterbottle = 7)

/obj/item/box/cola/spacewind/WillContain()
	return list(/obj/item/chems/drinks/cans/space_mountain_wind = 7)

/obj/item/box/cola/drgibb/WillContain()
	return list(/obj/item/chems/drinks/cans/dr_gibb = 7)

/obj/item/box/cola/starkist/WillContain()
	return list(/obj/item/chems/drinks/cans/starkist = 7)

/obj/item/box/cola/spaceup/WillContain()
	return list(/obj/item/chems/drinks/cans/space_up = 7)

/obj/item/box/cola/lemonlime/WillContain()
	return list(/obj/item/chems/drinks/cans/lemon_lime = 7)

/obj/item/box/cola/icedtea/WillContain()
	return list(/obj/item/chems/drinks/cans/iced_tea = 7)

/obj/item/box/cola/grapejuice/WillContain()
	return list(/obj/item/chems/drinks/cans/grape_juice = 7)

/obj/item/box/cola/sodawater/WillContain()
	return list(/obj/item/chems/drinks/cans/sodawater = 7)

/obj/item/box/snack
	name = "box of snack food"
	desc = "A box full of snack foods."

/obj/item/box/snack/WillContain()
	return list(/obj/item/food/sosjerky = 7)

/obj/item/box/snack/noraisin/WillContain()
	return list(/obj/item/food/no_raisin = 7)

/obj/item/box/snack/cheesehonks/WillContain()
	return list(/obj/item/food/cheesiehonkers = 7)

/obj/item/box/snack/tastybread/WillContain()
	return list(/obj/item/food/tastybread = 7)

/obj/item/box/snack/candy/WillContain()
	return list(/obj/item/food/candy = 7)

/obj/item/box/snack/chips/WillContain()
	return list(/obj/item/food/chips = 7)

/obj/item/box/snack/buns/WillContain()
	return list(/obj/item/food/bun = 7)

//canned goods in cardboard
/obj/item/box/canned
	name = "box of canned food"
	desc = "A box full of canned foods."
/obj/item/box/canned/WillContain()
	return list(/obj/item/food/can/spinach = 1)

/obj/item/box/canned/beef/WillContain()
	return list(/obj/item/food/can/beef = 6)

/obj/item/box/canned/beans/WillContain()
	return list(/obj/item/food/can/beans = 6)

/obj/item/box/canned/tomato/WillContain()
	return list(/obj/item/food/can/tomato = 6)

// machinery stock parts
/obj/item/box/parts
	name = "assorted parts pack"
	icon = 'icons/obj/items/storage/part_pack.dmi'
	icon_state = "big"
	w_class = ITEM_SIZE_NORMAL

/obj/item/box/parts/WillContain()
	return list(
		/obj/item/stock_parts/power/apc/buildable = 3,
		/obj/item/stock_parts/console_screen = 2,
		/obj/item/stock_parts/matter_bin = 2
	)

/obj/item/box/parts_pack
	name = "parts pack"
	desc = "A densely-stuffed box containing some small eletrical parts."
	icon = 'icons/obj/items/storage/part_pack.dmi'
	icon_state = "part"
	w_class = ITEM_SIZE_SMALL
	storage = /datum/storage/box/parts_pack

/obj/item/box/parts_pack/Initialize(ml, material_key)
	setup_name()
	return ..()

/obj/item/box/parts_pack/proc/setup_name()
	var/list/cnt = WillContain()
	if((islist(cnt) || ispath(cnt)) && length(cnt))
		var/atom/movable/AM = ispath(cnt)? cnt : cnt[1]
		SetName("[initial(AM.name)] pack")

/obj/item/box/parts_pack/manipulator
	icon_state = "mainpulator"
/obj/item/box/parts_pack/manipulator/WillContain()
	return list(/obj/item/stock_parts/manipulator = 7)

/obj/item/box/parts_pack/laser
	icon_state = "laser"
/obj/item/box/parts_pack/laser/WillContain()
	return list(/obj/item/stock_parts/micro_laser = 7)

/obj/item/box/parts_pack/capacitor
	icon_state = "capacitor"
/obj/item/box/parts_pack/capacitor/WillContain()
	return list(/obj/item/stock_parts/capacitor = 7)

/obj/item/box/parts_pack/keyboard
	icon_state = "keyboard"
/obj/item/box/parts_pack/keyboard/WillContain()
	return list(/obj/item/stock_parts/keyboard = 7)
