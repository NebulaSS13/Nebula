/obj/random/minevault
	name = "random vault loot"
	desc = "Loot for mine vaults."
	icon = /obj/structure/closet/crate/large::icon
	icon_state = /obj/structure/closet/crate/large::icon_state

/obj/random/minevault/spawn_choices()
	var/static/list/spawnable_choices = list(
		list(
			/obj/item/clothing/mask/smokable/pipe,
			/obj/item/chems/drinks/bottle/rum,
			/obj/item/chems/drinks/bottle/whiskey,
			/obj/item/food/grown/ambrosiadeus,
			/obj/item/flame/fuelled/lighter/zippo,
			/obj/structure/closet/crate/hydroponics
		) = 5,
		list(
			/obj/item/tool/drill,
			/obj/item/clothing/suit/space/void/mining,
			/obj/item/clothing/head/helmet/space/void/mining,
			/obj/structure/closet/crate/engineering
		) = 5,
		list(
			/obj/item/tool/drill,
			/obj/item/clothing/suit/space/void/mining/alt,
			/obj/item/clothing/head/helmet/space/void/mining/alt,
			/obj/structure/closet/crate/engineering
		) = 5,
		list(
			/obj/item/chems/glass/beaker/advanced,
			/obj/item/chems/glass/beaker/advanced,
			/obj/item/chems/glass/beaker/advanced,
			/obj/structure/closet/crate/science
		) = 5,
		list(
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/diamond,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/item/stack/material/ore/gold,
			/obj/structure/closet/crate/engineering
		) = 5,
		list(
			/obj/item/tool/drill,
			/obj/item/clothing/glasses/material,
			/obj/structure/ore_box,
			/obj/structure/closet/crate
		) = 5,
		list(
			/obj/item/chems/glass/beaker/noreact,
			/obj/item/chems/glass/beaker/noreact,
			/obj/item/chems/glass/beaker/noreact,
			/obj/structure/closet/crate/science
		) = 5,
		list(
			/obj/item/secure_storage/briefcase/money,
			/obj/structure/closet/crate/plastic/rations
		) = 5,
		list(
			/obj/item/clothing/neck/tie/horrible,
			/obj/item/clothing/neck/tie/horrible,
			/obj/item/clothing/neck/tie/horrible,
			/obj/item/clothing/neck/tie/horrible,
			/obj/item/clothing/neck/tie/horrible,
			/obj/item/clothing/neck/tie/horrible,
			/obj/structure/closet/crate
		) = 5,
		list(
			/obj/item/baton,
			/obj/item/baton,
			/obj/item/baton,
			/obj/item/baton,
			/obj/structure/closet/crate
		) = 5,
		list(
			/obj/item/clothing/pants/shorts/athletic/red,
			/obj/item/clothing/pants/shorts/athletic/blue,
			/obj/structure/closet/crate
		) = 5,
		list(
			/obj/item/baton/cattleprod,
			/obj/item/baton/cattleprod,
			/obj/item/cell/high,
			/obj/item/cell/high,
			/obj/structure/closet/crate
		) = 2,
		list(
			/obj/item/toy/balloon,
			/obj/item/toy/balloon/nanotrasen,
			/obj/structure/closet/crate
		) = 2,
		list(
			/obj/item/toy/balloon,
			/obj/item/toy/balloon,
			/obj/structure/closet/crate
		) = 2,
		list(
			/obj/item/rig/industrial/equipped,
			/obj/item/ore_satchel,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/clothing/head/kitty,
			/obj/item/clothing/head/kitty,
			/obj/item/clothing/head/kitty,
			/obj/item/clothing/head/kitty,
			/obj/structure/closet/crate
		) = 2,
		list(
			/obj/random/coin,
			/obj/random/coin,
			/obj/random/coin,
			/obj/random/coin,
			/obj/random/coin,
			/obj/structure/closet/crate/plastic
		) = 2,
		list(
			/obj/random/voidsuit,
			/obj/random/voidsuit,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/clothing/suit/space/syndicate/black/red,
			/obj/item/clothing/head/helmet/space/syndicate/black/red,
			/obj/item/clothing/suit/space/syndicate/black/red,
			/obj/item/clothing/head/helmet/space/syndicate/black/red,
			/obj/item/gun/projectile/automatic/smg/uzi,
			/obj/item/gun/projectile/automatic/smg/uzi,
			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/smg/empty,
			/obj/item/ammo_magazine/smg/empty,
			/obj/structure/closet/crate/plastic
		) = 2,
		list(
			/obj/item/clothing/suit/ianshirt,
			/obj/item/clothing/suit/ianshirt,
			/obj/item/bedsheet/ian,
			/obj/structure/closet/crate/plastic
		) = 2,
		list(
			/obj/item/clothing/suit/armor/vest,
			/obj/item/clothing/suit/armor/vest,
			/obj/item/gun/projectile/bolt_action,
			/obj/item/gun/projectile/bolt_action,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/item/ammo_casing/rifle,
			/obj/structure/closet/crate/plastic
		) = 2,
		list(
			/mob/living/exosuit/premade/powerloader/old
		) = 4,
		list(
			/obj/item/tool/pickaxe/titanium,
			/obj/item/ore_satchel,
			/obj/item/clothing/glasses/material,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/tool/drill,
			/obj/item/ore_satchel,
			/obj/item/clothing/glasses/material,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/tool/hammer/jack,
			/obj/item/ore_satchel,
			/obj/item/clothing/glasses/material,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/tool/pickaxe/titanium,
			/obj/item/ore_satchel,
			/obj/item/clothing/glasses/material,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/tool/drill/diamond,
			/obj/item/ore_satchel,
			/obj/item/clothing/glasses/material,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/tool/pickaxe,
			/obj/item/ore_satchel,
			/obj/item/clothing/glasses/material,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/gun/energy/plasmacutter,
			/obj/item/ore_satchel,
			/obj/item/clothing/glasses/material,
			/obj/structure/closet/crate/engineering
		) = 2,
		list(
			/obj/item/sword/katana,
			/obj/item/sword/katana,
			/obj/structure/closet/crate
		) = 2,
		list(
			/obj/item/sword,
			/obj/item/sword,
			/obj/structure/closet/crate
		) = 2,
		list(
			/obj/item/clothing/mask/balaclava,
			/obj/item/star,
			/obj/item/star,
			/obj/item/star,
			/obj/item/star,
			/obj/structure/closet/crate
		) = 1,
		list(
			/obj/item/clothing/head/bearpelt,
			/obj/item/clothing/costume/soviet,
			/obj/item/clothing/costume/soviet,
			/obj/item/gun/projectile/bolt_action,
			/obj/item/gun/projectile/bolt_action,
			/obj/structure/closet/crate
		) = 1,
		list(
			/obj/item/gun/projectile/revolver,
			/obj/item/gun/projectile/revolver,
			/obj/item/gun/projectile/pistol,
			/obj/item/gun/projectile/pistol,
			/obj/structure/closet/crate
		) = 1,
		list(
			/obj/item/sword/cultblade,
			/obj/item/clothing/suit/cultrobes,
			/obj/item/clothing/head/culthood,
			/obj/item/soulstone,
			/obj/structure/closet/crate
		) = 1,
		list(
			/obj/item/vampiric,
			/obj/item/vampiric,
			/obj/structure/closet/crate/science
		) = 1,
		list(
			/obj/item/energy_blade/sword,
			/obj/item/energy_blade/sword,
			/obj/item/energy_blade/sword,
			/obj/item/shield/energy,
			/obj/item/shield/energy,
			/obj/structure/closet/crate/science
		) = 1,
		list(
			/obj/item/backpack/clown,
			/obj/item/clothing/costume/clown,
			/obj/item/clothing/shoes/clown_shoes,
			/obj/item/clothing/mask/gas/clown_hat,
			/obj/item/bikehorn,
			/obj/item/chems/spray/waterflower,
			/obj/item/pen/crayon/rainbow,
			/obj/structure/closet/crate
		) = 1,
		list(
			/obj/item/clothing/costume/mime,
			/obj/item/clothing/shoes/color/black,
			/obj/item/clothing/gloves,
			/obj/item/clothing/mask/gas/mime,
			/obj/item/clothing/head/beret,
			/obj/item/clothing/suspenders,
			/obj/item/pen/crayon/mime,
			/obj/structure/closet/crate
		) = 1,
		list(
			/obj/item/belt/champion,
			/obj/item/clothing/mask/luchador,
			/obj/item/clothing/mask/luchador/rudos,
			/obj/item/clothing/mask/luchador/tecnicos,
			/obj/structure/closet/crate
		) = 1,
		list(
			/obj/structure/artifact,
			/obj/structure/anomaly_container
		) = 1,
		list(
			/obj/random/psionic,
			/obj/random/humanoidremains,
			/obj/structure/closet/crate
		)
	)
	return spawnable_choices

/obj/random/helmet
	name = "Random Armour Helmet"
	desc = "This is a random helmet that protects your head."

/obj/random/helmet/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/head/helmet                             = 30,
		/obj/item/clothing/head/helmet/merc                        = 10,
		/obj/item/clothing/head/helmet/riot                        = 15,
	)
	return spawnable_choices

/obj/random/helmet/highend
	desc = "This is a random actually good helmet that protects your head."

/obj/random/helmet/highend/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/clothing/head/helmet/merc                 = 10,
	)
	return spawnable_choices
