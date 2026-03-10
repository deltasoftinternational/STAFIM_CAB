
report 76000 "BC Imprimer code d'emplacement"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\src\Reports\rdlc\CAB.rdl';
    ApplicationArea = Warehouse;
    Caption = 'Imprimer emplacement';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Bin; Bin)
        {
            DataItemTableView = SORTING("Location Code", Code);
            RequestFilterFields = "Location Code";
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
                IncludeCaption = true;
            }
            column(Code_Bin; Code)
            {
                IncludeCaption = true;
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

                BarcodeImage.EncodeCode128(Bin.Code, 1, false, ComInf_gRecTmp);

            end;

            trigger OnPreDataItem()
            begin
                if LocationCode <> '' then
                    bin.SetFilter(code, Locationcode);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(option)
                {
                    field(Location; LocationCode)
                    {
                        TableRelation = bin.Code;
                        ApplicationArea = all;
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        BinFilter := Bin.GetFilters;
    end;

    var
        EncodedText: Text;
        BinFilter: Text;
        ComInf_gRecTmp: record "Company Information" temporary;
        LocationCode: Text;
}