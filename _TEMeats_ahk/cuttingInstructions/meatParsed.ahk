Weight := ["4oz", "5oz", "6oz"]
Tomahawks := ["*No", "Yes"]
thickness := ["1.5in", "1in", "1.25in", "1.75in", "0.75in"]
steaks := ["Grind", "Roasts", "Steaks", "Stew Meat", "Fajita", "Kabob", "Cube Steak", "Thinly Sliced"]

BeefMap := Map(
    "Chuck", Map(
        "Grind", "Grind",
        "Bone-in", Map(
            "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"], "Steaks", "Finished."
        ),
        "Boneless", "Flag red"
    ),
    "Arm", Map(
        "*Grind", "*Grind",
        "Bone-in", Map(
            "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Boneless", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        )
    ),
    "Brisket", ["Grind", "Whole", "Halved", "Quartered"],
    "Shanks", Map(
        "Grind", "Finished.", "Whole", "Finished.",
        "Shank Cuts", ["2in", "1.5in", "1in"]
    ),
    "Skirt", Map("Grind", "Finished.", "Steak", "Finished."),
    "Bones", Map(
        "*No", "No",
        "Yes", Map("Marrow Only", "Finished.",
            "Marrow Only", "Finished.",
            "Knuckles Only", "Finished.",
            "Marrows & Knuckles", "Finished.")
    ),
    "Ribs", Map("*Grind", "Finished.", "Plate", "Finished.", "English", "Finished.", "Korean", "Finished."),
    "Ribeye", Map(
        "Grind", "Finished.",
        "Bone-in", Map(
            "Steaks", Map(
                "See sub-menu", Map(
                    "Thickness", thickness,
                    "Tomahawk", Tomahawks,
                    "No./Pack", ["2", "3", "4", "1"]
                )),
            "Roasts", Map(
                "See sub-menu", Map(
                    "Size", ["Halved", "Whole", "Thirds"],
                    "Frenched per pack", ["No", 2, 1]
                ))
        ),
        "Boneless", Map(
            "Steaks",
            Map(
                "See sub-menu", Map(
                    "Thickness", thickness,
                    "No\pack", [1, 2, 3, 4],
                    "Spare Ribs", ["Yes", "*Grind"]
                )),
            "Roasts", Map(
                "See sub-menu", Map(
                    "Spare Ribs", ["Yes", "*Grind"],
                    "Size", ["Halved", "Whole", "Thirds"]
                )
            )
        )),
    "Loin", Map(
        "Hanger", Map("Grind", "Finished.", "Steak", "Finished."),
        "Flank", Map("Grind", "Finished.", "Steak", "Finished.")
    ),
    "Steaks", Map(
        "*Grind", "Finished.",
        "N.Y. Strip", Map(
            "See sub-menu", Map(
                "Thickness", thickness,
                "No./Pack", ["2", "3", "4", "1"]
        )),
        "Filet Mignon", Map(
            "See sub-menu", Map(
                "Thickness", thickness,
                "No./Pack", ["2", "3", "4", "1"]
        )),
        "Top Sirloin", Map(
            "See sub-menu", Map(
                "Thickness", thickness
        )),
        "T-bone/Porterhouse/Bone-in Sirloin", Map(
            "T-bone/Porterhouse", Map(
            "See sub-menu", Map(
                "Thickness", thickness,
                "No./Pack", ["2", "3", "4", "1"]
            )),
            "Bone-in Sirloin", Map(
            "See sub-menu", Map(
                "Thickness", thickness
            )
        ))
    ),
    "Round", Map(
        "London Broil", steaks,
        "Top Round", steaks,
        "Bottom Round", steaks,
        "Eye of Round", steaks,
        "Sirloin Tip", steaks
    ),
    "Ground", Map(
        "Trim Packed Unground", Map(
            "No", "Finished.",
            "Yes", "Ask customer:(10 lbs-1000 lbs)"
        ),
        "Ground Beef", Map(
            "1 lb", ["100% 1 lb", "2 lbs (50%)", "5 lbs (50%)", "10 lbs (50%)"],
            "2 lb", ["100% 2 lbs", "1 lb (50%)", "5 lbs (50%)", "10 lbs (50%)"],
            "5 lb", ["100% 5 lbs", "1 lb (50%)", "2 lbs (50%)", "10 lbs (50%)"],
            "10 lb", ["100% 5 lbs", "1 lb (50%)", "2 lbs (50%)", "10 lbs (50%)"],
            "10 lbs", ["100% 10 lbs", "1 lb (50%)", "2 lbs (50%)", "5 lbs (50%)"]
        ),
        "Beef Patties", Map(
            "None", "Finished.",
            "25 lbs", weight,
            "50 lbs", weight,
            "75 lbs", weight,
            "100 lbs", weight
        )
    ),
    "Offal", Map(
        "Heart", ["No", "Yes"],
        "Liver", [
            "No",
            "Whole",
            "Roasts"]
    )
)