page 76012 "CB Warehouse Non Scanned"
{
    Caption = 'Non Scanned';
    SourceTable = "Warehouse Activity Line";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(GroupName)
            {
                field("Article"; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                // Bind the field to your global variable instead of the table field
                field("Quantity"; quantity)
                {
                    Caption = 'Quantité';
                    ApplicationArea = All;
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                }
            }
        }
    }

    var
        quantity: Decimal;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("CB purchase UserQuantity");
        quantity := Rec."CB purchase UserQuantity" + Rec."CB validated Quantity";
    end;
}