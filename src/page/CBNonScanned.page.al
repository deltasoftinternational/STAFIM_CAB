page 76009 "CB Non Scanned"
{
    Caption = 'Non Scanned';
    PageType = StandardDialog;
    SourceTable = "Phys. Invt. Record Line";
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(GroupName)
            {
                field(Article; rec."Item No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; rec."Description")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Emplacement; rec."Bin Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Vide; rec.Recorded)
                {
                    ApplicationArea = all;
                    Caption = 'Vide';

                }
            }

        }
    }

}