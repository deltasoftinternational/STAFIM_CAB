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
                field("Article"; rec."Item No.")
                {
                    Editable = false;
                }
                field("Description"; rec."Description")
                {
                    Editable = false;
                }
                field("Quantity"; rec."CB purchase UserQuantity")
                {
                    caption = 'Quantité';
                    Editable = false;
                    DecimalPlaces = 0 : 5;
                }
            }

        }
    }

    var
        quantity: decimal;

}