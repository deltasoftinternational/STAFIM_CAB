table 76002 "CB USER"
{
    Caption = 'Utilisateurs';
    LookupPageId = "CB User List";
    DataClassification = ToBeClassified;

    fields
    {

        field(1; User; Text[20])
        {
            DataClassification = ToBeClassified;
            //CharAllowed = '09azAZ';
            TableRelation = "ADCS User".Name;
        }

        field(2; Enregistrement; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Phys. Invt. Order Header"."No." where("Status" = const(Open));



        }

        field(3; no; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Phys. Invt. Record Header"."Recording No." where("Order No." = field(Enregistrement), "Status" = const(Open));

        }

    }
    keys
    {
        key(Key1; User, Enregistrement, no)
        {
            Clustered = true;
        }

    }










}