tableextension 76001 "CB Warehouse Activity Line" extends "Warehouse Activity Line" //5767
{
    fields
    {
        field(76000; "CB Nbre Colis"; Integer)
        {
            Caption = 'Colis';
            CalcFormula = count("CB Colis" where(
                  "Picking No" = field("No."),
                  "Picking line no" = field("Line No.")
              ));
            Editable = false;
            FieldClass = FlowField;
        }
        field(76001; "CB Picking validated"; Boolean)
        {

        }
        field(76002; "CB Picked barcode"; text[250])
        {

        }
        field(76003; "CB Nbre Colis picking"; Integer)
        {
            Caption = 'Colis';
            CalcFormula = count("CB Colis" where(
                  "Picking No" = field("No."),
                  "Picking line source" = field("Line No.")
              ));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

