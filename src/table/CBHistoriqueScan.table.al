table 76000 "CB Historique Scan"
{
    LookupPageId = "CB Historique";
    Caption = 'Historique scan';
    fields
    {
        field(76000; Barcode; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(76001; article; Code[20])
        {
        }
        field(76002; Description; Text[250])
        {
        }
        field(76003; "Picked Quantity"; Decimal)
        {
        }
        field(76004; "Controlled Quantity"; Decimal)
        {
        }
        field(76005; "Document No."; Text[50])
        {
        }
        field(76006; Magasin; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(76007; Emplacement; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(76008; user; code[50])
        {
            TableRelation = "ADCS User".Name;
        }
        field(76009; "Document Type"; enum "CB scantype")
        {
            Caption = 'Type';
        }
        field(76010; Cancelled; Boolean)
        {
            initvalue = false;
        }
    }
    keys
    {

        key(key1; article, "Document No.", Magasin, Emplacement, user, "Document Type", Cancelled)
        {
        }
    }
}



