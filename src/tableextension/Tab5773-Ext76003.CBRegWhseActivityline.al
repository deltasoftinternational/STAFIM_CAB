tableextension 76003 "CB Reg Whse. Activity line" extends "Registered Whse. Activity line" //5773
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
        field(76004; "CB Scanned Quantity"; decimal)
        {
            Caption = 'Quantité scan';

            Editable = false;

        }
    }
}

