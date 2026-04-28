page 76013 "CB scan colis"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    caption = 'Pointage colis';

    layout
    {
        area(Content)
        {

            usercontrol(html; "CB HTML8")
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
                        // CurrPage.html.Render(AddItem(''));
                        // CurrPage.html.WhenLoaded();
                        CurrPage.html.Render(Login2(usname));
                        CurrPage.html.Ventefocus();

                    end
                    else
                        Error('saisie votre mot de passe ou votre utilisateur');
                end;

                trigger info(info: JsonObject)
                var
                    cmdv: Text;
                    cmdvToken: JsonToken;
                    STF_Colis_Summary: Record "STF Colis Summary";
                begin
                    colisno := '';
                    info.SelectToken('cmdv', cmdvToken);
                    cmdvToken.WriteTo(cmdv);
                    cmdv := cmdv.Replace('"', '');
                    cmdSave := cmdv;
                    if cmdSave = '' then error('Veuillez choisir la facture fournisseur');
                    STF_Colis_Summary.Reset();
                    STF_Colis_Summary.SetRange("Vendor Invoice No.", cmdSave);
                    STF_Colis_Summary.SetRange(Arrived, false);
                    if STF_Colis_Summary.FindSet() then begin


                        CurrPage.html.Render(AddItem(cmdsave));
                        CurrPage.html.WhenLoaded();
                    end
                    else
                        error('Facture fournisseur non existante ou pointée');

                end;


                trigger CheckCAB(cab: JsonObject)
                var
                    cab_token: JsonToken;
                    STF_Colis_Summary: Record "STF Colis Summary";
                    item: record item;
                begin


                    cab.SelectToken('cab', cab_token);
                    cab_token.WriteTo(cab_value);
                    cab_value := cab_value.Replace('"', '').Replace('\r', '');
                    // CurrPage.html.remplirdescription(item."Description");

                    STF_Colis_Summary.reset();
                    STF_Colis_Summary.setrange("Colis No.", cab_value);
                    STF_Colis_Summary.setrange("Vendor Invoice No.", cmdsave);
                    if STF_Colis_Summary.findset() then
                        repeat
                            if (STF_Colis_Summary.Arrived = true) and (STF_Colis_Summary."Pointing ADCS User" <> '') then
                                message('Colis déja pointée')
                            else begin


                                STF_Colis_Summary.Validate(Arrived, true);
                                STF_Colis_Summary.Validate("Pointing ADCS User", usname);
                                STF_Colis_Summary.Modify();
                            end;

                        until STF_Colis_Summary.next() = 0
                    else
                        error('colis non existant dans cette facture');
                    STF_Colis_Summary.reset();
                    STF_Colis_Summary.setrange("Vendor Invoice No.", cmdsave);
                    if STF_Colis_Summary.FindSet() then
                        repeat
                            CurrPage.html.rempliremp(STF_Colis_Summary."Colis No.", Format(STF_Colis_Summary.Arrived));
                        until STF_Colis_Summary.next() = 0;
                end;




            }

        }
    }

    actions
    {

    }
    procedure Login2(usname: Text): Text
    var
        ADCS_User: Record "ADCS User";
        Warehouse_Header: Record "Warehouse Activity Header";
        out: TextBuilder;
        STF_Colis_Summary: Record "STF Colis Summary";
        fournisseur: text;

    begin
        fournisseur := '';
        out.APPEND('<!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style> body { font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0; } .container { max-width: 800px; margin: 0 auto; padding: 20px; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h1 { text-align: center; margin-bottom: 30px; color: #333; } label { display: block; margin-bottom: 8px; color: #333; } input[type="text"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; } .qte-container { display: grid; } button { background-color: #04AA6D; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer; width: 40%; font-size: 16px; transition: background-color 0.3s; } button:hover { background-color: #048f5d; } #resetBtn { background-color: cadetblue; float: left; } #nextBtn { float: right; } #finishBtn { float: left; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } .loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute; z-index: 10; top: 20%; left: 40%; text-align: center; font-size: 10px; } @-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } } @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } } </style> </head> ');
        out.APPEND('<body> <h2>Numéro du Facture fournisseur</h2> ');
        out.APPEND('<div id="tableContainer" ' +
'style="width:100%; max-height:250px; overflow-y:auto; border:1px solid #ccc; ' +
'border-radius:6px; box-sizing:border-box; background-color:#fff; ' +
'font-family:Arial; font-size:16px; margin-bottom:15px;">');
        if role <> 'COL' then
            out.APPEND('<table style="width:100%; border-collapse:collapse;">' +
        '<thead>' +
        '<tr style="background-color:#04AA6D; color:white; position:sticky; top:0;">' +
        '<th style="text-align:left; padding:10px;">Facture fournisseur</th>' +
        '</tr></thead><tbody>');

        STF_Colis_Summary.Reset();
        STF_Colis_Summary.SetCurrentKey("Vendor Invoice No.");
        STF_Colis_Summary.SetAscending("Vendor Invoice No.", true);
        STF_Colis_Summary.SetRange(Arrived, false);

        if STF_Colis_Summary.findset() then
            REPEAT
                if STF_Colis_Summary."Vendor Invoice No." <> fournisseur then begin

                    fournisseur := STF_Colis_Summary."Vendor Invoice No.";
                    out.APPEND(
     '<tr onclick="selectRow(this, ''' + STF_Colis_Summary."Vendor Invoice No." + ''')" ' +
     'style="cursor:pointer; background-color:#fff; border-bottom:1px solid #ddd;">' +
     '<td style="padding:10px;">' + STF_Colis_Summary."Vendor Invoice No." + '</td></tr>'
    );
                end;

            UNTIL STF_Colis_Summary.NEXT() = 0;

        out.APPEND('</tbody></table></div>');
        if role <> 'COL' then
            out.APPEND('<input type="text" style="display:none;" id="cmdv" name="cmdv" required onKeyDown="if(event.keyCode==13) go();"> ')
        else
            out.APPEND('<input type="text" id="cmdv" name="cmdv" required onKeyDown="if(event.keyCode==13) go();"> ');

        out.APPEND('<div style="text-align:center"><button id="gu" name="gu" onKeyDown="if(event.keyCode==13) go();" onClick="go()" style="float: center;">Accès</button></div>');
        out.APPEND('</body> </html>');

        EXIT(Format(out));
    end;

    procedure Login(): Text
    var
        ADCS_User: Record "ADCS User";
        out: TextBuilder;
    begin
        ADCS_User.RESET();
        out.APPEND('<!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style> body { font-family: Arial, Helvetica, sans-serif;  margin: 0; padding: 0; } .container {  margin: 0 auto; padding: 20px; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h1 { text-align: center; margin-bottom: 30px; color: #333; } label { display: block; margin-bottom: 8px; color: #333; } input[type="password"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }  input[type="text"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; } .qte-container { display: grid; } button { background-color: #04AA6D; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer; width: 50%; font-size: 16px; transition: background-color 0.3s; } button:hover { background-color: #048f5d; } #resetBtn { background-color: cadetblue; float: left; } #nextBtn { float: right; } #finishBtn { float: right; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } .loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute; z-index: 10; top: 20%; left: 40%; text-align: center; font-size: 10px; } @-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } }  </style> </head> ');
        out.APPEND('<body> <h2 style="margin: 0 auto;text-align: center">Accès à la préparation du colis</h2> <div class="container"> <label for="uname"><b>Utilisateur</b></label>');
        out.APPEND('<select id="user" name="uname">');
        out.APPEND('<option value=""></option>');

        IF ADCS_User.FINDSET() THEN
            REPEAT
                out.APPEND('<option value=' + ADCS_User.Name + '>' + ADCS_User.Name + '</option>');
            UNTIL ADCS_User.NEXT() = 0;


        out.APPEND('<label for="psw"><b>Mot de passe</b></label> ');
        out.APPEND('<input  id="passInput" type="password" placeholder="Enter Mot de passe" name="psw" required onKeyDown="if(event.keyCode==13) login();"> ');
        out.APPEND('<div style="text-align:center;"> <button onclick="PICK()" style="margin-right:4%;background-color: cadetblue;width: 80%;">Scanner colis</button>  </div>');

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
        out.APPEND('<center><h3>Facture: ' + cmdsave + '</h3></center>');

        out.APPEND('<div class="card">');

        out.APPEND('<label>Colis</label>');
        out.APPEND('<input type="text" id="article" placeholder="Scanner ou saisir colis">');
        // out.APPEND('<label>Description</label>');
        // out.APPEND('<input type="text" id="desc" disabled>');

        out.APPEND('<div id="tableContainer" ' +
'style="box-sizing: border-box;width:100%; max-height:250px; overflow-y:auto; border:1px solid #ccc; ' +
'border-radius:6px; box-sizing:border-box; background-color:#fff; ' +
'font-family:Arial; font-size:16px; margin-bottom:15px;margin-top:20px">');

        out.APPEND('<table id="tableEmp" style="box-sizing: border-box;width:100%; border-collapse:collapse;margin-top:0px">');
        out.APPEND('<tr style="background-color:#04AA6D; color:white; position:sticky; top:0;"><th style="text-align:left; padding:10px;">Colis</th><th style="text-align:left; padding:10px;">Pointé</th></tr>');
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
