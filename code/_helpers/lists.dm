/*
 * Holds procs to help with list operations
 * Contains groups:
 *			Misc
 *			Sorting
 */

// Determiner constants
#define DET_NONE        BITFLAG(0)
#define DET_DEFINITE    BITFLAG(1) //! the
#define DET_INDEFINITE  BITFLAG(2) //! a, an, some

/*
 * Misc
 */

//Returns a list in plain english as a string
/proc/english_list(var/list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = ",", summarize = FALSE)

	if(!length(input))
		return nothing_text

	if(summarize)
		var/list/thing_gender = list()
		var/list/thing_count = list()
		for(var/atom/thing as anything in input)
			input -= thing
			var/thing_string = isatom(thing) ? thing.name : "\proper [thing]"
			thing_count[thing_string] += 1
			if(ismob(thing))
				var/mob/mob_thing = thing
				thing_gender[thing_string] = mob_thing.get_gender()
			else
				thing_gender[thing_string] = isatom(thing) ? thing.gender : NEUTER
		input = list()
		for(var/thing_string in thing_count)
			if(thing_count[thing_string] == 1)
				input += "\the [thing_string]"
			else
				input += "[thing_count[thing_string]] [thing_gender[thing_string] == PLURAL ? text_make_plural(thing_string) : thing_string]"

	switch(length(input))
		if(1)
			return "[input[1]]"
		if(2)
			return "[input[1]][and_text][input[2]]"
		else
			return "[jointext(input, comma_text, 1, -1)][final_comma_text][and_text][input[input.len]]"

//Returns a newline-separated list that counts equal-ish items, outputting count and item names, optionally with icons and specific determiners
/proc/counting_english_list(list/input, output_icons = TRUE, determiners = DET_NONE, nothing_text = "nothing", line_prefix = "", first_item_prefix = "\n", last_item_suffix = "\n", and_text = "\n", comma_text = "\n", final_comma_text = "")
	var/list/counts = list() // counted input items
	var/list/items = list() // actual objects for later reference (for icons and formatting)

	// count items
	for(var/item in input)
		var/name = "[item]" // index items by name; usually works fairly well for loose equality
		if(name in counts)
			counts[name]++
		else
			counts[name] = 1
			items.Add(item)

	// assemble the output list
	var/list/out = list()
	var/i = 0
	for(var/item in items)
		var/name = "[item]"
		var/count = counts[name]
		var/item_str = line_prefix
		if(count > 1)
			item_str += "[count]x&nbsp;"

		if(isatom(item))
			// atoms/items/objects can be pretty and whatnot
			var/atom/A = item
			if(output_icons && isicon(A.icon) && !ismob(A)) // mobs tend to have unusable icons
				item_str += "[html_icon(A)]&nbsp;"
			switch(determiners)
				if(DET_NONE) item_str += A.name
				if(DET_DEFINITE) item_str += "\the [A]"
				if(DET_INDEFINITE) item_str += "\a [A]"
				else item_str += name
		else
			// non-atoms use plain string conversion
			item_str += name

		if(i == 0)
			item_str = first_item_prefix + item_str
		if(i == items.len - 1)
			item_str = item_str + last_item_suffix

		out.Add(item_str)
		i++

	// finally return the list using regular english_list builder
	return english_list(out, nothing_text, and_text, comma_text, final_comma_text)

//A "preset" for counting_english_list that displays the list "inline" (comma separated)
/proc/inline_counting_english_list(list/input, output_icons = TRUE, determiners = DET_NONE, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "", line_prefix = "", first_item_prefix = "", last_item_suffix = "")
	return counting_english_list(input, output_icons, determiners, nothing_text, line_prefix, first_item_prefix, last_item_suffix, and_text, comma_text, final_comma_text)

//Checks for specific types in a list
/proc/is_type_in_list(datum/thing, list/type_list)
	if(!length(type_list) || !istype(thing))
		return FALSE
	for(var/check_type in type_list)
		if(istype(thing, check_type))
			return TRUE
	return FALSE

//Checks for specific paths in a list
/proc/is_path_in_list(var/check_path, list/type_list)
	if(!length(type_list) || !ispath(check_path))
		return FALSE
	for(var/check_type in type_list)
		if(ispath(check_path, check_type))
			return TRUE
	return FALSE

//returns a new list with only atoms that are in typecache atoms
/proc/typecache_filter_list(list/atoms, list/typecache)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if (typecache[A.type])
			. += A

/proc/typecache_filter_list_reverse(list/atoms, list/typecache)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(!typecache[A.type])
			. += A

/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(typecache_include[A.type] && !typecache_exclude[A.type])
			. += A

/proc/typecache_first_match(list/target, list/typecache)
	for (var/thing in target)
		var/datum/D = thing
		if (typecache[D.type])
			return D

//Like typesof() or subtypesof(), but returns a typecache instead of a list
/proc/typecacheof(path, ignore_root_path, only_root_path = FALSE)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = ignore_root_path ? subtypesof(path) : typesof(path)
		var/list/typelist = list()
		for(var/T in types)
			typelist[T] = TRUE
		return typelist
	else if(islist(path))
		var/list/pathlist = path
		var/list/typelist = list()
		if(ignore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					typelist[T] = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					typelist[P] = TRUE
				else
					for(var/T in typesof(P))
						typelist[T] = TRUE
		return typelist

//Checks for specific types in specifically structured (Assoc "type" = TRUE) lists ('typecaches')
/proc/is_type_in_typecache(atom/A, list/cache)
	if(!LAZYLEN(cache) || !A)
		return 0
	return cache[A.type]


/proc/instances_of_type_in_list(var/atom/A, var/list/target_list)
	var/instances = 0
	for(var/type in target_list)
		if(istype(A, type))
			instances++
	return instances

/*
 * Returns list containing all the entries from first list that are not present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/difflist(var/list/first, var/list/second, var/skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result += e
	else
		result = first - second
	return result

/*
Two lists may be different (A!=B) even if they have the same elements.
This actually tests if they have the same entries and values.
This will handle list values in associative lists, but cannot handle
non-associative list equivalence across different refs.
*/
/proc/same_entries(var/list/first, var/list/second)
	if(!islist(first) || !islist(second))
		return 0
	if(length(first) != length(second))
		return 0
	for(var/entry in first)
		if(!(entry in second))
			return 0
		var/first_entry = first[entry]
		if(islist(first_entry))
			var/second_entry = second[entry]
			if(!islist(second_entry))
				return 0
			if(!same_entries(first_entry, second_entry))
				return 0
		else if(first_entry != second[entry])
			return 0
	return 1
/*
Checks if a list has the same entries and values as an element of big.
*/
/proc/in_as_list(var/list/little, var/list/big)
	if(!islist(big))
		return 0
	for(var/element in big)
		if(same_entries(little, element))
			return 1
	return 0
/*
 * Returns list containing entries that are in either list but not both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/uniquemergelist(var/list/first, var/list/second, var/skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		result = difflist(first, second, skiprep)+difflist(second, first, skiprep)
	else
		result = first ^ second
	return result

/proc/assoc_merge_add(var/value_a, var/value_b)
	return value_a + value_b

// This proc merges two associative lists
/proc/merge_assoc_lists(var/list/a, var/list/b, var/merge_method, var/default_if_null_value = null)
	. = list()
	for(var/key in a)
		var/a_value = a[key]
		a_value = isnull(a_value) ? default_if_null_value : a_value
		.[key] = a_value
	for(var/key in b)
		var/b_value = b[key]
		b_value = isnull(b_value) ? default_if_null_value : b_value
		if(!(key in .))
			.[key] = b_value
		else
			.[key] = call(merge_method)(.[key], b_value)

//Pretends to pick an element based on its weight but really just seems to pick a random element.
/proc/pickweight(list/target_list)
	var/total = 0
	var/item
	for (item in target_list)
		if (!target_list[item])
			target_list[item] = 1
		total += target_list[item]

	total = rand(1, total)
	for (item in target_list)
		total -= target_list[item]
		if (total <= 0)
			return item

	return null

//Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/listfrom)
	if (listfrom.len > 0)
		var/picked = pick(listfrom)
		listfrom -= picked
		return picked
	return null

//Returns the top(last) element from the list and removes it from the list (typical stack function)
/proc/pop(list/listfrom)
	if (listfrom.len > 0)
		var/picked = listfrom[listfrom.len]
		listfrom.len--
		return picked
	return null

//Returns the first element from the list and removes it from the list
/proc/popleft(list/target_list)
	if(length(target_list))
		. = target_list[1]
		target_list.Cut(1,2)

//Returns the next element in parameter list after first appearance of parameter element. If it is the last element of the list or not present in list, returns first element.
/proc/next_in_list(element, list/target_list)
	for(var/i = 1 to target_list.len)
		if(target_list[i] == element)
			if(i >= target_list.len)
				return target_list[1]
			return target_list[i+1]
	return target_list[1]

//Returns the previous element in parameter list after first appearance of parameter element. If it is the first element of the list or not present in list, returns first element.
/proc/previous_in_list(element, list/target_list)
	for(var/i = 1 to target_list.len)
		if(target_list[i] == element)
			if(i <= 1)
				return target_list[target_list.len]
			return target_list[i-1]
	return target_list[target_list.len]

/*
 * Sorting
 */

//Reverses the order of items in the list
/proc/reverselist(list/target_list)
	var/list/output = list()
	if(target_list)
		for(var/i = target_list.len; i >= 1; i--)
			output += target_list[i]
	return output

//Randomize: Return the list in a random order
/proc/shuffle(var/list/target_list)
	if(!target_list)
		return

	target_list = target_list.Copy()

	for(var/i=1; i<target_list.len; i++)
		target_list.Swap(i, rand(i,target_list.len))
	return target_list

//Return a list with no duplicate entries
/proc/uniquelist(var/list/target_list)
	. = list()
	for(var/i in target_list)
		. |= i

// Return a list of the values in an assoc list (including null)
/proc/list_values(var/list/target_list)
	. = list()
	for(var/e in target_list)
		. += target_list[e]

//Mergesort: divides up the list into halves to begin the sort
/proc/sortKey(var/list/client/target_list, var/order = 1)
	if(isnull(target_list) || target_list.len < 2)
		return target_list
	var/middle = target_list.len / 2 + 1
	return mergeKey(sortKey(target_list.Copy(0,middle)), sortKey(target_list.Copy(middle)), order)

//Mergsort: does the actual sorting
/proc/mergeKey(var/list/client/left, var/list/client/right, var/order = 1)
	var/left_index=1
	var/right_index=1
	var/list/result = new()
	while(left_index <= left.len && right_index <= right.len)
		var/client/val_left = left[left_index]
		var/client/val_right = right[right_index]
		if(sorttext(val_left.ckey, val_right.ckey) == order)
			result += left[left_index++]
		else
			result += right[right_index++]

	if(left_index <= left.len)
		return (result + left.Copy(left_index, 0))
	return (result + right.Copy(right_index, 0))

// Macros to test for bits in a bitfield. Note, that this is for use with indexes, not bit-masks!
#define BITTEST(bitfield,index)  ((bitfield)  &  BITFLAG(index))
#define BITSET(bitfield,index)   (bitfield)  |=  BITFLAG(index)
#define BITRESET(bitfield,index) (bitfield)  &= ~BITFLAG(index)
#define BITFLIP(bitfield,index)  (bitfield)  ^=  BITFLAG(index)

//Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	var/list/r = list()
	if(istype(wordlist,/list))
		var/max = min(wordlist.len,16)
		var/bit = 1
		for(var/i=1, i<=max, i++)
			if(bitfield & bit)
				r += wordlist[i]
			bit = BITSHIFT_LEFT(bit, 1)
	else
		for(var/bit=1, bit<=65535, bit = BITSHIFT_LEFT(bit, 1))
			if(bitfield & bit)
				r += bit

	return r

// Returns the key based on the index
/proc/get_key_by_value(var/list/target_list, var/value)
	for(var/key in target_list)
		if(target_list[key] == value)
			return key

/proc/count_by_type(var/list/target_list, type)
	var/i = 0
	for(var/T in target_list)
		if(istype(T, type))
			i++
	return i

//Don't use this on lists larger than half a dozen or so
/proc/insertion_sort_numeric_list_ascending(var/list/target_list)
	//to_world_log("ascending len input: [target_list.len]")
	var/list/out = list(pop(target_list))
	for(var/entry in target_list)
		if(isnum(entry))
			var/success = 0
			for(var/i=1, i<=out.len, i++)
				if(entry <= out[i])
					success = 1
					out.Insert(i, entry)
					break
			if(!success)
				out.Add(entry)

	//to_world_log("	output: [out.len]")
	return out

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
// Use ADD_SORTED(list, A, cmp_proc)

// Return the index using dichotomic search
/proc/FindElementIndex(atom/A, list/target_list, cmp)
	var/i = 1
	var/j = target_list.len
	var/mid

	while(i < j)
		mid = round((i+j)/2)

		if(call(cmp)(target_list[mid],A) < 0)
			i = mid + 1
		else
			j = mid

	if(i == 1 || i ==  target_list.len) // Edge cases
		return (call(cmp)(target_list[i],A) > 0) ? i : i+1
	else
		return i


/proc/dd_sortedObjectList(var/list/target_list, var/cache=list())
	if(target_list.len < 2)
		return target_list
	var/middle = target_list.len / 2 + 1 // Copy is first,second-1
	return dd_mergeObjectList(dd_sortedObjectList(target_list.Copy(0,middle), cache), dd_sortedObjectList(target_list.Copy(middle), cache), cache) //second parameter null = to end of list

/proc/dd_mergeObjectList(var/list/target_list, var/list/right, var/list/cache)
	var/left_index=1
	var/right_index=1
	var/list/result = new()
	while(left_index <= target_list.len && right_index <= right.len)
		var/LLi = target_list[left_index]
		var/RRi = right[right_index]
		var/LLiV = cache[LLi]
		var/RRiV = cache[RRi]
		if(!LLiV)
			LLiV = LLi:dd_SortValue()
			cache[LLi] = LLiV
		if(!RRiV)
			RRiV = RRi:dd_SortValue()
			cache[RRi] = RRiV
		if(LLiV < RRiV)
			result += target_list[left_index++]
		else
			result += right[right_index++]

	if(left_index <= target_list.len)
		return (result + target_list.Copy(left_index, 0))
	return (result + right.Copy(right_index, 0))

// Insert an object into a sorted list, preserving sortedness
/proc/dd_insertObjectList(var/list/target_list, var/O)
	var/min = 1
	var/max = target_list.len + 1
	var/Oval = O:dd_SortValue()

	while(1)
		var/mid = min+round((max-min)/2)

		if(mid == max)
			target_list.Insert(mid, O)
			return

		var/Lmid = target_list[mid]
		var/midval = Lmid:dd_SortValue()
		if(Oval == midval)
			target_list.Insert(mid, O)
			return
		else if(Oval < midval)
			max = mid
		else
			min = mid+1

/*
proc/dd_sortedObjectList(list/incoming)
	/*
	   Use binary search to order by dd_SortValue().
	   This works by going to the half-point of the list, seeing if the node in
	   question is higher or lower cost, then going halfway up or down the list
	   and checking again. This is a very fast way to sort an item into a list.
	*/
	var/list/sorted_list = new()
	var/low_index
	var/high_index
	var/insert_index
	var/midway_calc
	var/current_index
	var/current_item
	var/current_item_value
	var/current_sort_object_value
	var/list/list_bottom

	var/current_sort_object
	for (current_sort_object in incoming)
		low_index = 1
		high_index = sorted_list.len
		while (low_index <= high_index)
			// Figure out the midpoint, rounding up for fractions.  (BYOND rounds down, so add 1 if necessary.)
			midway_calc = (low_index + high_index) / 2
			current_index = round(midway_calc)
			if (midway_calc > current_index)
				current_index++
			current_item = sorted_list[current_index]

			current_item_value = current_item:dd_SortValue()
			current_sort_object_value = current_sort_object:dd_SortValue()
			if (current_sort_object_value < current_item_value)
				high_index = current_index - 1
			else if (current_sort_object_value > current_item_value)
				low_index = current_index + 1
			else
				// current_sort_object == current_item
				low_index = current_index
				break

		// Insert before low_index.
		insert_index = low_index

		// Special case adding to end of list.
		if (insert_index > sorted_list.len)
			sorted_list += current_sort_object
			continue

		// Because BYOND lists don't support insert, have to do it by:
		// 1) taking out bottom of list, 2) adding item, 3) putting back bottom of list.
		list_bottom = sorted_list.Copy(insert_index)
		sorted_list.Cut(insert_index)
		sorted_list += current_sort_object
		sorted_list += list_bottom
	return sorted_list
*/

/proc/dd_sortedtextlist(list/incoming, case_sensitive = 0)
	// Returns a new list with the text values sorted.
	// Use binary search to order by sortValue.
	// This works by going to the half-point of the list, seeing if the node in question is higher or lower cost,
	// then going halfway up or down the list and checking again.
	// This is a very fast way to sort an item into a list.
	var/list/sorted_text = new()
	var/low_index
	var/high_index
	var/insert_index
	var/midway_calc
	var/current_index
	var/current_item
	var/list/list_bottom
	var/sort_result

	var/current_sort_text
	for (current_sort_text in incoming)
		low_index = 1
		high_index = sorted_text.len
		while (low_index <= high_index)
			// Figure out the midpoint, rounding up for fractions.  (BYOND rounds down, so add 1 if necessary.)
			midway_calc = (low_index + high_index) / 2
			current_index = round(midway_calc)
			if (midway_calc > current_index)
				current_index++
			current_item = sorted_text[current_index]

			if (case_sensitive)
				sort_result = sorttextEx(current_sort_text, current_item)
			else
				sort_result = sorttext(current_sort_text, current_item)

			switch(sort_result)
				if (1)
					high_index = current_index - 1	// current_sort_text < current_item
				if (-1)
					low_index = current_index + 1	// current_sort_text > current_item
				if (0)
					low_index = current_index		// current_sort_text == current_item
					break

		// Insert before low_index.
		insert_index = low_index

		// Special case adding to end of list.
		if (insert_index > sorted_text.len)
			sorted_text += current_sort_text
			continue

		// Because BYOND lists don't support insert, have to do it by:
		// 1) taking out bottom of list, 2) adding item, 3) putting back bottom of list.
		list_bottom = sorted_text.Copy(insert_index)
		sorted_text.Cut(insert_index)
		sorted_text += current_sort_text
		sorted_text += list_bottom
	return sorted_text

/datum/proc/dd_SortValue()
	return "[src]"

/obj/machinery/dd_SortValue()
	return "[sanitize_old(name)]"

/obj/machinery/camera/dd_SortValue()
	return "[c_tag]"

/datum/alarm/dd_SortValue()
	return "[sanitize_old(last_name)]"

//creates every subtype of prototype (excluding prototype) and adds it to list target_list.
//if no list/target_list is provided, one is created.
/proc/init_subtypes(prototype, list/target_list)
	if(!islist(target_list))
		target_list = list()
	for(var/path in subtypesof(prototype))
		target_list += new path()
	return target_list

//creates every subtype of prototype (excluding prototype) and adds it to list target_list as a type/instance pair.
//if no list/target_list is provided, one is created.
/proc/init_subtypes_assoc(prototype, list/target_list)
	if(!islist(target_list))
		target_list = list()
	for(var/path in subtypesof(prototype))
		target_list[path] = new path()
	return target_list

#define listequal(A, B) (A.len == B.len && !length(A^B))

/proc/filter_list(var/list/target_list, var/type)
	. = list()
	for(var/entry in target_list)
		if(istype(entry, type))
			. += entry

/proc/group_by(var/list/group_list, var/key, var/value)
	var/values = group_list[key]
	if(!values)
		values = list()
		group_list[key] = values

	values += value

/proc/duplicates(var/list/target_list)
	. = list()
	var/list/checked = list()
	for(var/value in target_list)
		if(value in checked)
			. |= value
		else
			checked += value

//Move a single element from position fromIndex within a list, to position toIndex
//All elements in the range [1,toIndex) before the move will be before the pivot afterwards
//All elements in the range [toIndex, target_list.len+1) before the move will be after the pivot afterwards
//In other words, it's as if the range [fromIndex,toIndex) have been rotated using a <<< operation common to other languages.
//fromIndex and toIndex must be in the range [1,target_list.len+1]
//This will preserve associations ~Carnie
/proc/moveElement(list/target_list, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex)	//no need to move
		return
	if(fromIndex > toIndex)
		++fromIndex	//since a null will be inserted before fromIndex, the index needs to be nudged right by one

	target_list.Insert(toIndex, null)
	target_list.Swap(fromIndex, toIndex)
	target_list.Cut(fromIndex, fromIndex+1)

//Move elements [fromIndex,fromIndex+len) to [toIndex-len, toIndex)
//Same as moveElement but for ranges of elements
//This will preserve associations ~Carnie
/proc/moveRange(list/target_list, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance)	//there are more elements to be moved than the distance to be moved. Therefore the same result can be achieved (with fewer operations) by moving elements between where we are and where we are going. The result being, our range we are moving is shifted left or right by dist elements
		if(fromIndex <= toIndex)
			return	//no need to move
		fromIndex += len	//we want to shift left instead of right

		for(var/i=0, i<distance, ++i)
			target_list.Insert(fromIndex, null)
			target_list.Swap(fromIndex, toIndex)
			target_list.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i=0, i<len, ++i)
			target_list.Insert(toIndex, null)
			target_list.Swap(fromIndex, toIndex)
			target_list.Cut(fromIndex, fromIndex+1)

//replaces reverseList ~Carnie
/proc/reverseRange(list/target_list, start=1, end=0)
	if(target_list.len)
		start = start % target_list.len
		end = end % (target_list.len+1)
		if(start <= 0)
			start += target_list.len
		if(end <= 0)
			end += target_list.len + 1

		--end
		while(start < end)
			target_list.Swap(start++,end--)

	return target_list

//Copies a list, and all lists inside it recusively
//Does not copy any other reference type
/proc/deepCopyList(list/l)
	if(!islist(l))
		return l
	. = l.Copy()
	for(var/i = 1 to l.len)
		if(islist(.[i]))
			.[i] = .(.[i])

/**
 * Deep copy/clone everything in the list, or reference things that cannot be cloned. Use with caution.
 * atom_refs_only: If true, the proc will only reference /atom subtypes, and will not clone them.
 */
/proc/listDeepClone(var/list/target_list, var/atom_refs_only = FALSE)
	if(atom_refs_only && isatom(target_list))
		return target_list
	if(istype(target_list, /datum))
		var/datum/D = target_list
		return D.CanClone()? D.Clone() : D //If the datum can be cloned, clone it, or just reference it otherwise
	//Anything else that's not a list just return the ref
	if(!islist(target_list))
		return target_list

	. = target_list.Copy()
	for(var/i = 1 to length(target_list))
		var/I = .[i]
		if(islist(I) || istype(I, /datum))
			.[i] = listDeepClone(I)

#define IS_VALID_INDEX(list, index) (list.len && index > 0 && index <= list.len)

// Returns the first key where T fulfills ispath
/proc/get_ispath_key(var/list/target_list, var/T)
	for(var/key in target_list)
		if(ispath(T, key))
			return key

// Gets the first instance that is of the given type (strictly)
/proc/get_instance_of_strict_type(var/list/target_list, var/T)
	for(var/key in target_list)
		var/atom/A = key
		if(A.type == T)
			return A

var/global/list/json_cache = list()
/proc/cached_json_decode(var/json_to_decode)
	if(length(json_to_decode))
		try
			if(isnull(global.json_cache[json_to_decode]))
				global.json_cache[json_to_decode] = json_decode(json_to_decode)
			var/list/decoded = global.json_cache[json_to_decode]
			if(islist(decoded)) // To prevent cache mutation.
				return deepCopyList(decoded)
			else if(decoded)
				return decoded
		catch(var/exception/e)
			log_error("Exception during JSON decoding ([json_to_decode]): [EXCEPTION_TEXT(e)]")
	return list()

/proc/load_text_from_directory(var/directory, var/expected_extension = ".txt", var/recursive = TRUE)

	if(!directory)
		return list(
			"files"      = list(),
			"item_count" = 0,
			"dir_count"  = 0
		)

	if(copytext(directory, -1) != "/")
		directory += "/"

	var/list/walked_directories = list()
	var/list/loaded_files = list()
	var/dir_count  = 0
	var/item_count = 0

	// Use a while loop so we can recurse over subdirectories.
	var/list/directories_to_check = list(directory)
	// Cache the extension length so we can save some time when checking for matches.
	expected_extension = trim(lowertext(expected_extension))
	var/expected_extension_length = -(length(expected_extension))
	while(length(directories_to_check))

		// Check each directory only once to avoid wasted effort.
		var/checkdir = directories_to_check[1]
		directories_to_check -= checkdir
		walked_directories += checkdir

		// Skip an examples directory if provided.
		if(checkdir == "[directory]examples/")
			continue

		// Iterate the file list.
		for(var/checkfile in flist(checkdir))
			checkfile = "[checkdir][checkfile]"
			// This is a directory, if we're recursing we want to go down this rabbit hole (unless we've already seen this dir via symlink).
			if(copytext(checkfile, -1) == "/")
				if(recursive && !(checkfile in walked_directories))
					directories_to_check += checkfile
					dir_count++
				continue
			// Not a file we want, continue on.
			if(expected_extension && lowertext(copytext(checkfile, expected_extension_length)) != expected_extension)
				continue
			// Fail on duplicates.
			// TODO: maybe aggregate them? checkfile is a fully qualified path so I can't see any real world case for overlap other than symlink stuff.
			if(checkfile in loaded_files)
				PRINT_STACK_TRACE("Duplicate file load for [checkfile].")
				continue
			try
				// Actually load the file now.
				loaded_files[checkfile] = safe_file2text(checkfile)
				item_count++
			catch(var/exception/e)
				PRINT_STACK_TRACE("Exception loading [checkfile]: [EXCEPTION_TEXT(e)]")

	// Return a manifest for further processing.
	return list(
		"files"      = loaded_files,
		"item_count" = item_count,
		"dir_count"  = dir_count
	)

/// Is this a dense (all keys have non-null values) associative list with at least one entry?
/proc/is_dense_assoc(var/list/target_list)
	return length(target_list) > 0 && !isnull(target_list[target_list[1]])
