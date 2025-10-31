page 76004 "CB Pick Subform"
{
    Caption = 'Motif';
    SourceTable = "Warehouse Activity Line";
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            field("Item No."; Rec."Item No.")
            {
                Caption = 'Numéro de l''article';
                Editable = false;
                ApplicationArea = All;
            }
            field("Warehouse Reason Code"; Rec."Warehouse Reason Code")
            {
                Caption = 'Code motif';
                ApplicationArea = All;
            }
        }
    }
}