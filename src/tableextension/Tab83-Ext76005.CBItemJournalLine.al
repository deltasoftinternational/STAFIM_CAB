tableextension 76005 "CB Item Journal Line" extends "Item Journal Line" //83
{
    fields
    {
        field(76000; "CB Comptage 1"; Decimal)
        {
            Caption = 'Comptage 1';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(76001; "CB Comptage 2"; Decimal)
        {
            Caption = 'Comptage 2';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(76002; "CB Comptage 3"; Decimal)
        {
            Caption = 'Comptage 3';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(76003; "CB Motif Ecart"; Text[100])
        {
            Caption = 'Motif d''écart';
            DataClassification = ToBeClassified;
        }
        field(76004; "CB Comptage Actif"; Integer)
        {
            Caption = 'Comptage actif';
            DataClassification = ToBeClassified;
            InitValue = 1;
            MinValue = 1;
            MaxValue = 3;
        }
        field(76005; "CB Ecart Valeur"; Decimal)
        {
            Caption = 'Écart en valeur';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(76006; "CB Inventaire Validé"; Boolean)
        {
            Caption = 'Inventaire validé';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
