controladdin "CB HTML6"
{
    StartupScript = 'JS/startup.js';
    Scripts = 'JS/script_recep.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 980;

    event ControlReady();
    event info(info: JsonObject);
    event terminer(info: JsonObject);

    event back_to_login(emplc: JsonObject);
    event getsource(emplc: JsonObject);


    procedure receptionfocus();
    event validate(item: JsonObject);

    event CheckUser(user: JsonObject);
    event item(item: JsonObject);
    event finish(finish: JsonObject);
    event finish2(finish: JsonObject);
    event fermerModal(finish: JsonObject);
    event CheckCAB(cab: JsonObject);
    event remplirqte2(cab: JsonObject);

    procedure Render(HTML: Text);
    procedure WhenLoaded();
    procedure remplirqtestock(stock: text);

    procedure rempliremp(value: text);
    procedure remplirqte(value: text);

    procedure cabnonvalide();
    procedure ViderCAB();
    procedure reset();
    procedure Viderqte();

    procedure autoComplete(barcodeNo: code[20]; articleNo: code[20]; desc: Text; qtea: Decimal; bb: Text; quantitya: decimal);

}