controladdin "CB HTML7"
{
    StartupScript = 'JS/startup.js';
    Scripts = 'JS/script_bin.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 980;

    event ControlReady();




    event CheckUser(user: JsonObject);
    event CheckCAB(cab: JsonObject);

    procedure Render(HTML: Text);
    procedure WhenLoaded();

    procedure rempliremp(emp: code[20]; quantity: Text);

    procedure remplirdescription(description: Text);

}