### SERIALIZATION
The biggest feature of persistence is the serialization system. This is a completely custom serialization system bespoke just to persistence, using a SQL and JSON backend.

The serialization system compiles `saved_vars.json` when a game starts up into a global list. All vars listed on a type are **automatically propagated** up to all of its subtypes, thereby inheriting those declarations as well. It is not necessary to duplicate declarations.

### SAVING A DATUM
Persisting an object is very simple to do. At the base of the repository is a `saved_vars.json` file. Add entries to this file in order to persist them.

Be sure to check the path for your object doesn't already exist when adding it.

### FLATTEN MODE
Flatten mode is a special flag that can be added to an entry in `saved_vars.json`. When `"flatten": true` the object will be serialized into json on the database, both increasing speed, efficiency, and stability of the saves. As well as preserving indexes safely. There are a few caveats to flatten mode that are important to keep in mind.

* Flatten mode can only serialize text, numbers, nulls, and lists.
* Flatten mode respects the `saved_vars.json` list and checks for all the same checks when deciding if a var should be serialized.
* Do not flatten objects with references to other objects.
* Do not flatten objects with paths, files, matrixes, and so on.

Flatten is a *very* simple system and be overwhelmed easily. `/datum/gas_mixture` for example was a great candidate for flatten, but `/mob` obviously is not. Use responsibly.