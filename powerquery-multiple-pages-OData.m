let
    BaseUrl = "https://global.intelex.com/Login3/LOGICS/api/v2/object/SafetIncidentv6_SSafetyIncidentObject?$select=DateOccurenceH,TimofOccurrence,ShiftStartTime,ShiftEndTime,HrsAtTimeofAcc,DateCreated,IncidenRecordNo,InjurePartyName,WhatObjHarmed,DateOfBirth,DayAwayFromWork,DaysJobTransfer,InjuWorkRelated,Deleted&$expand=CreatedBy($select=Name),Location($select=Name),hciMasterIncide($select=IncidentNo),CategoryID($select=Caption),Function($select=Caption),DHLInjPartyType($select=Caption),CausationType($select=Caption),SubIncidentType($select=Caption),DHLBodyPart($select=Caption),Workflow($select=DueDateType,WorkflowStatus)&",
    perPage = 500,
    
    getUrlJsonData = (Url) =>
        let Json    = Json.Document(Web.Contents(Url))
        in  Json,

    getAllPages = () =>
        let Url   = BaseUrl & "$count=true&$top=0",
            Json  = getUrlJsonData(Url),
            Count = Json[#"@odata.count"]
        in  Count,

    GetPage = (Index) =>
        let Skip  = "$skip=" & Text.From(Index * perPage),
            Top   = "$top=" & Text.From(perPage),
            Url   = BaseUrl & Skip & "&" & Top,
            Json  = getUrlJsonData(Url),
            value = Json[#"value"]
        in value,

    dataCount = List.Max({ perPage, getAllPages() }),
        PageCount   = Number.RoundUp(dataCount / perPage),
        PageIndices = { 0 .. PageCount - 1 },
        Pages       = List.Transform(PageIndices, each GetPage(_)),
        maxValues    = List.Union(Pages),
    Table       = Table.FromList(maxValues, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
in
    Table
