let
    UrlToPbiImage = (ImageUrl as text) as text =>
let
    BinaryContent = Web.Contents(ImageUrl),
    Base64 = "data:image/jpeg;base64, " & Binary.ToText(BinaryContent, 

BinaryEncoding.Base64)
in
    Base64 
in
    UrlToPbiImage
