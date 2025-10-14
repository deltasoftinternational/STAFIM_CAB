page 76003 "CB Role Center"
{
    PageType = RoleCenter;
    Caption = 'CAB';
    layout
    {
        area(RoleCenter)
        {

            group(cmdVente)
            {

            }
        }
    }


    actions
    {
        area(Processing)
        {
            group(Vente)
            {
                Caption = 'Vente';
                Image = Calculator;

                action(Connect7)
                {
                    Caption = 'Vente';
                    RunObject = Page "CB Vente";
                    ApplicationArea = All;
                    Image = Calculator;
                }

            }



        }


    }

}



profile Barcode
{
    Description = 'Barcode';
    RoleCenter = "CB Role Center";
}
