let
    Source = Table.SelectColumns(#"Dialysis Facility Reports", {"CCN", "Provider Name", "State", "City", "Ownership Type", "ESRD Network", "NPI", "Chain Name", "Modality", "Alternate CCN(s)"}),
    Grouped = Table.Distinct(Source)
in
    Grouped