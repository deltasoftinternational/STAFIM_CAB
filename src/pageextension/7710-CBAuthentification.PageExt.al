pageextension 76000 "CB Authentification" extends "ADCS Users" //7710
{
    layout
    {
        modify(Password)
        {
            Visible = false;
        }
        addafter(Name)
        {


            field("CB BC Password"; Rec."CB Password")
            {
                Caption = 'Mot de passe';
                ExtendedDatatype = Masked;
                ApplicationArea = all;
            }

        }

    }
}