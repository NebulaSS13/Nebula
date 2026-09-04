/// An automatically ordered list, using the cmp proc to weight the list items
/datum/priority_queue
	/// The actual queue
	VAR_PRIVATE/list/my_queue = list()
	/// The weight function used to order the queue
	VAR_PRIVATE/cmp

/// Takes a proc `comparer` that will be used to compare the items inserted
/// * Param `comparer` take two arguments and return the difference in their weight
/// * For example: /proc/CompareItems(atom/A, atom/B) return A.size - B.size
/datum/priority_queue/New(comparer)
	cmp = comparer

/// * Returns: `TRUE` if the queue is empty, otherwise `FALSE`
/datum/priority_queue/proc/IsEmpty()
	return !my_queue.len

/// Add an `item` to the list, immediatly ordering it to its position using dichotomic search
/datum/priority_queue/proc/Enqueue(item)
	ADD_SORTED(my_queue, item, cmp)

/// Removes and returns the first item in the queue
/// * Returns: The first `item` in the queue, otherwise `FALSE`
/datum/priority_queue/proc/Dequeue()
	if(!my_queue.len)
		return FALSE
	. = my_queue[1]

	Remove(.)

/// Removes an `item` from the list
/// * Returns: `TRUE` if succesfully removed, otherwise `FALSE`
/datum/priority_queue/proc/Remove(item)
	. = my_queue.Remove(item)

/// * Returns: A copy of the item list
/datum/priority_queue/proc/List()
	. = my_queue.Copy()

/// Finds an `item` in the list
/// * Returns: The position of the `item`, or `0` if not found
/datum/priority_queue/proc/Seek(item)
	. = my_queue.Find(item)

/// Gets the item at the positon `index`
/// * Returns: The `item` at the index, or `0` if outside the range of the queue
/datum/priority_queue/proc/Get(index)
	if(index > my_queue.len || index < 1)
		return 0
	return my_queue[index]

/// * Returns: The length of the queue
/datum/priority_queue/proc/Length()
	. = my_queue.len

/datum/priority_queue/proc/GetQueue()
	return my_queue

/// Resorts the `item` to its correct position in the queue.
/// * For example: The queue is sorted based on weight and atom A changes weight after being added
/datum/priority_queue/proc/ReSort(item)
	var/i = Seek(item)
	if(i == 0)
		return
	while(i < my_queue.len && call(cmp)(my_queue[i],my_queue[i+1]) > 0)
		my_queue.Swap(i,i+1)
		i++
	while(i > 1 && call(cmp)(my_queue[i],my_queue[i-1]) <= 0) // Last inserted element being first in case of ties (optimization)
		my_queue.Swap(i,i-1)
		i--
