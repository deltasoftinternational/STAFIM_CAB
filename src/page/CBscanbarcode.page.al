page 76005 "CB scan barcode"
{
    caption = 'Scan code à barre';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(barcode; barcode)
            {
                Caption = 'Code à barre';
                ApplicationArea = All;
            }

        }
    }
    procedure getbarcode(): text
    begin
        exit(barcode);
    end;

    var
        barcode: text;
}