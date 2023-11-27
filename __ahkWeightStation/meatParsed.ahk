Tomahawks := [">>Tomahawks", "*No", "Yes"]
thickness := [">>Thickness", "1.5in", "1in", "1.25in", "1.75in", "0.75in"]
steaks :=  ["Grind", "Roasts", "Steaks", "Stew Meat", "Fajita", "Kabob", "Cube Steak", "Thinly Sliced"]

Tomahawks := [">>Tomahawks", "*No", "Yes"]
thickness := [">>Thickness", "1.5in", "1in", "1.25in", "1.75in", "0.75in"]
steaks :=  ["Grind", "Roasts", "Steaks", "Stew Meat", "Fajita", "Kabob", "Cube Steak", "Thinly Sliced"]
BeefMap := Map(
    "Chuck/Shoulder", Map(
        "Grind", "Grind",
        "Bone-in", Map(
            "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"], "Steaks", "Select?"
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
        "Grind", "Grind", "Whole", "Whole",
        "Shank Cuts", ["2in", "1.5in", "1in"]
    ),
    "Skirt", ["Grind", "Steak"],
    "Bones", Map(
        "*No", "No",
        "Yes", ["Marrow Only",
            "Marrow Only",
            "Knuckles Only",
            "Marrows & Knuckles"]
    ),
    "Ribs", ["*Grind", "Plate", "English", "Korean"],
    "Ribeye", Map(
        "Grind", "Select?",
        "Bone-in", Map(
            "Steaks", Map(
                "*Select All:", "",
                "Thickness", thickness,
                "Tomahawk", Tomahawks,
                "No./Pack", [
                    "2", "3", "4", "1"
                    ]
            ),
            "Roasts", Map(
                "*Select All:", "",
                "Size", ["Halved", "Whole", "Thirds"],
                "Frenched per pack", ["No", 2, 1]
            )
        ),
        "Boneless", Map(
            "Steaks", 
            Map(
                "*Select All:", "",
                "Thickness", thickness,
                "No\pack", [1, 2, 3, 4],
                "Spare Ribs", ["Yes", "*Grind"]
            ),
            "Roasts", Map(
                "*Select All:", "",
                "Spare Ribs", ["Yes", "*Grind"],
                "Size", ["Halved", "Whole", "Thirds"]
            )
        )
    ),
    "Loin", Map(
        "Hanger", ["Grind", "Steak"],
        "Flank", ["Grind", "Steak"]
    ),
    "Steaks", Map(
        "*Grind", "Select?",
        "N.Y. Strip", Map(
            "*Complete Both: ", "",
            "Thickness", thickness,
            "No./Pack", ["2", "3", "4", "1"]
        ),
        "Filet Mignon", Map(
            "Thickness", thickness,
            "No./Pack", ["2", "3", "4", "1"]
        ),
        "Top Sirloin", Map(
            "Thickness", thickness
        ),
        "T-bone/Porterhouse/Bone-in Sirloin", Map(
            "T-bone/Porterhouse", Map(
                "Thickness", thickness,
                "No./Pack", ["2", "3", "4", "1"]
            ),
            "Bone-in Sirloin", Map(
                "Thickness", thickness
            )
        )
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
            "No", "Select?",
            "Yes", ["Ask customer:(10 lbs-1000 lbs)"]
        ),
        "Ground Beef", Map(
            "1 lb", ["100% 1 lb", "2 lbs (50%)", "5 lbs (50%)", "10 lbs (50%)"],
            "2 lbs", ["100% 2 lbs", "1 lb (50%)", "5 lbs (50%)", "10 lbs (50%)"],
            "5 lbs", ["100% 5 lbs", "1 lb (50%)", "2 lbs (50%)", "10 lbs (50%)"],
            "10 lbs", ["100% 10 lbs", "1 lb (50%)", "2 lbs (50%)", "5 lbs (50%)"]
        ),
        "Beef Patties", Map(
            "None", "Select?",
            "25 lbs", [">>Weight>>", "4oz", "5oz", "6oz"],
            "50 lbs", [">>Weight>>", "4oz", "5oz", "6oz"],
            "75 lbs", [">>Weight>>", "4oz", "5oz", "6oz"],
            "100 lbs", [">>Weight>>", "4oz", "5oz", "6oz"]
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