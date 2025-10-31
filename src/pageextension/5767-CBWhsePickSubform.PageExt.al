pageextension 76001 "CB Whse. Pick Subform" extends "Whse. Pick Subform" //5767
{
    layout
    {

        addafter("Qty. Outstanding")
        {

            field("CB Colis"; Rec."CB Nbre Colis")
            {
                Caption = 'Colis';
                ApplicationArea = all;
            }
            field("CB Picking validated"; Rec."Picking validated")
            {
                Caption = 'Picking validated';
                ApplicationArea = all;
            }


        }

    }
}