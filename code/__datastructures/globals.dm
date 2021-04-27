//See controllers/globals.dm
#define GLOBAL_MANAGED(X, InitValue)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
	##X = ##InitValue;\
	gvars_datum_init_order += #X;\
}

#define GLOBAL_RAW(X) /datum/controller/global_vars/var/global##X

#define GLOBAL_DATUM_INIT(X, Typepath, InitValue) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, InitValue)

#define GLOBAL_DATUM(X, Typepath) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, null)
