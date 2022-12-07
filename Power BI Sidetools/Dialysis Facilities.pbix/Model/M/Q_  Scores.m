let
    Source = Table.SelectColumns(#"FY 2021 Dialysis Facility Reports", {"CCN", "Measure ID", "Year", "Measure Score"}),
    #"Sorted Rows" = Table.Sort(Source,{{"CCN", Order.Ascending}, {"Measure ID", Order.Ascending}}),
    #"Split Column by Position" = Table.SplitColumn(#"Sorted Rows", "Measure ID", Splitter.SplitTextByPositions({0, 4}, true), {"Measure ID.1", "Measure ID.2"})
in
    #"Split Column by Position"