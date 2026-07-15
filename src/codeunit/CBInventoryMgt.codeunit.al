codeunit 76002 "CB Inventory Mgt"
{

    procedure IsDirectedPutAwayAndPick(LocationCode: Code[10]): Boolean
    var
        Location: Record Location;
    begin
        if LocationCode = '' then
            exit(false);
        if not Location.Get(LocationCode) then
            exit(false);
        exit(Location."Directed Put-away and Pick");
    end;

    procedure GetWhsePhysInvTemplateName(): Code[10]
    var
        WhseJnlTemplate: Record "Warehouse Journal Template";
    begin
        WhseJnlTemplate.Reset();
        WhseJnlTemplate.SetRange(Type, WhseJnlTemplate.Type::"Physical Inventory");
        if WhseJnlTemplate.FindFirst() then
            exit(WhseJnlTemplate.Name);
        Error('Aucun modèle de feuille entrepôt de type Inventaire physique trouvé.');
    end;

    procedure GetItemPhysInvTemplateName(): Code[10]
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        ItemJnlTemplate.Reset();
        ItemJnlTemplate.SetRange(Type, ItemJnlTemplate.Type::"Phys. Inventory");
        if ItemJnlTemplate.FindFirst() then
            exit(ItemJnlTemplate.Name);
        Error('Aucun modèle de feuille article de type Inventaire physique trouvé.');
    end;

    procedure GetWhseReclassTemplateName(): Code[10]
    var
        WhseJnlTemplate: Record "Warehouse Journal Template";
    begin
        WhseJnlTemplate.Reset();
        WhseJnlTemplate.SetRange(Type, WhseJnlTemplate.Type::Reclassification);
        if WhseJnlTemplate.FindFirst() then
            exit(WhseJnlTemplate.Name);
        Error('Aucun modèle de feuille entrepôt de type Reclassement trouvé.');
    end;

    procedure GetItemReclassTemplateName(): Code[10]
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        ItemJnlTemplate.Reset();
        ItemJnlTemplate.SetRange(Type, ItemJnlTemplate.Type::Transfer);
        if ItemJnlTemplate.FindFirst() then
            exit(ItemJnlTemplate.Name);
        Error('Aucun modèle de feuille article de type Transfert/Reclassement trouvé.');
    end;

    procedure CheckAlreadyCountedWhse(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10]; ItemNo: Code[20]; BinCode: Code[20]; ComptageNo: Integer)
    var
        WhseJnlLine: Record "Warehouse Journal Line";
    begin
        WhseJnlLine.Reset();
        WhseJnlLine.SetRange("Journal Template Name", TemplateName);
        WhseJnlLine.SetRange("Journal Batch Name", BatchName);
        WhseJnlLine.SetRange("Location Code", LocationCode);
        WhseJnlLine.SetRange("Item No.", ItemNo);
        if BinCode <> '' then
            WhseJnlLine.SetRange("Bin Code", BinCode);
        if WhseJnlLine.FindFirst() then begin
            if WhseJnlLine."CB Inventaire Validé" then
                Error('Déjà compté');

        end;
    end;

    procedure CheckAlreadyCountedItem(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10]; ItemNo: Code[20]; BinCode: Code[20]; ComptageNo: Integer)
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", BatchName);
        ItemJnlLine.SetRange("Location Code", LocationCode);
        ItemJnlLine.SetRange("Item No.", ItemNo);
        if BinCode <> '' then
            ItemJnlLine.SetRange("Bin Code", BinCode);
        if ItemJnlLine.FindFirst() then begin
            if ItemJnlLine."CB Inventaire Validé" then
                Error('Déjà compté');

        end;
    end;


    procedure SetComptageWhse(var WhseJnlLine: Record "Warehouse Journal Line"; ComptageNo: Integer; Quantity: Decimal)
    begin
        case ComptageNo of
            1:
                begin
                    WhseJnlLine."CB Comptage 1" := Quantity;
                    WhseJnlLine."CB Comptage Actif" := 1;
                end;
            2:
                begin
                    WhseJnlLine."CB Comptage 2" := Quantity;
                    WhseJnlLine."CB Comptage Actif" := 2;
                end;
            3:
                begin
                    WhseJnlLine."CB Comptage 3" := Quantity;
                    WhseJnlLine."CB Comptage Actif" := 3;
                end;
        end;
    end;

    procedure SetComptageItem(var ItemJnlLine: Record "Item Journal Line"; ComptageNo: Integer; Quantity: Decimal)
    begin
        case ComptageNo of
            1:
                begin
                    ItemJnlLine."CB Comptage 1" := Quantity;
                    ItemJnlLine."CB Comptage Actif" := 1;
                end;
            2:
                begin
                    ItemJnlLine."CB Comptage 2" := Quantity;
                    ItemJnlLine."CB Comptage Actif" := 2;
                end;
            3:
                begin
                    ItemJnlLine."CB Comptage 3" := Quantity;
                    ItemJnlLine."CB Comptage Actif" := 3;
                end;
        end;
    end;


    procedure PrepareComptage2Whse(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10]): Integer
    var
        WhseJnlLine: Record "Warehouse Journal Line";
        Count: Integer;
    begin
        Count := 0;
        WhseJnlLine.Reset();
        WhseJnlLine.SetRange("Journal Template Name", TemplateName);
        WhseJnlLine.SetRange("Journal Batch Name", BatchName);
        if LocationCode <> '' then
            WhseJnlLine.SetRange("Location Code", LocationCode);
        if WhseJnlLine.FindSet() then
            repeat
                if WhseJnlLine."CB Comptage 1" <> WhseJnlLine."Qty. (Calculated)" then begin
                    WhseJnlLine."CB Comptage Actif" := 2;
                    WhseJnlLine.Modify();
                    Count += 1;
                end;
            until WhseJnlLine.Next() = 0;
        exit(Count);
    end;

    procedure PrepareComptage2Item(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10]): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        Count: Integer;
    begin
        Count := 0;
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", BatchName);
        if LocationCode <> '' then
            ItemJnlLine.SetRange("Location Code", LocationCode);
        if ItemJnlLine.FindSet() then
            repeat
                if ItemJnlLine."CB Comptage 1" <> ItemJnlLine."Qty. (Calculated)" then begin
                    ItemJnlLine."CB Comptage Actif" := 2;
                    ItemJnlLine.Modify();
                    Count += 1;
                end;
            until ItemJnlLine.Next() = 0;
        exit(Count);
    end;

    procedure PrepareComptage3Whse(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10]): Integer
    var
        WhseJnlLine: Record "Warehouse Journal Line";
        InvSetup: Record "CB Inventory Setup";
        Item: Record Item;
        EcartValeur: Decimal;
        Count: Integer;
    begin
        InvSetup.GetSetup();
        Count := 0;

        WhseJnlLine.Reset();
        WhseJnlLine.SetRange("Journal Template Name", TemplateName);
        WhseJnlLine.SetRange("Journal Batch Name", BatchName);
        if LocationCode <> '' then
            WhseJnlLine.SetRange("Location Code", LocationCode);
        WhseJnlLine.SetRange("CB Comptage Actif", 2);
        if WhseJnlLine.FindSet() then
            repeat
                if WhseJnlLine."CB Comptage 2" <> WhseJnlLine."CB Comptage 1" then begin
                    EcartValeur := 0;
                    if Item.Get(WhseJnlLine."Item No.") then
                        EcartValeur := Abs(WhseJnlLine."CB Comptage 2" - WhseJnlLine."CB Comptage 1") * Item."Unit Cost";
                    WhseJnlLine."CB Ecart Valeur" := EcartValeur;

                    if (InvSetup."CB Seuil Ecart Valeur" > 0) and (EcartValeur < InvSetup."CB Seuil Ecart Valeur") then begin
                        WhseJnlLine.Validate("Qty. (Phys. Inventory)", WhseJnlLine."CB Comptage 2");
                        WhseJnlLine.Modify();
                    end else begin
                        WhseJnlLine."CB Comptage Actif" := 3;
                        WhseJnlLine.Modify();
                        Count += 1;
                    end;
                end else begin
                    WhseJnlLine."CB Ecart Valeur" := 0;
                    WhseJnlLine.Validate("Qty. (Phys. Inventory)", WhseJnlLine."CB Comptage 2");
                    WhseJnlLine.Modify();
                end;
            until WhseJnlLine.Next() = 0;
        exit(Count);
    end;

    procedure PrepareComptage3Item(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10]): Integer
    var
        ItemJnlLine: Record "Item Journal Line";
        InvSetup: Record "CB Inventory Setup";
        Item: Record Item;
        EcartValeur: Decimal;
        Count: Integer;
    begin
        InvSetup.GetSetup();
        Count := 0;

        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", BatchName);
        if LocationCode <> '' then
            ItemJnlLine.SetRange("Location Code", LocationCode);
        ItemJnlLine.SetRange("CB Comptage Actif", 2);
        if ItemJnlLine.FindSet() then
            repeat
                if ItemJnlLine."CB Comptage 2" <> ItemJnlLine."CB Comptage 1" then begin
                    EcartValeur := 0;
                    if Item.Get(ItemJnlLine."Item No.") then
                        EcartValeur := Abs(ItemJnlLine."CB Comptage 2" - ItemJnlLine."CB Comptage 1") * Item."Unit Cost";
                    ItemJnlLine."CB Ecart Valeur" := EcartValeur;

                    if (InvSetup."CB Seuil Ecart Valeur" > 0) and (EcartValeur < InvSetup."CB Seuil Ecart Valeur") then begin
                        ItemJnlLine.Validate("Qty. (Phys. Inventory)", ItemJnlLine."CB Comptage 2");
                        ItemJnlLine.Modify();
                    end else begin
                        ItemJnlLine."CB Comptage Actif" := 3;
                        ItemJnlLine.Modify();
                        Count += 1;
                    end;
                end else begin
                    ItemJnlLine."CB Ecart Valeur" := 0;
                    ItemJnlLine.Validate("Qty. (Phys. Inventory)", ItemJnlLine."CB Comptage 2");
                    ItemJnlLine.Modify();
                end;
            until ItemJnlLine.Next() = 0;
        exit(Count);
    end;

    procedure FinalizeWhseInventory(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10])
    var
        WhseJnlLine: Record "Warehouse Journal Line";
        Location: Record Location;
        InvSetup: Record "CB Inventory Setup";
        FinalQty: Decimal;
    begin
        InvSetup.GetSetup();

        WhseJnlLine.Reset();
        WhseJnlLine.SetRange("Journal Template Name", TemplateName);
        WhseJnlLine.SetRange("Journal Batch Name", BatchName);
        if LocationCode <> '' then
            WhseJnlLine.SetRange("Location Code", LocationCode);
        WhseJnlLine.SetRange("CB Inventaire Validé", false);
        if WhseJnlLine.FindSet() then
            repeat
                case WhseJnlLine."CB Comptage Actif" of
                    1:
                        FinalQty := WhseJnlLine."CB Comptage 1";
                    2:
                        FinalQty := WhseJnlLine."CB Comptage 2";
                    3:
                        FinalQty := WhseJnlLine."CB Comptage 3";
                    else
                        FinalQty := WhseJnlLine."CB Comptage 1";
                end;

                if FinalQty <> WhseJnlLine."Qty. (Calculated)" then
                    if InvSetup."CB Motif Ecart Obligatoire" then
                        if WhseJnlLine."CB Motif Ecart" = '' then
                            Error('Motif d''écart obligatoire pour l''article %1, emplacement %2.',
                                WhseJnlLine."Item No.", WhseJnlLine."Bin Code");

                if (WhseJnlLine."To Bin Code" = '') and (WhseJnlLine."Bin Code" <> '') then
                    WhseJnlLine.Validate("To Bin Code", WhseJnlLine."Bin Code");
                if WhseJnlLine."From Bin Code" = '' then begin
                    Location.Get(WhseJnlLine."Location Code");
                    WhseJnlLine."From Bin Code" := Location."Adjustment Bin Code";
                end;
                WhseJnlLine.Validate("Qty. (Phys. Inventory)", FinalQty);
                WhseJnlLine."CB Inventaire Validé" := true;
                WhseJnlLine.Modify(true);
            until WhseJnlLine.Next() = 0;
    end;

    procedure FinalizeItemInventory(TemplateName: Code[10]; BatchName: Code[10]; LocationCode: Code[10])
    var
        ItemJnlLine: Record "Item Journal Line";
        InvSetup: Record "CB Inventory Setup";
        FinalQty: Decimal;
    begin
        InvSetup.GetSetup();

        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", BatchName);
        if LocationCode <> '' then
            ItemJnlLine.SetRange("Location Code", LocationCode);
        ItemJnlLine.SetRange("CB Inventaire Validé", false);
        if ItemJnlLine.FindSet() then
            repeat
                case ItemJnlLine."CB Comptage Actif" of
                    1:
                        FinalQty := ItemJnlLine."CB Comptage 1";
                    2:
                        FinalQty := ItemJnlLine."CB Comptage 2";
                    3:
                        FinalQty := ItemJnlLine."CB Comptage 3";
                    else
                        FinalQty := ItemJnlLine."CB Comptage 1";
                end;

                if FinalQty <> ItemJnlLine."Qty. (Calculated)" then
                    if InvSetup."CB Motif Ecart Obligatoire" then
                        if ItemJnlLine."CB Motif Ecart" = '' then
                            Error('Motif d''écart obligatoire pour l''article %1, magasin %2.',
                                ItemJnlLine."Item No.", ItemJnlLine."Location Code");

                ItemJnlLine.Validate("Qty. (Phys. Inventory)", FinalQty);
                ItemJnlLine."CB Inventaire Validé" := true;
                ItemJnlLine.Modify(true);
            until ItemJnlLine.Next() = 0;
    end;
}
