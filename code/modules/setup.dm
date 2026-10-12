// No direct modifications needed here. The antagonist_role definition handles selection.
// The existing setup_antagonists proc should pick up the new role automatically
// if it's added to the list of possible antagonist roles (e.g., world.antagonist_roles).
// Ensure that /datum/antagonist_role/tungtungsahur is added to the list of roles
// that the game considers for antagonist selection. This is usually done in
// config files or a central antagonist setup proc.
// For example, in a `config.dm` or `setup.dm` where antagonist roles are initialized:
// world.antagonist_roles += new /datum/antagonist_role/tungtungsahur()
