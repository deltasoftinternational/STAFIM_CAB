pageextension 76001 "CB Whse. Pick Subform" extends "Whse. Pick Subform" //5767
{
    layout
    {

        addafter("Qty. Outstanding")
        {

            field("CB Colis"; Rec."CB Nbre Colis")
            {
                Caption = 'Colis';
                ApplicationArea = Warehouse;
            }
            field("CB Picking validated"; Rec."CB Picking validated")
            {
                Caption = 'Picking validated';
                ApplicationArea = Warehouse;
                Editable = false;
            }


        }

    }
}