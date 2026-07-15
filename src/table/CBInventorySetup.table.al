table 76004 "CB Inventory Setup"
{
    Caption = 'Paramétrage inventaire CB';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Clé primaire';
            DataClassification = ToBeClassified;
        }
        field(2; "CB Seuil Ecart Valeur"; Decimal)
        {
            Caption = 'Seuil écart en valeur (exclusion comptage 3)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
        }
        field(3; "CB Motif Ecart Obligatoire"; Boolean)
        {
            Caption = 'Motif d''écart obligatoire';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if not Get('') then begin
            Init();
            "Primary Key" := '';
            Insert();
        end;
    end;
}
