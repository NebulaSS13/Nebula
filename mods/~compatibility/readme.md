# Modpack Compatibility System
This folder exists as a way to work around the fact that the previous system for modpack cross-compatibility, define-gating, is sensitive to include order. This resulted in a lot of boilerplate, like having to emit warnings if modpacks were included in the wrong order. This meant that you could also introduce cyclical dependencies, where no matter what it would emit a warning and content would be missing.

To avoid this issue, we instead include all compatibility patches last, so it is load order agnostic.

## FAQ
### Why aren't the compatibility files in the modpacks themselves?
I didn't want to edit the modpack include validation script to exclude the compatibility patches from all DMEs.

### Why is it organised using subfolders?
I didn't like using `#if defined(FOO) && defined(BAR)` and nested `#ifdef`s were hard to follow, so instead I group them by modpack.

### Is there a general rule for which modpacks get their own folder?
Not really. I just grouped them in roughly the way that would result in the largest existing groupings, and then chose groupings that would make the most sense to expand in the future (fantasy and standard jobs).

### Do all patches need to be in a subfolder?
No, it's totally fine to just put something in the base patches directory if there's only one patch for either of the mods in that pairing. That said, sometimes it can make sense to add a folder with just one patch if you can foresee future development requiring additional patches in the same category.

### How do I decide which folder a patch goes in if both modpacks have folders?
I tend to personally go based on whatever it's mostly about; a hypothetical patch renaming and respriting psionics for the fantasy modpack would go in the fantasy folder. Alternatively, you could think of it as going for whichever one is more specific.

That said, if one has a lot more patches than the other, or if one modpack (take Standard Jobs, for example) is patched by several modpacks that already have folders, it's fine to just go with whatever produces the largest patch subfolders (or gets rid of small/redundant ones).