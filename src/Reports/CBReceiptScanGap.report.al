report 76002 "CB Receipt Scan Gap"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = '.\src\Reports\rdlc\Receipt Scan Gap.rdl';
    Caption = 'Ecart scan réception', Locked = true;
    dataset
    {
        dataitem("Registered Whse. Activity Hdr."; "Registered Whse. Activity Hdr.")
        {
            RequestFilterFields = "No.", "Whse. Activity No.", "Location Code", "STF Transit Folder No.";
            DataItemTableView = sorting("No.") where(Type = const("Put-away"));
            column(No_; "No.") { }
            column(Whse__Activity_No_; "Whse. Activity No.") { }
            column(TitleCap; TitleCap) { }
            column(ItemNoCap; ItemNoCap) { }
            column(ItemDescCap; ItemDescCap) { }
            column(QtyCap; QtyCap) { }
            column(ScannedQtyCap; ScannedQtyCap) { }
            column(QtyGapCap; QtyGapCap) { }
            column(BinCap; BinCap) { }
            column(ShowScanHistory; ShowScanHistory) { }
            column(UserCap; UserCap) { }
            column(DocumentNoCap; DocumentNoCap) { }

            dataitem("Registered Whse. Activity Line"; "Registered Whse. Activity Line")
            {
                DataItemLink = "Activity Type" = field("Type"), "No." = field("No.");
                DataItemTableView = sorting("No.", "Line No.") where("Action Type" = const(Place));
                column(Item_No_; "Item No.") { }
                column(ItemDescription; Description) { }
                column(Quantity; Quantity) { }
                column(CB_Scanned_Quantity; "CB Scanned Quantity") { }
                dataitem("CB Historique Scan"; "CB Historique Scan")
                {
                    DataItemLink = Magasin = field("Location Code"), Article = field("Item No.");
                    DataItemTableView = sorting("Document No.") where("Document Type" = Const(Reception));

                    column(article; article) { }
                    column(Description; Description) { }
                    column(Controlled_Quantity; "Controlled Quantity") { }
                    column(Emplacement; Emplacement) { }
                    column(user; user) { }

                    trigger OnPreDataItem()
                    begin
                        if not ShowScanHistory then
                            CurrReport.Break();
                        "CB Historique Scan".SetRange("Document No.", "Registered Whse. Activity Hdr."."Whse. Activity No.");
                    end;
                }
            }



        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Group)
                {
                    field(ShowScanHistory; ShowScanHistory)
                    {
                        ApplicationArea = all;
                        Caption = 'Afficher historique scan';
                        ToolTip = 'Specifies the value of the Show Scan History field.';
                    }
                }
            }
        }
    }
    var
        ShowScanHistory: Boolean;
        TitleCap: Label 'Ecarts scan réception', Locked = true;
        ItemNoCap: Label 'Article', Locked = true;
        ItemDescCap: Label 'Description', Locked = true;
        QtyCap: Label 'Quantité', Locked = true;
        ScannedQtyCap: Label 'Qté scannée', Locked = true;
        QtyGapCap: Label 'Ecart', Locked = true;
        BinCap: Label 'Emplacement', Locked = true;
        UserCap: Label 'Utilisateur', Locked = true;
        DocumentNoCap: Label 'N° document', Locked = true;
}