page 76006 "CB Reception"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    caption = 'Scan réception';

    layout
    {
        area(Content)
        {

            usercontrol(html; "CB HTML6")
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
                //AssignedUser: Record "STF WMS Assigned User ADCS";

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
                        // if ADCS_USER."CB Password" <> uspass then
                        //     Error('Mot de passe incorrect !');
                        // AssignedUser.Reset();
                        // AssignedUser.SetRange(Name, usname);
                        // if role = 'PICK' then begin
                        //     AssignedUser.SetFilter("Zone Type", '%1|%2|%3', AssignedUser."Zone Type"::"Big Item", AssignedUser."Zone Type"::"Precious Item", AssignedUser."Zone Type"::"Small Item");
                        //     if not AssignedUser.FindSet() then
                        //         error('L''untilisateur n''est pas afecté sur une zone de picking');
                        // end;
                        // if role = 'CROSS' then begin
                        //     AssignedUser.SetRange("Zone Type", AssignedUser."Zone Type"::"Cross Item");
                        //     if not AssignedUser.FindSet() then
                        //         error('L''untilisateur n''est pas afecté sur Cross Item');
                        // end;
                        // if role = 'COL' then begin
                        //     AssignedUser.SetRange("Zone Type", AssignedUser."Zone Type"::" ");
                        //     if not AssignedUser.FindSet() then
                        //         error('L''untilisateur n''est pas un controlleur');
                        magsave := ADCS_USER."STF Location";
                        // end;
                        CurrPage.html.Render(Login2(usname));
                    end
                    else
                        Error('saisie votre mot de passe ou votre utilisateur');
                end;

                trigger terminer(info: JsonObject)
                var
                    Assignment: Record "STF Wareh Activity Assignment";
                    Warehouse_Activity_Line: Record "Warehouse Activity Line";
                    scan: page "CB scan barcode";

                begin
                    if role <> 'COL' then
                        if scan.RunModal() = ACTION::OK then begin
                            Picked_barcode := scan.getbarcode();
                            if Picked_barcode = '' then
                                error('vous devez scanner le code à barre');
                            Warehouse_Activity_Line.Reset();
                            Warehouse_Activity_Line.setrange("STF Colis", Picked_barcode);
                            if Warehouse_Activity_Line.FindSet() then
                                error('code à barre déja utilisé');
                        end
                        else
                            error('vous devez scanner le code à barre');


                    Warehouse_Activity_Line.reset();
                    Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::"Put-away");
                    Warehouse_Activity_Line.SetRange("STF Assigned WMS User Name", usname);
                    Warehouse_Activity_Line.SetRange("No.", cmdsave);
                    if Warehouse_Activity_Line.findset() then
                        repeat
                            if Warehouse_Activity_Line."Action Type" = Warehouse_Activity_Line."Action Type"::Take then
                                if not (Warehouse_Activity_Line."CB Picking validated") then
                                    error('Veuillez valider tous les emplacements');
                            if role <> 'COL' then begin
                                Warehouse_Activity_Line.Validate("STF Colis", Picked_barcode);
                                Warehouse_Activity_Line.Modify();
                            end;
                        until Warehouse_Activity_Line.Next() = 0;
                    Assignment.Reset();
                    Assignment.setrange("No.", cmdSave);
                    if role = 'COL' then
                        Assignment.SetRange("Action Type", Assignment."Action Type"::Place)
                    else begin
                        Assignment.SetRange("User Assigned", usname);
                        Assignment.SetRange("Action Type", Assignment."Action Type"::take);
                    end;
                    if role = 'COL' then
                        Assignment.setfilter("No. Type", typesaveall);
                    if Assignment.FindSet() then
                        repeat
                            if role = 'COL' then
                                Assignment.validate("User Assigned", usname);
                            Assignment.Validate(Status, Assignment.Status::"Activity Completed");
                            Assignment.Modify();
                        until Assignment.Next() = 0;
                    cmdSave := '';
                    CurrPage.html.Render(Login2(usname));
                    CurrPage.html.receptionfocus();
                end;

                trigger info(info: JsonObject)
                var
                    cmdv: Text;
                    cmdvToken: JsonToken;
                    Warehouse_Header: Record "Warehouse Activity Header";
                    // Warehouse_Header_temp: Record "Warehouse Activity Header" temporary;
                    ADCS_USER: Record "ADCS User";
                    // Wareh_Activity_Assignment: Record "STF Wareh Activity Assignment";
                    // Assignment: Record "STF Wareh Activity Assignment";
                    // assigned_user: record "STF WMS Assigned User ADCS";
                    Warehouse_Activity_Line: Record "Warehouse Activity Line";
                begin
                    colisno := '';
                    Warehouse_Header.init();
                    info.SelectToken('cmdv', cmdvToken);
                    cmdvToken.WriteTo(cmdv);
                    cmdv := cmdv.Replace('"', '');

                    picked_barcode := cmdv;
                    Warehouse_Activity_Line.reset();
                    Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::"Put-away");
                    Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::place);
                    Warehouse_Activity_Line.SetRange("STF Colis", picked_barcode);
                    Warehouse_Activity_Line.SetRange("Location Code", magsave);
                    if Warehouse_Activity_Line.FindSet() then
                        cmdSave := Warehouse_Activity_Line."No."

                    else
                        error('code à barre non existant');


                    Warehouse_Header.Reset();
                    Warehouse_Header.SetRange("No.", cmdsave);
                    typesave := '';
                    ADCS_User.SetRange(Name, usname);
                    if ADCS_User.FindSet() then begin
                        Warehouse_Header.SetRange(Type, Warehouse_Header.Type::Pick);
                        Warehouse_Header.SetRange("Location Code", ADCS_User."STF Location");



                        CurrPage.html.Render(AddItem(cmdsave));
                        CurrPage.html.WhenLoaded();
                    end
                    else
                        Message('Veuillez affecter l''utilisateur');
                end;

                trigger remplirqte2(cab: JsonObject)
                var
                    cabq: text;
                    cabq_token: JsonToken;
                    scan: record "CB historique scan";
                    total_quantity: Decimal;



                begin
                    if cab_exists_flag = 0 then
                        error('veuillez scanner l''article');
                    cab.SelectToken('cabq', cabq_token);
                    cabq_token.WriteTo(cabq);
                    cabq := cabq.Replace('"', '');
                    Evaluate(QuantityItem, cabq);

                    scan.Reset();
                    scan.SetRange("Document Type", scan."Document Type"::reception);
                    scan.SetRange("Document No.", cmdSave);
                    scan.setrange(article, item_no_text);
                    scan.setrange(Magasin, magsave);
                    scan.setrange(Emplacement, emplacement);
                    scan.setrange(Cancelled, false);
                    total_quantity := 0;
                    old_quantity := 0;
                    if scan.findset() then begin
                        repeat
                            total_quantity := total_quantity + scan."Controlled Quantity";
                            if scan.user <> usname then
                                old_quantity := scan."Controlled Quantity" + old_quantity;

                        until scan.Next() = 0;
                        total_quantity := total_quantity + QuantityItem;

                    end
                    else
                        total_quantity := QuantityItem;
                    CurrPage.html.autoComplete(cab_value, item_no_text, item_description, total_quantity, box_flag_value, quantitya);
                end;

                trigger CheckCAB(cab: JsonObject)
                var
                    Warehouse_Activity_Line: Record "Warehouse Activity Line";
                    increment_token: JsonToken;
                    cab_token: JsonToken;
                    increment_value: Text;
                    box_flag_token: JsonToken;
                    quantity_expected_token: JsonToken;
                    empl_token: JsonToken;
                    quantity_expected_text: Text;
                    quantity_scanned_text: Text;
                    Colis_token: JsonToken;
                    Item_Reference: Record "Item Reference";
                    item: record item;
                begin
                    QuantityItem := 0;
                    cab_exists_flag := 0;
                    quantitya := 0;

                    cab.SelectToken('cab', cab_token);
                    cab_token.WriteTo(cab_value);
                    cab_value := cab_value.Replace('"', '').Replace('\r', '');

                    cab.SelectToken('emplacement', empl_token);
                    empl_token.WriteTo(emplacement);
                    emplacement := emplacement.Replace('"', '').Replace('\r', '');

                    cab.SelectToken('increment', increment_token);
                    increment_token.WriteTo(increment_value);
                    increment_value := increment_value.Replace('"', '').Replace('\r', '');

                    cab.SelectToken('articleNo', increment_token);
                    increment_token.WriteTo(item_no_text);
                    item_no_text := item_no_text.Replace('"', '');

                    cab.SelectToken('b', box_flag_token);
                    box_flag_token.WriteTo(box_flag_value);
                    box_flag_value := box_flag_value.Replace('"', '');

                    cab.SelectToken('qtea', quantity_expected_token);
                    quantity_expected_token.WriteTo(quantity_expected_text);
                    quantity_expected_text := quantity_expected_text.Replace('"', '');

                    cab.SelectToken('qtes', quantity_expected_token);
                    quantity_expected_token.WriteTo(quantity_scanned_text);
                    quantity_scanned_text := quantity_scanned_text.Replace('"', '');

                    cab.SelectToken('Colis', Colis_token);
                    Colis_token.WriteTo(colisno);
                    colisno := colisno.Replace('"', '');
                    colisno := colisno.Replace(' ', '');
                    if role = 'COL' then
                        if colisno = '' then
                            error('Veuillez scanner le colis');
                    if StrLen(quantity_scanned_text) > 5 then
                        Error('Veuillez vérifier la quantité. La quantité ne doit pas dépasser 5 chiffres.');
                    Item_Reference.reset();
                    Item_Reference.setrange("Reference Type", Item_Reference."Reference Type"::"Bar Code");
                    Item_Reference.setrange("Reference No.", cab_value);
                    if Item_Reference.findset() then begin
                        cab_exists_flag := 1;
                        item_no_text := Item_Reference."Item No.";
                        item.reset();
                        item.setrange("No.", item_no_text);
                        item.SetFilter("location filter", magsave);
                        if item.findset() then begin
                            item.CalcFields("DLT Available Inventory");
                            item_description := item.Description;
                            CurrPage.html.remplirqtestock(Format(item."DLT Available Inventory"));

                        end;
                    end
                    else begin
                        item.reset();
                        item.setrange("No.", cab_value);
                        item.SetFilter("location filter", magsave);
                        if item.findset() then begin
                            item.CalcFields("DLT Available Inventory");
                            item_description := item.Description;
                            cab_exists_flag := 1;
                            item_no_text := item."No.";

                            CurrPage.html.remplirqtestock(Format(item."DLT Available Inventory"));

                        end;
                    end;

                    if cab_exists_flag = 1 then begin

                        Warehouse_Activity_Line.Reset();
                        Warehouse_Activity_Line.SetRange("No.", cmdsave);
                        Warehouse_Activity_Line.SetRange("Item No.", item_no_text);
                        Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::"Put-away");

                        Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::place);
                        Warehouse_Activity_Line.SetRange("STF Colis", picked_barcode);

                        if Warehouse_Activity_Line.findset() then begin
                            emplacement := Warehouse_Activity_Line."Bin Code";
                            CurrPage.html.rempliremp(emplacement);
                            repeat
                                quantitya += Warehouse_Activity_Line."Qty. Outstanding";
                            until Warehouse_Activity_Line.Next() = 0;
                        end
                        else
                            Error('Article non existant');
                        CurrPage.html.remplirqte(cab_value);


                    end else
                        CurrPage.html.cabnonvalide();
                end;



                trigger finish2(item: JsonObject)
                var
                    ligne_reception: Record "CB Historique Scan";
                begin
                    ligne_reception.Reset();
                    ligne_reception.SetRange("Document No.", cmdSave);
                    ligne_reception.SetRange(user, usname);
                    if ligne_reception.FindSet() then
                        Page.run(76001, ligne_reception);
                end;


                trigger fermerModal(item: JsonObject)
                begin
                    Page.run(52003);
                end;

                trigger validate(item_json: JsonObject)
                var
                    token_empl: JsonToken;
                    emplacement: text;
                    Warehouse_Activity_Line: Record "Warehouse Activity Line";
                    ModalResult: Action;
                begin
                    item_json.SelectToken('emp', token_empl);
                    token_empl.WriteTo(emplacement);
                    emplacement := emplacement.Replace('"', '');
                    Warehouse_Activity_Line.Reset();
                    Warehouse_Activity_Line.SetRange("No.", cmdsave);
                    Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::"Put-away");
                    Warehouse_Activity_Line.SetRange("CB Picking validated", false);
                    Warehouse_Activity_Line.SetRange("STF Assigned WMS User Name", usname);
                    Warehouse_Activity_Line.SetRange("Bin Code", emplacement);
                    Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::take);
                    if Warehouse_Activity_Line.FindSet() then
                        repeat
                            if Warehouse_Activity_Line."Qty. Outstanding" <> Warehouse_Activity_Line."STF Picked Quantity" then begin
                                ModalResult := Page.RunModal(76004, Warehouse_Activity_Line);
                                if ModalResult <> ACTION::LookupOK then
                                    error('vous devez choisir un code motif');
                                if Warehouse_Activity_Line."Warehouse Reason Code" = '' then
                                    error('vous devez choisir un code motif');
                            end;
                            Warehouse_Activity_Line.Validate("CB Picking validated", true);
                            Warehouse_Activity_Line.Modify();
                        until Warehouse_Activity_Line.next() = 0;
                    remplirempl();
                end;

                trigger Item(item_json: JsonObject)
                var

                    article_no_text: Text;
                    quantity_text: Text;
                    cab_value: Text;
                    description_text: Text;
                    vide_flag: Text;
                    emplacement: text;
                    quantity_affiche_text: Text;

                    quantity_dec: Decimal;
                    newQuantity: Decimal;

                    token_article: JsonToken;
                    token_quantity: JsonToken;
                    token_vide: JsonToken;
                    token_cab: JsonToken;
                    token_description: JsonToken;
                    token_quantity_affiche: JsonToken;
                    token_empl: JsonToken;
                    QuantityInLine: decimal;
                    Warehouse_Activity_Line, WarehouseActivityTakeLine : Record "Warehouse Activity Line";
                    scan: record "CB historique scan";
                    item: record item;



                begin
                    item_json.SelectToken('art', token_article);
                    token_article.WriteTo(article_no_text);
                    article_no_text := article_no_text.Replace('"', '');

                    item_json.SelectToken('qtea', token_quantity);
                    token_quantity.WriteTo(quantity_text);
                    quantity_text := quantity_text.Replace('"', '');

                    item_json.SelectToken('vide', token_vide);
                    token_vide.WriteTo(vide_flag);
                    vide_flag := vide_flag.Replace('"', '');

                    item_json.SelectToken('emp', token_empl);
                    token_empl.WriteTo(emplacement);
                    emplacement := emplacement.Replace('"', '');

                    if StrLen(quantity_text) > 5 then
                        Error('Veuillez vérifier la quantité. La quantité ne doit pas dépasser 5 chiffres.');

                    item_json.SelectToken('cab', token_cab);
                    token_cab.WriteTo(cab_value);
                    cab_value := cab_value.Replace('"', '');



                    item_json.SelectToken('des', token_description);
                    token_description.WriteTo(description_text);
                    description_text := description_text.Replace('"', '');

                    item_json.SelectToken('qteaf', token_quantity_affiche);
                    token_quantity_affiche.WriteTo(quantity_affiche_text);
                    quantity_affiche_text := quantity_affiche_text.Replace('"', '');

                    if StrLen(quantity_affiche_text) > 5 then
                        Error('Veuillez vérifier la quantité. La quantité ne doit pas dépasser 5 chiffres.');

                    Evaluate(quantity_dec, quantity_text);
                    QuantityInLine := 0;
                    newQuantity := quantity_dec;
                    Warehouse_Activity_Line.Reset();
                    Warehouse_Activity_Line.SetRange("No.", cmdsave);
                    Warehouse_Activity_Line.SetRange("Item No.", article_no_text);
                    Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::"Put-away");
                    Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::place);
                    Warehouse_Activity_Line.SetRange("STF Colis", picked_barcode);


                    Warehouse_Activity_Line.SetRange("Bin Code", emplacement);
                    if Warehouse_Activity_Line.findset() then
                        repeat
                            if Warehouse_Activity_Line."Qty. Outstanding" < newQuantity then begin
                                Warehouse_Activity_Line.Validate("Qty. to Handle", Warehouse_Activity_Line."Qty. Outstanding");
                                newQuantity := newQuantity - Warehouse_Activity_Line."Qty. Outstanding";
                            end
                            else begin
                                Warehouse_Activity_Line.Validate("Qty. to Handle", newQuantity);
                                newQuantity := 0;
                            end;
                            QuantityInLine += Warehouse_Activity_Line."Qty. Outstanding";
                            Warehouse_Activity_Line.Modify();
                            WarehouseActivityTakeLine.get(Warehouse_Activity_Line."Activity Type", Warehouse_Activity_Line."No.", Warehouse_Activity_Line."Line No." - 10000);
                            WarehouseActivityTakeLine.Validate("Qty. to Handle", Warehouse_Activity_Line."Qty. to Handle");
                            WarehouseActivityTakeLine.modify();
                        until Warehouse_Activity_Line.Next() = 0;
                    if QuantityInLine < quantity_dec then begin
                        CurrPage.html.Viderqte();
                        error('Quantité doit étre inférieur à la quantité demandée');

                    end;
                    item.get(article_no_text);
                    scan.Reset();
                    scan.SetRange("Document Type", scan."Document Type"::reception);
                    scan.SetRange("Document No.", cmdSave);
                    scan.setrange(article, article_no_text);
                    scan.setrange(Magasin, magsave);
                    scan.setrange(Emplacement, emplacement);
                    scan.setrange("User", usname);
                    if scan.findset() then begin
                        scan.Validate("Controlled Quantity", quantity_dec - old_quantity);
                        scan.Validate("Barcode", cab_value);
                        scan.Validate("Description", Item.Description);
                        scan.Modify(true);

                    end
                    else begin
                        scan.Init();
                        scan.Validate("Barcode", cab_value);

                        scan.Validate("Document Type", scan."Document Type"::reception);
                        scan.Validate("Document No.", cmdSave);
                        scan.Validate(article, article_no_text);
                        scan.Validate(Magasin, magsave);
                        scan.Validate(Emplacement, emplacement);
                        scan.Validate(Cancelled, false);
                        scan.Validate("User", usname);
                        scan.Validate("Description", Item.Description);
                        scan.Validate("Controlled Quantity", quantity_dec - old_quantity);
                        scan.Insert(true);

                    end;
                    if vide_flag = 'TRUE' then
                        CurrPage.html.ViderCAB();
                end;



                trigger back_to_login(emplc: JsonObject)
                var
                begin
                    cmdSave := '';
                    CurrPage.html.Render(Login2(usname));
                    CurrPage.html.receptionfocus();


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
        out.APPEND('<div style="text-align:center;"> <button onclick="PICK()" style="margin-right:4%;background-color: cadetblue;width: 80%;">Réception</button>  </div>');

        EXIT(Format(out));
    END;





    procedure Login2(usname: Text): Text
    var
        ADCS_User: Record "ADCS User";
        out: TextBuilder;

    begin

        out.APPEND('<!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style> body { font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0; } .container { max-width: 800px; margin: 0 auto; padding: 20px; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h1 { text-align: center; margin-bottom: 30px; color: #333; } label { display: block; margin-bottom: 8px; color: #333; } input[type="text"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; } .qte-container { display: grid; } button { background-color: #04AA6D; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer; width: 40%; font-size: 16px; transition: background-color 0.3s; } button:hover { background-color: #048f5d; } #resetBtn { background-color: cadetblue; float: left; } #nextBtn { float: right; } #finishBtn { float: left; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } .loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute; z-index: 10; top: 20%; left: 40%; text-align: center; font-size: 10px; } @-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } } @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } } </style> </head> ');
        out.APPEND('<body> <h2>Numéro de colis Scanné</h2> ');
        out.APPEND('<div id="tableContainer" ' +
'style="width:100%; max-height:250px; overflow-y:auto; border:1px solid #ccc; ' +
'border-radius:6px; box-sizing:border-box; background-color:#fff; ' +
'font-family:Arial; font-size:16px; margin-bottom:15px;">');

        out.APPEND('<table style="width:100%; border-collapse:collapse;">' +
        '<thead>' +
        '<tr style="background-color:#04AA6D; color:white; position:sticky; top:0;">' +
        '<th style="text-align:left; padding:10px;">Code à barre</th>' +
        '</tr></thead><tbody>');
        ADCS_User.RESET();
        ADCS_User.SETRANGE(Name, usname);






        out.APPEND('</tbody></table></div>');
        out.APPEND('<input type="text" style="" id="cmdv" name="cmdv" required onKeyDown="if(event.keyCode==13) go();"> ');

        out.APPEND('<div style="text-align:center"><button id="gu" name="gu" onKeyDown="if(event.keyCode==13) go();" onClick="go()" style="float: center;">Accès</button></div>');
        out.APPEND('</body> </html>');

        EXIT(Format(out));
    end;

    procedure assigned()
    var
        Assignment: Record "STF Wareh Activity Assignment";
        Assignment_user: Record "STF WMS Assigned User ADCS";
        ZoneList: List of [Text];
        ZoneValue: Text;
        ZoneEnum: Enum "STF Zone Type";

        useraffected: boolean;

    begin
        if role = 'COL' then
            ZoneList := typesaveall.Split('|')
        else
            ZoneList := typesavepick.Split('|');
        Assignment.Reset();
        Assignment.setrange("No.", cmdSave);
        Assignment.Setfilter(Status, '%1|%2|%3', Assignment.Status::Assigned, Assignment.Status::"Waiting for assignment", Assignment.Status::"Activity In Progress");
        if role = 'COL' then
            Assignment.SetRange("Action Type", Assignment."Action Type"::place)
        else
            Assignment.SetRange("Action Type", Assignment."Action Type"::take);

        if Assignment.FindSet() then
            repeat
                if role = 'COL' then begin
                    if Assignment."User Assigned" = '' then
                        Assignment.Validate("User Assigned", usname);
                    Assignment.Validate(Status, Assignment.Status::"Activity In Progress");
                    Assignment.Modify();


                end
                else begin
                    Assignment_user.Reset();
                    Assignment_user.setrange(name, usname);
                    Assignment_user.setrange("Zone Type", Assignment."No. Type");
                    if Assignment_user.FindSet() then begin
                        if Assignment."User Assigned" = '' then
                            Assignment.Validate("User Assigned", usname);
                        Assignment.Validate(Status, Assignment.Status::"Activity In Progress");
                        Assignment.Modify();
                        assignuser(Assignment);

                    end;
                end;
            until Assignment.Next() = 0
        else begin
            useraffected := false;
            if role <> 'COL' then begin
                foreach ZoneValue in ZoneList do begin
                    if ZoneValue = '' then error('zone vide');
                    if not Evaluate(ZoneEnum, ZoneValue) then
                        Error('Invalid Zone Type: %1', ZoneValue);
                    Assignment.Init();
                    Assignment.Validate("No.", cmdSave);
                    Assignment.Validate("Action Type", Assignment."Action Type"::take);
                    Assignment_user.Reset();
                    Assignment_user.setrange(name, usname);
                    Assignment_user.setrange("Zone Type", ZoneEnum);
                    if Assignment_user.FindSet() then begin

                        Assignment_user.Reset();
                        Assignment_user.SetRange(Name, usname);
                        Assignment_user.SetRange("Zone Type", ZoneEnum);

                        if Assignment_user.FindSet() then begin
                            useraffected := true;
                            Assignment.Validate("User Assigned", usname);
                            Assignment.validate("No. Type", ZoneEnum);
                            Assignment.Validate(Status, Assignment.Status::"Activity In Progress");
                            Assignment.Validate("Assignment Date", today);
                            Assignment.Validate("Assignment Time", time);
                            if Assignment.Insert(true) then assignuser(Assignment);


                        end;
                    end;
                end;
                if not useraffected then
                    error('Veuillez vérifier les zones affectés sur cet utilisateur');
            end
            else
                foreach ZoneValue in ZoneList do begin
                    if ZoneValue = '' then error('zone vide');
                    if not Evaluate(ZoneEnum, ZoneValue) then
                        Error('Invalid Zone Type: %1', ZoneValue);
                    Assignment.Init();
                    Assignment.Validate("No.", cmdSave);
                    Assignment.Validate("Action Type", Assignment."Action Type"::Place);


                    Assignment.Validate("User Assigned", usname);
                    Assignment.validate("No. Type", ZoneEnum);
                    Assignment.Validate(Status, Assignment.Status::"Activity In Progress");
                    Assignment.Validate("Assignment Date", today);
                    Assignment.Validate("Assignment Time", time);
                    if Assignment.Insert(true) then;

                end;
        end;
    end;

    procedure assignuser(Assignment: Record "STF Wareh Activity Assignment")
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";

    begin
        if (WarehouseActivityHeader.get(WarehouseActivityHeader.Type::Pick, Assignment."No.")) then
            case Assignment."No. Type" of
                Assignment."No. Type"::"Small Item":
                    begin
                        WarehouseActivityHeader.validate("STF User ADCS Small Item", usname);
                        WarehouseActivityHeader.Validate("STF Status Small Warehouse Act", WarehouseActivityHeader."STF Status Small Warehouse Act"::"Activity In Progress");
                    end;
                Assignment."No. Type"::"Big Item":
                    begin
                        WarehouseActivityHeader.validate("STF User ADCS Big Item", usname);
                        WarehouseActivityHeader.Validate("STF Status Big Warehouse Act", WarehouseActivityHeader."STF Status Big Warehouse Act"::"Activity In Progress");

                    end;
                Assignment."No. Type"::"Precious Item":
                    begin
                        WarehouseActivityHeader.validate("STF User ADCS precious Item", usname);
                        WarehouseActivityHeader.Validate("STF Status Precious Wareh Act", WarehouseActivityHeader."STF Status Precious Wareh Act"::"Activity In Progress");
                    end;
            end;
        WarehouseActivityHeader.Modify(true);
    end;



    procedure remplirempl()
    var
        Warehouse_Activity_Line: Record "Warehouse Activity Line";

    begin
        if role <> 'COL' then begin

            CurrPage.html.reset();

            Warehouse_Activity_Line.reset();
            Warehouse_Activity_Line.setcurrentkey("Bin Code");
            Warehouse_Activity_Line.SetAscending("Bin Code", true);
            Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::"Put-away");
            Warehouse_Activity_Line.setrange("CB Picking validated", false);
            Warehouse_Activity_Line.SetRange("STF Assigned WMS User Name", usname);
            Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::take);
            Warehouse_Activity_Line.SetRange("No.", cmdsave);
            if Warehouse_Activity_Line.findset() then
                CurrPage.html.rempliremp(Warehouse_Activity_Line."Bin code")
            else
                Message('il n''ya pas d''article non validé affecté à cet utilisateur');
        end;
    end;

    procedure AddItem(cmdv: Text): Text
    var
        out: TextBuilder;
    begin
        out.APPEND('<!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style> .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.7); justify-content: center; align-items: center; } .modal-content { background-color: #fff; padding: 20px; border-radius: 5px; text-align: center; } .modal-btn { margin: 10px; padding: 10px 20px; cursor: pointer; } body { font-family: Arial, Helvetica, sans-serif; background-color: #f9f9f9; margin: 0; padding: 0; } .container { max-width: 800px; margin: 0 auto; padding: 20px; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h1 { text-align: center; margin-bottom: 30px; color: #333; } label { display: block; margin-bottom: 8px; color: #333; } input[type="text"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; } .qte-container { display: grid; } button { background-color: #04AA6D; color: white; padding: 14px 20px; margin: 10px 0; border: none; border-radius: 4px; cursor: pointer; width: 40%; font-size: 16px; transition: background-color 0.3s; } button:hover { background-color: #048f5d; } #resetBtn { background-color: cadetblue; float: left; margin-right: 20px; } #nextBtn { float: right; } #finishBtn { float: left; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } .loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute; z-index: 10; top: 20%; left: 40%; text-align: center; font-size: 10px; } @-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } } @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } } </style> </head> ');
        out.APPEND('<body><center> <h2 style="color : red;">reception: ' + cmdv + '</h2> </center>');
        out.APPEND('<center> <h3 style="color : red;"> Magasin: ' + magsave + '</h3> </center>');
        out.APPEND('<div style="text-align:center;display:none;"><label for="increment"><b style="color : red;">Voulez-vous incrémenter?</b></label>');
        out.APPEND('<input type="checkbox" id="increment" name="increment" value="true" checked></div>');


        out.APPEND('<input style="display:None;" tabindex="-1" enterkeyhint="done" id="Colis" type="text" name="Colis" onKeyDown="if(event.keyCode==27) Colis.select(); required>');




        out.APPEND('<div id="all" style="display: flex; gap: 2%;width:100%;"> <div id="allcab" style="width:100%;" > <label for="cab"><b>Code à barre</b></label> <input type="text" style="width:48%;" id="cab" tabindex="-1" enterkeyhint="done" name="cab" placeholder="Article" onKeyPress="if(event.keyCode==13) passerCab(this);"  required> <input placeholder="Quantité" style="width:48%;margin-left:2%;" type="text" id="cabq" tabindex="-1" enterkeyhint="done" name="cabquantity" onKeyPress="if(event.keyCode==13) passerCabQuantity(this);" required></div> <div id="alllot" style="display: none; flex-direction: column; align-items: center;"> <label id="lotl" for="Lot"><b>Numéro de Lot</b></label> <input tabindex="-1" enterkeyhint="done" id="Lot" type="text" name="Lot" onKeyDown="if(event.keyCode==27) Lot.select();" onKeyPress="if(event.keyCode==13) check();"  required> </div> </div>');
        out.APPEND('<label  for="emp"><b>Emplacement</b></label> <input  id="emp" type="text" name="emp" disabled="true">');
        out.APPEND('</input> ');

        out.APPEND('<div id="alldate" style="display: none; flex-direction: column; align-items: center;"> <label id="daeExl" for="daeEx"><b>Date Déxpiration</b></label> <input id="daeEx" type="text" name="daeEx" onKeyDown="if(event.keyCode==27) daeEx.select();" onKeyPress="if(event.keyCode==13) check();" required> </div>');
        out.APPEND('<label for="desc"><b>Description</b></label> <input id="desc" type="text" name="desc" readonly="readonly">');

        out.APPEND('<div style="display: flex; justify-content: space-between; align-items: center; width: 100%; gap: 2%;">');
        out.APPEND('<label for="qtescan" style="width: 32%; text-align: center;"><b>Qte Scan</b></label>');
        out.APPEND('<label for="qtea" style="width: 32%; text-align: center;"><b>Qte Total</b></label>');
        out.APPEND('<label for="qtestock" style="width: 32%; text-align: center;"><b>Qte Stock</b></label>');
        out.APPEND('</div>');

        out.APPEND('<div style="display: flex; justify-content: space-between; align-items: center; width: 100%; gap: 2%; margin-top: 4px;">');

        out.APPEND('<input tabindex="-1" enterkeyhint="done" id="qtes" type="text" name="qtescan" '
            + 'style="width: 32%; text-align: center; font-size: 16px;" '
            + 'onkeydown="if(event.keyCode==27) this.select();" '
            + 'onkeypress="if(event.keyCode==13) next2();" required>');

        out.APPEND('<input tabindex="-1" enterkeyhint="done" id="qtea" type="text" name="qtea" '
            + 'style="width: 32%; text-align: center; font-size: 16px; background-color: #f5f5f5; border: 1px solid #ccc;" '
            + 'readonly>');

        out.APPEND('<input tabindex="-1" enterkeyhint="done" id="qtestock" type="text" name="qtestock" '
            + 'style="width: 32%; text-align: center; font-size: 16px; background-color: #f5f5f5; border: 1px solid #ccc;" '
            + 'readonly>');

        out.APPEND('</div>');


        out.APPEND('<label for="article"><b>Article</b></label> <input id="articleNo" type="text" name="article" readonly="readonly" required>');

        out.APPEND('<label id="cabcopy" style="display:none;"></label>');
        out.APPEND('<div style="">');

        out.APPEND('<input id="message" type="text" name="message" style="width:240px;display: inline-block;font-size:16px; background: rgba(0, 0, 0, 0); border: none;"><br>');
        out.APPEND('<div>');

        out.APPEND('<div style="text-align:center;"> <button onclick="reset()" style="margin-right:4%;background-color: cadetblue;width: 40%;">Réinitialiser</button> <button onclick="finish2()" style="width:40%;margin-left:4%;">Aperçu</button> </div>');
        out.APPEND('<div id="myModal" class="modal";> <div class="modal-content" style="margin-top:220px;"> <p> Le reception a été terminée avec succès. Souhaitez-vous continuer ou fermer ?</p> <button class="modal-btn" onclick="fermerModal()">Sortir de lapplication</button> <button id="cmdv" name="cmdv" type="text" onclick="back()" class="modal-btn">Revenir au menu précédent</button> </div> </div>');

        out.APPEND('</body> </html>');

        EXIT(Format(out));
    end;

    var
        increment, usname, cmdSave, magsave, role, colisno, typesave : Text;
        item_no_text: Text;
        item_description: Text;
        box_flag_value: Text;
        cab_value: Text;
        typesaveall: text;
        typesavepick: text;

        old_quantity, QuantityItem, quantitya : decimal;
        emplacement, Picked_barcode : text;
        cab_exists_flag: Integer;




}
