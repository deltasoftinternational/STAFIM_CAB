pageextension 76005 "CB Registered Put-away" extends "Registered Put-away"//5795
{
    layout
    {

    }
    actions
    {
        addlast("&Put-away")
        {
            action("CB Receipt Scan Gap")
            {
                ApplicationArea = All;
                Caption = 'Ecart scan réception', Locked = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    ReceiptScanGap: Report "CB Receipt Scan Gap";
                    WhseActivityHdr: Record "Registered Whse. Activity Hdr.";
                begin
                    WhseActivityHdr.Reset();
                    WhseActivityHdr.SetRange("No.", Rec."No.");
                    ReceiptScanGap.SetTableView(WhseActivityHdr);
                    ReceiptScanGap.Run();
                end;
            }
        }
    }
}