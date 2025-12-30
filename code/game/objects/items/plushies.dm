//Large plushies.
/obj/structure/plushie
	abstract_type = /obj/structure/plushie
	desc = "A very generic plushie. It seems to not want to exist."
	icon = 'icons/obj/structures/plushie.dmi'
	icon_state = "ianplushie"
	anchored = FALSE
	density = TRUE
	var/phrase = "I don't want to exist anymore!"
	var/phrase_sound
	var/phrase_volume = 20
	var/phrase_vary = TRUE

/obj/structure/plushie/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	playsound(src.loc, 'sound/effects/rustle1.ogg', 100, 1)
	if(user.check_intent(I_FLAG_HELP))
		user.visible_message(
			SPAN_NOTICE("<b>\The [user]</b> hugs \the [src]!"),
			SPAN_NOTICE("You hug \the [src]!"))
	else if (user.check_intent(I_FLAG_HARM))
		user.visible_message(
			SPAN_WARNING("<b>\The [user]</b> punches \the [src]!"),
			SPAN_WARNING("You punch \the [src]!"))
	else if (user.check_intent(I_FLAG_GRAB))
		user.visible_message(
			SPAN_WARNING("<b>\The [user]</b> attempts to strangle \the [src]!"),
			SPAN_WARNING("You attempt to strangle \the [src]!"))
	else
		user.visible_message(
			SPAN_NOTICE("<b>\The [user]</b> pokes \the [src]."),
			SPAN_NOTICE("You poke \the [src]."))
	if(phrase)
		audible_message("<span class='game say'><span class='name'>\The [src]</span> says, <span class='message'><span class='body'>\"[phrase]\"</span></span></span>")
	if(phrase_sound)
		playsound(loc, phrase_sound, phrase_volume, phrase_vary)
	return TRUE

/obj/structure/plushie/ian
	name = "plush corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Ian\"?"
	phrase = "Arf!"

/obj/structure/plushie/drone
	name = "plush drone"
	desc = "A plushie of a happy drone! It appears to be smiling."
	icon_state = "droneplushie"
	phrase = "Beep boop!"

/obj/structure/plushie/carp
	name = "plush carp"
	desc = "A plushie of an elated carp! Straight from the wilds of the frontier, now right here in your hands."
	icon_state = "carpplushie"
	phrase = "Glorf!"

/obj/structure/plushie/beepsky
	name = "plush Officer Sweepsky"
	desc = "A plushie of a popular industrious cleaning robot! If it could feel emotions, it would love you."
	icon_state = "beepskyplushie"
	phrase = "Ping!"

//Small plushies.
/obj/item/toy/plushie
	abstract_type = /obj/item/toy/plushie
	name = "generic small plush"
	desc = "A very generic small plushie. It seems to not want to exist."
	icon = 'icons/obj/toy/plush_nymph.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_HEAD
	var/phrase
	var/phrase_sound
	var/phrase_volume = 20
	var/phrase_vary = TRUE

/obj/item/toy/plushie/attack_self(mob/user)
	if(user.check_intent(I_FLAG_HELP))
		user.visible_message(
			SPAN_NOTICE("<b>\The [user]</b> hugs \the [src]!"),
			SPAN_NOTICE("You hug \the [src]!"))
	else if (user.check_intent(I_FLAG_HARM))
		user.visible_message(
			SPAN_WARNING("<b>\The [user]</b> punches \the [src]!"),
			SPAN_WARNING("You punch \the [src]!"))
	else if (user.check_intent(I_FLAG_GRAB))
		user.visible_message(
			SPAN_WARNING("<b>\The [user]</b> attempts to strangle \the [src]!"),
			SPAN_WARNING("You attempt to strangle \the [src]!"))
	else
		user.visible_message(
			SPAN_NOTICE("<b>\The [user]</b> pokes \the [src]."),
			SPAN_NOTICE("You poke \the [src]."))
	if(phrase)
		audible_message("<span class='game say'><span class='name'>\The [src]</span> says, <span class='message'><span class='body'>\"[phrase]\"</span></span></span>")
	if(phrase_sound)
		playsound(loc, phrase_sound, phrase_volume, phrase_vary)
	return TRUE

/obj/item/toy/plushie/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	. = ..()
	if(. && phrase_sound)
		playsound(src, phrase_sound, phrase_volume, phrase_vary)

// Various miscellaneous animal plushies.
/obj/item/toy/plushie/deer
	name = "deer plushie"
	desc = "A soft deer plush."
	icon = 'icons/obj/toy/plush_deer.dmi'

/obj/item/toy/plushie/mouse
	name = "mouse plush"
	desc = "A plushie of a mouse! What was once considered a vile rodent is now your very best friend."
	icon = 'icons/obj/toy/plush_mouse.dmi'

/obj/item/toy/plushie/kitten
	name = "kitten plush"
	desc = "A plushie of a cute kitten! Watch as it purrs its way right into your heart."
	icon = 'icons/obj/toy/plush_kitten.dmi'

/obj/item/toy/plushie/lizard
	name = "lizard plush"
	desc = "A plushie of a scaly lizard!"
	icon = 'icons/obj/toy/plush_lizard.dmi'

/obj/item/toy/plushie/spider
	name = "spider plush"
	desc = "A plushie of a fuzzy spider! It has eight legs - all the better to hug you with."
	icon = 'icons/obj/toy/plush_spider.dmi'

/obj/item/toy/plushie/corgi
	name = "corgi plushie"
	desc = "A soft corgi plush."
	icon = 'icons/obj/toy/plush_corgi.dmi'

/obj/item/toy/plushie/corgi/ribbon
	desc = "A soft corgi plush. This one has a ribbon."
	icon = 'icons/obj/toy/plush_corgi_ribbon.dmi'

/obj/item/toy/plushie/robo_corgi
	name = "robot corgi plushie"
	desc = "A corgi plush with a stiff grey plastic casing and a red monoptic."
	icon = 'icons/obj/toy/plush_corgi_robot.dmi'

/obj/item/toy/plushie/octopus
	name = "octopus plushie"
	desc = "A soft octopus plushie."
	icon = 'icons/obj/toy/plush_octopus.dmi'

/obj/item/toy/plushie/face_hugger
	name = "huggable alien plushie"
	desc = "A strange alien plushie."
	icon = 'icons/obj/toy/plush_facehugger.dmi'

/obj/item/toy/plushie/nymph
	name = "nymph plushie"
	desc = "A soft diona nymph plush."
	icon = 'icons/obj/toy/plush_nymph.dmi'

// Therapy plushes.
/obj/item/toy/plushie/therapy
	name = "red therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is red."
	icon = 'icons/obj/toy/plush_therapy_red.dmi'

/obj/item/toy/plushie/therapy/orange
	name = "orange therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is orange."
	icon = 'icons/obj/toy/plush_therapy_orange.dmi'


/obj/item/toy/plushie/therapy/yellow
	name = "yellow therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is yellow."
	icon = 'icons/obj/toy/plush_therapy_yellow.dmi'

/obj/item/toy/plushie/therapy/green
	name = "green therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is green."
	icon = 'icons/obj/toy/plush_therapy_green.dmi'

/obj/item/toy/plushie/therapy/purple
	name = "purple therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is purple."
	icon = 'icons/obj/toy/plush_therapy_purple.dmi'

/obj/item/toy/plushie/therapy/blue
	name = "blue therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is blue."
	icon = 'icons/obj/toy/plush_therapy_blue.dmi'

// Carp plushies
/obj/item/toy/plushie/carp
	name = "space carp plushie"
	desc = "An adorable stuffed toy that resembles a space carp."
	attack_verb = list("bitten", "eaten", "fin slapped")
	phrase_sound = 'sound/weapons/bite.ogg'
	icon = 'icons/obj/toy/plush_carp.dmi'
/obj/item/toy/plushie/carp/ice
	name = "ice carp plushie"
	icon = 'icons/obj/toy/plush_carp_ice.dmi'

/obj/item/toy/plushie/carp/silent
	name = "monochrome carp plushie"
	icon = 'icons/obj/toy/plush_carp_silent.dmi'

/obj/item/toy/plushie/carp/electric
	name = "electric carp plushie"
	icon = 'icons/obj/toy/plush_carp_electric.dmi'

/obj/item/toy/plushie/carp/gold
	name = "golden carp plushie"
	icon = 'icons/obj/toy/plush_carp_gold.dmi'

/obj/item/toy/plushie/carp/toxin
	name = "toxic carp plushie"
	icon = 'icons/obj/toy/plush_carp_toxic.dmi'

/obj/item/toy/plushie/carp/dragon
	name = "dragon carp plushie"
	icon = 'icons/obj/toy/plush_carp_dragon.dmi'

/obj/item/toy/plushie/carp/pink
	name = "pink carp plushie"
	icon = 'icons/obj/toy/plush_carp_pink.dmi'

/obj/item/toy/plushie/carp/candy
	name = "candy carp plushie"
	icon = 'icons/obj/toy/plush_carp_candy.dmi'

/obj/item/toy/plushie/carp/nebula
	name = "nebula carp plushie"
	icon = 'icons/obj/toy/plush_carp_nebula.dmi'

/obj/item/toy/plushie/carp/void
	name = "void carp plushie"
	icon = 'icons/obj/toy/plush_carp_void.dmi'

// Fox plushes.
/obj/item/toy/plushie/fox
	name = "red fox plushie"
	icon = 'icons/obj/toy/plush_fox.dmi'

/obj/item/toy/plushie/fox/black
	name = "black fox plushie"
	icon = 'icons/obj/toy/plush_fox_black.dmi'

/obj/item/toy/plushie/fox/marble
	name = "marble fox plushie"
	icon = 'icons/obj/toy/plush_fox_marble.dmi'

/obj/item/toy/plushie/fox/blue
	name = "blue fox plushie"
	icon = 'icons/obj/toy/plush_fox_blue.dmi'

/obj/item/toy/plushie/fox/orange
	name = "orange fox plushie"
	icon = 'icons/obj/toy/plush_fox_orange.dmi'

/obj/item/toy/plushie/fox/coffee
	name = "coffee fox plushie"
	icon = 'icons/obj/toy/plush_fox_coffee.dmi'

/obj/item/toy/plushie/fox/pink
	name = "pink fox plushie"
	icon = 'icons/obj/toy/plush_fox_pink.dmi'

/obj/item/toy/plushie/fox/purple
	name = "purple fox plushie"
	icon = 'icons/obj/toy/plush_fox_purple.dmi'

/obj/item/toy/plushie/fox/crimson
	name = "crimson fox plushie"
	icon = 'icons/obj/toy/plush_fox_crimson.dmi'

// Cat plushes.
/obj/item/toy/plushie/cat
	name = "black cat plushie"
	desc = "A plush toy cat."
	icon = 'icons/obj/toy/plush_cat.dmi'

/obj/item/toy/plushie/cat/grey
	name = "grey cat plushie"
	icon = 'icons/obj/toy/plush_cat_grey.dmi'

/obj/item/toy/plushie/cat/white
	name = "white cat plushie"
	icon = 'icons/obj/toy/plush_cat_white.dmi'

/obj/item/toy/plushie/cat/orange
	name = "orange cat plushie"
	icon = 'icons/obj/toy/plush_cat_orange.dmi'

/obj/item/toy/plushie/cat/siamese
	name = "siamese cat plushie"
	icon = 'icons/obj/toy/plush_cat_siamese.dmi'

/obj/item/toy/plushie/cat/tabby
	name = "tabby cat plushie"
	icon = 'icons/obj/toy/plush_cat_tabby.dmi'

/obj/item/toy/plushie/cat/tuxedo
	name = "tuxedo cat plushie"
	icon = 'icons/obj/toy/plush_cat_tuxedo.dmi'

// Squid plushies.
/obj/item/toy/plushie/squid
	name = "green squid plushie"
	desc = "A small, cute and loveable squid friend. This one is green."
	icon = 'icons/obj/toy/plush_squid.dmi'

/obj/item/toy/plushie/squid/mint
	name = "mint squid plushie"
	desc = "A small, cute and loveable squid friend. This one is mint coloured."
	icon = 'icons/obj/toy/plush_squid_mint.dmi'

/obj/item/toy/plushie/squid/blue
	name = "blue squid plushie"
	desc = "A small, cute and loveable squid friend. This one is blue."
	icon = 'icons/obj/toy/plush_squid_blue.dmi'

/obj/item/toy/plushie/squid/orange
	name = "orange squid plushie"
	desc = "A small, cute and loveable squid friend. This one is orange."
	icon = 'icons/obj/toy/plush_squid_orange.dmi'

/obj/item/toy/plushie/squid/yellow
	name = "yellow squid plushie"
	desc = "A small, cute and loveable squid friend. This one is yellow."
	icon = 'icons/obj/toy/plush_squid_yellow.dmi'

/obj/item/toy/plushie/squid/pink
	name = "pink squid plushie"
	desc = "A small, cute and loveable squid friend. This one is pink."
	icon = 'icons/obj/toy/plush_squid_pink.dmi'
