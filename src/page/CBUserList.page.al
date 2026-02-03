page 76008 "CB User List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CB USER";
    caption = 'Affectation des utilisateurs';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Nom utilisateur"; rec.User)
                {
                    ApplicationArea = All;

                }

                field("Document No"; rec.Enregistrement)
                {
                    Caption = 'Cmd. Inventaire';
                    ApplicationArea = All;
                }
                field(Enregistrement; rec.no)
                {
                    Caption = 'Enregistrement No.';
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }


}