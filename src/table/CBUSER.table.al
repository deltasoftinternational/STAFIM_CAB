table 76002 "CB USER"
{
    Caption = 'Utilisateurs';
    LookupPageId = "CB User List";
    DataClassification = ToBeClassified;

    fields
    {

        field(76003; User; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "ADCS User".Name;
        }




        field(76004; "CB Inv. Journal Template"; Code[10])
        {
            Caption = 'Modèle feuille inventaire article';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name where(Type = const("Phys. Inventory"));
        }

        field(76005; "CB Inv. Journal Batch"; Code[10])
        {
            Caption = 'Feuille inventaire article';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("CB Inv. Journal Template"));
        }

        field(76006; "CB Whse. Inv. Jnl Template"; Code[10])
        {
            Caption = 'Modèle feuille inventaire entrepôt';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Journal Template".Name where(Type = const("Physical Inventory"));
        }

        field(76007; "CB Whse. Inv. Jnl Batch"; Code[10])
        {
            Caption = 'Feuille inventaire entrepôt';
            DataClassification = ToBeClassified;
            TableRelation = "Warehouse Journal Batch".Name where("Journal Template Name" = field("CB Whse. Inv. Jnl Template"));
        }

        field(76008; "CB Comptage"; Integer)
        {
            Caption = 'Comptage affecté';
            DataClassification = ToBeClassified;
            InitValue = 1;
            MinValue = 1;
            MaxValue = 3;
        }

        field(76009; "CB Inv. Journal Type"; Enum "CB Inv. Journal Type")
        {
            Caption = 'Type feuille inventaire';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; User, "CB Inv. Journal Template", "CB Inv. Journal Batch", "CB Whse. Inv. Jnl Template", "CB Whse. Inv. Jnl Batch", "CB Comptage", "CB Inv. Journal Type")
        {
            Clustered = true;
        }

    }
}
