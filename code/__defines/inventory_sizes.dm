// The below should be used to define an item's w_class variable.
// Example: w_class = ITEM_SIZE_LARGE
// This allows the addition of future w_classes without needing to change every file.

/*
	A note on w_classes - this is an attempt to describe the w_classes currently in use
	with an attempt at providing examples of the kinds of things that fit each w_class

	1 - tiny items - things like screwdrivers and pens, sheets of paper
	2 - small items - things that can fit in a pocket
	3 - normal items
	4 - large items - the largest things you can fit in a backpack
	5 - bulky items - backpacks are this size, for reference
	6 - human sized objects
	10 - things that are large enough to not realistically fit into a container (or should not be contained)
	20 - things that take up an entire turf, like wall girders or door assemblies
*/

#define ITEM_SIZE_TINY           1
#define ITEM_SIZE_SMALL          2
#define ITEM_SIZE_NORMAL         3
#define ITEM_SIZE_LARGE          4
#define ITEM_SIZE_HUGE           5
#define ITEM_SIZE_GARGANTUAN     6
#define ITEM_SIZE_STRUCTURE      20

#define ITEM_SIZE_MIN            ITEM_SIZE_TINY
#define ITEM_SIZE_MAX            ITEM_SIZE_STRUCTURE

#define BASE_STORAGE_COST(w_class) (2**(w_class-1)) //1,2,4,8,16,...

//linear increase. Using many small storage containers is more space-efficient than using large ones,
//in exchange for being limited in the w_class of items that will fit
#define BASE_STORAGE_CAPACITY(w_class) (7*(w_class-1))

#define DEFAULT_BACKPACK_STORAGE BASE_STORAGE_CAPACITY(ITEM_SIZE_HUGE)
#define DEFAULT_LARGEBOX_STORAGE BASE_STORAGE_CAPACITY(ITEM_SIZE_LARGE)
#define DEFAULT_BOX_STORAGE      BASE_STORAGE_CAPACITY(ITEM_SIZE_NORMAL)
