/*

	- Z-Mimic -

	This is a system for rendering the Z-level(s) below this one under turfs in a way that's as indistinguishable to players as possible, while also remaining scalable
	enough to run on maps with extreme numbers of Z-enabled turfs (100k+). While it may be complex internally, interacting with Z-Mimic should be straightforward.


	- Usage (Turf) -

	Most of the time just setting the turf level `z_flags` is all you need to do. To enable Z-Mimic for a turf:

		z_flags = MIMIC_DEFAULTS

	There are also presets for some common situations:
	- ZM_MIMIC_PRESET_HOLE: Just a z-hole. No icon, nothing to cast a shadow on, allows atmos.
	- ZM_MIMIC_PRESET_HOLE_WITH_BORDER: A z-hole with an icon, like an icon smoothed border. Allows atmos.
	- ZM_MIMIC_PRESET_TRANSLUCENT_TURF: A turf that has translucent/transparent accents. Does not allow atmos, but allows players to see the things below. Blocks clicks, even where alpha is 0.

	You may want to enable some other flags based on what the turf is doing, but this is all that is necesssary to enable baseline Z copy for a turf. Other flags that are
	likely to be useful include:

	- ZM_MIMIC_BELOW: Enable Z-mimic. Part of MIMIC_DEFAULTS.
	- ZM_MIMIC_REPLACE: Replace the turf's appearance instead of preserving it. This is more efficient, but means the turf can't have its own icon or overlays. This is intended for simple Z-holes. Used to be called MIMIC_OVERWRITE.
	- ZM_ALLOW_LIGHTING: Allow lights to shine through this Z-turf. Part of MIMIC_DEFAULTS.
	- ZM_ALLOW_ATMOS: Allow ZAS to form connections through this Z-turf.

	Niche use flags that you probably won't need:
	- ZM_MIMIC_NO_AO: Skip regular turf AO. You should generally avoid using this even on simple Z-holes (MIMIC_REPLACE) and space since it can cause artifacts on edges of large turfs,
		but it can be a minor performance gain if you're certain the AO is never visible. This flag may be removed in future versions.
	- ZM_NO_OCCLUDE: By default, Z-Mimic assumes that turfs that are *not* ZM_MIMIC_REPLACE are blocking the entire turf (like glass flooring) and will intercept clicks.
	 This will force the turf to allow clickthrough, which can be useful if creating a Z-hole turf with smoothed edges. This does not prevent clicking on the Z-turf itself.
	- ZM_OVERRIDE: If this is set, Z-Mimic will ignore the normal copy pipeline and will just copy either the turf's baseturf, or use the contents
		of the `z_appearance` var if it is set. Z-turfs with this set are considered the bottom of a Z-group, so can be used to prevent Z-Mimic from interacting with Z-connections.
	- ZM_HIDE_ATOMS: If this turf is considered opaque (see MIMIC_NO_OCCLUDE), also hide atoms from the right click menu. This prevents examining below atoms, however.
	- ZM_MIMIC_NO_ZAO: Skip Z-AO for this turf. You generally don't want to use this, but the AO is not visible on Z-turfs with edges anyway, so disabling it there is free performance.

	Flags that are applicable to non-zmimic turfs:
	- ZM_VISUALLY_BIG: This turf is (visually) larger than world.icon_size, so ZM should render it even if covered by a turf above it.

	Internal use flags that you shouldn't use, but may show up in the analyzer:
	- ZM_BOUNDARY: This indicates that this turf is beside an active Z-turf, so is creating movable mimics despite not being a mimic turf. These may create turf mimics if they're
		above a VISUALLY_BIG turf.
	- ZM_OVER_VB: This z-turf is above a VISUALLY_BIG turf, so will participate in turf mimic in some cases when it usually would not.

	Z-Mimic can be toggled after a turf has been created using the `enable_zmimic()` and `disable_zmimic()` procs.
	If a turf's appearance has been updated in a way that doesn't involve SSoverlays, call `update_above()` on the turf to instruct Z-Mimic to recopy its appearance. This is cheap.

	- Usage (Movable) -

	Generally movables should not need to care about Z-Mimic. There are some edge cases that may require `z_flags` to be set:
	- If your atom is long (greater than one turf along the facing axis), you should set ZMM_LOOKAHEAD.
	- If your atom is wide (greater than one turf perpendicular to the facing axis), you should set ZMM_LOOKBESIDE.
	- If your atom is wide on both axes, set both flags.
	- If your atom always contains overlays with `plane` explicitly set, consider setting ZMM_MANGLE_PLANES to improve efficiency. If this is only sometimes true, omit this flag and let ZM detect.
	- If your atom should not render under ZM at all (for instance, it uses rendering features that ZM does not support, or it is an abstract object), set ZMM_IGNORE.
		- ZM will ignore INVISIBILITY_ABSTRACT objects and qdeleted objects regardless of IGNORE.

	If you update the appearance of your movable without interacting with SSoverlays, consider adding an `UPDATE_OO_IF_PRESENT` call at the end to notify ZM of appearance updates. This call is very cheap.

	- Public API -
	These are all calls in ZM that are considered public API, anything other these calls is considered unstable (in the API sense) and may change without regards to compatibility.

	Movables:
		- `UPDATE_OO_IF_PRESENT` (macro)
			- Only valid in contexts where `src` is a movable.
			- If this movable has an associated Z-Mimic mimic, update its appearance.
			- Cheap, but SSoverlays will automatically run this for you if you make overlay calls.
		- `MOVABLE_IS_BELOW_ZTURF(M)` (macro)
			- Check if a specified movable is below an active Z-mimic turf and should be mimicked.
			- This respects the LOOKAHEAD/LOOKBESIDE flags.
		- `MOVABLE_IS_ON_ZTURF(M)` (macro)
			- Check if a specified movable is on an active Z-mimic turf.
			- This respects the LOOKAHEAD/LOOKBESIDE flags.
		- `z_flags` (var)
			- Flags `ZMM_IGNORE`, `ZMM_LOOKAHEAD`, `ZMM_LOOKBESIDE`, and `ZMM_MANGLE_PLANES` are considered stable.
		- `get_above_oo()` (proc)
			- Return a list of mimics copying this movable, directly or indirectly.
			- This can be useful if trying to `animate()` a movable and you want this animation to also apply to mimics.
				- Keep in mind that the mimic cannot update its appearance while `animate()` runs.

	Turfs:
		- `TURF_IS_MIMICKING(T)` (macro)
			- Check if a specified turf is copying movables. This includes mimic boundary turfs.
			- Cheap.
		- `TURF_IS_MIMIC(T)` (macro)
			- Check if a specified turf is a Z-mimic turf. This is implied by the above, but this excludes boundaries.
			- Cheap.
		- `enable_zmimic(additional_flags = 0)` (proc)
			- Enable Z-mimic on a turf after it has been initialized.
			- Returns: TRUE if this turf transitioned from non-mimic to mimic, FALSE otherwise.
		- `disable_zmimic()` (proc)
			- Disable Z-mimic on a turf after it has been initialized.
			- Returns: TRUE if this turf transitioned from mimic to non-mimic, FALSE otherwise.
			- Mimic objects will hang around for a few seconds after this is called, though they should be hidden from rightclick.

	Atoms:
		- `update_above()` (proc)
			- Update above mimics' appearance. Valid on turfs and movables.

	Z-Copy (SSzcopy):
		- `calculate_zstack_limits()` (proc)
			- Regenerate Z-group information. Call this if you create new Z-levels, even if they do not contain Z-turfs.
		- `update_all()` (proc)
			- Intended for admin/developer proc-call. Do not use in code.
			- Force all mimic turfs and mimic objects on the map to update.
		- `hard_reset()` (proc)
			- Intended for admin/developer proc-call. Do not use in code.
			- Flush all Z-Mimic state and rebuild from scratch.
		- `unsupported_rebuild_z_state()` (proc)
			- Harder than hard_reset(). Will forcibly reconstruct ZM connection information, as well as performing a hard reset.
			- Please don't use this without knowing its implications.
			- Actually using this proc is fully unsupported, and may corrupt Z-lighting for the rest of the round.
			- This does not rebuild Z-lighting.
			- This does not rebuild boundary information.
			- This proc may be necessary if you are doing (unsupported) things with dynamic Z-groups and need to kick Z-Mimic.

*/

/*

	- Z-Mimic Internals -

	ZM fundamentally works by creating mimic objects to hold appearances for movables *directly below*, including other mimic objects. This recursive copy allows ZM to
	copy appearance of many levels without having to ever consider more than one level at a time, but requires Z-groups to update bottom to top. This is enforced by allowing
	multiple queue entries for the same object, though ZM will only actually evaluate the last entry. ZM stores relations between mimic objects as a doubly-linked list on the
	movables, as well as storing turf up/down connections as a doubly-linked list.

	ZM's code makes some assumptions, though this list is not necessarily exhaustive:
	- Z-groups will not be taller than OPENSPACE_MAX_DEPTH.
		- If violated: Warning emitted on boot, layering behavior undefined for atoms with a depth below OPENSPACE_MAX_DEPTH.
		- There is little drawback to increasing OPENSPACE_MAX_DEPTH beyond greater plane use and slightly higher client graphics load.
	- Atoms should render correctly if relocated to another plane.
		- This generally does not apply to overlays on atoms due to overlay mangling.
	- Z coordinates are linear and do not skip levels.
		- A turf above another turf (within the same Z-group) is always at `z = below.z + 1`.
		- More specifically: `get_step(ref, UP) == GET_ABOVE(ref)`, where turfs are members of the same Z-group.
		- ZM does math on the `z` coordinate to calculate depth.
	- Z-groups are contiguous across the entire Z-level.
		- If two turfs have the same z coordinate, they must have the same z connections / be part of the same z-group.
		- ZM assumes that z-groups are global, and stores the maximum Z value for a z-group with z-level granularity.
		- Virtual z-levels are only supported if every virtual z in the real z-level has identical Z-connections, or does not interact with ZM (e.g., only one level tall).
		- ZM_OVERRIDE turfs will block ZM scans and connections below them do not need to make sense, but use with care.
	- Z-groups are immutable after they have been used.
		- Changing Z-connections after ZM has been initialized on a level is undefined behavior, though primarily due to lighting.
		- ZM_OVERRIDE turfs will block ZM scans and connections below them can change, but use with care.
		- Creating new Z-levels and registering them with Z-Mimic (via `calculate_zstack_limits()`) is allowed and expected.
	- Unlike older versions of Z-Mimic, making space turfs mimic is supported.
		- Actually doing this will slightly increase Z-Mimic's memory usage on maps with a lot of space.
		- This may look strange due to interactions with lighting -- depth cues will still render, but lighting generally does not on space.
	- `vis_contents` is not copied, though particles are.

	- ZMM_LOOKAHEAD and ZMM_LOOKBESIDE only increase the scan radius by one turf (in both directions).
		- Atoms larger than this may not render in some cases where they should, but this will probably not be very obvious. Support for these can be added if it becomes necessary.

	On BOUNDARY:
	- Boundary turfs are half-way between a z-mimic turf and a regular turf. They copy movables but do not copy turfs, create shadowers, participate in AO, or copy lighting.
	- Movables under a boundary do not show in right-click since the client shouldn't actually see them anyway.
		- Movables with LOOKAHEAD or LOOKBESIDE are excluded from this since they probably are actually visible.
	- The primary purpose of these is to cause mimics to reliably be created before the movable moves under the true z-turf, to preserve gliding in all cases.
		- Gliding for movables that have recently been under a z-turf (last 10 seconds) is handled by the destruction timer.
	- Boundaries are considered z-stack terminators, even when they're mimicking the turf below them. They are considered opaque (and so should be the target of render by
		turfs above them), but may still need to mimic the things below them to make things like VISUALLY_BIG function.

	Miscellaneous notes:
	- The destruction timer exists to preserve gliding in/out below Z-turfs, as well as reduce mimic churn when movables are moving between z and non-z turfs frequently.
		- Some of this behavior is now also provided by MIMIC_BOUNDARY turfs, which are more reliable at preserving gliding.
	- Mimics that move between Z-levels or move between Z-turfs with different rendering behavior require SSzcopy.update_mimic_layering()` to be run.
		- This is handled in Move()/forceMove(), though Z-turfs are only considered different if their Z-flags contain a different set of values in the subset `ZM_FLAGS_AFFECTS_LAYERING`.
	- A turf can be a BOUNDARY and a MIMIC at the same time. Converting a BOUNDARY into a MIMIC is considered a boundary promotion, and converting a MIMIC into a BOUNDARY is
	considered a boundary demotion.
	- ZM proxies examine: when a mimic is examined, it will call its parent atom's examine proc with a z-depth description suffix.
		- This behavior does not apply to turfs, though `desc` is copied by ZM too and will display fine.
	- Wall AO and Z-AO are explicitly copied by Z-Copy so it can generate AO for 'midspan' turfs that are between the visible turf and the root turf, even though they technically
		aren't being rendered by ZM. This AO is reduced in intensity to make it less ugly, see the SECONDARY AO defines if you need to tune this.
	- 'Z-stack' and 'Z-group' are related, but not the same: a z-stack is the discovered stack of active ZM turfs, whereas a Z-group is the set of Z-connections discovered by ZM.
		- A z-stack is always within a single z-group, though may span the entire height of the z-group.
	- A turf that is VISUALLY_BIG will stop upwards propagation of OVER_VB (visually big) for efficiency due to how unlikely it is players will notice this, but you can undefine
		ZM_VISUALLY_BIG_STOPS_VB_PROPAGATION if you don't want VISUALLY_BIG turfs to mask VISUALLY_BIG turfs below them. Read the comment near that define for details.

	Render:
	- ZM assigns a 'depth' value to all turfs and movables it is copying.
	- A Z-group can be up to OPENTURF_MAX_DEPTH deep; ones that are deeper than this have undefined layering behavior.
		- There's not much reason to avoid increasing this value if you need more, though mind that it will increase plane usage and slightly increase client graphics load.
		- This limit is applied per linear group of connected Z-levels, not globally. 3 unrelated groups of OPENTURF_MAX_DEPTH are legal, for instance.
		- Default is 10.
	- Each depth has an associated group of 'render slices', a group of 3 (default) planemasters that handle the different components of depth render.
		- SLICE_SLOT_ROOT: Basic movable copy. Most objects go here.
		- SLICE_SLOT_LIGHTING: Lighting objects and ZM shadowers. This is where the ZM shadowing effect is applied (via planemaster), and is the plane you want to mask if attempting to
			apply emissives to Z-Mimic. It is normally internally masked to only apply to areas covered by VSLICE_SLOT_ZSUM (sum of all ZM atom render).
		- SLICE_SLOT_CAP: Above-lighting effects like Z-AO. This renders above the shadowing effect so is unaffected by depth cues from this level.
		- Adding more slots is supported, but make sure to add them to the ZSUM if they represent actual visible objects that are supposed to be affected by lighting/depth.
	- Depth groups also have associated render slices in the 'basement'; planes being rendered below all other planes that are not meant to be directly visible, but are used internally.
		- Yes, they're supposed to be actually hidden. BYOND thinks otherwise apparently.
		- VSLICE_SLOT_ZSUM: A sum of every SLOT_ROOT on this depth + the ZSUM below us (so, sum of all ZM objects visible on this depth).
			- The lighting/depth render slice is masked with this, so lighting will only render where objects actually are.

	Turf states:
		There are a few states a z-turf can be in.
		- Normal (replaced)
			- A turf that passed through setup_zmimic(), and has MIMIC_REPLACE set.
			- Appearance has been lost.
		- Normal (proxy)
			- A turf that passed through setup_zmimic(), but does not have MIMIC_REPLACE set.
			- Still has its own appearance.
			- Has a turf proxy object holding the below turf appearance.
		- Synthetic (override)
			- A turf that was passed into z-mimic but uses MIMIC_OVERRIDE.
			- While it has run through Z-Copy, it has minimal ZM state and does not meaningfully participate in Z-Mimic.
			- Only a single appearance is being copied: either a simple type mimic of the baseturf, or a custom appearance in `z_appearance`.
		- Synthetic (non-z)
			- A turf that was passed into z-mimic but has no Z-connection below it.
			- Identical rendering to above, but has fewer legal state transitions.
		- Zero init
			- A space turf that has nothing below it.
			- Behaves identically to a regular space turf, does not participate in ZM after init.
		- Fast init
			- An REPLACE turf (including space) that is above another fast init turf (or a zero init turf), and has no movables on its turf, nor is it copying lighting.
			- Has *not* passed through Z-Copy, appearance has just been set to space for parallax.
			- Appearance has been lost.
			- Does not have a shadower, and some ZM debug variables (like root) are unset.
		- Boundary
			- A non-ZM turf that is directly adjacent to ZM. Has been through `setup_zmimic()`, but only movables are being copied.
			- Does not have a shadower, and some ZM debug variables (like root) are unset.

		Supported state transitions:
		- (any) -> Non-Z
		- Non-Z -> (any)
		- Normal (replaced) -> Normal (proxy)
		- Normal (proxy) -> Normal (replaced)
		- Normal (either) -> Synthetic (replaced)
		- Normal (either) -> Boundary
		- Boundary -> Normal (either)
		- Fast init -> Normal (either)
		- Synthetic (replaced) -> Normal (either)
		- Normal (either) -> Synthetic (replaced)

	Internal types:
		- openspace/multiplier -> shadows below level, holds Z-AO overlays, handles lighting copy.
			- These render on ZM_SLICE_SLOT_LIGHTING, with Z-AO being on ZM_SLICE_SLOT_CAP.
		- openspace/mimic -> holds appearance of copied atoms, proxies examine
			- These are allowed to copy other mimic objects, as well as multipliers. Their behavior may change based on the root object they're copying.
		- openspace/turf_proxy -> holds appearance of non-REPLACE turfs
		- openspace/turf_mimic -> mimic for the above
*/
