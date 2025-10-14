tableextension 76001 "CB Warehouse Activity Line" extends "Warehouse Activity Line" //5767
{
    fields
    {


        field(76000; "CB Picked Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            Trigger onvalidate()
            begin
                if rec."CB Picked Quantity" > Rec."Qty. Outstanding" then
                    Error('Vous ne pouvez pas traiter plus que les %1 unités restantes.', Rec."Qty. Outstanding");
            end;

        }
        field(76001; "CB Controlled Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            Trigger onvalidate()
            begin
                if rec."CB Controlled Quantity" > Rec."Qty. Outstanding" then
                    Error('Vous ne pouvez pas traiter plus que les %1 unités restantes.', Rec."Qty. Outstanding");
            end;

        }
        field(76002; "CB Nbre Colis"; Integer)
        {
            Caption = 'Colis';
            CalcFormula = count("CB Colis" where(
                  "Picking No" = field("No."),
                  "Picking line no" = field("Line No.")
              ));
            Editable = false;
            FieldClass = FlowField;
        }




    }
}

