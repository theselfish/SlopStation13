// Assuming a client_prefs.dm exists, we need to add the new preference there.
// If not, this file would need to be created and integrated.

// Original content of client_prefs.dm would be here.
// For demonstration, I'll assume a basic structure for /datum/client_prefs.

/datum/client_prefs
	var/templeos_welcome_shown = FALSE // New preference to track welcome screen display

	// Existing variables would be here, e.g.:
	// var/varname = default_value

/datum/client_prefs/proc/load(client/C)
	// Original load logic would be here.
	// Example:
	// var/list/prefs_data = file2list("data/client_prefs/[C.ckey].prefs")
	// if (prefs_data)
	// 	src.varname = text2num(prefs_data["varname"])

	// Load the new preference
	var/list/prefs_data = file2list("data/client_prefs/[C.ckey].prefs") // Assuming this is how prefs are loaded
	if (prefs_data && prefs_data["templeos_welcome_shown"])
		src.templeos_welcome_shown = text2num(prefs_data["templeos_welcome_shown"])

	// Assign prefs to client
	C.prefs = src

/datum/client_prefs/proc/save(client/C)
	// Original save logic would be here.
	// Example:
	// var/list/prefs_data = list()
	// prefs_data["varname"] = num2text(src.varname)
	// list2file(prefs_data, "data/client_prefs/[C.ckey].prefs")

	// Save the new preference
	var/list/prefs_data = list()
	// Load existing prefs first to avoid overwriting other settings
	var/list/existing_prefs = file2list("data/client_prefs/[C.ckey].prefs")
	if (existing_prefs)
		prefs_data += existing_prefs

	prefs_data["templeos_welcome_shown"] = num2text(src.templeos_welcome_shown)
	list2file(prefs_data, "data/client_prefs/[C.ckey].prefs")
