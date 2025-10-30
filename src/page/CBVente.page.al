page 76000 "CB Vente"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    caption = 'Scan Vente';

    layout
    {
        area(Content)
        {

            usercontrol(html; "CB HTML5")
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
                    AssignedUser: Record "STF WMS Assigned User ADCS";

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
                        if ADCS_USER."CB Password" <> uspass then
                            Error('Mot de passe incorrect !');
                        AssignedUser.Reset();
                        AssignedUser.SetRange(Name, usname);
                        if role = 'PICK' then begin
                            AssignedUser.SetFilter("Zone Type", '%1|%2|%3', AssignedUser."Zone Type"::"Big Item", AssignedUser."Zone Type"::"Precious Item", AssignedUser."Zone Type"::"Small Item");
                            if not AssignedUser.FindSet() then
                                error('L''untilisateur n''est pas afecté sur une zone de picking');
                        end;
                        if role = 'CROSS' then begin
                            AssignedUser.SetRange("Zone Type", AssignedUser."Zone Type"::"Cross Item");
                            if not AssignedUser.FindSet() then
                                error('L''untilisateur n''est pas afecté sur Cross Item');
                        end;
                        if role = 'COL' then begin
                            AssignedUser.SetRange("Zone Type", AssignedUser."Zone Type"::" ");
                            if not AssignedUser.FindSet() then
                                error('L''untilisateur n''est pas un controlleur');
                        end;
                        CurrPage.html.Render(Login2(usname));
                    end else
                        Error('saisie votre mot de passe ou votre utilisateur');
                end;

                trigger terminer(info: JsonObject)
                var
                    Assignment: Record "STF Wareh Activity Assignment";
                begin
                    Assignment.Reset();
                    Assignment.setrange("No.", cmdSave);
                    if role = 'COL' then
                        Assignment.SetRange("Action Type", Assignment."Action Type"::Place)
                    else begin
                        Assignment.SetRange("User Assigned", usname);

                        Assignment.SetRange("Action Type", Assignment."Action Type"::take);
                    end;

                    if Assignment.FindSet() then
                        repeat
                            if role = 'COL' then
                                Assignment.validate("User Assigned", usname);

                            Assignment.Validate(Status, Assignment.Status::"Activity Completed");
                            Assignment.Modify();
                        until Assignment.Next() = 0;
                    cmdSave := '';
                    CurrPage.html.Render(Login2(usname));
                    CurrPage.html.Ventefocus();

                end;

                trigger info(info: JsonObject)
                var
                    cmdv: Text;
                    cmdvToken: JsonToken;
                    Warehouse_Header: Record "Warehouse Activity Header";
                    Warehouse_Header_temp: Record "Warehouse Activity Header" temporary;
                    ADCS_USER: Record "ADCS User";
                    Wareh_Activity_Assignment: Record "STF Wareh Activity Assignment";
                    Assignment: Record "STF Wareh Activity Assignment";

                begin


                    colisno := '';
                    Warehouse_Header.init();

                    info.SelectToken('cmdv', cmdvToken);
                    cmdvToken.WriteTo(cmdv);
                    cmdv := cmdv.Replace('"', '');
                    cmdSave := cmdv;
                    Warehouse_Header.Reset();
                    Warehouse_Header.SetRange("No.", cmdv);
                    typesave := '';
                    ADCS_User.SetRange(Name, usname);
                    if ADCS_User.FindSet() then begin


                        Warehouse_Header.SetRange(Type, Warehouse_Header.Type::Pick);
                        Warehouse_Header.SetRange("Location Code", ADCS_User."STF Location");
                        if role = 'PICK' then begin


                            Warehouse_Header.SetFilter("STF User ADCS Big Item", usname);
                            Warehouse_Header.setfilter("STF Status Big Warehouse Act", '%1|%2', Warehouse_Header."STF Status Big Warehouse Act"::Assigned, Warehouse_Header."STF Status Big Warehouse Act"::"Activity In Progress");
                            if Warehouse_Header.FindSet() then
                                repeat
                                    Warehouse_Header_temp.init();
                                    Warehouse_Header_temp := Warehouse_Header;
                                    if Warehouse_Header_temp.Insert() then;
                                until Warehouse_Header.Next() = 0;
                            Warehouse_Header.setrange("STF User ADCS Big Item");
                            Warehouse_Header.setrange("STF Status Big Warehouse Act");

                            Warehouse_Header.SetFilter("STF User ADCS Small Item", usname);
                            Warehouse_Header.setfilter("STF Status small Warehouse Act", '%1|%2', Warehouse_Header."STF Status small Warehouse Act"::Assigned, Warehouse_Header."STF Status small Warehouse Act"::"Activity In Progress");
                            if Warehouse_Header.FindSet() then
                                repeat
                                    Warehouse_Header_temp.init();
                                    Warehouse_Header_temp := Warehouse_Header;
                                    if Warehouse_Header_temp.Insert() then;
                                until Warehouse_Header.Next() = 0;
                            Warehouse_Header.setrange("STF User ADCS Small Item");
                            Warehouse_Header.setrange("STF Status small Warehouse Act");

                            Warehouse_Header.SetFilter("STF User ADCS Precious Item", usname);
                            Warehouse_Header.setfilter("STF Status Precious Wareh Act", '%1|%2', Warehouse_Header."STF Status Precious Wareh Act"::Assigned, Warehouse_Header."STF Status Precious Wareh Act"::"Activity In Progress");
                            if Warehouse_Header.FindSet() then
                                repeat
                                    Warehouse_Header_temp.init();
                                    Warehouse_Header_temp := Warehouse_Header;
                                    if Warehouse_Header_temp.Insert() then;
                                until Warehouse_Header.Next() = 0;

                        end;
                        if role = 'CROSS' then begin

                            Warehouse_Header.SetRange("STF User ADCS Cross Item", usname);
                            Warehouse_Header.SetFilter("STF Status Cross Wareh Act", '%1|%2', Warehouse_Header."STF Status Cross Wareh Act"::Assigned, Warehouse_Header."STF Status Cross Wareh Act"::"Activity In Progress");
                            if Warehouse_Header.FindSet() then
                                repeat

                                    Warehouse_Header_temp.init();
                                    Warehouse_Header_temp := Warehouse_Header;
                                    if Warehouse_Header_temp.Insert() then;
                                until Warehouse_Header.Next() = 0;
                        end;
                        if role = 'COL' then begin
                            Wareh_Activity_Assignment.Reset();
                            Wareh_Activity_Assignment.SetRange("No.", cmdSave);
                            Wareh_Activity_Assignment.SetRange("Action Type", Wareh_Activity_Assignment."Action Type"::Take);
                            Wareh_Activity_Assignment.setrange(Status, Wareh_Activity_Assignment.Status::"Activity Completed");
                            if Wareh_Activity_Assignment.FindSet() then
                                repeat
                                    if typesave = '' then
                                        typesave := Format(Wareh_Activity_Assignment."No. Type")
                                    else
                                        typesave += '|' + Format(Wareh_Activity_Assignment."No. Type");
                                until Wareh_Activity_Assignment.Next() = 0;

                            Warehouse_Header.FilterGroup(-1);

                            Warehouse_Header.setfilter("STF Status Big Warehouse Act", Format(Warehouse_Header."STF Status Big Warehouse Act"::"Activity Completed"));
                            Warehouse_Header.setfilter("STF Status Small Warehouse Act", Format(Warehouse_Header."STF Status Small Warehouse Act"::"Activity Completed"));
                            Warehouse_Header.setfilter("STF Status Precious Wareh Act", Format(Warehouse_Header."STF Status Precious Wareh Act"::"Activity Completed"));

                            if Warehouse_Header.FindSet() then
                                repeat
                                    Assignment.Reset();
                                    Assignment.setrange("No.", Warehouse_Header."No.");
                                    Assignment.SetRange("Action Type", Assignment."Action Type"::place);
                                    Assignment.SetRange(Status, Assignment.Status::"Activity Completed");
                                    if not Assignment.FindSet() then begin
                                        Warehouse_Header_temp.init();
                                        Warehouse_Header_temp := Warehouse_Header;
                                        if Warehouse_Header_temp.Insert() then;
                                    end;
                                until Warehouse_Header.Next() = 0;
                        end;
                        if Warehouse_Header_temp.FindSet() then begin
                            magsave := Warehouse_Header_temp."Location Code";
                            assigned();
                            CurrPage.html.Render(AddItem(cmdv));
                            CurrPage.html.WhenLoaded();

                        end
                        else
                            Message('Code prélèvement invalide!');
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
                    cab.SelectToken('cabq', cabq_token);
                    cabq_token.WriteTo(cabq);
                    cabq := cabq.Replace('"', '');
                    Evaluate(QuantityItem, cabq);

                    scan.Reset();
                    scan.SetRange("Document Type", scan."Document Type"::Vente);
                    scan.SetRange("Document No.", cmdSave);
                    scan.setrange(article, item_no_text);
                    scan.setrange(Magasin, magsave);
                    if role <> 'COL' then
                        scan.setrange(Emplacement, emplacement);
                    scan.setrange(Cancelled, false);
                    total_quantity := 0;
                    old_quantity := 0;
                    if scan.findset() then begin
                        repeat
                            if role = 'COL' then begin
                                total_quantity := total_quantity + scan."Controlled Quantity";
                                if scan.user <> usname then
                                    old_quantity := scan."Controlled Quantity" + old_quantity;
                            end
                            else begin
                                total_quantity := total_quantity + scan."Picked Quantity";
                                if scan.user <> usname then old_quantity := scan."Picked Quantity" + old_quantity;
                            end;
                        until scan.Next() = 0;
                        total_quantity := total_quantity + QuantityItem;

                    end
                    else
                        total_quantity := QuantityItem;
                    CurrPage.html.autoComplete(cab_value, item_no_text, item_description, total_quantity, box_flag_value);
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
                    cab_exists_flag: Integer;

                    Item_Reference: Record "Item Reference";
                    item: record item;
                    emplchange: boolean;
                begin
                    QuantityItem := 0;
                    emplchange := false;
                    cab_exists_flag := 0;

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
                    Warehouse_Activity_Line.Reset();
                    Warehouse_Activity_Line.SetRange("No.", cmdsave);
                    Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::"Pick");
                    Warehouse_Activity_Line.SetRange("Bin Code", cab_value);
                    Warehouse_Activity_Line.setrange("Action Type", Warehouse_Activity_Line."Action Type"::take);
                    Warehouse_Activity_Line.setrange("STF Assigned WMS User Name", usname);
                    if role <> 'COL' then
                        if Warehouse_Activity_Line.FindSet() then
                            if emplacement <> cab_value then
                                if cab_value <> '' then begin
                                    CurrPage.html.rempliremp(cab_value);
                                    emplchange := true;
                                end
                                else
                                    if emplacement = '' then
                                        error('Emplacement non existent dans le prélèvement');
                    Item_Reference.reset();
                    Item_Reference.setrange("Reference Type", Item_Reference."Reference Type"::"Bar Code");
                    Item_Reference.setrange("Reference No.", cab_value);
                    if Item_Reference.findset() then begin
                        cab_exists_flag := 1;
                        item_no_text := Item_Reference."Item No.";
                        item.get(item_no_text);
                        item_description := item.Description;
                    end
                    else
                        if item.get(cab_value) then begin
                            cab_exists_flag := 1;
                            item_description := item.Description;
                            item_no_text := cab_value;
                        end;
                    if not emplchange then
                        if cab_exists_flag = 1 then begin
                            if role <> 'COL' then
                                if emplacement = '' then
                                    error('Veuillez scanner l''emplacement.');
                            Warehouse_Activity_Line.Reset();
                            Warehouse_Activity_Line.SetRange("No.", cmdsave);
                            Warehouse_Activity_Line.SetRange("Item No.", item_no_text);
                            Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::Pick);

                            if role = 'COL' then begin
                                Warehouse_Activity_Line.SetFilter("STF Zone Type", typesave);
                                Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::place);
                            end
                            else begin

                                Warehouse_Activity_Line.SetRange("STF Assigned WMS User Name", usname);
                                Warehouse_Activity_Line.SetRange("Bin Code", emplacement);
                                Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::take);

                            end;
                            if not Warehouse_Activity_Line.findset() then
                                Error('Article non existant');
                            CurrPage.html.remplirqte(cab_value);


                        end else
                            CurrPage.html.cabnonvalide();
                end;



                trigger finish2(item: JsonObject)
                var
                    ligne_Vente: Record "CB Historique Scan";
                begin
                    ligne_Vente.Reset();
                    ligne_Vente.SetRange("Document No.", cmdSave);
                    ligne_Vente.SetRange(user, usname);
                    if ligne_Vente.FindSet() then
                        Page.run(76001, ligne_Vente);
                end;


                trigger fermerModal(item: JsonObject)

                begin



                    Page.run(52003);


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
                    Warehouse_Activity_Line: Record "Warehouse Activity Line";
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
                    Warehouse_Activity_Line.SetRange("Activity Type", Warehouse_Activity_Line."Activity Type"::Pick);
                    if role = 'COL' then begin
                        Warehouse_Activity_Line.setfilter("STF Zone Type", typesave);
                        Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::place);
                    end
                    else begin
                        Warehouse_Activity_Line.SetRange("STF Assigned WMS User Name", usname);
                        Warehouse_Activity_Line.SetRange("Bin Code", emplacement);
                        Warehouse_Activity_Line.SetRange("Action Type", Warehouse_Activity_Line."Action Type"::take);
                    end;
                    if Warehouse_Activity_Line.findset() then
                        repeat
                            if Warehouse_Activity_Line."Qty. Outstanding" < newQuantity then begin
                                if role = 'COL' then
                                    Warehouse_Activity_Line.Validate("STF Controlled Quantity", Warehouse_Activity_Line."Qty. Outstanding")
                                else
                                    Warehouse_Activity_Line.Validate("STF Picked Quantity", Warehouse_Activity_Line."Qty. Outstanding");
                                newQuantity := newQuantity - Warehouse_Activity_Line."Qty. Outstanding";
                            end
                            else begin
                                if role = 'COL' then
                                    Warehouse_Activity_Line.Validate("STF Controlled Quantity", newQuantity)
                                else
                                    Warehouse_Activity_Line.Validate("STF Picked Quantity", newQuantity);
                                newQuantity := 0;
                            end;
                            QuantityInLine += Warehouse_Activity_Line."Qty. Outstanding";
                            Warehouse_Activity_Line.Modify();
                            if role = 'COL' then
                                addormodifycolis(Warehouse_Activity_Line);
                        until Warehouse_Activity_Line.Next() = 0;
                    if QuantityInLine < quantity_dec then begin
                        CurrPage.html.Viderqte();
                        error('Quantité doit étre inférieur à la quantité demandée');

                    end;
                    item.get(article_no_text);
                    scan.Reset();
                    scan.SetRange("Document Type", scan."Document Type"::Vente);
                    scan.SetRange("Document No.", cmdSave);
                    scan.setrange(article, article_no_text);
                    scan.setrange(Magasin, magsave);
                    if role <> 'COL' then
                        scan.setrange(Emplacement, emplacement);
                    scan.setrange(Cancelled, false);
                    scan.setrange("User", usname);
                    if scan.findset() then begin
                        if role = 'COL' then
                            scan.Validate("Controlled Quantity", quantity_dec - old_quantity)
                        else
                            scan.Validate("Picked Quantity", quantity_dec - old_quantity);
                        scan.Validate("Barcode", cab_value);
                        scan.Validate("Description", Item.Description);
                        scan.Modify(true);

                    end
                    else begin
                        scan.Init();
                        scan.Validate("Barcode", cab_value);

                        scan.Validate("Document Type", scan."Document Type"::Vente);
                        scan.Validate("Document No.", cmdSave);
                        scan.Validate(article, article_no_text);
                        scan.Validate(Magasin, magsave);
                        if role <> 'COL' then
                            scan.Validate(Emplacement, emplacement);
                        scan.Validate(Cancelled, false);
                        scan.Validate("User", usname);
                        scan.Validate("Description", Item.Description);
                        if role = 'COL' then
                            scan.Validate("Controlled Quantity", quantity_dec - old_quantity)
                        else
                            scan.Validate("Picked Quantity", quantity_dec - old_quantity);
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
                    CurrPage.html.Ventefocus();


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
        out.APPEND('<body> <h2 style="margin: 0 auto;text-align: center">Accès à la préparation du Vente</h2> <div class="container"> <label for="uname"><b>Utilisateur</b></label>');
        out.APPEND('<select id="user" name="uname">');
        out.APPEND('<option value=""></option>');

        IF ADCS_User.FINDSET() THEN
            REPEAT
                out.APPEND('<option value=' + ADCS_User.Name + '>' + ADCS_User.Name + '</option>');
            UNTIL ADCS_User.NEXT() = 0;

        out.APPEND('</select> ');
        out.APPEND('<label for="role"><b>Type d''utilisateur</b></label>');
        out.APPEND('<select id="role" name="role">');
        out.APPEND('<option value=" "> </option>');
        out.APPEND('<option value="PICK">Picking</option>');
        out.APPEND('<option value="COL">Colisage Et Emballage</option>');
        out.APPEND('<option value="CROSS">Cross</option>');
        out.APPEND('</select>');
        out.APPEND('<label for="psw"><b>Mot de passe</b></label> ');
        out.APPEND('<input  id="passInput" type="password" placeholder="Enter Mot de passe" name="psw" required onKeyDown="if(event.keyCode==13) login();"> ');
        out.APPEND('<div style="text-align:center"><button   id="gu" name="gu" onKeyDown="if(event.keyCode==13) login();" onClick="login()"  style="float: center;">se connecter</button></div></body>');

        EXIT(Format(out));
    END;





    procedure Login2(usname: Text): Text
    var
        ADCS_User: Record "ADCS User";
        Warehouse_Header: Record "Warehouse Activity Header";
        out: TextBuilder;
        Warehouse_Header_temp: Record "Warehouse Activity Header" temporary;
        Assignment: Record "STF Wareh Activity Assignment";


    begin
        ADCS_User.RESET();
        ADCS_User.SETRANGE(Name, usname);

        out.APPEND('<!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style> body { font-family: Arial, Helvetica, sans-serif; margin: 0; padding: 0; } .container { max-width: 800px; margin: 0 auto; padding: 20px; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h1 { text-align: center; margin-bottom: 30px; color: #333; } label { display: block; margin-bottom: 8px; color: #333; } input[type="text"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; } .qte-container { display: grid; } button { background-color: #04AA6D; color: white; padding: 14px 20px; margin: 8px 0; border: none; border-radius: 4px; cursor: pointer; width: 40%; font-size: 16px; transition: background-color 0.3s; } button:hover { background-color: #048f5d; } #resetBtn { background-color: cadetblue; float: left; } #nextBtn { float: right; } #finishBtn { float: left; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } .loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute; z-index: 10; top: 20%; left: 40%; text-align: center; font-size: 10px; } @-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } } @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } } </style> </head> ');
        out.APPEND('<body> <h2>Numéro du Vente Scanné</h2> ');
        out.APPEND('<label for="cmdv"><b>numero Vente</b></label> ');
        out.APPEND('<select id="cmdvl" onChange="remplir()" type="text" name="cmdv" required> ');

        IF ADCS_User.FINDSET() THEN BEGIN



            Warehouse_Header.RESET();
            Warehouse_Header.SetRange(Type, Warehouse_Header.Type::Pick);
            Warehouse_Header.SetRange("Location Code", ADCS_User."STF Location");

            if role = 'PICK' then begin
                Warehouse_Header.SetFilter("STF User ADCS Big Item", usname);
                Warehouse_Header.setfilter("STF Status Big Warehouse Act", '%1|%2', Warehouse_Header."STF Status Big Warehouse Act"::Assigned, Warehouse_Header."STF Status Big Warehouse Act"::"Activity In Progress");
                if Warehouse_Header.FindSet() then
                    repeat
                        Warehouse_Header_temp.init();
                        Warehouse_Header_temp := Warehouse_Header;
                        if Warehouse_Header_temp.Insert() then;
                    until Warehouse_Header.Next() = 0;
                Warehouse_Header.setrange("STF User ADCS Big Item");
                Warehouse_Header.setrange("STF Status Big Warehouse Act");

                Warehouse_Header.SetFilter("STF User ADCS Small Item", usname);
                Warehouse_Header.setfilter("STF Status small Warehouse Act", '%1|%2', Warehouse_Header."STF Status small Warehouse Act"::Assigned, Warehouse_Header."STF Status small Warehouse Act"::"Activity In Progress");
                if Warehouse_Header.FindSet() then
                    repeat
                        Warehouse_Header_temp.init();
                        Warehouse_Header_temp := Warehouse_Header;
                        if Warehouse_Header_temp.Insert() then;
                    until Warehouse_Header.Next() = 0;
                Warehouse_Header.setrange("STF User ADCS Small Item");
                Warehouse_Header.setrange("STF Status small Warehouse Act");

                Warehouse_Header.SetFilter("STF User ADCS Precious Item", usname);
                Warehouse_Header.setfilter("STF Status Precious Wareh Act", '%1|%2', Warehouse_Header."STF Status Precious Wareh Act"::Assigned, Warehouse_Header."STF Status Precious Wareh Act"::"Activity In Progress");
                if Warehouse_Header.FindSet() then
                    repeat
                        Warehouse_Header_temp.init();
                        Warehouse_Header_temp := Warehouse_Header;
                        if Warehouse_Header_temp.Insert() then;
                    until Warehouse_Header.Next() = 0;

            end;
            if role = 'CROSS' then begin


                Warehouse_Header.SetRange("STF User ADCS Cross Item", usname);
                Warehouse_Header.setfilter("STF Status Cross Wareh Act", '%1|%2', Warehouse_Header."STF Status Cross Wareh Act"::Assigned, Warehouse_Header."STF Status Cross Wareh Act"::"Activity In Progress");
                if Warehouse_Header.FindSet() then
                    repeat
                        Warehouse_Header_temp.init();
                        Warehouse_Header_temp := Warehouse_Header;
                        if Warehouse_Header_temp.Insert() then;
                    until Warehouse_Header.Next() = 0;
            end;
            if role = 'COL' then begin
                Warehouse_Header.FilterGroup(-1);

                Warehouse_Header.setfilter("STF Status Big Warehouse Act", Format(Warehouse_Header."STF Status Big Warehouse Act"::"Activity Completed"));
                Warehouse_Header.setfilter("STF Status Small Warehouse Act", Format(Warehouse_Header."STF Status Small Warehouse Act"::"Activity Completed"));
                Warehouse_Header.setfilter("STF Status Precious Wareh Act", Format(Warehouse_Header."STF Status Precious Wareh Act"::"Activity Completed"));

                if Warehouse_Header.FindSet() then
                    repeat
                        Assignment.Reset();
                        Assignment.setrange("No.", Warehouse_Header."No.");
                        Assignment.SetRange("Action Type", Assignment."Action Type"::place);
                        Assignment.SetRange(Status, Assignment.Status::"Activity Completed");
                        if not Assignment.FindSet() then begin
                            Warehouse_Header_temp.init();
                            Warehouse_Header_temp := Warehouse_Header;
                            if Warehouse_Header_temp.Insert() then;
                        end;
                    until Warehouse_Header.Next() = 0;
            end;
            out.APPEND('<option value=' + '' + '>' + '' + '</option>');

            if Warehouse_Header_temp.findlast() then
                REPEAT
                    out.APPEND('<option value=' + Warehouse_Header_temp."No." + '>' + Warehouse_Header_temp."No." + '</option>');
                UNTIL Warehouse_Header_temp.NEXT(-1) = 0;
        END;

        out.APPEND('</select> ');
        out.APPEND('<input type="text" id="cmdv" name="cmdv" required onKeyDown="if(event.keyCode==13) go();"> ');
        out.APPEND('<div style="text-align:center"><button id="gu" name="gu" onKeyDown="if(event.keyCode==13) go();" onClick="go()" style="float: center;">Accès</button></div>');
        out.APPEND('</body> </html>');

        EXIT(Format(out));
    end;

    procedure assigned()
    var
        Assignment: Record "STF Wareh Activity Assignment";
    begin
        Assignment.Reset();
        Assignment.setrange("No.", cmdSave);
        Assignment.setrange(Status, Assignment.Status::Assigned);
        if role = 'COL' then
            Assignment.SetRange("Action Type", Assignment."Action Type"::place)
        else begin
            Assignment.SetRange("Action Type", Assignment."Action Type"::take);

            Assignment.SetRange("User Assigned", usname);

        end;
        if Assignment.FindSet() then
            repeat
                if role = 'COL' then
                    Assignment.Validate("User Assigned", usname);
                Assignment.Validate(Status, Assignment.Status::"Activity In Progress");
                Assignment.Modify();
            until Assignment.Next() = 0;


    end;

    procedure addormodifycolis(warehouseline: record "Warehouse Activity Line")
    var
        Colis: record "CB Colis";
        lineno: integer;
        finalquantity: decimal;
    //warehouseline2: record "Warehouse Activity Line";
    begin
        finalquantity := 0;
        // warehouseline2.Reset();
        // warehouseline2.SetRange("Action Type", warehouseline2."Action Type"::Take);
        // warehouseline2.SetRange("No.", warehouseline."No.");
        // warehouseline2.SetRange("Source Type", warehouseline."Source Type");
        // warehouseline2.SetRange("Source Subtype", warehouseline."Source Subtype");
        // warehouseline2.SetRange("Source Line No.", warehouseline."Source Line No.");
        // if warehouseline2.findset() then begin
        //     finalquantity := warehouseline2."CB picked Quantity";
        //     warehouseline2.Validate("CB Controlled Quantity", warehouseline."CB Controlled Quantity");
        //     warehouseline2.Modify();
        // end;
        // warehouseline.Validate("CB Picked Quantity", finalquantity);
        // warehouseline.Modify();
        if colisno = '' then
            error('veuillez scanner le colis');
        lineno := 10000;
        if Colis.FindLast() then
            lineno := Colis."line No" + 10000;
        Colis.Reset();
        Colis.SetRange("Colis No", colisno);

        Colis.SetRange("Picking No", warehouseline."No.");
        Colis.SetRange("Picking Line No", warehouseline."Line No.");
        if colis.FindSet() then begin
            colis.Validate("Quantity", warehouseline."STF Controlled Quantity");
            //colis.Validate("Final Quantity", finalquantity);
            colis.Modify();
        end
        else begin
            Colis.Init();
            Colis.Validate("Line No", lineno);

            Colis.Validate("Colis No", colisno);
            Colis.Validate("Picking No", warehouseline."No.");
            Colis.Validate("Picking Line No", warehouseline."Line No.");
            colis.Validate("Quantity", warehouseline."STF Controlled Quantity");
            //colis.Validate("Final Quantity", finalquantity);
            colis.Insert();
        end;
    end;

    procedure AddItem(cmdv: Text): Text
    var
        out: TextBuilder;
    begin
        out.APPEND('<!DOCTYPE html> <html> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style> .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.7); justify-content: center; align-items: center; } .modal-content { background-color: #fff; padding: 20px; border-radius: 5px; text-align: center; } .modal-btn { margin: 10px; padding: 10px 20px; cursor: pointer; } body { font-family: Arial, Helvetica, sans-serif; background-color: #f9f9f9; margin: 0; padding: 0; } .container { max-width: 800px; margin: 0 auto; padding: 20px; background-color: #fff; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); } h1 { text-align: center; margin-bottom: 30px; color: #333; } label { display: block; margin-bottom: 8px; color: #333; } input[type="text"], select { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; } .qte-container { display: grid; } button { background-color: #04AA6D; color: white; padding: 14px 20px; margin: 10px 0; border: none; border-radius: 4px; cursor: pointer; width: 40%; font-size: 16px; transition: background-color 0.3s; } button:hover { background-color: #048f5d; } #resetBtn { background-color: cadetblue; float: left; margin-right: 20px; } #nextBtn { float: right; } #finishBtn { float: left; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } .loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute; z-index: 10; top: 20%; left: 40%; text-align: center; font-size: 10px; } @-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } } @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } } </style> </head> ');
        out.APPEND('<body><center> <h2 style="color : red;">Vente: ' + cmdv + '</h2> </center>');
        out.APPEND('<center> <h3 style="color : red;"> Magasin: ' + magsave + '</h3> </center>');
        out.APPEND('<div style="text-align:center;display:none;"><label for="increment"><b style="color : red;">Voulez-vous incrémenter?</b></label>');
        out.APPEND('<input type="checkbox" id="increment" name="increment" value="true" checked></div>');

        if role = 'COL' then begin
            out.APPEND('<label for="Colis" style:"margin-right:10px"><b>Colis</b></label> ');
            out.APPEND('<input tabindex="-1" enterkeyhint="done" id="Colis" type="text" name="Colis" onKeyDown="if(event.keyCode==27) Colis.select();" onKeyPress="if(event.keyCode==13) SelectCab();" required>');
        end
        else
            out.APPEND('<input style="display:None;" tabindex="-1" enterkeyhint="done" id="Colis" type="text" name="Colis" onKeyDown="if(event.keyCode==27) Colis.select(); required>');



        out.APPEND('<div id="all" style="display: flex; gap: 2%;width:100%;"> <div id="allcab" style="width:100%;" > <label for="cab"><b>Code à barre</b></label> <input type="text" style="width:49%;" id="cab" tabindex="-1" enterkeyhint="done" name="cab" placeholder="Article" onKeyPress="if(event.keyCode==13) passerCab(this);"  required> <input placeholder="Quantité" style="width:48%;margin-left:2%;" type="text" id="cabq" tabindex="-1" enterkeyhint="done" name="cabquantity" onKeyPress="if(event.keyCode==13) passerCabQuantity(this);" required></div> <div id="alllot" style="display: none; flex-direction: column; align-items: center;"> <label id="lotl" for="Lot"><b>Numéro de Lot</b></label> <input tabindex="-1" enterkeyhint="done" id="Lot" type="text" name="Lot" onKeyDown="if(event.keyCode==27) Lot.select();" onKeyPress="if(event.keyCode==13) check();"  required> </div> </div>');
        out.APPEND('<div id="alldate" style="display: none; flex-direction: column; align-items: center;"> <label id="daeExl" for="daeEx"><b>Date Déxpiration</b></label> <input id="daeEx" type="text" name="daeEx" onKeyDown="if(event.keyCode==27) daeEx.select();" onKeyPress="if(event.keyCode==13) check();" required> </div>');
        out.APPEND('<label for="desc"><b>Description</b></label> <input id="desc" type="text" name="desc" readonly="readonly">');

        out.APPEND('<label for="qtea" style:"margin-right:10px"><b>Quantité</b></label> ');
        out.APPEND('<input tabindex="-1" enterkeyhint="done" id="qtes" type="text" name="qtea" onKeyDown="if(event.keyCode==27) qtea.select();" onKeyPress="if(event.keyCode==13) next2();" required>');
        out.APPEND('<input tabindex="-1" enterkeyhint="done" style="display:none;" id="qtea" type="text" name="qtea" style="margin-left:1%;width:47%; text-align:center; font-size:16px;" onKeyDown="if(event.keyCode==27) qtea.select();" onKeyPress="if(event.keyCode==13) next2();"   required>');
        out.APPEND('<label for="article"><b>Article</b></label> <input id="articleNo" type="text" name="article" readonly="readonly" required>');
        if role = 'COL' then
            out.APPEND('<label style="display:none;"  for="emp"><b>Emplacement</b></label> <input  id="emp" type="text" name="emp" disabled="true" style="display:none;">')
        else
            out.APPEND('<label  for="emp"><b>Emplacement</b></label> <input  id="emp" type="text" name="emp" disabled="true">');
        out.APPEND('</input> ');
        out.APPEND('<label id="cabcopy" style="display:none;"></label>');
        out.APPEND('<div style="">');

        out.APPEND('<input id="message" type="text" name="message" style="width:240px;display: inline-block;font-size:16px; background: rgba(0, 0, 0, 0); border: none;"><br>');
        out.APPEND('<div>');
        out.APPEND('<div style="text-align:center;"> <button onclick="reset()" style="margin-right:4%;background-color: cadetblue;width: 40%;">Réinitialiser</button> <button onclick="finish2()" style="width:40%;margin-left:4%;">Aperçu</button> <button onclick="terminer()" style="margin-leftt:4%;background-color: red;width: ">Terminer</button> </div>');
        out.APPEND('<div id="myModal" class="modal";> <div class="modal-content" style="margin-top:220px;"> <p> Le Vente a été terminée avec succès. Souhaitez-vous continuer ou fermer ?</p> <button class="modal-btn" onclick="fermerModal()">Sortir de lapplication</button> <button id="cmdv" name="cmdv" type="text" onclick="back()" class="modal-btn">Revenir au menu précédent</button> </div> </div>');

        out.APPEND('</body> </html>');

        EXIT(Format(out));
    end;

    var
        increment, usname, cmdSave, magsave, role, colisno, typesave : Text;
        item_no_text: Text;
        item_description: Text;
        box_flag_value: Text;
        cab_value: Text;

        old_quantity, QuantityItem : decimal;
        emplacement: text;



}
