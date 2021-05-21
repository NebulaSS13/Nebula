// These vars are populated by /decl/recipe/Initialize(), which is called by the recipe codex
// category during world setup and should in theory not need any additional init calls.

var/global/microwave_maximum_item_storage =  0
var/global/list/microwave_recipes =          list()
var/global/list/microwave_accepts_reagents = list()
var/global/list/microwave_accepts_items =    list(
	/obj/item/holder,
	/obj/item/chems/food/snacks/grown
)

/* * * * * * * * * * * * * * * * * * * * * * * * * *
 * /datum/recipe by rastaf0            13 apr 2011 *
 * /decl/recipe by Neb                 21 may 2021 *
 *                                                 *
 * Happy tenth birthday you pile of spaghetti!     *
 * * * * * * * * * * * * * * * * * * * * * * * * * */

/decl/recipe
	var/display_name      // Descriptive name of the recipe, should be unique to avoid codex pages being unsearchable.
	var/list/reagents     // example: = list(/decl/material/liquid/drink/juice/berry = 5) // do not list same reagent twice
	var/list/items        // example: = list(/obj/item/crowbar, /obj/item/welder) // place /foo/bar before /foo
	var/list/fruit        // example: = list("fruit" = 3)
	var/result            // example: = /obj/item/chems/food/snacks/donut/normal
	var/time = 100        // Cooking time in deciseconds.

	// Codex entry values.
	var/hidden_from_codex // If TRUE, codex page will not be generated for this recipe.
	var/lore_text         // IC description of recipe/food.
	var/mechanics_text    // Mechanical description of recipe/food.
	var/antag_text        // Any antagonist-relevant stuff relating to this recipe.

/decl/recipe/Initialize()
	. = ..()
	global.microwave_recipes += src
	for(var/thing in reagents)
		global.microwave_accepts_reagents |= thing
	for(var/thing in items)
		global.microwave_accepts_items |= thing
	global.microwave_maximum_item_storage = max(global.microwave_maximum_item_storage, length(items))

/decl/recipe/proc/check_reagents(var/datum/reagents/avail_reagents)
	if(length(avail_reagents?.reagent_volumes) < length(reagents))
		return FALSE
	for(var/rtype in reagents)
		if(REAGENT_VOLUME(avail_reagents, rtype) < reagents[rtype])
			return FALSE 
	return TRUE

/decl/recipe/proc/check_fruit(var/obj/container)
	if(!length(fruit))
		return TRUE
	var/container_contents = container?.get_contained_external_atoms()
	if(length(container_contents) < length(fruit))
		return FALSE
	var/list/needed_fruits = fruit.Copy()
	for(var/obj/item/chems/food/snacks/grown/G in container_contents)
		var/ktag = G.seed?.kitchen_tag
		if(needed_fruits[ktag] > 0)
			needed_fruits[ktag]--
	for(var/ktag in needed_fruits)
		if(needed_fruits[ktag] > 0)
			return FALSE
	return TRUE

/decl/recipe/proc/check_items(var/obj/container)
	if(!length(items))
		return TRUE
	var/container_contents = container?.get_contained_external_atoms()
	if(length(container_contents) < length(items))
		return FALSE
	var/list/needed_items = items.Copy()
	for(var/itype in needed_items)
		for(var/thing in container_contents)
			if(istype(thing, itype))
				container_contents -= thing
				needed_items -= itype
				break
		if(!length(container_contents))
			break
	return !length(needed_items)

//general version
/decl/recipe/proc/make(var/obj/container)
	var/obj/result_obj = new result(container)
	var/list/contained_atoms = container.get_contained_external_atoms()
	if(contained_atoms)
		contained_atoms -= result_obj
		for(var/obj/O in contained_atoms)
			O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
			qdel(O)
	container.reagents.clear_reagents()
	return result_obj

// food-related
/decl/recipe/proc/make_food(var/obj/container)
	if(!result)
		log_error("<span class='danger'>Recipe [type] is defined without a result, please bug this.</span>")
		return
	var/obj/result_obj = new result(container)
	container.reagents?.clear_reagents()
	//Checked here in case LAZYCLEARLIST nulls and no more physical ingredients are added
	var/list/container_contents = container.get_contained_external_atoms()
	if(!container_contents)
		return result_obj
	for (var/obj/O in (container_contents-result_obj))
		if (O.reagents)
			O.reagents.clear_reagent(/decl/material/liquid/nutriment)
			O.reagents.update_total()
			O.reagents.trans_to_obj(result_obj, O.reagents.total_volume)
		if(istype(O,/obj/item/holder/))
			var/obj/item/holder/H = O
			H.destroy_all()
		qdel(O)
	return result_obj
