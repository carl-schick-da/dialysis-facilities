let
    Source = Csv.Document(Web.Contents("https://data.cms.gov/sites/default/files/2021-01/FY_2021_Facility_Level_Dialysis_Facility_Reports.csv"),[Delimiter=",", Columns=14, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"State", type text}, {"CCN", Int64.Type}, {"Provider Name", type text}, {"City", type text}, {"Ownership Type", type text}, {"ESRD Network", Int64.Type}, {"NPI", type text}, {"Chain Name", type text}, {"Modality", type text}, {"Alternate CCN(s)", type text}, {"Measure", type text}, {"Measure Score", type number}, {"Year(s) covered by the measure", type text}, {"Measure ID", type text}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type",{"CCN", "Provider Name", "State", "City", "Ownership Type", "ESRD Network", "NPI", "Chain Name", "Modality", "Alternate CCN(s)", "Measure", "Measure Score", "Year(s) covered by the measure", "Measure ID"}),
    #"Filtered Rows" = Table.SelectRows(#"Reordered Columns", each ([#"Year(s) covered by the measure"] <> "2016-18" and [#"Year(s) covered by the measure"] <> "2016-19" and [#"Year(s) covered by the measure"] <> "n/a")),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"Year(s) covered by the measure", "Year"}}),
    #"Filter Out Pediatrics" = Table.SelectRows(#"Renamed Columns", each not Text.StartsWith([Measure ID], "p_")),
    #"Filter In Yearly" = Table.SelectRows(#"Filter Out Pediatrics", each Text.EndsWith([Measure ID], "y1_f") or Text.EndsWith([Measure ID], "y2_f") or Text.EndsWith([Measure ID], "y3_f") or Text.EndsWith([Measure ID], "y4_f")),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Filter In Yearly", "Measure", Splitter.SplitTextByEachDelimiter({","}, QuoteStyle.Csv, true), {"Measure Name", "Measure Year"}),
    #"Split Column by Position" = Table.SplitColumn(#"Split Column by Delimiter", "Measure ID", Splitter.SplitTextByPositions({0, 4}, true), {"Measure ID", "Measure ID Suffix"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Split Column by Position",{{"Measure Name", type text}, {"Measure Year", type text}, {"Measure ID", type text}, {"Measure ID Suffix", type text}, {"Year", Int64.Type}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type1",{"Measure Year", "Measure ID Suffix"}),
    #"Select Specific Measures" = Table.SelectRows(#"Removed Columns", each (
            [Measure ID] = "staff" or 
            [Measure ID] = "endcnt" or 
            [Measure ID] = "dea" or 
            [Measure ID] = "exd" or 
            [Measure ID] = "CWhdavgufr" or 
            [Measure ID] = "CWhdufr2" or
            [Measure ID] = "CWhdavgktv" or
            [Measure ID] = "CWhdktv1" or
            [Measure ID] = "CWhdptmthdenom"
            ))
in
    #"Select Specific Measures"