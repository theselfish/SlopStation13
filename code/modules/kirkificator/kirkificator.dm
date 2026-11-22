// Kirkificator module – adds fun "Kirkify" transformations to text and objects.

// Global proc that takes a string and returns a Kirk‑styled version.
proc/kirkify(text)
{
    if (!text)
        return "Live long and prosper.";

    // Replace some common phrases with iconic Kirk lines.
    var/list/replacements = list(
        "hello" = "Greetings, crew",
        "good morning" = "Good morning, star‑fleet",
        "good night" = "Good night, stars",
        "thanks" = "Thank you, captain",
        "please" = "If you would be so kind"
    );
    var/processed = lowertext(text);
    for (var/key in replacements)
    {
        processed = replacetext(processed, key, replacements[key]);
    }
    // Capitalize each word for dramatic effect.
    var/list/words = splittext(processed, " ");
    for (var/i in 1 to words.len)
    {
        var/word = words[i];
        if (length(word) > 0)
            words[i] = uppertext(copytext(word, 1, 2)) + copytext(word, 2);
    }
    var/result = jointext(words, " ");
    // Append classic sign‑off.
    result += " Live long and prosper.";
    return result;
}

// Helper proc to rename an atom using Kirkification.
proc/kirkify_atom(atom/A)
{
    if (!A)
        return;
    A.name = kirkify(A.name);
}

// Add a verb to all mobs for easy access.
/mob/verb/Kirkify(message as text)
{
    if (!usr || !usr.client)
        return;
    // Optional permission check – only allow players with the KIRKIFY trait.
    if (!usr.client?.holder?.has_trait("KIRKIFY"))
    {
        to_chat(usr, "You lack the charisma to Kirkify.");
        return;
    }
    var/translated = kirkify(message);
    // Broadcast the transformed message as if spoken.
    usr.say(translated);
}
