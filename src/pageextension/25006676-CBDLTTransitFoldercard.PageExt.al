pageextension 76004 "CB DLT Transit Folder card" extends "DLT Transit Folder card"//25006676
{
    layout
    {

    }
    actions
    {
        addafter("DLT Localisation article")
        {
            action("CB Receipt Scan Gap")
            {
                ApplicationArea = All;
                Caption = 'Ecart scan réception', Locked = true;
                Image = PrintReport;

                trigger OnAction()
                var
                    ReceiptScanGap: Report "CB Receipt Scan Gap";
                    WhseActivityHdr: Record "Registered Whse. Activity Hdr.";
                begin
                    WhseActivityHdr.Reset();
                    WhseActivityHdr.SetRange("STF Transit Folder No.", Rec."TFNo.");
                    ReceiptScanGap.SetTableView(WhseActivityHdr);
                    ReceiptScanGap.Run();
                end;
            }
        }
        addlast(Category_Report)
        {
            actionref(ReceiptScanGapProm; "CB Receipt Scan Gap")
            {

            }
        }
    }
}