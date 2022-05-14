#define ATOM_IS_TEMPERATURE_SENSITIVE(A) (A && !(A.atom_flags & ATOM_FLAG_NO_TEMP_CHANGE))
#define ATOM_SHOULD_TEMPERATURE_ENQUEUE(A) (ATOM_IS_TEMPERATURE_SENSITIVE(A) && !QDELETED(A))
#define ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD 5
#define ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT 0.25

#define ADJUST_ATOM_TEMPERATURE(_atom, _temp) \
	_atom.temperature = _temp; \
	HANDLE_REACTIONS(_atom.reagents); \
	QUEUE_TEMPERATURE_ATOMS(_atom);

#define QUEUE_TEMPERATURE_ATOMS(_atoms) \
	if(islist(_atoms)) { \
		for(var/thing in _atoms) { \
			var/atom/A = thing; \
			QUEUE_TEMPERATURE_ATOM(A); \
		} \
	} else { \
		QUEUE_TEMPERATURE_ATOM(_atoms); \
	}

#define QUEUE_TEMPERATURE_ATOM(_atom) \
	if(ATOM_SHOULD_TEMPERATURE_ENQUEUE(_atom)) { \
		SStemperature.processing[_atom] = TRUE; \
	}

#define UNQUEUE_TEMPERATURE_ATOMS(_atoms) \
	if(islist(_atoms)) { \
		for(var/thing in _atoms) { \
			var/atom/A = thing; \
			UNQUEUE_TEMPERATURE_ATOM(A); \
		} \
	} else { \
		UNQUEUE_TEMPERATURE_ATOM(_atoms); \
	}

#define UNQUEUE_TEMPERATURE_ATOM(_atom) \
	if(ATOM_IS_TEMPERATURE_SENSITIVE(_atom)) { \
		SStemperature.processing -= _atom; \
	}