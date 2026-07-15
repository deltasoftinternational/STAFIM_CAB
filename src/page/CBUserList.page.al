page 76008 "CB User List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CB USER";
    caption = 'Affectation des utilisateurs';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Nom utilisateur"; Rec.User)
                {
                    ApplicationArea = All;
                }
                field("CB Inv. Journal Type"; Rec."CB Inv. Journal Type")
                {
                    Caption = 'Type feuille inventaire';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("CB Comptage"; Rec."CB Comptage")
                {
                    Caption = 'Comptage affecté';
                    ApplicationArea = All;
                }
                field("CB Whse. Inv. Jnl Template"; Rec."CB Whse. Inv. Jnl Template")
                {
                    Caption = 'Modèle feuille inv. entrepôt';
                    ApplicationArea = All;
                    Visible = true;
                    Enabled = IsWhseType;
                }
                field("CB Whse. Inv. Jnl Batch"; Rec."CB Whse. Inv. Jnl Batch")
                {
                    Caption = 'Feuille inv. entrepôt';
                    ApplicationArea = All;
                    Visible = true;
                    Enabled = IsWhseType;
                }
                field("CB Inv. Journal Template"; Rec."CB Inv. Journal Template")
                {
                    Caption = 'Modèle feuille inv. article';
                    ApplicationArea = All;
                    Visible = true;
                    Enabled = IsItemType;
                }
                field("CB Inv. Journal Batch"; Rec."CB Inv. Journal Batch")
                {
                    Caption = 'Feuille inv. article';
                    ApplicationArea = All;
                    Visible = true;
                    Enabled = IsItemType;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    trigger OnAfterGetRecord()
    begin
        IsWhseType := Rec."CB Inv. Journal Type" = Rec."CB Inv. Journal Type"::"Feuille Entrepôt";
        IsItemType := Rec."CB Inv. Journal Type" = Rec."CB Inv. Journal Type"::"Feuille Article";
    end;

    var
        IsWhseType: Boolean;
        IsItemType: Boolean;
}
