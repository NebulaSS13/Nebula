#define ATOM_IS_TEMPERATURE_SENSITIVE(A) (istype(A) && A.simulated && A.temperature_sensitive)
#define ATOM_SHOULD_TEMPERATURE_ENQUEUE(A) (ATOM_IS_TEMPERATURE_SENSITIVE(A) && !QDELETED(A))
#define ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD 5
#define MIN_TEMPERATURE_COEFFICIENT 1
#define MAX_TEMPERATURE_COEFFICIENT 10
#define THERMAL_MASS_CONSTANT 1

#define ADJUST_ATOM_TEMPERATURE(_atom, _temp) \
	_atom.temperature = _temp; \
	HANDLE_REACTIONS(_atom.reagents); \
	queue_temperature_atoms(_atom);

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


// This is a proc primarily for profiling purposes.
/proc/queue_temperature_atoms(var/atom/atom)
	if(islist(atom))
		for(var/thing in atom)
			var/atom/A = thing
			QUEUE_TEMPERATURE_ATOM(A)
	else if(atom)
		QUEUE_TEMPERATURE_ATOM(atom)
