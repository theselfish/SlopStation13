// Automated tests for the Kirkificator module.

// Ensure the test suite runs only in test mode.
#if defined(TESTING)

// Test basic string transformation.
proc/test_kirkify_basic()
{
    var/result = kirkify("hello crew");
    if (!findtext(result, "Greetings, Crew"))
        CRASH("Kirkify failed to replace 'hello' phrase.");
    if (!findtext(result, "Live long and prosper"))
        CRASH("Kirkify missing sign‑off.");
}

// Test empty input handling.
proc/test_kirkify_empty()
{
    var/result = kirkify("");
    if (result != "Live long and prosper.")
        CRASH("Kirkify empty string did not return default sign‑off.");
}

// Test atom renaming.
proc/test_kirkify_atom()
{
    var/obj/item/test_item = new /obj/item();
    test_item.name = "laser pistol";
    kirkify_atom(test_item);
    if (!findtext(test_item.name, "Laser Pistol"))
        CRASH("Kirkify atom did not rename correctly.");
    if (!findtext(test_item.name, "Live long and prosper"))
        CRASH("Kirkify atom missing sign‑off.");
    qdel(test_item);
}

#endif // TESTING
