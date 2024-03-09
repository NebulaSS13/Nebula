/*
This is pulled directly from Virgo. Credits to them. Modifications made for Lighthouse by Carl.
The below text is holdover from Virgo.


- - - - - - - - - - -
Basically, each player key gets one chance per loot pile to get them phat lewt.
When they click the pile, after a delay, they 'roll' if they get anything, using chance_nothing.  If they're unlucky, they get nothing.
Otherwise, they roll up to two times, first a roll for rare things, using chance_rare.  If they succeed, they get something quite good.
If that roll fails, they do one final roll, using chance_uncommon.  If they succeed, they get something fairly useful.
If that fails again, they walk away with some common junk.
The same player cannot roll again, however other players can.  This has two benefits.  The first benefit is that someone raiding all of
maintenance will not deprive other people from a shot at loot, and that for the surface variants, it quietly encourages bringing along
buddies, to get more chances at getting cool things instead of someone going solo to hoard all the stuff.
Loot piles can be depleted, if loot_depleted is turned on.  Note that players who searched the pile already won't deplete the loot furthers when searching again.
*/

/decl/modpack/dungeon_loot
	name = "Dungeon Loot"
	dreams = list("Packrats")
