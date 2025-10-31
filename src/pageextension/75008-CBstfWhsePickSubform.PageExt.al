pageextension 76002 "CB stf Whse. Pick Subform" extends "STF Whse. Pick Subform" //75008
{
    layout
    {

        addafter("Whse. Document No.")
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