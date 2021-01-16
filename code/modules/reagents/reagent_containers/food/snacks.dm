//Food items that are eaten normally and don't leave anything behind.


/obj/item/chems/food/snacks
	name = "snack"
	desc = "Yummy!"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	var/bitesize = 1
	var/bitecount = 0
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/nutriment_amt = 0
	var/nutriment_type = /decl/material/liquid/nutriment // Used to determine which base nutriment type is spawned for this item.
	var/list/nutriment_desc = list("food" = 1)    // List of flavours and flavour strengths. The flavour strength text is determined by the ratio of flavour strengths in the snack.
	var/list/eat_sound = 'sound/items/eatfood.ogg'
	center_of_mass = @"{'x':16,'y':16}"
	w_class = ITEM_SIZE_SMALL

/obj/item/chems/food/snacks/Initialize()
	.=..()
	if(nutriment_amt)
		reagents.add_reagent(nutriment_type, nutriment_amt, nutriment_desc)
	amount_per_transfer_from_this = bitesize

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/chems/food/snacks/proc/On_Consume(var/mob/M)
	if(!reagents.total_volume)
		M.visible_message("<span class='notice'>[M] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")
		M.drop_item()
		M.update_personal_goal(/datum/goal/achievement/specific_object/food, type)
		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(get_turf(M))
				M.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				M.put_in_hands(trash)
		qdel(src)
	return

/obj/item/chems/food/snacks/attack_self(mob/user)
	attack(user, user)

/obj/item/chems/food/snacks/dragged_onto(var/mob/user)
	attack(user, user)

/obj/item/chems/food/snacks/self_feed_message(mob/user)
	if(!iscarbon(user))
		return ..()
	var/mob/living/carbon/C = user
	var/fullness = C.get_fullness()
	if (fullness <= 50)
		to_chat(C, SPAN_WARNING("You hungrily chew out a piece of [src] and gobble it!"))
	if (fullness > 50 && fullness <= 150)
		to_chat(C, SPAN_NOTICE("You hungrily begin to eat [src]."))
	if (fullness > 150 && fullness <= 350)
		to_chat(C, SPAN_NOTICE("You take a bite of [src]."))
	if (fullness > 350 && fullness <= 550)
		to_chat(C, SPAN_NOTICE("You unwillingly chew a bit of [src]."))
	
/obj/item/chems/food/snacks/feed_sound(mob/user)
	if(eat_sound)
		playsound(user, pick(eat_sound), rand(10, 50), 1)

/obj/item/chems/food/snacks/standard_feed_mob(mob/user, mob/target)
	. = ..()
	if(.)
		bitecount++
		On_Consume(target)

/obj/item/chems/food/snacks/attack(mob/M, mob/user, def_zone)
	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='danger'>None of [src] left!</span>")
		qdel(src)
		return 0
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, "<span class='notice'>\The [src] isn't open!</span>")
		return 0
	if(istype(M, /mob/living/carbon))
		//TODO: replace with standard_feed_mob() call.
		var/mob/living/carbon/C = M
		var/fullness = C.get_fullness()
		if (fullness > 550)
			var/message = C == user ? "You cannot force any more of [src] to go down your throat." : "[user] cannot force anymore of [src] down [M]'s throat."
			to_chat(user, SPAN_WARNING(message))
			return 0
		if(standard_feed_mob(user, M))
			return 1
	return 0

/obj/item/chems/food/snacks/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if (bitecount==0)
		return
	else if (bitecount==1)
		to_chat(user, "<span class='notice'>\The [src] was bitten by someone!</span>")
	else if (bitecount<=3)
		to_chat(user, "<span class='notice'>\The [src] was bitten [bitecount] time\s!</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] was bitten multiple times!</span>")

/obj/item/chems/food/snacks/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/storage))
		..()// -> item/attackby()
		return
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, "<span class='notice'>\The [src] isn't open!</span>")
		return 0
	// Eating with forks
	if(istype(W,/obj/item/kitchen/utensil))
		var/obj/item/kitchen/utensil/U = W
		if(U.scoop_food)
			if(!U.reagents)
				U.create_reagents(5)

			if (U.reagents.total_volume > 0)
				to_chat(user, "<span class='warning'>You already have something on your [U].</span>")
				return

			user.visible_message( \
				"\The [user] scoops up some [src] with \the [U]!", \
				"<span class='notice'>You scoop up some [src] with \the [U]!</span>" \
			)

			src.bitecount++
			U.overlays.Cut()
			U.loaded = "[src]"
			var/image/I = new(U.icon, "loadedfood")
			I.color = src.filling_color
			U.overlays += I

			if(!reagents)
				crash_with("A snack [type] failed to have a reagent holder when attacked with a [W.type]. It was [QDELETED(src) ? "" : "not"] being deleted.")
			else
				reagents.trans_to_obj(U, min(reagents.total_volume,5))
				if (reagents.total_volume <= 0)
					qdel(src)
			return

	if (is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/storage/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if (hide_item)
			if (W.w_class >= src.w_class || is_robot_module(W) || istype(W,/obj/item/chems/food/condiment))
				return
			if(!user.unEquip(W, src))
				return

			to_chat(user, "<span class='warning'>You slip \the [W] inside \the [src].</span>")
			add_fingerprint(user)
			W.forceMove(src)
			return

		if (has_edge(W))
			if (!can_slice_here)
				to_chat(user, "<span class='warning'>You cannot slice \the [src] here! You need a table or at least a tray to do it.</span>")
				return

			var/slices_lost = 0
			if (W.w_class > ITEM_SIZE_NORMAL)
				user.visible_message("<span class='notice'>\The [user] crudely slices \the [src] with [W]!</span>", "<span class='notice'>You crudely slice \the [src] with your [W]!</span>")
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message("<span class='notice'>\The [user] slices \the [src]!</span>", "<span class='notice'>You slice \the [src]!</span>")

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/slice = new slice_path (src.loc)
				reagents.trans_to_obj(slice, reagents_per_slice)
			qdel(src)
			return

/obj/item/chems/food/snacks/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/chems/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
	. = ..()

////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/food/snacks/attack_animal(var/mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return
	user.visible_message("<b>[user]</b> nibbles away at \the [src].","You nibble away at \the [src].")
	bitecount++
	if(reagents && user.reagents)
		reagents.trans_to_mob(user, bitesize, CHEM_INGEST)
	spawn(5)
		if(!src && !user.client)
			user.custom_emote(1,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]")
			qdel(src)
	On_Consume(user)

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use regenerative serum). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.


/obj/item/chems/food/snacks/aesirsalad
	name = "\improper Aether salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468c00"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_amt = 8
	nutriment_desc = list("apples" = 3,"salad" = 4, "quintessence" = 2)
	bitesize = 3
/obj/item/chems/food/snacks/aesirsalad/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/regenerator, 8)

/obj/item/chems/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#fdffd1"
	volume = 10
	center_of_mass = @"{'x':16,'y':13}"

/obj/item/chems/food/snacks/egg/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein/egg, 3)

/obj/item/chems/food/snacks/egg/afterattack(obj/O, mob/user, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && ATOM_IS_OPEN_CONTAINER(O)))
		return
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	qdel(src)

/obj/item/chems/food/snacks/egg/throw_impact(atom/hit_atom)
	..()
	if(QDELETED(src))
		return // Could potentially happen with unscupulous atoms on hitby() throwing again, etc.
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	reagents.splash(hit_atom, reagents.total_volume)
	visible_message("<span class='warning'>\The [src] has been squashed!</span>","<span class='warning'>You hear a smack.</span>")
	qdel(src)

/obj/item/chems/food/snacks/egg/attackby(obj/item/W, mob/user)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, "<span class='notice'>The egg refuses to take on this color!</span>")
			return

		to_chat(usr, "<span class='notice'>You color \the [src] [clr]</span>")
		icon_state = "egg-[clr]"
	else
		..()

/obj/item/chems/food/snacks/egg/blue
	icon_state = "egg-blue"

/obj/item/chems/food/snacks/egg/green
	icon_state = "egg-green"

/obj/item/chems/food/snacks/egg/mime
	icon_state = "egg-mime"

/obj/item/chems/food/snacks/egg/orange
	icon_state = "egg-orange"

/obj/item/chems/food/snacks/egg/purple
	icon_state = "egg-purple"

/obj/item/chems/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/chems/food/snacks/egg/red
	icon_state = "egg-red"

/obj/item/chems/food/snacks/egg/yellow
	icon_state = "egg-yellow"

/obj/item/chems/food/snacks/egg/lizard/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein/egg, 5)
	if(prob(30))	//extra nutriment
		reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)

/obj/item/chems/food/snacks/friedegg
	name = "fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#ffdf78"
	center_of_mass = @"{'x':16,'y':14}"
	bitesize = 1
/obj/item/chems/food/snacks/friedegg/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/solid/mineral/sodiumchloride, 1)
	reagents.add_reagent(/decl/material/solid/blackpepper, 1)


/obj/item/chems/food/snacks/boiledegg
	name = "boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#ffffff"
/obj/item/chems/food/snacks/boiledegg/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/snacks/organ
	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#e00d34"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 3
/obj/item/chems/food/snacks/organ/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, rand(3,5))
	reagents.add_reagent(/decl/material/liquid/bromide, rand(1,3))


/obj/item/chems/food/snacks/tofu
	name = "tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#fffee0"
	center_of_mass = @"{'x':17,'y':10}"
//	nutriment_amt = 3
	nutriment_desc = list("tofu" = 3, "softness" = 3)
	bitesize = 3

/obj/item/chems/food/snacks/tofu/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/plant_protein, 6)

/obj/item/chems/food/snacks/tofurkey
	name = "\improper Tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#fffee0"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_amt = 12
	nutriment_desc = list("turkey" = 3, "tofu" = 5, "softness" = 4)
	bitesize = 3

/obj/item/chems/food/snacks/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#c9ac83"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_amt = 3
	nutriment_desc = list("dryness" = 2, "bread" = 2)
	bitesize = 1

/obj/item/chems/food/snacks/fishfingers
	name = "fish fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#ffdefe"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 3
/obj/item/chems/food/snacks/fishfingers/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#e0d7c5"
	center_of_mass = @"{'x':17,'y':16}"
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "mushroom" = 2)
	bitesize = 6
/obj/item/chems/food/snacks/hugemushroomslice/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/psychotropics, 3)

/obj/item/chems/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato."
	icon_state = "tomatomeat"
	filling_color = "#db0000"
	center_of_mass = @"{'x':17,'y':16}"
	nutriment_amt = 3
	nutriment_desc = list("raw" = 2, "tomato" = 3)
	bitesize = 6

/obj/item/chems/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#db0000"
	center_of_mass = @"{'x':16,'y':10}"
	bitesize = 3
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/bearmeat/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 12)
	reagents.add_reagent(/decl/material/liquid/amphetamines, 5)

/obj/item/chems/food/snacks/spider
	name = "giant spider leg"
	desc = "An economical replacement for crab. In space! Would probably be a lot nicer cooked."
	icon_state = "spiderleg"
	filling_color = "#d5f5dc"
	center_of_mass = @"{'x':16,'y':10}"
	bitesize = 3
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/spider/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 9)

/obj/item/chems/food/snacks/spider/cooked
	name = "boiled spider meat"
	desc = "An economical replacement for crab. In space!"
	icon_state = "spiderleg_c"
	bitesize = 5

/obj/item/chems/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43de18"
	center_of_mass = @"{'x':16,'y':10}"
	bitesize = 6
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/xenomeat/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)
	reagents.add_reagent(/decl/material/liquid/acid/polyacid,6)

/obj/item/chems/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#db0000"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 2
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/meatball/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/snacks/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 2
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/sausage/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/snacks/fatsausage
	name = "fat sausage"
	desc = "A piece of mixed, long meat, with some bite to it."
	icon_state = "sausage"
	filling_color = "#db0000"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 2
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/fatsausage/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/snacks/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <b>NOT</b> overconsume."
	filling_color = "#6d6d00"
	heated_reagents = list(
		/decl/material/liquid/regenerator = 5, 
		/decl/material/liquid/amphetamines = 0.75, 
		/decl/material/liquid/stimulants = 0.25
	)
	var/has_been_heated = 0 // Unlike the warm var, this checks if the one-time self-heating operation has been used.

/obj/item/chems/food/snacks/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, "<span class='notice'>The heating chemicals have already been spent.</span>")
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	addtimer(CALLBACK(src, .proc/heat, weakref(user)), 20 SECONDS)

/obj/item/chems/food/snacks/donkpocket/sinpocket/heat(weakref/message_to)
	..()
	if(message_to)
		var/mob/user = message_to.resolve()
		if(user)
			to_chat(user, "You think \the [src] is ready to eat about now.")

/obj/item/chems/food/snacks/donkpocket
	name = "\improper Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#dedeab"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("heartiness" = 1, "dough" = 2)
	nutriment_amt = 2
	var/warm = 0
	var/list/heated_reagents = list(/decl/material/liquid/regenerator = 5)

/obj/item/chems/food/snacks/donkpocket/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/snacks/donkpocket/proc/heat()
	if(warm)
		return
	warm = 1
	for(var/reagent in heated_reagents)
		reagents.add_reagent(reagent, heated_reagents[reagent])
	bitesize = 6
	SetName("warm " + name)
	addtimer(CALLBACK(src, .proc/cool), 7 MINUTES)

/obj/item/chems/food/snacks/donkpocket/proc/cool()
	if(!warm)
		return
	warm = 0
	for(var/reagent in heated_reagents)
		reagents.clear_reagent(reagent)
	SetName(initial(name))

/obj/item/chems/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#f2b6ea"
	center_of_mass = @"{'x':15,'y':11}"
	bitesize = 2
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/brainburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)
	reagents.add_reagent(/decl/material/liquid/neuroannealer, 6)

/obj/item/chems/food/snacks/ghostburger
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#fff2ff"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 2
	bitesize = 2

/obj/item/chems/food/snacks/human
	filling_color = "#d63c3c"
	material = /decl/material/solid/meat
	var/hname = ""
	var/job = null

/obj/item/chems/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 2
/obj/item/chems/food/snacks/human/burger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/snacks/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("cheese" = 2, "bun" = 2)
	nutriment_amt = 2
/obj/item/chems/food/snacks/cheeseburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/snacks/meatburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#d63c3c"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2
/obj/item/chems/food/snacks/meatburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/snacks/plainburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "burger"
	filling_color = "#d63c3c"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2
/obj/item/chems/food/snacks/plainburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/snacks/hamburger
	name = "hamburger"
	desc = "The cornerstone of every nutritious breakfast, now with ham!"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "hamburger"
	filling_color = "#d63c3c"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3
	bitesize = 2
/obj/item/chems/food/snacks/hamburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)

/obj/item/chems/food/snacks/fishburger
	name = "fish sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#ffdefe"
	center_of_mass = @"{'x':16,'y':10}"
	bitesize = 3
/obj/item/chems/food/snacks/fishburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/snacks/tofuburger
	name = "tofu burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#fffee0"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("bun" = 2, "pseudo-soy meat" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = COLOR_GRAY80
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2, "metal" = 3)
	nutriment_amt = 2
	bitesize = 2
/obj/item/chems/food/snacks/roburger/Initialize()
	.=..()
	if(prob(5))
		reagents.add_reagent(/decl/material/liquid/nanitefluid, 2)

/obj/item/chems/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = COLOR_GRAY80
	volume = 100
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 0.1
/obj/item/chems/food/snacks/roburgerbig/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nanitefluid, 100)

/obj/item/chems/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43de18"
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 2
/obj/item/chems/food/snacks/xenoburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/snacks/clownburger
	name = "clown burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#ff00ff"
	center_of_mass = @"{'x':17,'y':12}"
	nutriment_desc = list("bun" = 2, "clown shoe" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/mimeburger
	name = "mime burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#ffffff"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("bun" = 2, "mime paint" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/omelette
	name = "cheese omelette"
	desc = "Omelette with cheese!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#fff9a8"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 1
/obj/item/chems/food/snacks/omelette/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/snacks/muffin
	name = "muffin"
	desc = "A delicious and spongy little cake."
	icon_state = "muffin"
	filling_color = "#e0cf9b"
	center_of_mass = @"{'x':17,'y':4}"
	nutriment_desc = list("sweetness" = 3, "muffin" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/bananapie
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#fbffb8"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("pie" = 3, "cream" = 2)
	nutriment_amt = 4
	bitesize = 3
/obj/item/chems/food/snacks/pie/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/banana_cream,5)

/obj/item/chems/food/snacks/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("<span class='danger'>\The [src.name] splats.</span>","<span class='danger'>You hear a splat.</span>")
	qdel(src)

/obj/item/chems/food/snacks/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("sweetness" = 2, "pie" = 3)
	nutriment_amt = 4
	bitesize = 3
/obj/item/chems/food/snacks/berryclafoutis/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/berry, 5)

/obj/item/chems/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles."
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#e6deb5"
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("waffle" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/snacks/pancakesblu
	name = "blueberry pancakes"
	desc = "Pancakes with blueberries, delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/snacks/pancakes
	name = "pancakes"
	desc = "Pancakes without blueberries, still delicious."
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("pancake" = 8)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/snacks/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4d2f5e"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("cheese" = 3, "eggplant" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/soylentgreen
	name = "\improper Soylent Green"
	desc = "Not made of people. Honest."//Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#b8e6b5"
	center_of_mass = @"{'x':15,'y':11}"
	bitesize = 2
/obj/item/chems/food/snacks/soylentgreen/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/snacks/soylenviridians
	name = "\improper Soylen Virdians"
	desc = "Not made of people. Honest."//Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#e6fa61"
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("some sort of protein" = 10)//seasoned vERY well.
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/snacks/meatpie
	name = "meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 2
/obj/item/chems/food/snacks/meatpie/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/snacks/tofupie
	name = "tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#fffee0"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("tofu" = 2, "pie" = 8)
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#ffcccc"
	center_of_mass = @"{'x':17,'y':9}"
	nutriment_desc = list("sweetness" = 3, "mushroom" = 3, "pie" = 2)
	nutriment_amt = 5
	bitesize = 3
/obj/item/chems/food/snacks/amanita_pie/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/amatoxin, 3)
	reagents.add_reagent(/decl/material/liquid/psychotropics, 1)

/obj/item/chems/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#b8279b"
	center_of_mass = @"{'x':17,'y':9}"
	nutriment_desc = list("heartiness" = 2, "mushroom" = 3, "pie" = 3)
	nutriment_amt = 8
	bitesize = 2
/obj/item/chems/food/snacks/plump_pie/Initialize()
	.=..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent(/decl/material/liquid/regenerator, 5)

/obj/item/chems/food/snacks/xemeatpie
	name = "xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43de18"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 2
/obj/item/chems/food/snacks/xemeatpie/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/snacks/meatkabob
	name = "meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/material/rods
	filling_color = "#a85340"
	center_of_mass = @"{'x':17,'y':15}"
	bitesize = 2
/obj/item/chems/food/snacks/meatkabob/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/snacks/tofukabob
	name = "tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/material/rods
	filling_color = "#fffee0"
	center_of_mass = @"{'x':17,'y':15}"
	nutriment_desc = list("tofu" = 3, "metal" = 1)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/snacks/cubancarp
	name = "\improper Cuban Carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#e9adff"
	center_of_mass = @"{'x':12,'y':5}"
	nutriment_desc = list("toasted bread" = 3)
	nutriment_amt = 3
	bitesize = 3
/obj/item/chems/food/snacks/cubancarp/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/liquid/capsaicin, 3)

/obj/item/chems/food/snacks/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	filling_color = "#fffad4"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("popcorn" = 3)
	nutriment_amt = 2
	bitesize = 0.1

/obj/item/chems/food/snacks/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9c7a68"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("baked potato" = 3)
	nutriment_amt = 3
	bitesize = 2
/obj/item/chems/food/snacks/loadedbakedpotato/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/snacks/fries
	name = "chips"
	desc = "Frenched potato, fried."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("fresh fries" = 4)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/snacks/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("fried onions" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/snacks/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#c4bf76"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("slime" = 2, "soy" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/chems/food/snacks/spagetti
	name = "spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':16}"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 1
	bitesize = 1

/obj/item/chems/food/snacks/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("fresh fries" = 3, "cheese" = 3)
	nutriment_amt = 4
	bitesize = 2
/obj/item/chems/food/snacks/cheesyfries/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/snacks/fortunecookie
	name = "fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	filling_color = "#e8e79e"
	center_of_mass = @"{'x':15,'y':14}"
	nutriment_desc = list("fortune cookie" = 2)
	nutriment_amt = 3
	bitesize = 2

/obj/item/chems/food/snacks/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211f02"
	center_of_mass = @"{'x':16,'y':12}"
	bitesize = 2
/obj/item/chems/food/snacks/badrecipe/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/bromide, 1)
	reagents.add_reagent(/decl/material/solid/carbon, 3)

/obj/item/chems/food/snacks/plainsteak
	name = "plain steak"
	desc = "A piece of unseasoned cooked meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "steak"
	slice_path = /obj/item/chems/food/snacks/cutlet
	slices_num = 3
	filling_color = "#7a3d11"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 3
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/plainsteak/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/meatsteak
	name = "meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7a3d11"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 3
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/meatsteak/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)
	reagents.add_reagent(/decl/material/solid/mineral/sodiumchloride, 1)
	reagents.add_reagent(/decl/material/solid/blackpepper, 1)

/obj/item/chems/food/snacks/meatsteak/synthetic
	name = "meaty steak"
	desc = "A piece of hot spicy pseudo-meat."

/obj/item/chems/food/snacks/loadedsteak
	name = "loaded steak"
	desc = "A steak slathered in sauce with sauteed onions and mushrooms."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7a3d11"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("onion" = 2, "mushroom" = 2)
	nutriment_amt = 4
	bitesize = 3
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/loadedsteak/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)
	reagents.add_reagent(/decl/material/liquid/nutriment/garlicsauce, 2)

/obj/item/chems/food/snacks/spacylibertyduff
	name = "party jelly"
	desc = "LoOk aT aLl tHe PrEtTy CoLoUrS"
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42b873"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("mushroom" = 5, "rainbow" = 1)
	nutriment_amt = 6
	bitesize = 3
/obj/item/chems/food/snacks/spacylibertyduff/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/psychotropics, 6)

/obj/item/chems/food/snacks/amanitajelly
	name = "amanita jelly"
	desc = "Looks curiously toxic."
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ed0758"
	center_of_mass = @"{'x':16,'y':5}"
	nutriment_desc = list("jelly" = 3, "mushroom" = 3)
	nutriment_amt = 6
	bitesize = 3
/obj/item/chems/food/snacks/amanitajelly/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/amatoxin, 6)
	reagents.add_reagent(/decl/material/liquid/psychotropics, 3)

/obj/item/chems/food/snacks/poppypretzel
	name = "poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916e36"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("poppy seeds" = 2, "pretzel" = 3)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/snacks/meatballsoup
	name = "meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"
	center_of_mass = @"{'x':16,'y':8}"
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/snacks/meatballsoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/snacks/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup"//nonexistant?
	filling_color = "#c4dba0"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/slimesoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/chems/food/snacks/bloodsoup
	name = "tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#ff0000"
	center_of_mass = @"{'x':16,'y':7}"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/bloodsoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)
	reagents.add_reagent(/decl/material/liquid/blood, 10)
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/snacks/clownstears
	name = "clown's tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#c4fbff"
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("salt" = 1, "the worst joke" = 3)
	nutriment_amt = 4
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/clownstears/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/banana, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/chems/food/snacks/vegetablesoup
	name = "vegetable soup"
	desc = "A highly nutritious blend of vegetative goodness. Guaranteed to leave you with a, er, \"souped-up\" sense of wellbeing."
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("carrot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2)
	nutriment_amt = 8
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/snacks/vegetablesoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/snacks/nettlesoup
	name = "nettle soup"
	desc = "A mean, green, calorically lean dish derived from a poisonous plant. It has a rather acidic bite to its taste."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#afc4b5"
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("salad" = 4, "egg" = 2, "potato" = 2)
	nutriment_amt = 8
	bitesize = 5
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/snacks/nettlesoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/water, 5)
	reagents.add_reagent(/decl/material/liquid/regenerator, 5)

/obj/item/chems/food/snacks/mysterysoup
	name = "mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f082ff"
	center_of_mass = @"{'x':16,'y':6}"
	nutriment_desc = list("backwash" = 1)
	nutriment_amt = 1
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/mysterysoup/Initialize()
	.=..()
	switch(rand(1,10))
		if(1)
			reagents.add_reagent(/decl/material/liquid/nutriment, 6)
			reagents.add_reagent(/decl/material/liquid/capsaicin, 3)
			reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 2)
		if(2)
			reagents.add_reagent(/decl/material/liquid/nutriment, 6)
			reagents.add_reagent(/decl/material/liquid/frostoil, 3)
			reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 2)
		if(3)
			reagents.add_reagent(/decl/material/liquid/nutriment, 5)
			reagents.add_reagent(/decl/material/liquid/water, 5)
			reagents.add_reagent(/decl/material/liquid/regenerator, 5)
		if(4)
			reagents.add_reagent(/decl/material/liquid/nutriment, 5)
			reagents.add_reagent(/decl/material/liquid/water, 10)
		if(5)
			reagents.add_reagent(/decl/material/liquid/nutriment, 2)
			reagents.add_reagent(/decl/material/liquid/drink/juice/banana, 10)
		if(6)
			reagents.add_reagent(/decl/material/liquid/nutriment, 6)
			reagents.add_reagent(/decl/material/liquid/blood, 10)
		if(7)
			reagents.add_reagent(/decl/material/liquid/slimejelly, 10)
			reagents.add_reagent(/decl/material/liquid/water, 10)
		if(8)
			reagents.add_reagent(/decl/material/solid/carbon, 10)
			reagents.add_reagent(/decl/material/liquid/bromide, 10)
		if(9)
			reagents.add_reagent(/decl/material/liquid/nutriment, 5)
			reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 10)
		if(10)
			reagents.add_reagent(/decl/material/liquid/nutriment, 6)
			reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 5)
			reagents.add_reagent(/decl/material/liquid/eyedrops, 5)

/obj/item/chems/food/snacks/wishsoup
	name = "\improper Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d1f4ff"
	center_of_mass = @"{'x':16,'y':11}"
	bitesize = 5
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/wishsoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/water, 10)
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent(/decl/material/liquid/nutriment, 8, list("something good" = 8))

/obj/item/chems/food/snacks/hotchili
	name = "hot chili"
	desc = "Sound the fire alarm!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ff3c00"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("chilli peppers" = 2, "burning" = 1)
	nutriment_amt = 3
	bitesize = 5
/obj/item/chems/food/snacks/hotchili/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/liquid/capsaicin, 3)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 2)

/obj/item/chems/food/snacks/coldchili
	name = "cold chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2b00ff"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("chilly peppers" = 3)
	nutriment_amt = 3
	trash = /obj/item/trash/snack_bowl
	bitesize = 5
/obj/item/chems/food/snacks/coldchili/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/liquid/frostoil, 3)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 2)

//cubed animals!

/obj/item/chems/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#adac7f"
	center_of_mass = @"{'x':16,'y':14}"

	var/wrapped = 0
	var/growing = 0
	var/monkey_type = /mob/living/carbon/human/monkey

/obj/item/chems/food/snacks/monkeycube/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/snacks/monkeycube/attack_self(var/mob/user)
	if(wrapped)
		Unwrap(user)

/obj/item/chems/food/snacks/monkeycube/proc/Expand()
	if(!growing)
		growing = 1
		src.visible_message("<span class='notice'>\The [src] expands!</span>")
		var/mob/monkey = new monkey_type
		monkey.dropInto(src.loc)
		qdel(src)

/obj/item/chems/food/snacks/monkeycube/proc/Unwrap(var/mob/user)
	icon_state = "monkeycube"
	desc = "Just add water!"
	to_chat(user, SPAN_NOTICE("You unwrap \the [src]."))
	wrapped = 0
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	var/trash = new /obj/item/trash/cubewrapper(get_turf(user))
	user.put_in_hands(trash)

/obj/item/chems/food/snacks/monkeycube/On_Consume(var/mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.visible_message("<span class='warning'>A screeching creature bursts out of [M]'s chest!</span>")
		var/obj/item/organ/external/organ = H.get_organ(BP_CHEST)
		organ.take_external_damage(50, 0, 0, "Animal escaping the ribcage")
	Expand()

/obj/item/chems/food/snacks/monkeycube/on_reagent_change()
	if(reagents.has_reagent(/decl/material/liquid/water))
		Expand()

/obj/item/chems/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	item_flags = 0
	obj_flags = 0
	wrapped = 1

//Spider cubes, all that's left of the cube PR
/obj/item/chems/food/snacks/monkeycube/spidercube
	name = "spider cube"
	monkey_type = /obj/effect/spider/spiderling

/obj/item/chems/food/snacks/monkeycube/wrapped/spidercube
	name = "spider cube"
	monkey_type = /obj/effect/spider/spiderling

/obj/item/chems/food/snacks/spellburger
	name = "spell burger"
	desc = "This is absolutely magical."
	icon_state = "spellburger"
	filling_color = "#d505ff"
	nutriment_desc = list("magic" = 3, "buns" = 3)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/bigbiteburger
	name = "big bite burger"
	desc = "Forget the Luna Burger! THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#e3d681"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 4
	bitesize = 3
/obj/item/chems/food/snacks/bigbiteburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/snacks/enchiladas
	name = "enchiladas"
	desc = "Not to be confused with an echidna, though I don't know how you would."
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#a36a1f"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("tortilla" = 3, "corn" = 3)
	nutriment_amt = 2
	bitesize = 4
/obj/item/chems/food/snacks/enchiladas/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)
	reagents.add_reagent(/decl/material/liquid/capsaicin, 6)

/obj/item/chems/food/snacks/monkeysdelight
	name = "monkey's delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5c3c11"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 6
/obj/item/chems/food/snacks/monkeysdelight/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)
	reagents.add_reagent(/decl/material/liquid/drink/juice/banana, 5)
	reagents.add_reagent(/decl/material/solid/blackpepper, 1)
	reagents.add_reagent(/decl/material/solid/mineral/sodiumchloride, 1)

/obj/item/chems/food/snacks/baguette
	name = "baguette"
	desc = "Good for pretend sword fights."
	icon_state = "baguette"
	filling_color = "#e3d796"
	center_of_mass = @"{'x':18,'y':12}"
	nutriment_desc = list("long bread" = 6)
	nutriment_amt = 6
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/baguette/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/solid/blackpepper, 1)
	reagents.add_reagent(/decl/material/solid/mineral/sodiumchloride, 1)

/obj/item/chems/food/snacks/fishandchips
	name = "fish and chips"
	desc = "Best enjoyed wrapped in a newspaper on a cold wet day."
	icon_state = "fishandchips"
	filling_color = "#e3d796"
	center_of_mass = @"{'x':16,'y':16}"
	nutriment_desc = list("salt" = 1, "chips" = 2, "fish" = 2)
	nutriment_amt = 3
	bitesize = 3
/obj/item/chems/food/snacks/fishandchips/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/snacks/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce!"
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#d9be29"
	center_of_mass = @"{'x':16,'y':4}"
	nutriment_desc = list("bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread
	bitesize = 2

/obj/item/chems/food/snacks/sandwich/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/snacks/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#d9be29"
	center_of_mass = @"{'x':16,'y':4}"
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread
	bitesize = 2

/obj/item/chems/food/snacks/toastedsandwich/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/solid/carbon, 2)

/obj/item/chems/food/snacks/grilledcheese
	name = "grilled cheese sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#d9be29"
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/grilledcheese/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/tomatosoup
	name = "tomato soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d92929"
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("soup" = 5)
	nutriment_amt = 5
	bitesize = 3
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/tomatosoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 10)

/obj/item/chems/food/snacks/rofflewaffles
	name = "waffles(?)"
	desc = "There's something funny about these waffles."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#ff00f7"
	center_of_mass = @"{'x':15,'y':11}"
	nutriment_desc = list("waffle" = 7, "sweetness" = 1)
	nutriment_amt = 8
	bitesize = 4
/obj/item/chems/food/snacks/rofflewaffles/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/psychotropics, 8)

/obj/item/chems/food/snacks/stew
	name = "stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9e673a"
	center_of_mass = @"{'x':16,'y':5}"
	nutriment_desc = list("tomato" = 2, "potato" = 2, "carrot" = 2, "eggplant" = 2, "mushroom" = 2)
	nutriment_amt = 6
	bitesize = 10
/obj/item/chems/food/snacks/stew/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 5)
	reagents.add_reagent(/decl/material/liquid/eyedrops, 5)
	reagents.add_reagent(/decl/material/liquid/water, 5)

/obj/item/chems/food/snacks/jelliedtoast
	name = "jellied toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#b572ab"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("toasted bread" = 2)
	nutriment_amt = 1
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/jelliedtoast/cherry
/obj/item/chems/food/snacks/jelliedtoast/cherry/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)

/obj/item/chems/food/snacks/jelliedtoast/slime
/obj/item/chems/food/snacks/jelliedtoast/slime/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)

/obj/item/chems/food/snacks/jellyburger
	name = "jelly burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#b572ab"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("buns" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/chems/food/snacks/jellyburger/slime
/obj/item/chems/food/snacks/jellyburger/slime/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)

/obj/item/chems/food/snacks/jellyburger/cherry
/obj/item/chems/food/snacks/jellyburger/cherry/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)

/obj/item/chems/food/snacks/milosoup
	name = "milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	center_of_mass = @"{'x':16,'y':7}"
	nutriment_desc = list("soy" = 8)
	nutriment_amt = 8
	bitesize = 4
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/milosoup/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/water, 5)


/obj/item/chems/food/snacks/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("soy" = 4, "tomato" = 4)
	nutriment_amt = 8
	bitesize = 2

/obj/item/chems/food/snacks/boiledspagetti
	name = "boiled spaghetti"
	desc = "A plain dish of pasta, just screaming for sauce."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#fcee81"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("noodles" = 2)
	nutriment_amt = 2
	bitesize = 2

/obj/item/chems/food/snacks/boiledrice
	name = "boiled rice"
	desc = "White rice, a very important staple food. Goes excellent with many many things."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/boiledrice/chazuke
	name = "chazuke"
	desc = "An ancient way of using up day-old rice, this dish is composed of plain green tea poured over plain white rice. Hopefully you have something else to put in."
	icon_state = "chazuke"
	filling_color = "#f1ffdb"
	nutriment_desc = list("chazuke" = 2)
	bitesize = 3

/obj/item/chems/food/snacks/katsucurry
	name = "katsu curry"
	desc = "An oriental curry dish made from apples, potatoes, and carrots. Served with rice and breaded chicken."
	icon_state = "katsu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#faa005"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("rice" = 2, "apple" = 2, "potato" = 2, "carrot" = 2, "bread" = 2, )
	nutriment_amt = 6
	bitesize = 2

/obj/item/chems/food/snacks/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fffbdb"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("rice" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/snacks/pastatomato
	name = "spaghetti & tomato"
	desc = "Spaghetti and crushed tomatoes."
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#de4545"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("tomato" = 3, "noodles" = 3)
	nutriment_amt = 6
	bitesize = 4
/obj/item/chems/food/snacks/pastatomato/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 10)

/obj/item/chems/food/snacks/nanopasta
	name = "nanopasta"
	desc = "Nanomachines, son!"
	icon_state = "nanopasta"
	trash = /obj/item/trash/plate
	filling_color = "#535e66"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_amt = 6
	bitesize = 4
/obj/item/chems/food/snacks/nanopasta/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nanitefluid, 10)

/obj/item/chems/food/snacks/meatballspagetti
	name = "spaghetti & meatballs"
	desc = "Now thats a nice meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#de4545"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2
/obj/item/chems/food/snacks/meatballspagetti/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/spesslaw
	name = "spaghetti & too many meatballs"
	desc = "Do you want some pasta with those meatballs?"
	icon_state = "spesslaw"
	filling_color = "#de4545"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("noodles" = 4)
	nutriment_amt = 4
	bitesize = 2
/obj/item/chems/food/snacks/spesslaw/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#faa005"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("carrot" = 3, "salt" = 1)
	nutriment_amt = 3
	bitesize = 2
/obj/item/chems/food/snacks/carrotfries/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/eyedrops, 3)

/obj/item/chems/food/snacks/superbiteburger
	name = "super bite burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#cca26a"
	center_of_mass = @"{'x':16,'y':3}"
	nutriment_desc = list("buns" = 25)
	nutriment_amt = 25
	bitesize = 10
/obj/item/chems/food/snacks/superbiteburger/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 25)

/obj/item/chems/food/snacks/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#f21873"
	center_of_mass = @"{'x':15,'y':13}"
	nutriment_desc = list("apple" = 3, "caramel" = 3, "sweetness" = 2)
	nutriment_amt = 3
	bitesize = 3

/obj/item/chems/food/snacks/applepie
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#e0edc5"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("sweetness" = 2, "apple" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/chems/food/snacks/cherrypie
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#ff525a"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("sweetness" = 2, "cherry" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/chems/food/snacks/twobread
	name = "\improper Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#dbcc9a"
	center_of_mass = @"{'x':15,'y':12}"
	nutriment_desc = list("sourness" = 2, "bread" = 2)
	nutriment_amt = 2
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/threebread
	name = "\improper Three Bread"
	desc = "Is such a thing even possible?"
	icon_state = "threebread"
	filling_color = "#dbcc9a"
	center_of_mass = @"{'x':15,'y':12}"
	nutriment_desc = list("sourness" = 2, "bread" = 3)
	nutriment_amt = 3
	bitesize = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9e3a78"
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("bread" = 2)
	nutriment_amt = 2
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/jellysandwich/slime
/obj/item/chems/food/snacks/jellysandwich/slime/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)

/obj/item/chems/food/snacks/jellysandwich/cherry
/obj/item/chems/food/snacks/jellysandwich/cherry/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)

/obj/item/chems/food/snacks/mint
	name = "mint"
	desc = "A tasty after-dinner mint. It is only wafer thin."
	icon_state = "mint"
	filling_color = "#f2f2f2"
	center_of_mass = @"{'x':16,'y':14}"
	bitesize = 1
/obj/item/chems/food/snacks/mint/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/drink/syrup/mint, 1)


/obj/item/chems/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#e386bf"
	center_of_mass = @"{'x':17,'y':10}"
	nutriment_desc = list("mushroom" = 8, "milk" = 2)
	nutriment_amt = 8
	bitesize = 3
	eat_sound = list('sound/items/eatfood.ogg', 'sound/items/drink.ogg')

/obj/item/chems/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#cfb4c4"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("mushroom" = 4)
	nutriment_amt = 5
	bitesize = 2
/obj/item/chems/food/snacks/plumphelmetbiscuit/Initialize()
	.=..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent(/decl/material/liquid/nutriment, 3)
		reagents.add_reagent(/decl/material/liquid/regenerator, 5)


/obj/item/chems/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f0f2e4"
	center_of_mass = @"{'x':17,'y':10}"
	bitesize = 1
/obj/item/chems/food/snacks/chawanmushi/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)


/obj/item/chems/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#fac9ff"
	center_of_mass = @"{'x':15,'y':8}"
	nutriment_desc = list("tomato" = 4, "beet" = 4)
	nutriment_amt = 8
	bitesize = 2
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/beetsoup/Initialize()
	.=..()
	name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht"))


/obj/item/chems/food/snacks/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("salad" = 2, "tomato" = 2, "carrot" = 2, "apple" = 2)
	nutriment_amt = 8
	bitesize = 3

/obj/item/chems/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76b87f"
	center_of_mass = @"{'x':17,'y':11}"
	nutriment_desc = list("100% real salad")
	nutriment_amt = 6
	bitesize = 3
/obj/item/chems/food/snacks/validsalad/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#ffff00"
	center_of_mass = @"{'x':16,'y':18}"
	nutriment_desc = list("apple" = 8)
	nutriment_amt = 8
	bitesize = 3
/obj/item/chems/food/snacks/appletart/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/solid/metal/gold, 5)

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like meatbread and cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/chems/food/snacks/sliceable
	w_class = ITEM_SIZE_NORMAL //whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.
/**
 *  A food item slice
 *
 *  This path contains some extra code for spawning slices pre-filled with
 *  reagents.
 */
/obj/item/chems/food/snacks/slice
	name = "slice of... something"
	var/whole_path // path for the item from which this slice comes
	var/filled = FALSE // should the slice spawn with any reagents

/**
 *  Spawn a new slice of food
 *
 *  If the slice's filled is TRUE, this will also fill the slice with the
 *  appropriate amount of reagents. Note that this is done by spawning a new
 *  whole item, transferring the reagents and deleting the whole item, which may
 *  have performance implications.
 */
/obj/item/chems/food/snacks/slice/Initialize()
	.=..()
	if(filled)
		var/obj/item/chems/food/snacks/whole = new whole_path()
		if(whole && whole.slices_num)
			var/reagent_amount = whole.reagents.total_volume/whole.slices_num
			whole.reagents.trans_to_obj(src, reagent_amount)

		qdel(whole)

/obj/item/chems/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon_state = "meatbread"
	slice_path = /obj/item/chems/food/snacks/slice/meatbread
	slices_num = 5
	filling_color = "#ff7575"
	center_of_mass = @"{'x':19,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/meatbread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 20)

/obj/item/chems/food/snacks/slice/meatbread
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#ff7575"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/meatbread

/obj/item/chems/food/snacks/slice/meatbread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/chems/food/snacks/slice/xenomeatbread
	slices_num = 5
	filling_color = "#8aff75"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/xenomeatbread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 20)

/obj/item/chems/food/snacks/slice/xenomeatbread
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8aff75"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/xenomeatbread

/obj/item/chems/food/snacks/slice/xenomeatbread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/bananabread
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/chems/food/snacks/slice/bananabread
	slices_num = 5
	filling_color = "#ede5ad"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/bananabread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/banana_cream, 20)

/obj/item/chems/food/snacks/slice/bananabread
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#ede5ad"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':8}"
	whole_path = /obj/item/chems/food/snacks/sliceable/bananabread

/obj/item/chems/food/snacks/slice/bananabread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/tofubread
	name = "tofubread"
	desc = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/chems/food/snacks/slice/tofubread
	slices_num = 5
	filling_color = "#f7ffe0"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("tofu" = 10)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/slice/tofubread
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#f7ffe0"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/tofubread

/obj/item/chems/food/snacks/slice/tofubread/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/carrotcake
	name = "carrot cake"
	desc = "A favorite desert of sophisticated rabbits."
	icon_state = "carrotcake"
	slice_path = /obj/item/chems/food/snacks/slice/carrotcake
	slices_num = 5
	filling_color = "#ffd675"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "carrot" = 15)
	nutriment_amt = 25
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/sliceable/carrotcake/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/eyedrops, 10)

/obj/item/chems/food/snacks/slice/carrotcake
	name = "carrot cake slice"
	desc = "Carrotty slice of carrot cake, carrots are good for your eyes! It's true! Probably!"
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#ffd675"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/carrotcake

/obj/item/chems/food/snacks/slice/carrotcake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/braincake
	name = "brain cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/chems/food/snacks/slice/braincake
	slices_num = 5
	filling_color = "#e6aedb"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "slime" = 15)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/sliceable/braincake/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 25)
	reagents.add_reagent(/decl/material/liquid/neuroannealer, 10)

/obj/item/chems/food/snacks/slice/braincake
	name = "brain cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#e6aedb"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	whole_path = /obj/item/chems/food/snacks/sliceable/braincake

/obj/item/chems/food/snacks/slice/braincake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/cheesecake
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/chems/food/snacks/slice/cheesecake
	slices_num = 5
	filling_color = "#faf7af"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "cream" = 10, "cheese" = 15)
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/snacks/sliceable/cheesecake/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 15)

/obj/item/chems/food/snacks/slice/cheesecake
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction."
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#faf7af"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/cheesecake

/obj/item/chems/food/snacks/slice/cheesecake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/plaincake
	name = "vanilla cake"
	desc = "A plain cake, but a good cake."
	icon_state = "plaincake"
	slice_path = /obj/item/chems/food/snacks/slice/plaincake
	slices_num = 5
	filling_color = "#f7edd5"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "vanilla" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/slice/plaincake
	name = "vanilla cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#f7edd5"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/plaincake

/obj/item/chems/food/snacks/slice/plaincake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/orangecake
	name = "orange cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/chems/food/snacks/slice/orangecake
	slices_num = 5
	filling_color = "#fada8e"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "orange" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/slice/orangecake
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#fada8e"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/orangecake

/obj/item/chems/food/snacks/slice/orangecake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/limecake
	name = "lime cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/chems/food/snacks/slice/limecake
	slices_num = 5
	filling_color = "#cbfa8e"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lime" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/slice/limecake
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#cbfa8e"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/limecake

/obj/item/chems/food/snacks/slice/limecake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/lemoncake
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/chems/food/snacks/slice/lemoncake
	slices_num = 5
	filling_color = "#fafa8e"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "lemon" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/slice/lemoncake
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#fafa8e"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/lemoncake

/obj/item/chems/food/snacks/slice/lemoncake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/chocolatecake
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon_state = "chocolatecake"
	slice_path = /obj/item/chems/food/snacks/slice/chocolatecake
	slices_num = 5
	filling_color = "#805930"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "chocolate" = 15)
	nutriment_amt = 20
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/slice/chocolatecake
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/chocolatecake

/obj/item/chems/food/snacks/slice/chocolatecake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delcious cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/chems/food/snacks/cheesewedge
	slices_num = 5
	filling_color = "#fff700"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cheese" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/chems/food/snacks/sliceable/cheesewheel/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/snacks/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#fff700"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':10}"

/obj/item/chems/food/snacks/sliceable/birthdaycake
	name = "birthday cake"
	desc = "Happy birthday!"
	icon_state = "birthdaycake"
	slice_path = /obj/item/chems/food/snacks/slice/birthdaycake
	slices_num = 5
	filling_color = "#ffd6d6"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10)
	nutriment_amt = 20
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/sliceable/birthdaycake/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 10)


/obj/item/chems/food/snacks/slice/birthdaycake
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#ffd6d6"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/birthdaycake

/obj/item/chems/food/snacks/slice/birthdaycake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/bread
	name = "bread"
	desc = "Some plain old bread."
	icon_state = "bread"
	slice_path = /obj/item/chems/food/snacks/slice/bread
	slices_num = 5
	filling_color = "#ffe396"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 6
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/slice/bread
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#d27332"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':4}"
	whole_path = /obj/item/chems/food/snacks/sliceable/bread

/obj/item/chems/food/snacks/slice/bread/filled
	filled = TRUE


/obj/item/chems/food/snacks/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/chems/food/snacks/slice/creamcheesebread
	slices_num = 5
	filling_color = "#fff896"
	center_of_mass = @"{'x':16,'y':9}"
	nutriment_desc = list("bread" = 6, "cream" = 3, "cheese" = 3)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/creamcheesebread/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 15)

/obj/item/chems/food/snacks/slice/creamcheesebread
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#fff896"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/creamcheesebread

/obj/item/chems/food/snacks/slice/creamcheesebread/filled
	filled = TRUE

/obj/item/chems/food/snacks/watermelonslice
	name = "watermelon slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#ff3867"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':10}"

/obj/item/chems/food/snacks/sliceable/applecake
	name = "apple cake"
	desc = "A cake centred with apples."
	icon_state = "applecake"
	slice_path = /obj/item/chems/food/snacks/slice/applecake
	slices_num = 5
	filling_color = "#ebf5b8"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("cake" = 10, "sweetness" = 10, "apple" = 15)
	nutriment_amt = 15
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/slice/applecake
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#ebf5b8"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':14}"
	whole_path = /obj/item/chems/food/snacks/sliceable/applecake

/obj/item/chems/food/snacks/slice/applecake/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/pumpkinpie
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/chems/food/snacks/slice/pumpkinpie
	slices_num = 5
	filling_color = "#f5b951"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("pie" = 5, "cream" = 5, "pumpkin" = 5)
	nutriment_amt = 15

/obj/item/chems/food/snacks/slice/pumpkinpie
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#f5b951"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	whole_path = /obj/item/chems/food/snacks/sliceable/pumpkinpie

/obj/item/chems/food/snacks/slice/pumpkinpie/filled
	filled = TRUE

/obj/item/chems/food/snacks/cracker
	name = "cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#f5deb8"
	center_of_mass = @"{'x':17,'y':6}"
	nutriment_desc = list("salt" = 1, "cracker" = 2)
	w_class = ITEM_SIZE_TINY
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/chems/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#baa14c"

/obj/item/chems/food/snacks/sliceable/pizza/margherita
	name = "margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/chems/food/snacks/slice/margherita
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 15)
	nutriment_amt = 35
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/pizza/margherita/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 6)

/obj/item/chems/food/snacks/slice/margherita
	name = "margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/pizza/margherita

/obj/item/chems/food/snacks/slice/margherita/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/pizza/meatpizza
	name = "meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/chems/food/snacks/slice/meatpizza
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 15)
	nutriment_amt = 10
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/pizza/meatpizza/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 34)
	reagents.add_reagent(/decl/material/liquid/nutriment/barbecue, 6)

/obj/item/chems/food/snacks/slice/meatpizza
	name = "meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/pizza/meatpizza

/obj/item/chems/food/snacks/slice/meatpizza/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/pizza/mushroompizza
	name = "mushroompizza"
	desc = "Very special pizza."
	icon_state = "mushroompizza"
	slice_path = /obj/item/chems/food/snacks/slice/mushroompizza
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 5, "mushroom" = 10)
	nutriment_amt = 35
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/pizza/mushroompizza/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)

/obj/item/chems/food/snacks/slice/mushroompizza
	name = "mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/pizza/mushroompizza

/obj/item/chems/food/snacks/slice/mushroompizza/filled
	filled = TRUE

/obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "Vegetarian pizza huh? What about all the plants that were slaughtered to make this huh?? Hypocrite."
	icon_state = "vegetablepizza"
	slice_path = /obj/item/chems/food/snacks/slice/vegetablepizza
	slices_num = 6
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "cheese" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 25
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)
	reagents.add_reagent(/decl/material/liquid/nutriment/ketchup, 6)
	reagents.add_reagent(/decl/material/liquid/eyedrops, 12)

/obj/item/chems/food/snacks/slice/vegetablepizza
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	filling_color = "#baa14c"
	bitesize = 2
	center_of_mass = @"{'x':18,'y':13}"
	whole_path = /obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza

/obj/item/chems/food/snacks/slice/vegetablepizza/filled
	filled = TRUE

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/chems/food/snacks/sliceable/pizza/pizza // content pizza
	var/list/boxes = list()// If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/on_update_icon()

	overlays.Cut()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image("food.dmi", icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			overlays += pizzaimg

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			overlays += tagimg

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand(mob/user)

	if( open && pizza )
		user.put_in_hands( pizza )

		to_chat(user, "<span class='warning'>You take \the [src.pizza] out of \the [src].</span>")
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if(!user.is_holding_offhand(src))
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		to_chat(user, "<span class='warning'>You remove the topmost [src] from your hand.</span>")
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self(mob/user)

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby(obj/item/I, mob/user)
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				if(!user.unEquip(box, src))
					return
				box.boxes = list()// clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, "<span class='warning'>You put \the [box] ontop of \the [src]!</span>")
			else
				to_chat(user, "<span class='warning'>The stack is too high!</span>")
		else
			to_chat(user, "<span class='warning'>Close \the [box] first!</span>")

		return

	if( istype(I, /obj/item/chems/food/snacks/sliceable/pizza/) )

		if( src.open )
			if(!user.unEquip(I, src))
				return
			src.pizza = I

			update_icon()

			to_chat(user, "<span class='warning'>You put \the [I] in \the [src]!</span>")
		else
			to_chat(user, "<span class='warning'>You try to push \the [I] through the lid but it doesn't work!</span>")
		return

	if( istype(I, /obj/item/pen/) )

		if( src.open )
			return

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/Initialize()
	. = ..()
	pizza = new /obj/item/chems/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/Initialize()
	. = ..()
	pizza = new /obj/item/chems/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/Initialize()
	. = ..()
	pizza = new /obj/item/chems/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/Initialize()
	. = ..()
	pizza = new /obj/item/chems/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

/obj/item/chems/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_desc = list("dough" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

//obj/item/chems/food/snacks/dough/Initialize()
//	.=..()
//	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 1)

// Dough + rolling pin = flat dough
/obj/item/chems/food/snacks/dough/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/kitchen/rollingpin))
		new /obj/item/chems/food/snacks/sliceable/flatdough(src)
		to_chat(user, "You flatten the dough.")
		qdel(src)

// slicable into 3x doughslices
/obj/item/chems/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/chems/food/snacks/doughslice
	slices_num = 3
	center_of_mass = @"{'x':16,'y':16}"

/obj/item/chems/food/snacks/sliceable/flatdough/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 1)
	reagents.add_reagent(/decl/material/liquid/nutriment, 3)

/obj/item/chems/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/chems/food/snacks/spagetti
	slices_num = 1
	bitesize = 2
	center_of_mass = @"{'x':17,'y':19}"
	nutriment_desc = list("dough" = 1)
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	nutriment_desc = list("bun" = 4)
	nutriment_amt = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

//Items you can craft together. Like bomb making, but with food and less screwdrivers.

/obj/item/chems/food/snacks/bun/attackby(obj/item/W, mob/user)
	// bun + meatball = burger
	if(istype(W,/obj/item/chems/food/snacks/meatball))
		new /obj/item/chems/food/snacks/plainburger(src)
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// bun + cutlet = hamburger
	else if(istype(W,/obj/item/chems/food/snacks/cutlet))
		new /obj/item/chems/food/snacks/hamburger(src)
		to_chat(user, "You make a hamburger.")
		qdel(W)
		qdel(src)

	// bun + sausage = hotdog
	else if(istype(W,/obj/item/chems/food/snacks/sausage))
		new /obj/item/chems/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)

// burger + cheese wedge = cheeseburger
/obj/item/chems/food/snacks/plainburger/attackby(obj/item/chems/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))// && !istype(src,/obj/item/chems/food/snacks/cheesewedge))
		new /obj/item/chems/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Hamburger + cheese wedge = cheeseburger
/obj/item/chems/food/snacks/hamburger/attackby(obj/item/chems/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))// && !istype(src,/obj/item/chems/food/snacks/cheesewedge))
		new /obj/item/chems/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human burger + cheese wedge = cheeseburger
/obj/item/chems/food/snacks/human/burger/attackby(obj/item/chems/food/snacks/cheesewedge/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/snacks/cheeseburger(src)
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Spaghetti + meatball = spaghetti with meatball(s)
/obj/item/chems/food/snacks/boiledspagetti/attackby(obj/item/chems/food/snacks/meatball/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/snacks/meatballspagetti(src)
		to_chat(user, "You add some meatballs to the spaghetti.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Spaghetti with meatballs + meatball = spaghetti with more meatball(s)
/obj/item/chems/food/snacks/meatballspagetti/attackby(obj/item/chems/food/snacks/meatball/W, mob/user)
	if(istype(W))
		new /obj/item/chems/food/snacks/spesslaw(src)
		to_chat(user, "You add some more meatballs to the spaghetti.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Spaghetti + tomato = tomato'd spaghetti //commented out because I don't know how to define a tomato.
//obj/item/chems/food/snacks/spagetti/attackby(/obj/item/chems/food/snacks/grown/tomato/W, mob/user)
//	if(istype(W))
//		new /obj/item/chems/food/snacks/pastatomato(src)
//		to_chat(user, "You add some more meatballs to the spaghetti.")
//		qdel(W)
//		qdel(src)
//		return
//	else
//		..()

/obj/item/chems/food/snacks/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':8}"
	nutriment_desc = list("bun" = 8)
	nutriment_amt = 8
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3
	center_of_mass = @"{'x':21,'y':12}"
	nutriment_desc = list("cheese" = 2,"taco shell" = 2)
	nutriment_amt = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/taco/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)

/obj/item/chems/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	center_of_mass = @"{'x':17,'y':20}"
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/rawcutlet/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 1)

/obj/item/chems/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2
	center_of_mass = @"{'x':17,'y':20}"
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/cutlet/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':15}"
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/rawmeatball/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':17}"
	nutriment_type = /decl/material/liquid/nutriment/bread
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/hotdog/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 6)

/obj/item/chems/food/snacks/classichotdog
	name = "classic hotdog"
	desc = "Going literal."
	icon_state = "hotcorgi"
	bitesize = 6
	center_of_mass = @"{'x':16,'y':17}"
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/classichotdog/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 16)

/obj/item/chems/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':16}"
	nutriment_desc = list("bread" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

// potato + knife = raw sticks
/obj/item/chems/food/snacks/grown/potato/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/knife))
		new /obj/item/chems/food/snacks/rawsticks(src)
		to_chat(user, "You cut the potato.")
		qdel(src)
	else
		..()

/obj/item/chems/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Uncooked potato stick, not very tasty."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	center_of_mass = @"{'x':16,'y':12}"
	nutriment_desc = list("raw potato" = 3)
	nutriment_amt = 3

//Canned Foods - crack open, eat.

/obj/item/chems/food/snacks/canned
	name = "void can"
	icon = 'icons/obj/food_canned.dmi'
	atom_flags = 0
	var/sealed = TRUE

/obj/item/chems/food/snacks/canned/Initialize()
	. = ..()
	if(!sealed)
		unseal()

/obj/item/chems/food/snacks/canned/examine(mob/user)
	. = ..()
	to_chat(user, "It is [sealed ? "" : "un"]sealed.")

/obj/item/chems/food/snacks/canned/proc/unseal()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	sealed = FALSE
	update_icon()

/obj/item/chems/food/snacks/canned/attack_self(var/mob/user)
	if(sealed)
		playsound(loc,'sound/effects/canopen.ogg', rand(10,50), 1)
		to_chat(user, "<span class='notice'>You unseal \the [src] with a crack of metal.</span>")
		unseal()

/obj/item/chems/food/snacks/canned/on_update_icon()
	if(!sealed)
		icon_state = "[initial(icon_state)]-open"

//Just a short line of Canned Consumables, great for treasure in faraway abandoned outposts

/obj/item/chems/food/snacks/canned/beef
	name = "quadrangled beefium"
	icon_state = "beef"
	desc = "Proteins carefully cloned from an extinct species of cattle in a secret facility on the outer rim."
	trash = /obj/item/trash/beef
	filling_color = "#663300"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("beef" = 1)
	bitesize = 3
/obj/item/chems/food/snacks/canned/beef/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 12)

/obj/item/chems/food/snacks/canned/beans
	name = "baked beans"
	icon_state = "beans"
	desc = "Carefully synthethized from soy."
	trash = /obj/item/trash/beans
	filling_color = "#ff6633"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("beans" = 1)
	nutriment_amt = 12
	bitesize = 3

/obj/item/chems/food/snacks/canned/tomato
	name = "tomato soup"
	icon_state = "tomato"
	desc = "Plain old unseasoned tomato soup. This can is older than you are!"
	trash = /obj/item/trash/tomato
	filling_color = "#ae0000"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("tomato" = 1)
	bitesize = 3
	eat_sound = 'sound/items/drink.ogg'

/obj/item/chems/food/snacks/canned/tomato/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/drink/juice/tomato, 12)


/obj/item/chems/food/snacks/canned/tomato/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/chems/food/snacks/canned/spinach
	name = "spinach"
	icon_state = "spinach"
	desc = "Notably has less iron in it than a watermelon."
	trash = /obj/item/trash/spinach
	filling_color = "#003300"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("sogginess" = 1, "vegetable" = 1)
	bitesize = 20
/obj/item/chems/food/snacks/canned/spinach/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 5,
						/decl/material/liquid/adrenaline, 5,
						/decl/material/liquid/amphetamines, 5,
						/decl/material/solid/metal/iron, 5)

//Vending Machine Foods should go here.

/obj/item/chems/food/snacks/canned/caviar
	name = "canned caviar"
	icon_state = "fisheggs"
	desc = "Caviar, or space carp eggs. Carefully faked using alginate, artificial flavoring and salt."
	trash = /obj/item/trash/fishegg
	filling_color = "#000000"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 6
	bitesize = 1

/obj/item/chems/food/snacks/canned/caviar/true
	name = "canned caviar"
	icon_state = "carpeggs"
	desc = "Caviar, or space carp eggs. Exceeds the recomended amount of heavy metals in your diet! But very posh."
	trash = /obj/item/trash/carpegg
	filling_color = "#330066"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fish" = 1, "salt" = 1, "numbing sensation" = 1)
	nutriment_amt = 6
	bitesize = 1
/obj/item/chems/food/snacks/caviar/true/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)
	reagents.add_reagent(/decl/material/liquid/carpotoxin, 1)

/obj/item/chems/food/snacks/sosjerky
	name = "emergency meat jerky"
	icon_state = "sosjerky"
	desc = "For when you desperately want meat and you don't care what kind. Has the same texture as old leather boots."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	center_of_mass = @"{'x':15,'y':9}"
	bitesize = 2
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/sosjerky/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/no_raisin
	name = "raisins"
	icon_state = "4no_raisins"
	desc = "Pouring water on these will not turn them back into grapes, unfortunately."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	center_of_mass = @"{'x':15,'y':4}"
	nutriment_desc = list("raisins" = 6)
	nutriment_amt = 6

/obj/item/chems/food/snacks/spacetwinkie
	name = "eclair"
	icon_state = "space_twinkie"
	desc = "So full of preservatives, it's guaranteed to survive longer then you will."
	filling_color = "#ffe591"
	center_of_mass = @"{'x':15,'y':11}"
	bitesize = 2
/obj/item/chems/food/snacks/spacetwinkie/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 4)

/obj/item/chems/food/snacks/cheesiehonkers
	name = "cheese puffs"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheese flavoured snacks that will leave your fingers coated in cheese dust."
	trash = /obj/item/trash/cheesie
	filling_color = "#ffa305"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("cheese" = 5, "chips" = 2)
	nutriment_amt = 4
	bitesize = 2

/obj/item/chems/food/snacks/syndicake
	name = "subversive cakes"
	icon_state = "syndi_cakes"
	desc = "Made using extremely unethical labour, ingredients and marketing methods."
	filling_color = "#ff5d05"
	center_of_mass = @"{'x':16,'y':10}"
	nutriment_desc = list("sweetness" = 3, "cake" = 1)
	nutriment_amt = 4
	trash = /obj/item/trash/syndi_cakes
	bitesize = 3

/obj/item/chems/food/snacks/syndicake/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/regenerator, 5)

//terran delights

/obj/item/chems/food/snacks/pistachios
	name = "pistachios"
	icon_state = "pistachios"
	desc = "Pistachios. There is absolutely nothing remarkable about these."
	trash = /obj/item/trash/pistachios
	filling_color = "#825d26"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("nuts" = 1)
	nutriment_amt = 3
	bitesize = 0.5

/obj/item/chems/food/snacks/semki
	name = "sunflower seeds"
	icon_state = "semki"
	desc = "A favorite among birds."
	trash = /obj/item/trash/semki
	filling_color = "#68645d"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("sunflower seeds" = 1)
	nutriment_amt = 6
	bitesize = 0.5

/obj/item/chems/food/snacks/squid
	name = "\improper Calamari Crisps"
	icon_state = "squid"
	desc = "Space cepholapod tentacles, carefully removed from the squid then dried into strips of delicious rubbery goodness!"
	trash = /obj/item/trash/squid
	filling_color = "#c0a9d7"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1
/obj/item/chems/food/snacks/squid/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/croutons
	name = "croutons"
	icon_state = "croutons"
	desc = "Fried bread cubes. Good in salad but I guess you can just eat them as is."
	trash = /obj/item/trash/croutons
	filling_color = "#c6b17f"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("bread" = 1, "salt" = 1)
	nutriment_amt = 3
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/salo
	name = "salo"
	icon_state = "salo"
	desc = "Pig fat. Salted. Just as good as it sounds."
	trash = /obj/item/trash/salo
	filling_color = "#e0bcbc"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fat" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 2
/obj/item/chems/food/snacks/salo/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/snacks/driedfish
	name = "vobla"
	icon_state = "driedfish"
	desc = "Dried salted beer snack fish."
	trash = /obj/item/trash/driedfish
	filling_color = "#c8a5bb"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fish" = 1, "salt" = 1)
	nutriment_amt = 2
	bitesize = 1
/obj/item/chems/food/snacks/driedfish/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)

/obj/item/chems/food/snacks/liquidfood
	name = "\improper LiquidFood MRE"
	desc = "A prepackaged grey slurry for all of the essential nutrients a soldier requires to survive. No expiration date is visible..."
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#a8a8a8"
	center_of_mass = @"{'x':16,'y':15}"
	nutriment_desc = list("chalk" = 6)
	nutriment_amt = 20
	bitesize = 4
/obj/item/chems/food/snacks/liquidfood/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/solid/metal/iron, 3)

/obj/item/chems/food/snacks/meatcube
	name = "cubed meat"
	desc = "Fried, salted lean meat compressed into a cube. Not very appetizing."
	icon_state = "meatcube"
	filling_color = "#7a3d11"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 3
	material = /decl/material/solid/meat

/obj/item/chems/food/snacks/meatcube/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 15)

/obj/item/chems/food/snacks/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy... and surprisingly tasty."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#a66829"
	center_of_mass = @"{'x':17,'y':16}"
	nutriment_desc = list("bread" = 2, "sweetness" = 3)
	nutriment_amt = 6
	nutriment_type = /decl/material/liquid/nutriment/bread
	bitesize = 2

/obj/item/chems/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7d5f46"
	center_of_mass = @"{'x':15,'y':15}"
	nutriment_amt = 1
	nutriment_desc = list("candy" = 1)
	bitesize = 2
/obj/item/chems/food/snacks/candy/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 3)

/obj/item/chems/food/snacks/candy/proteinbar
	name = "protein bar"
	desc = "MuscleLopin brand protein bars, guaranteed to get you soSO strong!"
	icon_state = "proteinbar"
	trash = /obj/item/trash/candy/proteinbar
	bitesize = 6
/obj/item/chems/food/snacks/candy/proteinbar/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 9)
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 4)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 4)

/obj/item/chems/food/snacks/candy/donor
	name = "donor candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	nutriment_desc = list("candy" = 10)
	bitesize = 5
/obj/item/chems/food/snacks/candy/donor/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 10)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 3)

/obj/item/chems/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Not actually candied corn."
	icon_state = "candy_corn"
	filling_color = "#fffcb0"
	center_of_mass = @"{'x':14,'y':10}"
	nutriment_amt = 4
	nutriment_desc = list("candy corn" = 4)
	bitesize = 2
/obj/item/chems/food/snacks/candy_corn/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment, 4)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 2)

/obj/item/chems/food/snacks/chips
	name = "chips"
	desc = "It is impossible to open the packet without rustling it loudly."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#e8c31e"
	center_of_mass = @"{'x':15,'y':15}"
	nutriment_amt = 3
	nutriment_desc = list("salt" = 1, "chips" = 2)
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "cookie"
	filling_color = "#dbc94f"
	center_of_mass = @"{'x':17,'y':18}"
	nutriment_amt = 5
	nutriment_desc = list("sweetness" = 3, "cookie" = 2)
	w_class = ITEM_SIZE_TINY
	bitesize = 1
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/chocolatebar
	name = "chocolate bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7d5f46"
	center_of_mass = @"{'x':15,'y':15}"
	nutriment_amt = 2
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2
/obj/item/chems/food/snacks/chocolatebar/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 2)
	reagents.add_reagent(/decl/material/liquid/nutriment/coco, 2)

/obj/item/chems/food/snacks/chocolateegg
	name = "chocolate egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7d5f46"
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	bitesize = 2

/obj/item/chems/food/snacks/chocolateegg/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 2)
	reagents.add_reagent(/decl/material/liquid/nutriment/coco, 2)

/obj/item/chems/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#d9c386"
	var/overlay_state = "box-donut1"
	center_of_mass = @"{'x':13,'y':16}"
	nutriment_desc = list("sweetness", "donut")
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	nutriment_amt = 3
	bitesize = 3
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/donut/normal/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)

	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)
	center_of_mass = @"{'x':19,'y':16}"

/obj/item/chems/food/snacks/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	filling_color = "#ed11e6"
	nutriment_amt = 2
	bitesize = 10
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/donut/chaos/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(pick(list(
		/decl/material/liquid/nutriment,
		/decl/material/liquid/capsaicin,
		/decl/material/liquid/frostoil,
		/decl/material/liquid/nutriment/sprinkles,
		/decl/material/gas/chlorine,
		/decl/material/liquid/nutriment/coco,
		/decl/material/liquid/slimejelly,
		/decl/material/liquid/nutriment/banana_cream,
		/decl/material/liquid/nutriment/cherryjelly,
		/decl/material/liquid/fuel,
		/decl/material/liquid/regenerator)), 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted chaos donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

/obj/item/chems/food/snacks/donut/jelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_amt = 3
	bitesize = 5
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/chems/food/snacks/donut/jelly/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted jelly donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

/obj/item/chems/food/snacks/donut/slimejelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_amt = 3
	bitesize = 5
/obj/item/chems/food/snacks/donut/slimejelly/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(/decl/material/liquid/slimejelly, 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted jelly donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

/obj/item/chems/food/snacks/donut/cherryjelly
	name = "jelly donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ed1169"
	center_of_mass = @"{'x':16,'y':11}"
	nutriment_amt = 3
	bitesize = 5
/obj/item/chems/food/snacks/donut/cherryjelly/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 1)
	reagents.add_reagent(/decl/material/liquid/nutriment/cherryjelly, 5)
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.SetName("frosted jelly donut")
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 2)

//Sol Vendor

obj/item/chems/food/snacks/lunacake
	name = "moon cake"
	icon_state = "lunacake_wrapped"
	desc = "Now with 20% less lawsuit enabling regolith!"
	trash = /obj/item/trash/cakewrap
	filling_color = "#ffffff"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("sweet" = 4, "vanilla" = 1)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

obj/item/chems/food/snacks/lunacake/mochicake
	name = "mochi"
	icon_state = "mochicake_wrapped"
	desc = "A type of rice cake with an extremely soft, glutinous texture."
	trash = /obj/item/trash/mochicakewrap
	nutriment_desc = list("sweet" = 4, "rice" = 1)

obj/item/chems/food/snacks/lunacake/mooncake
	name = "dark side moon cake"
	icon_state = "mooncake_wrapped"
	desc = "Explore the dark side! May contain trace amounts of reconstituted cocoa."
	trash = /obj/item/trash/mooncakewrap
	filling_color = "#000000"
	nutriment_desc = list("sweet" = 4, "chocolate" = 1)
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

obj/item/chems/food/snacks/triton
	name = "\improper Tidal Gobs"
	icon_state = "tidegobs"
	desc = "Contains over 9000% of your daily recommended intake of salt."
	trash = /obj/item/trash/tidegobs
	filling_color = "#2556b0"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("salt" = 4, "ocean" = 1, "seagull" = 1)
	nutriment_amt = 5
	bitesize = 2

obj/item/chems/food/snacks/saturn
	name = "snack rings"
	icon_state = "saturno"
	desc = "A day ration of salt, styrofoam and possibly sawdust."
	trash = /obj/item/trash/saturno
	filling_color = "#dca319"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("salt" = 4, "peanut" = 2,  "wood?" = 1)
	nutriment_amt = 5
	bitesize = 2

obj/item/chems/food/snacks/jupiter
	name = "probably gelatin"
	icon_state = "jupiter"
	desc = "Some kind of gel, maybe?"
	trash = /obj/item/trash/jupiter
	filling_color = "#dc1919"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("jelly?" = 5)
	nutriment_amt = 5
	bitesize = 2

obj/item/chems/food/snacks/pluto
	name = "nutrient rods"
	icon_state = "pluto"
	desc = "Baseless tasteless nutrient rods to get you through the day. Now even less rash inducing!"
	trash = /obj/item/trash/pluto
	filling_color = "#ffffff"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("chalk" = 4, "sadness" = 1)
	nutriment_amt = 5
	bitesize = 2

obj/item/chems/food/snacks/mars
	name = "instant potato and eggs"
	icon_state = "mars"
	desc = "A steaming self-heated bowl of sweet eggs and taters!"
	trash = /obj/item/trash/mars
	filling_color = "#d2c63f"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("eggs" = 4, "potato" = 4, "mustard" = 2)
	nutriment_amt = 8
	bitesize = 2

obj/item/chems/food/snacks/venus
	name = "hot cakes"
	icon_state = "venus"
	desc = "Hot takes on hot cakes, a timeless classic now finally fit for human consumption!"
	trash = /obj/item/trash/venus
	filling_color = "#d2c63f"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("heat" = 4, "burning" = 1)
	nutriment_amt = 5
	bitesize = 2
	nutriment_type = /decl/material/liquid/nutriment/bread/cake

/obj/item/chems/food/snacks/venus/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/capsaicin = 5)

obj/item/chems/food/snacks/oort
	name = "\improper Cloud Rocks"
	icon_state = "oort"
	desc = "Pop rocks. The new formula guarantees fewer shrapnel induced oral injuries."
	trash = /obj/item/trash/oort
	filling_color = "#3f7dd2"
	center_of_mass = @"{'x':15,'y':9}"
	nutriment_desc = list("fizz" = 3, "sweet?" = 1, "shrapnel" = 1)
	nutriment_amt = 5
	bitesize = 2
/obj/item/chems/food/snacks/oort/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/frostoil = 5)

//weebo vend! So japanese it hurts

obj/item/chems/food/snacks/ricecake
	name = "rice ball"
	icon_state = "ricecake"
	desc = "A snack food made from balled up rice."
	nutriment_desc = list("rice" = 3, "sweet" = 1, "seaweed" = 1)
	nutriment_amt = 5
	bitesize = 2

obj/item/chems/food/snacks/pokey
	name = "chocolate coated biscuit sticks"
	icon_state = "pokeys"
	desc = "A bundle of chocolate coated biscuit sticks. Not as exciting as they seem."
	nutriment_desc = list("chocolate" = 1, "biscuit" = 2, "cardboard" = 2)
	nutriment_amt = 5
	bitesize = 2

obj/item/chems/food/snacks/weebonuts
	name = "spicy nuts"
	icon_state = "weebonuts"
	trash = /obj/item/trash/weebonuts
	desc = "A bag of spicy nuts. Goes well with beer!"
	nutriment_desc = list("nuts" = 4, "spicy!" = 1)
	nutriment_amt = 5
	bitesize = 2
/obj/item/chems/food/snacks/weebonuts/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/capsaicin = 1)

obj/item/chems/food/snacks/chocobanana
	name = "choco banana"
	icon_state = "chocobanana"
	trash = /obj/item/trash/stick
	desc = "A chocolate and sprinkles coated banana. On a stick."
	nutriment_desc = list("banana" = 3, "chocolate" = 1, "wax?" = 1)
	nutriment_amt = 5
	bitesize = 2
/obj/item/chems/food/snacks/chocobanana/Initialize()
	.=..()
	reagents.add_reagent(/decl/material/liquid/nutriment/sprinkles, 10)

obj/item/chems/food/snacks/dango
	name = "dango"
	icon_state = "dango"
	trash = /obj/item/trash/stick
	desc = "Food dyed rice dumplings on a stick."
	nutriment_desc = list("rice" = 4, "topping?" = 1)
	nutriment_amt = 5
	bitesize = 2

//inedible old vendor food

/obj/item/chems/food/snacks/old
	name = "master old-food"
	desc = "they're all inedible and potentially dangerous items"
	center_of_mass = @"{'x':15,'y':12}"
	nutriment_desc = list("rot" = 5, "mold" = 5)
	nutriment_amt = 10
	bitesize = 3
	filling_color = "#336b42"
/obj/item/chems/food/snacks/old/Initialize()
	.=..()
	reagents.add_reagent(pick(list(
				/decl/material/liquid/fuel,
				/decl/material/liquid/amatoxin,
				/decl/material/liquid/carpotoxin,
				/decl/material/liquid/zombiepowder,
				/decl/material/liquid/presyncopics,
				/decl/material/liquid/psychotropics)), 5)


/obj/item/chems/food/snacks/old/pizza
	name = "pizza"
	desc = "It's so stale you could probably cut something with the cheese."
	icon_state = "ancient_pizza"

/obj/item/chems/food/snacks/old/burger
	name = "\improper Giga Burger!"
	desc = "At some point in time this probably looked delicious."
	icon_state = "ancient_burger"

/obj/item/chems/food/snacks/old/hamburger
	name = "\improper Horse Burger!"
	desc = "Even if you were hungry enough to eat a horse, it'd be a bad idea to eat this."
	icon_state = "ancient_hburger"

/obj/item/chems/food/snacks/old/fries
	name = "chips"
	desc = "The salt appears to have preserved these, still stale and gross."
	icon_state = "ancient_fries"

/obj/item/chems/food/snacks/old/hotdog
	name = "hotdog"
	desc = "This one is probably only marginally less safe to eat than when it was first created.."
	icon_state = "ancient_hotdog"

/obj/item/chems/food/snacks/old/taco
	name = "taco"
	desc = "Interestingly, the shell has gone soft and the contents have gone stale."
	icon_state = "ancient_taco"

/obj/item/chems/food/snacks/pelmen
	name = "meat pelmen"
	desc = "Raw meat appetizer."
	icon_state = "pelmen"
	filling_color = "#ffffff"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 2

/obj/item/chems/food/snacks/pelmen/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 1)

/obj/item/chems/food/snacks/pelmeni_boiled
	name = "boiled pelmeni"
	desc = "A dish consisting of boiled pieces of meat wrapped in dough. Delicious!"
	icon_state = "pelmeni_boiled"
	filling_color = "#ffffff"
	center_of_mass = @"{'x':16,'y':16}"
	bitesize = 2

/obj/item/chems/food/snacks/pelmeni_boiled/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 30)
