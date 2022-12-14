let
    Source = Table.SelectColumns(#"Dialysis Facility Reports", {"Measure ID", "Measure Name"}),
    Grouped = Table.Distinct(Source),
    #"Split Column by Delimiter" = Table.SplitColumn(Grouped, "Measure Name", Splitter.SplitTextByEachDelimiter({":"}, QuoteStyle.Csv, false), {"Measure Prefix", "Measure Name"}),
    #"Trimmed Text" = Table.TransformColumns(#"Split Column by Delimiter",{{"Measure Name", Text.Trim, type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Trimmed Text",{"Measure Prefix"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Columns", {"Measure ID"})
in
    #"Removed Duplicates"