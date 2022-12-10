let
    Source = Table.SelectColumns(#"FY 2021 Dialysis Facility Reports", {"CCN", "Measure ID", "Year", "Measure Score"}),
    #"Reordered Columns" = Table.ReorderColumns(Source,{"CCN", "Year", "Measure ID", "Measure Score"}),
    #"Pivoted Column" = Table.Pivot(#"Reordered Columns", List.Distinct(#"Reordered Columns"[#"Measure ID"]), "Measure ID", "Measure Score")
in
    #"Pivoted Column"