# Branch Structure
The repository has two main branches, `dev` and `stable`, and one secondary branch, `staging`. Feature implementation, new assets, new maps, and other 'content' pull requests should be pointed at `dev`, while bugfixes for existing code, or fixes to broken assets like sprites or sounds, should be pointed at `stable`. `stable` will be merged back into `dev` periodically to keep the `dev` branch up to date with fixes, so duplicate pull requests are not necessary. `staging` is used for the period when `dev` is being tested and reviewed for promotion to `stable`, and should be targeted when writing fixes for issues encountered during `staging` testing, and otherwise should not be used.

# Contribution Standards

This is a quick and dirty set of agreed-upon standards for contributions to the codebase. It is fairly informal at the moment and should be considered liable to change.

---

### Style guide

- No relative pathing, all paths must be absolute.
- No use of `:`, cast the reference to the appropriate type and use `.`.
- No use of `goto` unless you have a really good, exhaustively explained reason.
- Use constants instead of magic numbers or bare strings, when the values are being used in logic.
- Do not comment out code, delete it, version control makes keeping it in the codebase pointless.
- Macros/consts UPPERCASE, types and var names lowercase.
- Use the `/global/` keyword when declaring a globally scoped variable (ie. `var/global/list/foo`).
- Use the `/static/` keyword, rather than `/global/`, when declaring a static member variable that should be static (`/obj/var/static/foo`).
- Use `global.foo` when referencing global variables (rather than just `foo`).

---

### Pull requests
- It's ultimately the responsibility of the person opening the PR to keep it up to date with the codebase and fix any issues found by unit testing or pointed out during review. Reviewers should be open to discussion objections/alternatives either on Discord or in the diff.
- Opening a PR on behalf of someone else is not recommended unless you are willing to see it through even with changes requested, etc. Opening a PR in bad faith or to make a point is not acceptable.

#### Pull request reviews:
- Check for adherence to the above, general code quality (efficiency, good practices, proper use of tools), and content quality (spelling of descs, etc). Not meeting the objective standards means no merge.
- If there's a personal dislike of the PR, post about it for discussion. Maybe have an 'on hold for discussion' label. Try to reach a consensus/compromise. Failing a compromise, a majority maintainer vote will decide.
- First person to review approves the PR, second person to review can merge it. If 24 hours pass with no objections, first person can merge the PR themselves.
- PRs can have a 24 hour grace period applied by maintainers if it seems important for discussion and responses to be involved. Don't merge for the grace period if applied (reviews are fine).
