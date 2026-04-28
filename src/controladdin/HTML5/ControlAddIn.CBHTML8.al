controladdin "CB HTML8"
{
    StartupScript = 'JS/startup.js';
    Scripts = 'JS/sript_colis.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 980;

    event ControlReady();


    event info(info: JsonObject);

    event CheckUser(user: JsonObject);
    event CheckCAB(cab: JsonObject);


    procedure Render(HTML: Text);
    procedure WhenLoaded();
    procedure afficheMessage(msg: text; color: text);
    procedure Ventefocus();

    procedure rempliremp(emp: code[20]; quantity: Text);

    procedure remplirdescription(description: Text);

}