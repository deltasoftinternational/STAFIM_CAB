pageextension 76010 "CB Whse. Put-away Subform" extends "Whse. Put-away Subform" //75008
{
    layout
    {

        addafter("Quantity")
        {


            field("CB Scanned Quantity"; Rec."CB Scanned Quantity")
            {
                Caption = 'Quantité scan';
                ApplicationArea = all;
            }


        }


    }
}