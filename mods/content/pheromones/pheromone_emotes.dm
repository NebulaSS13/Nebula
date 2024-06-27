/decl/emote/pheromone
	abstract_type = /decl/emote/pheromone
	var/smell_message
	var/self_smell_descriptor
	var/scent_color

/decl/emote/pheromone/mob_can_use(mob/living/user, assume_available = FALSE)
	return istype(user) && user.can_read_pheromones() && ..()

/decl/emote/pheromone/fear
	key = "scentfear"
	smell_message = "<span class='danger'>FEAR</span>"
	self_smell_descriptor = "distressing"
	scent_color = COLOR_RED

/decl/emote/pheromone/pain
	key = "scentpain"
	smell_message = "<span class='danger'>PAIN</span>"
	self_smell_descriptor = "distressing"
	scent_color = COLOR_RED

/decl/emote/pheromone/calm
	key = "scentcalm"
	smell_message = "<span class='notice'><b>calm</b></span>"
	self_smell_descriptor = "soothing"
	scent_color = COLOR_BLUE

/decl/emote/pheromone/storm
	key = "scentstorm"
	smell_message = "<span class='danger'><b>an oncoming storm</b></span>"
	self_smell_descriptor = "distressing"
	scent_color = COLOR_ORANGE

/decl/emote/pheromone/flood
	key = "scentflood"
	smell_message = "<span class='danger'><b>flooding tunnels</b></span>"
	self_smell_descriptor = "frantic"
	scent_color = COLOR_YELLOW

/decl/emote/pheromone/newsisters
	key = "scentsisters"
	smell_message = "<span class='danger'><b>new sisters</b></span>"
	self_smell_descriptor = "cheerful"
	scent_color = COLOR_GREEN_GRAY

/decl/emote/pheromone/foodgood
	key = "scentgoodfood"
	smell_message = "<span class='danger'><b>lots of good food</b></span>"
	self_smell_descriptor = "enticing"
	scent_color = COLOR_GREEN

/decl/emote/pheromone/foodbad
	key = "scentbadfood"
	smell_message = "<span class='danger'><b>spoiled food</b></span>"
	self_smell_descriptor = "disgusting"
	scent_color = COLOR_PURPLE

/decl/emote/pheromone/happy
	key = "scenthappy"
	smell_message = "<span class='danger'><b>happiness</b></span>"
	self_smell_descriptor = "positive"
	scent_color = COLOR_BABY_BLUE

/decl/emote/pheromone/sad
	key = "scentsad"
	smell_message = "<span class='danger'><b>sadness</b></span>"
	self_smell_descriptor = "ennervating"
	scent_color = COLOR_INDIGO

/decl/emote/pheromone/do_emote(var/atom/user, var/extra_params)
	if(!ismob(user))
		return
	var/mob/M = user
	if(M.incapacitated())
		return
	var/turf/T = get_turf(M)
	if(!T)
		return
	to_chat(user, SPAN_NOTICE("You emit the [self_smell_descriptor ? "[self_smell_descriptor] " : ""]scent of [smell_message]."))
	for(var/mob/living/human/H in viewers(world.view, user))
		if(H != user && H.stat == CONSCIOUS && H.can_read_pheromones())
			to_chat(H, SPAN_NOTICE("\The [user] emits the [self_smell_descriptor ? "[self_smell_descriptor] " : ""]scent of [smell_message]."))

	var/obj/effect/decal/cleanable/pheromone/pheromone = (locate() in T) || new(T)
	pheromone.color = scent_color || get_random_colour()
	pheromone.alpha = min(pheromone.alpha+30, 120)
	pheromone.cleanable_scent = smell_message
	pheromone.desc = "It smells of [smell_message]."
	pheromone.set_cleanable_scent()

/decl/emote/pheromone/custom
	key = "scentcustom"

/decl/emote/pheromone/custom/do_emote(var/atom/user, var/extra_params)
	var/new_smell = sanitize(extra_params || input("Please enter a short pheromone message.", "Pheromone") as text|null, max_length = MAX_LNAME_LEN)
	if(new_smell)
		smell_message = new_smell
		. = ..()
