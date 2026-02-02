page 76002 "CB Colis"
{
    Caption = 'Colisage entrepôt ';
    SourceTable = "CB Colis";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {

            repeater(Colis)
            {
                field("Colis No"; Rec."Colis No")
                {
                    Caption = 'Colis';
                    ApplicationArea = All;
                }
                field("Picking No"; Rec."Picking No")
                {
                    caption = 'Prélèvement';
                    ApplicationArea = All;

                }
                field("Picking line no"; Rec."Picking line no")
                {
                    caption = 'Ligne Prélèvement';
                }
                field(Quantity; Rec.Quantity)
                {
                    caption = 'Qte colisage';
                    DecimalPlaces = 0 : 5;


                    ApplicationArea = All;
                }
                field("Final Quantity"; Rec."Final Quantity")
                {
                    Caption = 'Quantité pické';
                    DecimalPlaces = 0 : 5;

                    ApplicationArea = All;
                }

            }
        }
    }
    // var
    //     RecArticle: Integer;

    // trigger OnAfterGetCurrRecord()
    // begin
    //     RecArticle := rec.Count();
    // end;
}