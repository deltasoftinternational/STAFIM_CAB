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
            group(Reception)
            {
                Caption = 'Réception';
                Image = Calculator;

                action(Connect8)
                {
                    Caption = 'Réception';
                    RunObject = Page "CB Reception";
                    ApplicationArea = All;
                    Image = Calculator;
                }

            }
            group(Colis)
            {
                Caption = 'Pointage colis';
                Image = Calculator;

                action(Connect11)
                {
                    Caption = 'Pointage colis';
                    RunObject = Page "CB scan colis";
                    ApplicationArea = All;
                    Image = Calculator;
                }

            }
            group(Item)
            {
                Caption = 'Article';
                Image = Bin;

                action(Connect9)
                {
                    Caption = 'Vérifier emplacement';
                    RunObject = Page "CB Bin";
                    ApplicationArea = All;
                    Image = Calculator;
                }

            }
            /*group(Inventaire)
            {
                Caption = 'Inventaire';
                Image = Calculator;

                action(Connect9)
                {
                    Caption = 'Inventaire';
                    RunObject = Page "CB Inventaire";
                    ApplicationArea = All;
                    Image = Calculator;
                }

            }*/
            group(Reclassement)
            {
                Caption = 'Reclassement';
                Image = Calculator;

                action(Connect10)
                {
                    Caption = 'Reclassement';
                    RunObject = Page "CB Reclassement";
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
