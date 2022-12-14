let
    Source = Csv.Document(Web.Contents(#"Dialysis Facilities Report Link"),[Delimiter=",", Columns=14, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Replaced Value" = Table.ReplaceValue(Source,"state","State",Replacer.ReplaceValue,{"Column1"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Provider_Name","Provider Name",Replacer.ReplaceValue,{"Column3"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","city","City",Replacer.ReplaceValue,{"Column4"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","Ownership_Type","Ownership Type",Replacer.ReplaceValue,{"Column5"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","ESRD_Network","ESRD Network",Replacer.ReplaceValue,{"Column6"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","Chain","Chain Name",Replacer.ReplaceValue,{"Column8"}),
    #"Replaced Value6" = Table.ReplaceValue(#"Replaced Value5","Alternate_CCNs","Alternate CCN(s)",Replacer.ReplaceValue,{"Column10"}),
    #"Replaced Value7" = Table.ReplaceValue(#"Replaced Value6","Measure_Score","Measure Score",Replacer.ReplaceValue,{"Column12"}),
    #"Replaced Value8" = Table.ReplaceValue(#"Replaced Value7","year","Year(s) covered by the measure",Replacer.ReplaceValue,{"Column13"}),
    #"Replaced Value9" = Table.ReplaceValue(#"Replaced Value8","Measure_ID","Measure ID",Replacer.ReplaceValue,{"Column14"}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Replaced Value9", [PromoteAllScalars=true]),
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