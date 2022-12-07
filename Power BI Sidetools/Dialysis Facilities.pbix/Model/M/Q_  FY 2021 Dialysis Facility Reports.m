let
    Source = Csv.Document(Web.Contents("https://data.cms.gov/sites/default/files/2021-01/FY_2021_Facility_Level_Dialysis_Facility_Reports.csv"),[Delimiter=",", Columns=14, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"State", type text}, {"CCN", Int64.Type}, {"Provider Name", type text}, {"City", type text}, {"Ownership Type", type text}, {"ESRD Network", Int64.Type}, {"NPI", type text}, {"Chain Name", type text}, {"Modality", type text}, {"Alternate CCN(s)", type text}, {"Measure", type text}, {"Measure Score", type number}, {"Year(s) covered by the measure", type text}, {"Measure ID", type text}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type",{"CCN", "Provider Name", "State", "City", "Ownership Type", "ESRD Network", "NPI", "Chain Name", "Modality", "Alternate CCN(s)", "Measure", "Measure Score", "Year(s) covered by the measure", "Measure ID"}),
    #"Filtered Rows" = Table.SelectRows(#"Reordered Columns", each ([#"Year(s) covered by the measure"] <> "2016-18" and [#"Year(s) covered by the measure"] <> "2016-19" and [#"Year(s) covered by the measure"] <> "n/a")),
    #"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"Year(s) covered by the measure", "Year"}, {"Measure", "Measure Name"}})
in
    #"Renamed Columns"