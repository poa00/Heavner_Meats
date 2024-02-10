Weight := ["1 lb", "2 lbs", "5 lbs", "10 lbs"]
Tomahawks := ["*No", "Yes"]
thickness := ["1.5in", "1in", "1.25in", "1.75in", "0.75in"]
steaks := ["Whole", "Steaks", "Grind"]
NoPack := ["2", "3", "4", "1"]
shortRibs := Map(
    "Grind", "Finished.",
    "Plate", "Finished.",
    "English", Map(
        "Bone-in", ["Bone-in", "Boneless"],
        "Boneless", "Finished."
    ),
    "Korean", "Finished.",
    "Bacon", Map(
        "Celery", "Celery",
        "Nitrite", "Nitrite",
        "Slab", "Slab",
        "Sliced", "Sliced"
    )
)
chuck := Map(
    "Grind", "Grind",
    "Bone-in", Map(
        "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"],
        "Steaks", ["Roasts", "Steaks"]
    ),
    "Boneless", Map(
        "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"],
        "Steaks", ["Roasts", "Steaks"]
    ))
arm := Map(
    "Grind", "Grind",
    "Bone-in", Map(
        "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
    ),
    "Boneless", Map(
        "Roasts", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"],
        "Ranch Steaks", "Ranch Steaks"
    )
)

ribEye := Map(
    "Grind", "Finished.",
    "Bone-in", Map(
        "Steaks", Map(
            "Thickness", thickness,
            "Tomahawks", Tomahawks,
            "No./Pack", ["2", "3", "4", "1"]
        )
    ),
    "Roasts", Map(
        "Size", ["Halved", "Whole", "Thirds"],
        "Frenched", ["No", "Yes"]
    ),
    "Boneless", Map(
        "Steaks", Map(
            "Thickness", thickness,
            "No./Pack", ["2", "3", "4", "1"],
            "Spare Ribs", ["Yes", "Grind"]
        ),
        "Roasts", Map(
            "Size", ["Halved", "Whole", "Thirds"],
            "Spare Ribs", ["Yes", "Grind"]
        )
    )
)

loinSteaks := Map(
    "SHORT LOIN", Map(
        "NY STRIP// FILET (BONELESS)", Map(
            "TBONE/PORTERHOUSE (BONE-IN STEAKS)", Map(
                "No Pack && Thickness", thickness,
                "NYSTRIP", Map(
                    "FILET OPTIONS", Map(
                        "Whole OR Steaks (NYSTRIP)", ["Whole", "Steaks"],
                        "Steaks", Map(
                            "Thickness", thickness,
                            "No Per Pack", ["2", "3", "4", "1"]
                        )
                    )
                )
            ),
            "NYSTRIP", Map(
                    "ROASTS", Weight,
                    "STEAKS", Map(
                        thickness,
                        NoPack
                )
            )
        ),
        "SIRLOIN", Map(
            "BONE-IN (SIRLOIN STEAK)", Map(
                "THICKNESS", thickness
            ),
            "BONELESS", Map(
                "ROASTS || STEAKS", Map(
                    "ROASTS", Weight,
                    "STEAKS", Map(
                        "TOP SIRLOIN || or -> all three below", Map(
                            "required 2 fields regardless", "Show after thickness",
                            "thickness", "Show after thickness",
                            "no/pack", "Show after thickness"
                        )
                    )
                )
            )
        )
    )
)

ground := Map(
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
        "25 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        ),
        "50 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        ),
        "75 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        ),
        "100 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        )
    )
)

londonBroil := Map(
    "Grind", "Finished.",
    "Roasts", Map(
        "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
    ),
    "Steaks", Map(
        "Thickness", thickness
    ),
    "Stew Meat", Map(
        "Weight", ["1 lb", "2 lbs", "5 lbs"]
    ),
    "Fajita", Map(
        "Weight", ["1 lb", "2 lbs", "5 lbs"]
    ),
    "Kabob", Map(
        "Weight", ["1 lb", "2 lbs", "5 lbs"]
    )
)

offal := Map(
    "Heart", ["No", "Yes"],
    "Liver", Map(
        "No", "No",
        "Whole", "Whole",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Sliced", "Sliced"
    ),
    "Kidney", ["No", "Yes"],
    "Tongue", ["No", "Yes"],
    "Oxtail", ["No", "Yes"],
    "Beef Back Fat", ["No", "Yes"],
    "Beef Kidney Fat", ["No", "Yes"]
)

BeefMap := Map(
    "Chuck", chuck,
    "Arm", arm,
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
        "Shank Cuts", ["2in", "1.5in", "1in"]
    ),
    "Skirt", Map("Grind", "Finished.", "Steak", "Finished."),
    "Bones", Map(
        "No", "No",
        "Marrow Only", "Finished.",
        "Knuckles Only", "Finished.",
        "Marrows & Knuckles", "Finished."
    ),
    "Short Ribs", shortRibs,
    "Ribeye", ribeye,
    "Hanger", Map("Grind", "Finished.", "Steak", "Finished."),
    "Flank", Map("Grind", "Finished.", "Steak", "Finished."),
    "Loin Steaks", loinSteaks,
    "TRITIP", "BINARY",
    "London Broil", londonBroil,
    "Top Round", Map(
        "Grind", "Finished.",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew Meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        )
    ),
    "Bottom Round", Map(
        "Grind", "Finished.",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew Meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        )
    ),
    "Eye of Round", Map(
        "Grind", "Finished.",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew Meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs, 5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs, 5 lbs"]
        )
    ),
    "Sirloin Tip", Map(
        "Grind", "Finished.",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew Meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs, 5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs, 5 lbs"]
        )
    ),
    "FAT", Map(
        "BACKFAT", "BINARY",
        "KIDNEYFAT", "BINARY",
        "GRIND", "BINARY"
    ),
    "Ground", ground,
    "Offal", offal
)