///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

//#TODO: Maybe merge this with /obj/item/glass/bottle?
/obj/item/chems/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	force = 5

	drop_sound = 'sound/foley/bottledrop1.ogg'
	pickup_sound = 'sound/foley/bottlepickup1.ogg'

	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = TRUE //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it
	var/obj/item/chems/glass/rag/rag = null
	var/rag_underlay = "rag"
	var/stop_spin_bottle = FALSE //Gotta stop the rotation.

/obj/item/chems/drinks/bottle/Initialize()
	. = ..()
	if(isGlass)
		unacidable = TRUE
	else
		verbs -= .verb/spin_bottle

/obj/item/chems/drinks/bottle/Destroy()
	if(!QDELETED(rag))
		rag.dropInto(loc)
	rag = null
	return ..()

/obj/item/chems/drinks/bottle/on_reagent_change()
	return

//when thrown on impact, bottles smash and spill their contents
/obj/item/chems/drinks/bottle/throw_impact(atom/hit_atom, var/datum/thrownthing/TT)
	..()
	if(isGlass && TT.thrower && TT.thrower.a_intent != I_HELP)
		if(TT.speed > throw_speed || smash_check(TT.dist_travelled)) //not as reliable as smashing directly
			smash(loc, hit_atom)

/obj/item/chems/drinks/bottle/proc/smash_check(var/distance)
	if(!isGlass)
		return 0
	if(rag && rag.on_fire) // Molotovs should be somewhat reliable, they're a pain to make.
		return TRUE
	if(!smash_duration)
		return 0
	var/list/chance_table = list(95, 95, 90, 85, 75, 60, 40, 15) //starting from distance 0
	var/idx = max(distance + 1, 1) //since list indices start at 1
	if(idx > chance_table.len)
		return 0
	return prob(chance_table[idx])

/obj/item/chems/drinks/bottle/proc/smash(var/newloc, atom/against = null)

	// Dump reagents onto the turf.
	var/turf/T = against ? get_turf(against) : get_turf(newloc)
	if(reagents?.total_volume)
		visible_message(SPAN_DANGER("The contents of \the [src] splash all over \the [against || T]!"))
		reagents.splash(against || T, reagents.total_volume)
	if(!T)
		qdel(src)
		return

	// Propagate our fire source down to the lowest level we can.
	// Ignite any fuel or mobs we have spilled. TODO: generalize to
	// flame sources when traversing open space.
	if(rag)
		rag.dropInto(T)
		while(T)
			rag.forceMove(T)
			if(rag.on_fire)
				T.hotspot_expose(700, 5)
				for(var/mob/living/M in T.contents)
					M.IgniteMob()
			if(!rag || QDELETED(src) || !HasBelow(T.z) || !T.is_open())
				break
			T = GetBelow(T)
		rag = null

	//Creates a shattering noise and replaces the bottle with a broken_bottle
	playsound(T, "shatter", 70, 1)
	var/obj/item/broken_bottle/B = new(T)
	if(prob(33))
		new/obj/item/shard(newloc) // Create a glass shard at the target's location!
	B.icon_state = src.icon_state
	var/icon/I = new('icons/obj/drinks.dmi', src.icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I
	B.dropInto(B.loc)
	transfer_fingerprints_to(B)
	qdel(src)
	return B

/obj/item/chems/drinks/bottle/attackby(obj/item/W, mob/user)
	if(!rag && istype(W, /obj/item/chems/glass/rag))
		insert_rag(W, user)
		return
	if(rag && W.isflamesource())
		rag.attackby(W, user)
		return
	..()

/obj/item/chems/drinks/bottle/attack_self(mob/user)
	if(rag)
		remove_rag(user)
	else
		..()

/obj/item/chems/drinks/bottle/proc/insert_rag(obj/item/chems/glass/rag/R, mob/user)
	if(!isGlass || rag) return

	if(user.try_unequip(R))
		to_chat(user, SPAN_NOTICE("You stuff [R] into [src]."))
		rag = R
		rag.forceMove(src)

		// Equalize reagents between the rag and bottle so that
		// the rag will probably have something to burn, and the
		// bottle contents will be tainted by having the rag dipped
		// in it.
		if(rag && rag.reagents)
			rag.reagents.trans_to(src, rag.reagents.total_volume)
			if(reagents)
				reagents.trans_to(rag, min(reagents.total_volume, rag.reagents.maximum_volume))
			rag.update_name()

		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
		update_icon()

/obj/item/chems/drinks/bottle/proc/remove_rag(mob/user)
	if(!rag) return
	user.put_in_hands(rag)
	rag = null
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()

/obj/item/chems/drinks/bottle/open(mob/user)
	if(rag) return
	..()

/obj/item/chems/drinks/bottle/on_update_icon()
	. = ..()
	underlays.Cut()
	if(rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image
		set_light(rag.light_range, 0.1, rag.light_color)
	else
		set_light(0)

/obj/item/chems/drinks/bottle/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()

	if(user.a_intent != I_HURT)
		return
	if(!smash_check(1))
		return //won't always break on the first hit

	var/mob/living/carbon/human/H = target
	if(istype(H) && H.headcheck(hit_zone))
		var/obj/item/organ/affecting = GET_EXTERNAL_ORGAN(H, hit_zone) //headcheck should ensure that affecting is not null
		user.visible_message(SPAN_DANGER("\The [user] smashes \the [src] into [H]'s [affecting.name]!"))
		// You are going to knock someone out for longer if they are not wearing a helmet.
		var/blocked = target.get_blocked_ratio(hit_zone, BRUTE, damage = 10) * 100
		var/weaken_duration = smash_duration + min(0, force - blocked + 10)
		if(weaken_duration)
			target.apply_effect(min(weaken_duration, 5), WEAKEN, blocked) // Never weaken more than a flash!
	else
		user.visible_message(SPAN_DANGER("\The [user] smashes \the [src] into [target]!"))

	//The reagents in the bottle splash all over the target, thanks for the idea Nodrak
	if(reagents)
		user.visible_message(SPAN_NOTICE("The contents of \the [src] splash all over [target]!"))
		reagents.splash(target, reagents.total_volume)
		if(rag && rag.on_fire && istype(target))
			target.IgniteMob()

	//Finally, smash the bottle. This kills (qdel) the bottle.
	var/obj/item/broken_bottle/B = smash(target.loc, target)
	user.put_in_active_hand(B)

/obj/item/chems/drinks/bottle/verb/spin_bottle()
	set name = "Spin Bottle"
	set category = "Object"
	set src in view(1)

	if(!ishuman(usr) || usr.incapacitated())
		return

	if(!stop_spin_bottle)
		if(src in usr.get_held_items())
			usr.drop_from_inventory(src)

		if(isturf(loc))
			var/speed = rand(1, 3)
			var/loops
			var/sleep_not_stacking
			switch(speed) //At a low speed, the bottle should not make 10 loops
				if(3)
					loops = rand(7, 10)
					sleep_not_stacking = 40
				if(1 to 2)
					loops = rand(10, 15)
					sleep_not_stacking = 25

			stop_spin_bottle = TRUE
			SpinAnimation(speed, loops, pick(0, 1)) //SpinAnimation(speed, loops, clockwise, segments)
			transform = turn(matrix(), dir2angle(pick(global.alldirs)))
			sleep(sleep_not_stacking) //Not stacking
			stop_spin_bottle = FALSE

/obj/item/chems/drinks/bottle/on_picked_up(mob/living/user)
	animate(src, transform = null, time = 0) //Restore bottle to its original position - animate() is needed to interrupt SpinAnimation()

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	force = 9
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = 1
	edge = 0
	obj_flags = OBJ_FLAG_HOLLOW
	material = /decl/material/solid/glass
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")

/obj/item/broken_bottle/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SCALPEL = TOOL_QUALITY_BAD))

/obj/item/broken_bottle/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/chems/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	center_of_mass = @"{'x':16,'y':4}"

/obj/item/chems/drinks/bottle/gin/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/gin, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	center_of_mass = @"{'x':16,'y':3}"

/obj/item/chems/drinks/bottle/whiskey/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/whiskey, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/agedwhiskey
	name = "aged whiskey"
	desc = "This rich, smooth, hideously expensive beverage was aged for decades."
	icon_state = "whiskeybottle2"
	center_of_mass = @"{'x':16,'y':3}"

/obj/item/chems/drinks/bottle/agedwhiskey/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/aged_whiskey, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/vodka
	name = "Tunguska Triple Distilled"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Indies around the galaxy."
	icon_state = "vodkabottle"
	center_of_mass = @"{'x':17,'y':3}"

/obj/item/chems/drinks/bottle/vodka/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/vodka, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/tequila
	name = "Caccavo Guaranteed Quality tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequilabottle"
	center_of_mass = @"{'x':16,'y':3}"

/obj/item/chems/drinks/bottle/tequila/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/tequila, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/patron/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/tequila, reagents.maximum_volume - 5)
	reagents.add_reagent(/decl/material/solid/metal/silver,     5)

/obj/item/chems/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	center_of_mass = @"{'x':16,'y':8}"

/obj/item/chems/drinks/bottle/rum/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/rum, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/holywater
	name = "Flask of Holy Water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = @"{'x':17,'y':10}"

/obj/item/chems/drinks/bottle/holywater/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/water, reagents.maximum_volume, list("holy" = TRUE))

/obj/item/chems/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	center_of_mass = @"{'x':17,'y':3}"

/obj/item/chems/drinks/bottle/vermouth/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/vermouth, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK!"
	icon_state = "kahluabottle"
	center_of_mass = @"{'x':17,'y':3}"

/obj/item/chems/drinks/bottle/kahlua/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/coffee, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	center_of_mass = @"{'x':15,'y':3}"

/obj/item/chems/drinks/bottle/goldschlager/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/vodka, reagents.maximum_volume - 5)
	reagents.add_reagent(/decl/material/solid/metal/gold,     5)

/obj/item/chems/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/cognac/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/cognac, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	center_of_mass = @"{'x':16,'y':4}"

/obj/item/chems/drinks/bottle/wine/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/wine, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/absinthe/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/absinthe, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/melonliquor
	name = "Emeraldine Melon Liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor. Sweet and light."
	icon_state = "alco-green" //Placeholder.
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/melonliquor/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/melonliquor, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/bluecuracao
	name = "Miss Blue Curacao"
	desc = "A fruity, exceptionally azure drink. Does not allow the imbiber to use the fifth magic."
	icon_state = "alco-blue" //Placeholder.
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/bluecuracao/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/bluecuracao, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/herbal
	name = "Liqueur d'Herbe"
	desc = "A bottle of the seventh-finest herbal liquor sold under a generic name in the galaxy. The back label has a load of guff about the monks who traditionally made this particular variety."
	icon_state = "herbal"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/herbal/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/herbal, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/grenadine
	name = "Briar Rose Grenadine Syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	icon_state = "grenadinebottle"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/grenadine/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/grenadine, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/cola
	name = "\improper Space Cola"
	desc = "Cola. in space."
	icon_state = "colabottle"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/cola/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/cola, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up_bottle"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/space_up/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/lemonade, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/space_mountain_wind/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/citrussoda, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/pwine
	name = "Warlock's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	icon_state = "pwinebottle"
	center_of_mass = @"{'x':16,'y':4}"

/obj/item/chems/drinks/bottle/pwine/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/pwine, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/sake
	name = "Takeo Sadow's Combined Sake"
	desc = "A bottle of the highest-grade sake allowed for import."
	icon_state = "sake"
	center_of_mass = @"{'x':16,'y':4}"

/obj/item/chems/drinks/bottle/sake/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/sake, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/champagne
	name = "Murcelano Vinyard's Premium Champagne"
	desc = "The regal drink of celebrities and royalty."
	icon_state = "champagne"
	center_of_mass = @"{'x':16,'y':4}"

/obj/item/chems/drinks/bottle/champagne/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/champagne, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/jagermeister
	name = "Kaisermeister Deluxe"
	desc = "Jagermeister. This drink just demands a party."
	icon_state = "herbal"
	center_of_mass = @"{'x':16,'y':6}"

/obj/item/chems/drinks/bottle/jagermeister/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/jagermeister, reagents.maximum_volume)

//////////////////////////PREMIUM ALCOHOL ///////////////////////
/obj/item/chems/drinks/bottle/premiumvodka
	name = "Four Stripes Quadruple Distilled"
	desc = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."
	icon_state = "premiumvodka"
	center_of_mass = @"{'x':17,'y':3}"

/obj/item/chems/drinks/bottle/premiumvodka/populate_reagents()
	var/namepick = pick("Four Stripes","Gilgamesh","Novaya Zemlya","Indie","STS-35")
	var/typepick = pick("Absolut","Gold","Quadruple Distilled","Platinum","Standard")
	name = "[namepick] [typepick]"
	reagents.add_reagent(/decl/material/liquid/ethanol/vodka/premium, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/premiumwine
	name = "Uve De Blanc"
	desc = "You feel pretentious just looking at it."
	icon_state = "premiumwine"
	center_of_mass = @"{'x':16,'y':4}"

/obj/item/chems/drinks/bottle/premiumwine/populate_reagents()
	var/namepick = pick("Calumont","Sciacchemont","Recioto","Torcalota")
	var/agedyear = rand(global.using_map.game_year - 150, global.using_map.game_year)
	name = "Chateau [namepick] De Blanc"
	desc += " This bottle is marked as [agedyear] Vintage."
	reagents.add_reagent(/decl/material/liquid/ethanol/wine/premium, reagents.maximum_volume)

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/chems/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = @"{'x':16,'y':7}"
	isGlass = 0
	drop_sound = 'sound/foley/drop1.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'

/obj/item/chems/drinks/bottle/orangejuice/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/juice/orange, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = @"{'x':16,'y':8}"
	isGlass = 0
	drop_sound = 'sound/foley/drop1.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'

/obj/item/chems/drinks/bottle/cream/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/milk/cream, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = @"{'x':16,'y':8}"
	isGlass = 0
	drop_sound = 'sound/foley/drop1.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'

/obj/item/chems/drinks/bottle/tomatojuice/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = @"{'x':16,'y':8}"
	isGlass = 0
	drop_sound = 'sound/foley/drop1.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'

/obj/item/chems/drinks/bottle/limejuice/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/juice/lime, reagents.maximum_volume)

//Small bottles
/obj/item/chems/drinks/bottle/small
	volume = 50
	smash_duration = 1
	atom_flags = 0 //starts closed
	rag_underlay = "rag_small"

/obj/item/chems/drinks/bottle/small/beer
	name = "space beer"
	desc = "Contains only water, malt and hops."
	icon_state = "beer"
	center_of_mass = @"{'x':16,'y':12}"

/obj/item/chems/drinks/bottle/small/beer/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/beer, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/small/ale
	name = "\improper Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = @"{'x':16,'y':10}"

/obj/item/chems/drinks/bottle/small/ale/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/ethanol/ale, reagents.maximum_volume)

/obj/item/chems/drinks/bottle/small/gingerbeer
	name = "Ginger Beer"
	desc = "A delicious non-alcoholic beverage enjoyed across Sol space."
	icon_state = "gingerbeer"
	center_of_mass = @"{'x':16,'y':12}"

/obj/item/chems/drinks/bottle/small/gingerbeer/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/drink/gingerbeer, reagents.maximum_volume)
