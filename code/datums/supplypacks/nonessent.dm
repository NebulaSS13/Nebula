/decl/hierarchy/supply_pack/nonessent
	name = "Non-essentials"

/decl/hierarchy/supply_pack/nonessent/painters
	name = "Art - Painting Supplies"
	contains = list(/obj/item/paint_sprayer = 2,
					/obj/item/cable_painter = 2)
	containername = "painting supplies crate"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/nonessent/artscrafts
	name = "Art - Arts and Crafts supplies"
	contains = list(
		/obj/item/box/fancy/crayons,
		/obj/item/camera,
		/obj/item/camera_film = 2,
		/obj/item/photo_album,
		/obj/item/chems/glass/bucket/paint/red,
		/obj/item/chems/glass/bucket/paint/green,
		/obj/item/chems/glass/bucket/paint/blue,
		/obj/item/chems/glass/bucket/paint/yellow,
		/obj/item/chems/glass/bucket/paint/purple,
		/obj/item/chems/glass/bucket/paint/black,
		/obj/item/chems/glass/bucket/paint/white,
		/obj/item/poster,
		/obj/item/stack/package_wrap/fifty      = 2,
		/obj/item/stack/package_wrap/gift/fifty = 2
	)
	containername = "arts and crafts crate"


/decl/hierarchy/supply_pack/nonessent/card_packs
	num_contained = 5
	contains = list(/obj/item/pack/cardemon,
					/obj/item/pack/spaceball,
					/obj/item/deck/holder)
	name = "Rec - Trading Cards"
	containername = "trading cards crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/lasertag
	name = "Rec - Lasertag equipment"
	contains = list(/obj/item/gun/energy/lasertag/red = 3,
					/obj/item/clothing/suit/redtag = 3,
					/obj/item/gun/energy/lasertag/blue = 3,
					/obj/item/clothing/suit/bluetag = 3)
	containertype = /obj/structure/closet
	containername = "lasertag Closet"

/decl/hierarchy/supply_pack/nonessent/instruments
	name = "Rec - Musical Instruments"
	contains = list(/obj/item/synthesized_instrument/synthesizer,
					/obj/item/synthesized_instrument/guitar/multi,
					/obj/item/synthesized_instrument/trumpet)
	containername = "musical instrument crate"


/decl/hierarchy/supply_pack/nonessent/llamps
	num_contained = 3
	contains = list(/obj/item/flashlight/lamp/lava,
					/obj/item/flashlight/lamp/lava/red,
					/obj/item/flashlight/lamp/lava/orange,
					/obj/item/flashlight/lamp/lava/yellow,
					/obj/item/flashlight/lamp/lava/green,
					/obj/item/flashlight/lamp/lava/cyan,
					/obj/item/flashlight/lamp/lava/blue,
					/obj/item/flashlight/lamp/lava/purple,
					/obj/item/flashlight/lamp/lava/pink)
	name = "Deco - Lava lamps"
	containername = "lava lamp crate"
	supply_method = /decl/supply_method/randomized


/decl/hierarchy/supply_pack/nonessent/wizard
	name = "Costume - Wizard"
	contains = list(/obj/item/staff/crystal,
					/obj/item/clothing/suit/wizrobe,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/beard)
	containername = "wizard costume crate"

/decl/hierarchy/supply_pack/nonessent/costume
	num_contained = 2
	contains = list(/obj/item/clothing/suit/pirate,
					/obj/item/clothing/suit/judgerobe,
					/obj/item/clothing/suit/jacket/waistcoat/black,
					/obj/item/clothing/suit/hastur,
					/obj/item/clothing/suit/holidaypriest,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/suit/imperium_monk,
					/obj/item/clothing/suit/ianshirt,
					/obj/item/clothing/costume/captain_suit,
					/obj/item/clothing/costume/head_of_personnel_suit,
					/obj/item/clothing/pants/slacks/purple,
					/obj/item/clothing/shirt/button,
					/obj/item/clothing/suit/jacket/vest/black,
					/obj/item/clothing/costume/mailman,
					/obj/item/clothing/dress/saloon,
					/obj/item/clothing/suspenders,
					/obj/item/clothing/suit/toggle/labcoat/mad,
					/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
					/obj/item/clothing/costume/schoolgirl,
					/obj/item/clothing/costume/owl,
					/obj/item/clothing/pants/slacks/black,
					/obj/item/clothing/shirt/button,
					/obj/item/clothing/neck/tie/bow/red,
					/obj/item/clothing/suit/jacket/vest/blue,
					/obj/item/clothing/costume/gladiator,
					/obj/item/clothing/costume/soviet,
					/obj/item/clothing/costume/scratch,
					/obj/item/clothing/dress/wedding/bride_white,
					/obj/item/clothing/suit/chef,
					/obj/item/clothing/suit/apron/overalls,
					/obj/item/clothing/costume/redcoat,
					/obj/item/clothing/costume/kilt,
					/obj/item/clothing/costume/savage_hunter,
					/obj/item/clothing/costume/savage_hunter/female,
					/obj/item/clothing/costume/wetsuit)
	name = "Costume - Random"
	containername = "actor costumes crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/formal_wear
	contains = list(
		/obj/item/clothing/head/bowler,
		/obj/item/clothing/head/that,
		/obj/item/clothing/suit/jacket,
		/obj/item/clothing/suit/jacket/blue,
		/obj/item/clothing/suit/jacket/purple,
		/obj/item/clothing/suit/jacket/black,
		/obj/item/clothing/suit/jacket/burgundy,
		/obj/item/clothing/suit/jacket/waistcoat,
		/obj/item/clothing/costume/lawyer_bluesuit,
		/obj/item/clothing/pants/slacks/purple,
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/suit/jacket/vest/black,
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/shoes/craftable
	)
	name = "Costume - Formalwear"
	containertype = /obj/structure/closet
	containername = "formalwear for the best occasions."


/decl/hierarchy/supply_pack/nonessent/hats
	num_contained = 4
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	name = "Costume - Collectible hats!"
	containername = "\improper Collectable hats crate! Brought to you by Bass.inc!"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/witch
	name = "Costume - Witch"
	contains = list(/obj/item/clothing/suit/wizrobe/marisa,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/marisa,
					/obj/item/staff/broom)
	containername = "witch costume crate"
	containertype = /obj/structure/closet

/decl/hierarchy/supply_pack/nonessent/costume_hats
	name = "Costume - Regular hats"
	contains = list(/obj/item/clothing/head/redcoat,
					/obj/item/clothing/head/plaguedoctorhat,
					/obj/item/clothing/head/pirate,
					/obj/item/clothing/head/hasturhood,
					/obj/item/clothing/head/powdered_wig,
					/obj/item/clothing/head/hairflower,
					/obj/item/clothing/head/hairflower/yellow,
					/obj/item/clothing/head/hairflower/blue,
					/obj/item/clothing/head/hairflower/pink,
					/obj/item/clothing/mask/gas/owl_mask,
					/obj/item/clothing/mask/gas/monkeymask,
					/obj/item/clothing/head/helmet/gladiator,
					/obj/item/clothing/head/ushanka,
					/obj/item/clothing/mask/spirit)
	containername = "actor hats crate"
	containertype = /obj/structure/closet
	num_contained = 2
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/nonessent/dresses
	name = "Costume - Womens formal dress locker"
	contains = list(/obj/item/clothing/dress/wedding/bride_orange,
					/obj/item/clothing/dress/wedding/bride_purple,
					/obj/item/clothing/dress/wedding/bride_blue,
					/obj/item/clothing/dress/wedding/bride_red,
					/obj/item/clothing/dress/wedding/bride_white,
					/obj/item/clothing/dress/sun,
					/obj/item/clothing/dress/green,
					/obj/item/clothing/dress/pink,
					/obj/item/clothing/dress/orange,
					/obj/item/clothing/dress/yellow,
					/obj/item/clothing/dress/saloon)
	containername = "pretty dress locker"
	containertype = /obj/structure/closet
	num_contained = 1
	supply_method = /decl/supply_method/randomized



/decl/hierarchy/supply_pack/nonessent/officetoys
	name = "Deco - Office toys"
	contains = list(/obj/item/toy/desk/newtoncradle,
					/obj/item/toy/desk/fan,
					/obj/item/toy/desk/officetoy,
					/obj/item/toy/desk/dippingbird)
	containername = "office toys crate"

/decl/hierarchy/supply_pack/nonessent/chaplaingear
	name = "Costume - Chaplain"
	contains = list(/obj/item/clothing/jumpsuit/chaplain,
					/obj/item/clothing/shoes/color/black,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/head/nun_hood,
					/obj/item/clothing/suit/chaplain_hoodie,
					/obj/item/clothing/head/chaplain_hood,
					/obj/item/clothing/suit/holidaypriest,
					/obj/item/clothing/dress/wedding/bride_white,
					/obj/item/box/candles = 3)
	containername = "chaplain equipment crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_ripl3
	name = "Mod - \"Firestarter\" exosuit modkit"
	contains = list(/obj/item/kit/paint/flames_red)
	containername = "heavy exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/exosuit_mod_ripl4
	num_contained = 1
	name = "Mod - \"Burning Chrome\" exosuit modkit"
	contains = list(/obj/item/kit/paint/flames_blue)
	containername = "heavy exosuit modkit crate"

/decl/hierarchy/supply_pack/nonessent/aromatherapy
	name = "Rec - Aromatherapy"
	contains = list(
		/obj/item/paper/aromatherapy_disclaimer,
		/obj/item/box/candles/scented = 3,
		/obj/item/box/candles/incense = 6,
		/obj/item/flame/fuelled/lighter/random)
	containername = "aromatherapy crate"
