controladdin "CB HTML"
{
    StartupScript = 'JS/startup.js';
    Scripts = 'JS/scripts.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 700;
    event ControlReady();
    event info(scan: JsonObject);
    event scan(info: JsonObject);
    event CheckUser(user: JsonObject);
    event item(item: JsonObject);
    event finish(finish: JsonObject);
    event UpdateBinQty(binQty: JsonObject);
    event finish2(finish: JsonObject);
    event comptage(compt: JsonObject);
    event CheckCAB(cab: JsonObject);
    event remplirqte2(cab: JsonObject);
    procedure WhenLoaded();
    procedure focusqte();
    procedure focusemp();
    procedure Render(HTML: Text);
    procedure nonscanned(Amount: Text);
    procedure cabVerif(CodeBin: code[20]);
    procedure autoComplete(itemNo: code[20]; desc: Text; emps: Text; unite: text; qte: Decimal; qtes: Decimal; qti: Decimal; bb: Text);
    procedure UpdateQty(itemNo: code[20]; desc: Text; unite: text; qte: Decimal; qtes: Decimal; qti: Decimal; bb: Text);
}