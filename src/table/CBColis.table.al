table 76001 "CB Colis"
{
    LookupPageId = "CB Colis";
    DrillDownPageId = "CB Colis";
    Caption = 'Colisage entrepôt';
    fields
    {

        field(76000; "Colis No"; Text[250])
        {

            DataClassification = ToBeClassified;
        }

        field(76001; "line No"; integer)
        {

        }
        field(76002; "Picking No"; Code[20])
        {
            tablerelation = "Warehouse Activity Header"."No.";
        }
        field(76003; "Picking line no"; integer)
        {
            tablerelation = "Warehouse Activity Line"."Line No." where("No." = field("Picking No"));


        }
        field(76004; Quantity; Decimal)
        {

        }

        field(76005; "Final Quantity"; Decimal)
        {


        }





    }

    keys
    {

        key(key1; "line No")
        {
            Clustered = true;
        }

    }



}



