//defines that give qdel hints. these can be given as a return in destory() or by calling

#define QDEL_HINT_QUEUE 		0 //qdel should queue the object for deletion.
#define QDEL_HINT_LETMELIVE		1 //qdel should let the object live after calling destory.
#define QDEL_HINT_IWILLGC		2 //functionally the same as the above. qdel should assume the object will gc on its own, and not check it.
#define QDEL_HINT_HARDDEL		3 //qdel should assume this object won't gc, and queue a hard delete using a hard reference.
#define QDEL_HINT_HARDDEL_NOW	4 //qdel should assume this object won't gc, and hard del it post haste.
#define QDEL_HINT_FINDREFERENCE	5 //functionally identical to QDEL_HINT_QUEUE if REFTRACKING_ENABLED is not enabled in _compiler_options.dm.
								  //if REFTRACKING_ENABLED is enabled, qdel will call this object's find_references() verb.
#define QDEL_HINT_IFFAIL_FINDREFERENCE 6		//Above but only if gc fails.
//defines for the gc_destroyed var

#define GC_QUEUE_FILTER 1
#define GC_QUEUE_CHECK 2
#define GC_QUEUE_HARDDELETE 3
#define GC_QUEUE_COUNT 3 //increase this when adding more steps.

// Defines for the ssgarbage queue items
#define GC_QUEUE_ITEM_QUEUE_TIME 1 //! Time this item entered the queue
#define GC_QUEUE_ITEM_REF 2 //! Ref to the item
#define GC_QUEUE_ITEM_GCD_DESTROYED 3 //! Item's gc_destroyed var value. Used to detect ref reuse.
#define GC_QUEUE_ITEM_INDEX_COUNT 3 //! Number of item indexes, used for allocating the nested lists. Don't forget to increase this if you add a new queue item index

// Defines for the time an item has to get its reference cleaned before it fails the queue and moves to the next.
#define GC_FILTER_QUEUE (1 SECONDS)
#define GC_CHECK_QUEUE (5 MINUTES)
#define GC_DEL_QUEUE (10 SECONDS)

#define GC_CURRENTLY_BEING_QDELETED -1

#define QDELING(X) (X.gc_destroyed)
#define QDELETED(X) (isnull(X) || QDELING(X))
#define QDESTROYING(X) (isnull(X) || X.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)

//Qdel helper macros.
#define QDEL_IN(item, time) if(!isnull(item)) {addtimer(CALLBACK(item, TYPE_PROC_REF(/datum, qdel_self)), time)}
#define QDEL_IN_CLIENT_TIME(item, time) if(!isnull(item)) {addtimer(CALLBACK(item, TYPE_PROC_REF(/datum, qdel_self)), time, TIMER_CLIENT_TIME)}
#define QDEL_NULL(item) if(item) {qdel(item); item = null}
#define QDEL_NULL_SCREEN(item) if(client) { client.screen -= item; }; QDEL_NULL(item)
#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) }}; if(x) {x.Cut(); x = null } // Second x check to handle items that LAZYREMOVE on qdel.
#define QDEL_LIST(L) if(L) { for(var/I in L) qdel(I); L.Cut(); }
#define QDEL_LIST_IN(L, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(______qdel_list_wrapper), L), time)
#define QDEL_LIST_ASSOC(L) if(L) { for(var/I in L) { qdel(L[I]); qdel(I); } L.Cut(); }
#define QDEL_LIST_ASSOC_VAL(L) if(L) { for(var/I in L) qdel(L[I]); L.Cut(); }

/proc/______qdel_list_wrapper(list/L) //the underscores are to encourage people not to use this directly.
	QDEL_LIST(L)
