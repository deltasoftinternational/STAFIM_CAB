report 76001 "CB Imprimer code Article"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\src\Reports\rdlc\CABA.rdl';
    ApplicationArea = Warehouse;
    Caption = 'Imprimer Article';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Bin; Item)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(BinCaption; TableCaption + ': ' + BinFilter)
            {

            }
            column(BinFilter; BinFilter)
            {
            }
            column(LocationCode_Bin; "Location Code")
            {
            }
            column(Code_Bin; "No.")
            {
            }
            column(QR_BLOB; ComInf_gRecTmp.Picture) { }
            trigger OnAfterGetRecord()
            var
                BarcodeImage: Codeunit "CB Vérification";
                TempBlob: Codeunit "Temp Blob";
                art: Record Item;
                lrecTmpCode128: Record "CB Code 12839" temporary;
            begin
                lrecTmpCode128.Reset;
                BarcodeImage.EncodeCode128(Bin."No.", 1, false, ComInf_gRecTmp);
            end;
        }
    }
    var
        "Location Code": text;
        Code: text;
        EncodedText: Text;
        BinFilter: Text;
        ComInf_gRecTmp: record "Company Information" temporary;
        LocationCode: Text;

}

