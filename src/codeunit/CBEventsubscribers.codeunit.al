codeunit 76001 "CB Event Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", OnBeforeUpdateWarehouseActivityLineQtyToHandle, '', false, false)]
    local procedure "Whse.-Activity-Register_OnBeforeUpdateWarehouseActivityLineQtyToHandle"(var WarehouseActivityLine: Record "Warehouse Activity Line"; var QtyDiff: Decimal; var QtyBaseDiff: Decimal; HideDialog: Boolean; var IsHandled: Boolean)
    begin
        if WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::"Put-away" then
            WarehouseActivityLine."CB Scanned Quantity" := 0;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Whse. Calculate Inventory", OnBeforeWhseJnlLineInsert, '', false, false)]
    local procedure "inv_OnBeforeWhseJnlLineInsert"(var WarehouseJournalLine: Record "Warehouse Journal Line"; var WarehouseEntry: Record "Warehouse Entry"; var NextLineNo: Integer)
    begin
        WarehouseJournalLine.Validate("Qty. (Phys. Inventory)", 0);
    end;


}