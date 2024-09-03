/// An automatically ordered list, using the cmp proc to weight the list items
/datum/priority_queue
	/// The actual queue
	var/list/L
	/// The weight function used to order the queue
	var/cmp

/// Takes a proc `comparer` that will be used to compare the items inserted
/// * Param `comparer` take two arguments and return the difference in their weight
/// * For example: /proc/CompareItems(atom/A, atom/B) return A.size - B.size
/datum/priority_queue/New(comparer)
	L = new()
	cmp = comparer

/// * Returns: `TRUE` if the queue is empty, otherwise `FALSE`
/datum/priority_queue/proc/IsEmpty()
	return !L.len

/// Add an `item` to the list, immediatly ordering it to its position using dichotomic search
/datum/priority_queue/proc/Enqueue(item)
	ADD_SORTED(L, item, cmp)

/// Removes and returns the first item in the queue
/// * Returns: The first `item` in the queue, otherwise `FALSE`
/datum/priority_queue/proc/Dequeue()
	if(!L.len)
		return FALSE
	. = L[1]

	Remove(.)

/// Removes an `item` from the list
/// * Returns: `TRUE` if succesfully removed, otherwise `FALSE`
/datum/priority_queue/proc/Remove(item)
	. = L.Remove(item)

/// * Returns: A copy of the item list
/datum/priority_queue/proc/List()
	. = L.Copy()

/// Finds an `item` in the list
/// * Returns: The position of the `item`, or `0` if not found
/datum/priority_queue/proc/Seek(item)
	. = L.Find(item)

/// Gets the item at the positon `index`
/// * Returns: The `item` at the index, or `0` if outside the range of the queue
/datum/priority_queue/proc/Get(index)
	if(index > L.len || index < 1)
		return 0
	return L[index]

/// * Returns: The length of the queue
/datum/priority_queue/proc/Length()
	. = L.len

/// Resorts the `item` to its correct position in the queue.
/// * For example: The queue is sorted based on weight and atom A changes weight after being added
/datum/priority_queue/proc/ReSort(item)
	var/i = Seek(item)
	if(i == 0)
		return
	while(i < L.len && call(cmp)(L[i],L[i+1]) > 0)
		L.Swap(i,i+1)
		i++
	while(i > 1 && call(cmp)(L[i],L[i-1]) <= 0) // Last inserted element being first in case of ties (optimization)
		L.Swap(i,i-1)
		i--
