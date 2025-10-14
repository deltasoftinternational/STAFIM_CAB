pageextension 76001 "CB Whse. Pick Subform" extends "Whse. Pick Subform" //5767
{
    layout
    {

        addafter("Qty. Outstanding")
        {

            field("CB Picked Quantity"; Rec."CB Picked Quantity")
            {
                Caption = 'Quantité prélevée';
                ApplicationArea = all;
            }
            field("CB Controlled Quantity"; Rec."CB Controlled Quantity")
            {
                Caption = 'Quantité Controllée';
                ApplicationArea = all;
            }
            field("CB Colis"; Rec."CB Nbre Colis")
            {
                Caption = 'Colis';
                ApplicationArea = all;
            }

        }

    }
}