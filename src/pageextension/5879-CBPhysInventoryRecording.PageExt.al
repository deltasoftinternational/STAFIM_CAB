pageextension 76003 "CB Phys. Inventory Recording" extends "Phys. Inventory Recording" //5879
{
    actions
    {
        addafter(Print)
        {


            Action(user)
            {
                Caption = 'Affectation utilisateurs';
                RunObject = page "CB User List";
                ApplicationArea = all;
                RunPageLink = "Enregistrement" = Field("order No."), No = Field("Recording No.");


            }
        }
    }
}