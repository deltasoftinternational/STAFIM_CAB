page 76011 "CB bin"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    caption = 'Scan article';

    layout
    {
        area(Content)
        {

            usercontrol(html; "CB HTML7")
            {
                ApplicationArea = all;
                trigger ControlReady()
                begin
                    CurrPage.html.Render(Login());
                end;

                trigger CheckUser(user: JsonObject)
                var
                    userToken: JsonToken;
                    passToken: JsonToken;
                    roletoken: JsonToken;
                    uspass: Text;
                    ADCS_USER: Record "ADCS User";
                begin
                    user.SelectToken('us', userToken);
                    user.SelectToken('ps', passToken);
                    user.SelectToken('role', roletoken);
                    userToken.WriteTo(usname);
                    passToken.WriteTo(uspass);
                    roletoken.WriteTo(role);
                    role := role.Replace('"', '');
                    if role = ' ' then
                        error('veuillez choisir un role');
                    usname := usname.Replace('"', '');
                    uspass := uspass.Replace('"', '');
                    if ADCS_USER.Get(usname) then begin
                        magsave := ADCS_USER."STF Location";
                        CurrPage.html.Render(AddItem(''));
                        CurrPage.html.WhenLoaded();

                    end
                    else
                        Error('saisie votre mot de passe ou votre utilisateur');
                end;


                trigger CheckCAB(cab: JsonObject)
                var
                    cab_token: JsonToken;
                    Bin_Content: Record "Bin Content";
                    item: record item;
                begin


                    cab.SelectToken('cab', cab_token);
                    cab_token.WriteTo(cab_value);
                    cab_value := cab_value.Replace('"', '').Replace('\r', '');
                    item.get(cab_value);
                    CurrPage.html.remplirdescription(item."Description");

                    Bin_Content.reset();
                    Bin_Content.setrange("Location Code", magsave);
                    Bin_Content.setrange("Item No.", cab_value);
                    //Bin_Content.setrange("Fixed", true);
                    Bin_Content.setfilter("Quantity (Base)", '>%1', 0);
                    if Bin_Content.findset() then
                        repeat
                            Bin_Content.calcfields("Quantity (Base)");
                            CurrPage.html.rempliremp(Bin_Content."Bin Code", Format(Bin_Content."Quantity (Base)"));
                        until Bin_Content.next() = 0
                    else
                        error('Stock non disponible dans %1', magsave);

                end;




            }

        }
    }

    actions
    {

    }
    procedure Login(): Text
    var
        ADCS_User: Record "ADCS User";
        out: TextBuilder;
    begin
        ADCS_User.RESET();
        out.APPEND('<!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style> body { font-family: Arial, Helvetica, sans-serif;  margin: 0; padding: 0; } .container {  margin: 0 auto; padding: 20px; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h1 { text-align: center; margin-bottom: 30px; color: #333; } label { display: block; margin-bottom: 8px; color: #333; } input[type="password"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }  input[type="text"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; } .qte-container { display: grid; } button { background-color: #04AA6D; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer; width: 50%; font-size: 16px; transition: background-color 0.3s; } button:hover { background-color: #048f5d; } #resetBtn { background-color: cadetblue; float: left; } #nextBtn { float: right; } #finishBtn { float: right; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } .loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute; z-index: 10; top: 20%; left: 40%; text-align: center; font-size: 10px; } @-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } }  </style> </head> ');
        out.APPEND('<body> <h2 style="margin: 0 auto;text-align: center">Accès à la préparation du reception</h2> <div class="container"> <label for="uname"><b>Utilisateur</b></label>');
        out.APPEND('<select id="user" name="uname">');
        out.APPEND('<option value=""></option>');

        IF ADCS_User.FINDSET() THEN
            REPEAT
                out.APPEND('<option value=' + ADCS_User.Name + '>' + ADCS_User.Name + '</option>');
            UNTIL ADCS_User.NEXT() = 0;


        out.APPEND('<label for="psw"><b>Mot de passe</b></label> ');
        out.APPEND('<input  id="passInput" type="password" placeholder="Enter Mot de passe" name="psw" required onKeyDown="if(event.keyCode==13) login();"> ');
        out.APPEND('<div style="text-align:center;"> <button onclick="PICK()" style="margin-right:4%;background-color: cadetblue;width: 80%;">Scanner article</button>  </div>');

        EXIT(Format(out));
    END;








    procedure AddItem(cmdv: Text): Text
    var
        out: TextBuilder;
    begin
        out.APPEND('<!DOCTYPE html>');
        out.APPEND('<html>');
        out.APPEND('<head>');
        out.APPEND('<meta name="viewport" content="width=device-width, initial-scale=1">');

        out.APPEND('<style>');
        out.APPEND('body{font-family:Arial,sans-serif;background:#f4f6f9;display:flex;justify-content:center;align-items:flex-start;padding-top:40px;margin:0}');
        out.APPEND('.card{background:white;padding:20px;border-radius:10px;box-shadow:0 4px 12px rgba(0,0,0,0.15)}');
        out.APPEND('h2,h3{text-align:center;margin:0 0 15px 0;color:red}');
        out.APPEND('label{font-weight:bold;display:block;margin-top:15px}');
        out.APPEND('input{box-sizing: border-box;width:100%;padding:10px;margin-top:5px;border-radius:6px;border:1px solid #ccc;font-size:14px}');
        out.APPEND('input:focus{outline:none;border-color:#04AA6D}');
        out.APPEND('button{width:100%;margin-top:20px;padding:12px;background:#04AA6D;color:white;border:none;border-radius:6px;font-size:16px;cursor:pointer}');
        out.APPEND('button:hover{background:#038e5a}');
        out.APPEND('table{width:100%;border-collapse:collapse;margin-top:20px}');
        out.APPEND('th,td{padding:10px;text-align:left}');
        out.APPEND('th{background-color:#04AA6D;color:white;position:sticky;top:0}');
        out.APPEND('</style>');

        out.APPEND('</head>');
        out.APPEND('<body>');

        // 
        out.APPEND('<center><h2>Interfaçe de scan</h2></center>');
        out.APPEND('<center><h3>Magasin: ' + magsave + '</h3></center>');

        out.APPEND('<div class="card">');

        out.APPEND('<label>Article</label>');
        out.APPEND('<input type="text" id="article" placeholder="Scanner ou saisir article">');
        out.APPEND('<label>Description</label>');
        out.APPEND('<input type="text" id="desc" disabled>');

        out.APPEND('<div id="tableContainer" ' +
'style="box-sizing: border-box;width:100%; max-height:250px; overflow-y:auto; border:1px solid #ccc; ' +
'border-radius:6px; box-sizing:border-box; background-color:#fff; ' +
'font-family:Arial; font-size:16px; margin-bottom:15px;margin-top:20px">');

        out.APPEND('<table id="tableEmp" style="box-sizing: border-box;width:100%; border-collapse:collapse;margin-top:0px">');
        out.APPEND('<tr style="background-color:#04AA6D; color:white; position:sticky; top:0;"><th style="text-align:left; padding:10px;">Emplacement</th><th style="text-align:left; padding:10px;">Quantité</th></tr>');
        out.APPEND('</table>');
        out.APPEND('</div>');


        out.APPEND('</div>');
        out.APPEND('</body>');
        out.APPEND('</html>');

        exit(format(out));
    end;

    var
        increment, usname, cmdSave, magsave, role, colisno, typesave : Text;
        item_no_text: Text;
        item_description: Text;
        box_flag_value: Text;
        cab_value: Text;
        typesaveall: text;
        validated, finished : boolean;
        typesavepick: text;

        old_quantity, QuantityItem, quantitya : decimal;
        emplacement, Picked_barcode : text;
        cab_exists_flag: Integer;




}
