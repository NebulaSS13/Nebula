/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	gender = PLURAL
	origin_tech = "{'materials':1}"

	var/singular_name
	var/plural_name
	var/base_state
	var/plural_icon_state
	var/max_icon_state
	var/amount = 1
	var/list/initial_matter
	var/matter_multiplier = 1
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/stack_merge_type  //determines whether different stack types can merge
	var/build_type //used when directly applied to a turf
	var/uses_charge
	var/list/charge_costs
	var/list/datum/matter_synth/synths
	var/list/datum/stack_recipe/recipes

/obj/item/stack/Initialize(mapload, amount, material)

	if(ispath(amount, /decl/material))
		PRINT_STACK_TRACE("Stack initialized with material ([amount]) instead of amount.")
		material = amount
	if (isnum(amount) && amount >= 1)
		src.amount = amount
	. = ..(mapload, material)
	if(!stack_merge_type)
		stack_merge_type = type
	if(!singular_name)
		singular_name = "sheet"
	if(!plural_name)
		plural_name = "[singular_name]s"

/obj/item/stack/Destroy()
	if(uses_charge)
		return 1
	if (src && usr && usr.machine == src)
		close_browser(usr, "window=stack")
	return ..()

/obj/item/stack/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(!uses_charge)
			to_chat(user, "There [src.amount == 1 ? "is" : "are"] [src.amount] [src.singular_name]\s in the stack.")
		else
			to_chat(user, "There is enough charge for [get_amount()].")

/obj/item/stack/attack_self(mob/user)
	list_recipes(user)

/obj/item/stack/get_matter_amount_modifier()
	. = amount * matter_multiplier

/obj/item/stack/proc/list_recipes(mob/user, recipes_sublist)
	if (!recipes)
		return
	if (!src || get_amount() <= 0)
		close_browser(user, "window=stack")
	user.set_machine(src) //for correct work of onclose
	var/list/recipe_list = recipes
	if (recipes_sublist && recipe_list[recipes_sublist] && istype(recipe_list[recipes_sublist], /datum/stack_recipe_list))
		var/datum/stack_recipe_list/srl = recipe_list[recipes_sublist]
		recipe_list = srl.recipes
	var/t1 = list()
	t1 += "<HTML><HEAD><title>Constructions from [src]</title></HEAD><body><TT>Amount Left: [src.get_amount()]<br>"
	for(var/i=1;i<=recipe_list.len,i++)
		var/E = recipe_list[i]
		if (isnull(E))
			continue

		if (istype(E, /datum/stack_recipe_list))
			t1+="<br>"
			var/datum/stack_recipe_list/srl = E
			t1 += "\[Sub-menu] <a href='?src=\ref[src];sublist=[i]'>[srl.title]</a>"

		if (istype(E, /datum/stack_recipe))
			var/datum/stack_recipe/R = E
			t1+="<br>"
			var/max_multiplier = round(src.get_amount() / R.req_amount)
			var/title
			var/can_build = 1
			can_build = can_build && (max_multiplier>0)
			if (R.res_amount>1)
				title+= "[R.res_amount]x [R.display_name()]\s"
			else
				title+= "[R.display_name()]"
			title+= " ([R.req_amount] [src.singular_name]\s)"
			var/skill_label = ""
			if(!user.skill_check(SKILL_CONSTRUCTION, R.difficulty))
				var/decl/hierarchy/skill/S = GET_DECL(SKILL_CONSTRUCTION)
				skill_label = "<font color='red'>\[[S.levels[R.difficulty]]]</font>"
			if (can_build)
				t1 +="[skill_label]<A href='?src=\ref[src];sublist=[recipes_sublist];make=[i];multiplier=1'>[title]</A>"
			else
				t1 += "[skill_label][title]"
			if (R.max_res_amount>1 && max_multiplier>1)
				max_multiplier = min(max_multiplier, round(R.max_res_amount/R.res_amount))
				t1 += " |"
				var/list/multipliers = list(5,10,25)
				for (var/n in multipliers)
					if (max_multiplier>=n)
						t1 += " <A href='?src=\ref[src];make=[i];multiplier=[n]'>[n*R.res_amount]x</A>"
				if (!(max_multiplier in multipliers))
					t1 += " <A href='?src=\ref[src];make=[i];multiplier=[max_multiplier]'>[max_multiplier*R.res_amount]x</A>"

	t1 += "</TT></body></HTML>"
	show_browser(user, JOINTEXT(t1), "window=stack")
	onclose(user, "stack")

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe, var/quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(required))
		if (produced>1)
			to_chat(user, "<span class='warning'>You haven't got enough [src] to build \the [produced] [recipe.display_name()]\s!</span>")
		else
			to_chat(user, "<span class='warning'>You haven't got enough [src] to build \the [recipe.display_name()]!</span>")
		return

	if(!recipe.can_make(user))
		return

	if (recipe.time)
		to_chat(user, "<span class='notice'>Building [recipe.display_name()] ...</span>")
		if (!user.do_skilled(recipe.time, SKILL_CONSTRUCTION))
			return

	if (use(required))
		if(user.skill_fail_prob(SKILL_CONSTRUCTION, 90, recipe.difficulty))
			to_chat(user, "<span class='warning'>You waste some [name] and fail to build \the [recipe.display_name()]!</span>")
			return
		var/atom/O = recipe.spawn_result(user, user.loc, produced)
		if(!QDELETED(O)) // In case of stack merger.
			O.add_fingerprint(user)
			user.put_in_hands(O)

/obj/item/stack/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return

	if (href_list["sublist"] && !href_list["make"])
		list_recipes(usr, text2num(href_list["sublist"]))

	if (href_list["make"])
		if (src.get_amount() < 1) qdel(src) //Never should happen

		var/list/recipes_list = recipes
		if (href_list["sublist"])
			var/datum/stack_recipe_list/srl = recipes_list[text2num(href_list["sublist"])]
			recipes_list = srl.recipes

		var/datum/stack_recipe/R = recipes_list[text2num(href_list["make"])]
		var/multiplier = text2num(href_list["multiplier"])
		if (!multiplier || (multiplier <= 0)) //href exploit protection
			return

		src.produce_recipe(R, multiplier, usr)

	if (src && usr.machine==src) //do not reopen closed window
		spawn( 0 )
			src.interact(usr)
			return
	return

//Return 1 if an immediate subsequent call to use() would succeed.
//Ensures that code dealing with stacks uses the same logic
/obj/item/stack/proc/can_use(var/used)
	if (get_amount() < used)
		return 0
	return 1

/obj/item/stack/create_matter()
	..()
	initial_matter = matter?.Copy()

/obj/item/stack/proc/update_matter()
	matter = initial_matter?.Copy()
	create_matter()

/obj/item/stack/proc/use(var/used)
	if (!can_use(used))
		return 0
	if(!uses_charge)
		amount -= used
		if (amount <= 0)
			qdel(src) //should be safe to qdel immediately since if someone is still using this stack it will persist for a little while longer
		else
			update_icon()
			update_matter()
		return 1
	else
		if(get_amount() < used)
			return 0
		for(var/i = 1 to charge_costs.len)
			var/datum/matter_synth/S = synths[i]
			S.use_charge(charge_costs[i] * used) // Doesn't need to be deleted
		return 1

/obj/item/stack/proc/add(var/extra)
	if(!uses_charge)
		if(amount + extra > get_max_amount())
			return 0
		else
			amount += extra
			update_icon()
			update_matter()
			return 1
	else if(!synths || synths.len < uses_charge)
		return 0
	else
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.add_charge(charge_costs[i] * extra)

/*
	The transfer and split procs work differently than use() and add().
	Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
	They also remove an equal amount from the source stack.
*/

//attempts to transfer amount to S, and returns the amount actually transferred
/obj/item/stack/proc/transfer_to(obj/item/stack/S, var/tamount=null)
	if (!get_amount() || !istype(S))
		return 0
	if (stack_merge_type != S.stack_merge_type)
		return 0
	if (isnull(tamount))
		tamount = src.get_amount()

	var/transfer = max(min(tamount, src.get_amount(), (S.get_max_amount() - S.get_amount())), 0)

	var/orig_amount = src.get_amount()
	if (transfer && src.use(transfer))
		S.add(transfer)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(S)
		return transfer
	return 0

//creates a new stack with the specified amount
/obj/item/stack/proc/split(var/tamount, var/force=FALSE)
	if (!amount)
		return null
	if(uses_charge && !force)
		return null

	var/transfer = max(min(tamount, src.amount, initial(max_amount)), 0)

	var/orig_amount = src.amount
	if (transfer && src.use(transfer))
		var/obj/item/stack/newstack = new src.type(loc, transfer, material?.type)
		newstack.copy_from(src)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(newstack)
		return newstack
	return null

/obj/item/stack/proc/copy_from(var/obj/item/stack/other)
	color = other.color

/obj/item/stack/proc/get_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.get_charge() / charge_costs[1])
		if(charge_costs.len > 1)
			for(var/i = 2 to charge_costs.len)
				S = synths[i]
				. = min(., round(S.get_charge() / charge_costs[i]))
		return
	return amount

/obj/item/stack/proc/get_max_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.max_energy / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.max_energy / charge_costs[i]))
		return
	return max_amount

/obj/item/stack/proc/add_to_stacks(mob/user, check_hands)
	var/list/stacks = list()
	if(check_hands && user)
		for(var/obj/item/stack/item in user.get_held_items())
			stacks |= item
	for (var/obj/item/stack/item in user?.loc)
		stacks |= item
	for (var/obj/item/stack/item in stacks)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if(user && transfer)
			to_chat(user, "<span class='notice'>You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s.</span>")
		if(!amount)
			break

/obj/item/stack/get_storage_cost()	//Scales storage cost to stack size
	. = ..()
	if (amount < max_amount)
		. = CEILING(. * amount / max_amount)

/obj/item/stack/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		var/N = input("How many stacks of [src] would you like to split off?", "Split stacks", 1) as num|null
		if(N)
			var/obj/item/stack/F = src.split(N)
			if (F)
				user.put_in_hands(F)
				src.add_fingerprint(user)
				F.add_fingerprint(user)
				spawn(0)
					if (src && usr.machine==src)
						src.interact(usr)
	else
		..()
	return

/obj/item/stack/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/S = W
		src.transfer_to(S)

		spawn(0) //give the stacks a chance to delete themselves if necessary
			if (S && usr.machine==S)
				S.interact(usr)
			if (src && usr.machine==src)
				src.interact(usr)
	else
		return ..()
