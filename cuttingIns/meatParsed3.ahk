Weight := ["1 lb", "2 lbs", "5 lbs", "10 lbs"]
Tomahawks := ["*No", "Yes"]
thickness := ["1.5in", "1in", "1.25in", "1.75in", "0.75in"]
steaks := ["Whole", "Steaks", "Grind"]
MapCopy := Map(
    "ROASTS", "WEIGHT (COPY)",
    "THICKNESS (COPY)", "THICKNESS (COPY)",
    "NO/PACK (COPY)", "NO/PACK (COPY)"
)

WeightMap := Map(
    "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"],
    "Spare Ribs", ["Yes", "Grind"],
    "Fajita", ["1 lb", "2 lbs", "5 lbs"],
    "Kabob", ["1 lb", "2 lbs", "5 lbs"]
)

BoneInMap := Map(
    "Roasts", WeightMap["Roasts"],
    "Steaks", WeightMap["Steaks"]
)

BonelessMap := Map(
    "Roasts", WeightMap["Roasts"],
    "Steaks", WeightMap["Steaks"],
    "Ranch Steaks", "Ranch Steaks"
)

SteakMap := Map(
    "Thickness", thickness,
    "Tomahawks", Tomahawks,
    "No./Pack", ["2", "3", "4", "1"],
    "Spare Ribs", WeightMap["Spare Ribs"]
)

BonelessTopSirloinMap := Map(
    "Roasts", WeightMap["Roasts"],
    "Steaks", Map(
        "Thickness", SteakMap["Thickness"],
        "No Per Pack", SteakMap["No./Pack"]
    )
)

SelectionMap := Map(
    "TOP SIRLOIN || or -> all three below", BonelessTopSirloinMap,
    "required 2 fields regardless", "Show after thickness",
    "thickness", "Show after thickness",
    "no/pack", "Show after thickness"
)

BeefMap := Map(
    "Chuck", Map(
        "Grind", "Grind",
        "Bone-in", BoneInMap,
        "Boneless", BonelessMap
    ),
    "Arm", Map(
        "Grind", "Grind",
        "Bone-in", BoneInMap,
        "Boneless", Map(
            "Roasts", BonelessMap["Roasts"],
            "Ranch Steaks", BonelessMap["Ranch Steaks"]
        )
    ),
    "Brisket", ["Grind", "Whole", "Halved", "Quartered"],
    "Sternum Bacon", Map(
        "Celery", "Celery",
        "Nitrite", "Nitrite",
        "Slab", "Slab",
        "Sliced", "Sliced"
    ),
    "Shanks", Map(
        "Grind", "Finished.",
        "Whole", "Finished.",
        "Shank Cuts", WeightMap["Shank Cuts"]
    ),
    "Skirt", SteakMap,
    "Bones", MapCopy,
    "Short Ribs", Map(
        "Grind", "Finished.",
        "Plate", "Finished.",
        "English", Map(
            "Bone-in", BoneInMap,
            "Boneless", MapCopy
        ),
        "Korean", "Finished.",
        "Bacon", Map(
            "Celery", "Celery",
            "Nitrite", "Nitrite",
            "Slab", "Slab",
            "Sliced", "Sliced"
        )
    ),
    "Ribeye", Map(
        "Grind", "Finished.",
        "Bone-in", Map(
            "Steaks", SteakMap
        ),
        "Roasts", Map(
            "Size", ["Halved", "Whole", "Thirds"],
            "Frenched", ["No", "Yes"]
        ),
        "Boneless", Map(
            "Steaks", SteakMap,
            "Roasts", Map(
                "Size", ["Halved", "Whole", "Thirds"],
                "Spare Ribs", WeightMap["Spare Ribs"]
            )
        )
    ),
    "Hanger", SteakMap,
    "Flank", SteakMap,
    "Loin Steaks", Map(
        "SHORT LOIN", Map(
            "NY STRIP// FILET (BONELESS)", Map(
                "TBONE/PORTERHOUSE (BONE-IN STEAKS)", SelectionMap,
                "NYSTRIP", Map(
                    "FILET OPTIONS", Map(
                        "Whole OR Steaks (NYSTRIP)", ["Whole", "Steaks"],
                        "Steaks", SelectionMap
                    )
                )
            ),
            "SIRLOIN", Map(
                "BONE-IN (SIRLOIN STEAK)", SelectionMap,
                "BONELESS", Map(
                    "ROASTS || STEAKS", SelectionMap
                )
            )
        )
    ),
    "TRITIP", "BINARY",
    "London Broil", Map(
        "Grind", "Finished.",
        "Roasts", WeightMap["Roasts"],
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew Meat", WeightMap["Stew Meat"],
        "Fajita", WeightMap["Fajita"],
        "Kabob", WeightMap["Kabob"]
    ),
    "Top Round", BoneInMap,
    "Bottom Round", BoneInMap,
    "Eye of Round", BoneInMap,
    "Sirloin Tip", BoneInMap,
    "FAT", Map(
        "BACKFAT", "BINARY",
        "KIDNEYFAT", "BINARY",
        "GRIND", "BINARY"
    ),
    "Ground", Map(
        "Trim Packed Unground", Map(
            "No", "Finished.",
            "Yes", "Ask customer:(10 lbs-1000 lbs)"
        ),
        "Ground Beef", Map(
            "1 lb", WeightMap["1 lb"],
            "2 lb", WeightMap["2 lb"],
            "5 lb", WeightMap["5 lb"],
            "10 lb", WeightMap["10 lb"],
            "10 lbs", WeightMap["10 lbs"]
        ),
        "Beef Patties", Map(
            "None", "Finished.",
            "25 lbs", Map(
                "Weight", ["4oz", "5oz", "6oz"]
            ),
            "50 lbs", MapCopy,
            "75 lbs", MapCopy,
            "100 lbs", MapCopy
        )
    ),
    "Offal", Map(
        "Heart", ["No", "Yes"],
        "Liver", Map(
            "No", "No",
            "Whole", "Whole",
            "Roasts", WeightMap["Roasts"],
            "Sliced", "Sliced"
        ),
        "Kidney", ["No", "Yes"],
        "Tongue", ["No", "Yes"],
        "Oxtail", ["No", "Yes"],
        "Beef Back Fat", ["No", "Yes"],
        "Beef Kidney Fat", ["No", "Yes"]
    )
)
