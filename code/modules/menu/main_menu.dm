// This file likely contains the main menu logic.
// We will modify the `show_main_menu` proc to include our TempleOS welcome screen.

// Original content of main_menu.dm would be here.
// For demonstration, I'll assume a basic structure.

/datum/ui_state/main_menu
	name = "Main Menu"
	// ... other properties

/client/proc/show_main_menu()
	set waitfor = FALSE // Don't block the client

	// Check if the TempleOS welcome screen has been shown for this client yet.
	// This prevents it from showing every time they return to the main menu.
	if (!src.prefs.templeos_welcome_shown)
		show_templeos_welcome_screen()
		src.prefs.templeos_welcome_shown = TRUE // Mark as shown
		src.prefs.save() // Save client preferences

	// Original main menu display logic would follow here.
	// For example:
	// src << browse_rsc("html/main_menu.html", "main_menu")
	// src << output("Welcome to SlopStation13!", "main_menu.title")
	// ... etc.

	// Placeholder for actual main menu display
	src << browse("
		<html>
			<head>
				<title>SlopStation13</title>
				<style>
					body { background-color: #1a1a1a; color: #eee; font-family: monospace; text-align: center; }
					.menu-container { margin-top: 100px; }
					.menu-button {
						background-color: #333;
						color: #eee;
						border: 1px solid #555;
						padding: 10px 20px;
						margin: 5px;
						cursor: pointer;
						font-size: 1.2em;
					}
					.menu-button:hover { background-color: #555; }
				</style>
			</head>
			<body>
				<div class='menu-container'>
					<h1>SlopStation13</h1>
					<p>The ultimate space station experience!</p>
					<button class='menu-button' onclick='byond://?src=\ref[src];action=start_game'>Start Game</button><br>
					<button class='menu-button' onclick='byond://?src=\ref[src];action=options'>Options</button><br>
					<button class='menu-button' onclick='byond://?src=\ref[src];action=exit'>Exit</button>
				</div>
			</body>
		</html>
	", "main_menu", "width=800;height=600")

/client/proc/show_templeos_welcome_screen()
	set waitfor = FALSE // Don't block the client

	// Display the TempleOS welcome screen.
	// This will overlay the screen with the custom DMI and Sumerian text.
	var/obj/screen/templeos_welcome_obj = new /obj/screen()
	templeos_welcome_obj.icon = 'icons/screen_templeos_welcome.dmi'
	templeos_welcome_obj.icon_state = "welcome_background"
	templeos_welcome_obj.screen_loc = "CENTER" // Center the background
	templeos_welcome_obj.layer = 20 // Ensure it's on top of other UI elements

	// Create a text overlay for the Sumerian greeting
	var/obj/screen/templeos_text_obj = new /obj/screen()
	templeos_text_obj.name = "templeos_greeting"
	templeos_text_obj.screen_loc = "CENTER:10,CENTER:10" // Position text slightly above center
	templeos_text_obj.text = "<center><font size='+5' color='#FFD700'>Šulmu, TempleOS-e!</font></center>" // Gold color for greeting
	templeos_text_obj.layer = 21 // Above the background
	templeos_text_obj.maptext_width = 500 // Give it some width for centering
	templeos_text_obj.maptext_height = 100

	// Add a small explanatory message below the greeting
	var/obj/screen/templeos_subtext_obj = new /obj/screen()
	templeos_subtext_obj.name = "templeos_subtext"
	templeos_subtext_obj.screen_loc = "CENTER:-10,CENTER:-10" // Position text slightly below center
	templeos_subtext_obj.text = "<center><font size='+1' color='#ADD8E6'>We are honored by your presence. May your journey be blessed.</font></center>" // Light blue
	templeos_subtext_obj.layer = 21
	templeos_subtext_obj.maptext_width = 500
	templeos_subtext_obj.maptext_height = 100

	src.screen += templeos_welcome_obj
	src.screen += templeos_text_obj
	src.screen += templeos_subtext_obj

	// Wait for a few seconds before transitioning to the main menu
	sleep(50) // 5 seconds (10 ticks per second by default)

	// Remove the welcome screen elements
	src.screen -= templeos_welcome_obj
	src.screen -= templeos_text_obj
	src.screen -= templeos_subtext_obj

	// Now, proceed to display the actual main menu
	// (The original show_main_menu logic will continue after this proc returns)

// Add a preference to track if the welcome screen has been shown
// This would typically go in a client_prefs.dm or similar file.
// For this example, I'll add it directly to the client datum.
// In a real project, you'd extend /datum/client_prefs.
/client
	var/templeos_welcome_shown = FALSE // Tracks if the welcome screen has been shown for this client

// If there's a /datum/client_prefs, you'd add it there:
// /datum/client_prefs
// 	var/templeos_welcome_shown = FALSE
// 	// ... and modify save/load procs to handle it.
