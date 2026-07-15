page 76014 "CB Inventory Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CB Inventory Setup";
    Caption = 'Paramétrage inventaire CB';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Général';

                field("CB Seuil Ecart Valeur"; Rec."CB Seuil Ecart Valeur")
                {
                    ApplicationArea = All;
                    ToolTip = 'Seuil en valeur en dessous duquel le comptage 3 peut être exclu.';
                }
                field("CB Motif Ecart Obligatoire"; Rec."CB Motif Ecart Obligatoire")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indique si le motif d''écart est obligatoire lors de la constatation d''un écart.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;
}
