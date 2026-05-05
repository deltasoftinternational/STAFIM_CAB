codeunit 76001 "CB Event subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", OnBeforeUpdateWarehouseActivityLineQtyToHandle, '', false, false)]
    local procedure "Whse.-Activity-Register_OnBeforeUpdateWarehouseActivityLineQtyToHandle"(var WarehouseActivityLine: Record "Warehouse Activity Line"; var QtyDiff: Decimal; var QtyBaseDiff: Decimal; HideDialog: Boolean; var IsHandled: Boolean)
    begin
        if WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::"Put-away" then
            WarehouseActivityLine."CB Scanned Quantity" := 0;
    end;

}