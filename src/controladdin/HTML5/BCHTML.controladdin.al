controladdin "BC HTML"
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
    //<<DELTA OB
    //defining the js function WhenLoaded as procedure so it can be called in the page code
    procedure WhenLoaded();
    //>>DELTA OB
    procedure Render(HTML: Text);
    procedure nonscanned(Amount: Text);

    procedure cabVerif(CodeBin: code[20]);
    //<<DELTA OB
    //Added qtes(quantité dans le magasin actuel) and qtei(quantité du stock total )
    procedure autoComplete(itemNo: code[20]; desc: Text; emps: Text; unite: text; qte: Decimal; qtes: Decimal; qti: Decimal; bb: Text);
    //>>DELTA OB

    procedure UpdateQty(itemNo: code[20]; desc: Text; unite: text; qte: Decimal; qtes: Decimal; qti: Decimal; bb: Text);


}