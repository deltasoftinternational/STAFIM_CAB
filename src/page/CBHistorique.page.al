page 76001 "CB Historique"
{
    Caption = 'Historique scan';
    SourceTable = "CB Historique Scan";
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
            field("Nombre des lignes"; RecArticle)
            {
                Caption = 'Nombre d articles comptés.';
                Editable = false;
            }
            repeater(GroupName)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Caption = 'Type de document';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Code à barre"; Rec."Barcode")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Article; Rec.article)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Picked Quantity"; Rec."Picked Quantity")
                {
                    Caption = 'Quantité prélevée';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Controlled Quantity"; Rec."Controlled Quantity")
                {
                    Caption = 'Quantité controllée';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Document; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Enregistrement; Rec.Enregistrement)
                {
                    caption = 'Enregistrement inventaire';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Inventaire; Rec.Qte)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Magasin; Rec.Magasin)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Emplacement; Rec.Emplacement)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(dest; Rec.dest)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(user; Rec.user)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date"; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    var
        RecArticle: Integer;

    trigger OnAfterGetCurrRecord()
    begin
        RecArticle := rec.Count();
    end;
}