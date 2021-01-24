/* Using a RelativePath is a workaround for collecting data from API's in Power BI if you have problems with using an API key to authenticate. 
Just replace the Authorizaztion value with your own Statuspage API key and replace the RelativePath with your Statuspage account path
See this blogpost for more information: https://gauteweb.net/english/data-from-api--39-s-in-power-bi.html */ 

Let
   Source = Json.Document(Web.Contents("https://api.statuspage.io", [Headers=[Authorization="XXXXXXX-XXXX-XXX-XXXX-XXXXXXXX"], RelativePath="/v1/pages/XXXXXXXXX/subscribers.json"])),
    
    #"Converted to Table" = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "created_at"}, {"Column1.id", "Column1.created_at"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Column1",{{"Column1.created_at", type datetime}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column1.id", "SubscriberID"}, {"Column1.created_at", "SubscribeDate"}}),
    #"Sorted Rows" = Table.Sort(#"Renamed Columns",{{"SubscribeDate", Order.Descending}})
in
    #"Sorted Rows"