pageextension 76012 "CB Phys. Inventory Journal" extends "Phys. Inventory Journal" //390
{
    layout
    {
        addafter("Qty. (Phys. Inventory)")
        {
            field("CB Comptage 1"; Rec."CB Comptage 1")
            {
                ApplicationArea = All;
                Caption = 'Comptage 1';
            }
            field("CB Comptage 2"; Rec."CB Comptage 2")
            {
                ApplicationArea = All;
                Caption = 'Comptage 2';
            }
            field("CB Comptage 3"; Rec."CB Comptage 3")
            {
                ApplicationArea = All;
                Caption = 'Comptage 3';
            }
            field("CB Comptage Actif"; Rec."CB Comptage Actif")
            {
                ApplicationArea = All;
                Caption = 'Comptage actif';
            }
            field("CB Ecart Valeur"; Rec."CB Ecart Valeur")
            {
                ApplicationArea = All;
                Caption = 'Écart en valeur';
            }
            field("CB Motif Ecart"; Rec."CB Motif Ecart")
            {
                ApplicationArea = All;
                Caption = 'Motif d''écart';
            }
            field("CB Inventaire Validé"; Rec."CB Inventaire Validé")
            {
                ApplicationArea = All;
                Caption = 'Validé';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            group("CB Comptage")
            {
                Caption = 'Comptage inventaire';

                action("CB Préparer Comptage 2")
                {
                    ApplicationArea = All;
                    Caption = 'Préparer Comptage 2';
                    Image = CalculateInventory;

                    trigger OnAction()
                    var
                        InvMgt: Codeunit "CB Inventory Mgt";
                        LinesCount: Integer;
                    begin
                        LinesCount := InvMgt.PrepareComptage2Item(
                            Rec."Journal Template Name",
                            Rec."Journal Batch Name",
                            Rec."Location Code");
                        Message('%1 ligne(s) nécessitent un comptage 2.', LinesCount);
                        CurrPage.Update(false);
                    end;
                }
                action("CB Préparer Comptage 3")
                {
                    ApplicationArea = All;
                    Caption = 'Préparer Comptage 3';
                    ToolTip = 'Identifie les lignes où Comptage 2 <> Comptage 1. Le comptage 3 peut être exclu si l''écart en valeur est inférieur au seuil.';
                    Image = CalculateInventory;

                    trigger OnAction()
                    var
                        InvMgt: Codeunit "CB Inventory Mgt";
                        LinesCount: Integer;
                    begin
                        LinesCount := InvMgt.PrepareComptage3Item(
                            Rec."Journal Template Name",
                            Rec."Journal Batch Name",
                            Rec."Location Code");
                        if LinesCount = 0 then
                            Message('Aucune ligne ne nécessite un comptage 3 (tous les écarts sont en dessous du seuil ou inexistants).')
                        else
                            Message('%1 ligne(s) nécessitent un comptage 3.', LinesCount);
                        CurrPage.Update(false);
                    end;
                }
                action("CB Valider Inventaire")
                {
                    ApplicationArea = All;
                    Caption = 'Valider l''inventaire';
                    ToolTip = 'Finalise l''inventaire en appliquant la quantité du dernier comptage. Vérifie que le motif d''écart est renseigné si obligatoire.';
                    Image = Approve;

                    trigger OnAction()
                    var
                        InvMgt: Codeunit "CB Inventory Mgt";
                    begin
                        if not Confirm('Voulez-vous valider l''inventaire ? Cette action est irréversible.') then
                            exit;
                        InvMgt.FinalizeItemInventory(
                            Rec."Journal Template Name",
                            Rec."Journal Batch Name",
                            Rec."Location Code");
                        Message('Inventaire validé avec succès.');
                        CurrPage.Update(false);
                    end;
                }


            }
        }
    }
}
