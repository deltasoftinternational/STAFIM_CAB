pageextension 76002 "CB stf Whse. Pick Subform" extends "STF Whse. Pick Subform" //75008
{
    layout
    {

        addafter("Whse. Document No.")
        {

            field("CB Colis"; Rec."CB Nbre Colis picking")
            {
                Caption = 'Colis';
                ApplicationArea = all;
            }
            field("CB Picking validated"; Rec."cb Picking validated")
            {
                Caption = 'Picking validated';
                ApplicationArea = all;
            }


        }
        addafter("Location Code")
        {
            field("CB Bin Code"; Rec."Bin Code")
            {
                Caption = 'Emplacement';
                ApplicationArea = all;
            }
        }

    }
}