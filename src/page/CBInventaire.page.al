page 76007 "CB Inventaire"
{
    caption = 'Inventaire';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            usercontrol(html; "CB HTML")
            {
                ApplicationArea = all;
                trigger ControlReady()
                begin
                    CurrPage.html.Render(Login());
                end;

                trigger remplirqte2(cab: JsonObject)
                var
                    cabq, emp : text;
                    cabq_token, empToken : JsonToken;
                    scan: record "CB historique scan";
                    total_quantity: Decimal;

                    QuantityItem: decimal;


                begin
                    cab.SelectToken('empl', empToken);
                    empToken.WriteTo(emp);
                    emp := emp.Replace('"', '');
                    if cab_exists_flag = 0 then
                        error('veuillez scanner l''article');
                    cab.SelectToken('cabq', cabq_token);
                    cabq_token.WriteTo(cabq);
                    cabq := cabq.Replace('"', '');
                    Evaluate(QuantityItem, cabq);

                    Scan.reset();
                    Scan.SetRange(Magasin, magSave);
                    Scan.setrange(article, item_no_text);
                    Scan.SetFilter("Document No.", invSave);
                    Scan.SetFilter(Enregistrement, enregistrementSave);
                    Scan.setrange(Emplacement, emp);
                    total_quantity := 0;
                    old_quantity := 0;
                    if scan.findset() then begin
                        repeat
                            total_quantity := total_quantity + scan."Qte";
                            if scan.user <> usersave then
                                old_quantity := scan."Qte" + old_quantity;

                        until scan.Next() = 0;
                        total_quantity := total_quantity + QuantityItem;

                    end
                    else
                        total_quantity := QuantityItem;
                    CurrPage.html.autoComplete(item_no_text, item_description, emp, '', total_quantity, total_quantity, total_quantity, 'false');
                end;

                trigger CheckUser(user: JsonObject)
                var
                    userToken: JsonToken;
                    passToken: JsonToken;
                    usname: Text;
                    uspass: Text;
                    ADCSUser: Record "ADCS User";
                begin
                    ADCSUser.reset();
                    user.SelectToken('us', userToken);
                    user.SelectToken('ps', passToken);

                    userToken.WriteTo(usname);
                    passToken.WriteTo(uspass);

                    usname := usname.Replace('"', '');
                    uspass := uspass.Replace('"', '');

                    if ADCSUser.Get(usname) then
                        if ADCSUser."CB Password" <> uspass then
                            Error('Mot de passe incorrect !');
                    if usname = '' then
                        Error('Utilisateur incorrect !');
                    CurrPage.html.Render(Login2(usname));

                    userSave := usname;
                end;

                trigger scan(scav: JsonObject)
                var
                    a: Integer;
                    INV: Record "CB Historique Scan";
                    WhseJnlLine: Record "Warehouse Journal Line";
                    ItemJnlLine: Record "Item Journal Line";
                    InvMgt: Codeunit "CB Inventory Mgt";
                    TemplateName: Code[10];
                begin
                    if InvMgt.IsDirectedPutAwayAndPick(magSave) then begin
                        TemplateName := InvMgt.GetWhsePhysInvTemplateName();
                        WhseJnlLine.Reset();
                        WhseJnlLine.SetRange("Journal Template Name", TemplateName);
                        WhseJnlLine.SetRange("Journal Batch Name", invSave);
                        WhseJnlLine.SetRange("Location Code", magSave);
                        WhseJnlLine.SetRange("CB Inventaire Validé", false);
                        WhseJnlLine.SetRange("CB Comptage 1", 0);
                        if WhseJnlLine.FindSet() then
                            a := WhseJnlLine.Count;
                    end else begin
                        TemplateName := InvMgt.GetItemPhysInvTemplateName();
                        ItemJnlLine.Reset();
                        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
                        ItemJnlLine.SetRange("Journal Batch Name", invSave);
                        ItemJnlLine.SetRange("Location Code", magSave);
                        ItemJnlLine.SetRange("CB Inventaire Validé", false);
                        ItemJnlLine.SetRange("CB Comptage 1", 0);
                        if ItemJnlLine.FindSet() then
                            a := ItemJnlLine.Count;
                    end;
                    CurrPage.html.nonscanned(Format(a));
                end;

                trigger info(info: JsonObject)
                var
                    mag: Text;
                    inv: text;
                    comp: text;
                    magToken: JsonToken;
                    invToken: JsonToken;
                    compToken: JsonToken;
                    enregistrement: Text;
                    enregistrementToken: JsonToken;
                    comptage: integer;
                begin

                    info.SelectToken('mag', magToken);
                    info.SelectToken('inv', invToken);
                    info.SelectToken('comp', compToken);
                    info.SelectToken('enregistrement', enregistrementToken);

                    magToken.WriteTo(mag);
                    invToken.WriteTo(inv);
                    compToken.WriteTo(comp);
                    enregistrementToken.WriteTo(enregistrement);

                    mag := mag.Replace('"', '');
                    inv := inv.Replace('"', '');
                    comp := comp.Replace('"', '');
                    compsave := comp;

                    enregistrement := enregistrement.Replace('"', '');

                    enregistrementSave := enregistrement;
                    invSave := inv;

                    magSave := mag;

                    if ((enregistrementSave = '') or (enregistrementSave = 'undefined')) then
                        Error('Veuillez choisir un Identifiant');

                    if (mag = 'ASUPPRIMER') then
                        Error('Veuillez choisir un autre magasin, le magasin selectionné est invalide')
                    else begin
                        Evaluate(comptage, comp);
                        CurrPage.html.Render(AddItem(inv, mag, comptage, comptage));
                        CurrPage.html.WhenLoaded();
                    end;
                end;

                trigger CheckCAB(cab: JsonObject)
                var
                    emplToken: JsonToken;
                    empl: Text;
                    cabToken: JsonToken;
                    cabv: Text;
                    ICR: Record "Item Reference";
                    item2: Record Item;
                    b: Boolean;
                    itemNo: text;
                    Bin: Record Bin;
                    compToken: JsonToken;
                    comp: Text;
                    cabFirstPart: text;
                    cabFirstPartToken: JsonToken;
                    cleanedCab: text;
                    cleanedBin: text;


                begin
                    cab.SelectToken('cab', cabToken);
                    cabToken.WriteTo(cabv);
                    cabv := cabv.Replace('"', '');




                    cab.SelectToken('comp', compToken);
                    compToken.WriteTo(comp);
                    comp := comp.Replace('"', '');


                    cab.SelectToken('cabFirstPart', cabFirstPartToken);
                    cabFirstPartToken.WriteTo(cabFirstPart);
                    cabFirstPart := cabFirstPart.Replace('"', '');

                    cab.SelectToken('empl', emplToken);
                    emplToken.WriteTo(empl);
                    empl := empl.Replace('"', '');



                    cleanedCab := analyseScannedCode(cabv);
                    cleanedBin := analyseScannedBin(cabv);
                    ICR.SetCurrentKey("Reference Type", "Reference No.");
                    ICR.SetRange("Reference Type", ICR."Reference Type"::"Bar Code");
                    ICR.setfilter("Reference No.", '%1|%2|%3', '' + cabv + '', '' + cleanedCab + '', '' + cleanedCab.trim() + '');
                    b := false;

                    if ((ICR.Find('-'))) then begin
                        b := true;
                        itemNo := ICR."Item No.";
                        ITEM2.get(itemNo);
                        item_description := ITEM2.Description;
                    end else begin
                        ITEM2.setfilter("No.", '%1|%2|%3', '' + cabv + '', '' + cleanedCab + '', '' + cleanedCab.trim() + '');

                        if ((ITEM2.Find('-'))) then begin
                            b := true;
                            itemNo := ITEM2."No.";
                            item_description := ITEM2.Description;

                        end;
                    end;

                    Bin.reset();
                    Bin.Setrange("Location Code", magSave);
                    Bin.setrange(Code, empl);
                    if not Bin.Find('-') then begin
                        CurrPage.html.cabVerif('');
                        error('veuillez vérifier l''emplacement');
                    end;
                    emplsave := empl;
                    if (not b) then
                        CurrPage.html.cabVerif('')

                    else begin
                        item_no_text := itemNo;
                        cab_exists_flag := 1;
                        CurrPage.html.focusqte();
                    end;

                end;

                trigger item(item: JsonObject)
                var

                    inv: Record "CB Historique Scan";
                    inv2: Record "CB Historique Scan";

                    itemToken: JsonToken;
                    descToken: JsonToken;
                    qteToken: JsonToken;
                    cabToken: JsonToken;
                    empToken: JsonToken;
                    compToken: JsonToken;
                    emp: Text;
                    itemNo: Text;
                    desc: Text;
                    qte: Text;
                    num: Decimal;
                    cab: Text;
                    cabv: Text;
                    comp: Text;
                begin

                    item.SelectToken('art', itemToken);
                    item.SelectToken('des', descToken);
                    item.SelectToken('qte', qteToken);
                    item.SelectToken('cab', cabToken);
                    item.SelectToken('empl', empToken);
                    item.SelectToken('comp', compToken);


                    itemToken.WriteTo(itemNo);
                    descToken.WriteTo(desc);
                    qteToken.WriteTo(qte);
                    cabToken.WriteTo(cab);

                    empToken.WriteTo(emp);
                    compToken.WriteTo(comp);
                    itemNo := itemNo.Replace('"', '');
                    desc := desc.Replace('"', '');
                    qte := qte.Replace('"', '');
                    cab := cab.Replace('"', '');
                    emp := emp.Replace('"', '');
                    comp := comp.Replace('"', '');



                    cabv := cab;


                    empSave := emp;
                    compSave := comp;
                    inv.reset();
                    inv.article := itemNo;
                    inv.Barcode := cabv;
                    inv.Description := desc;

                    if (cabv <> '') and (desc <> '') and (emp <> '') then
                        if not (Evaluate(num, qte)) then
                            Message('La quantité saisie est incorrect!') else
                            if (num < 0) then
                                Message('La quantité saisie est inférieur à 0')
                            else begin
                                inv."Document Type" := inv."Document Type"::Inventaire;
                                inv.Qte := num - old_quantity;
                                inv."Document No." := invSave;
                                inv.user := userSave;
                                inv.Magasin := magSave;
                                inv.Emplacement := emp;

                                Evaluate(inv.comptage, compSave);


                                Evaluate(inv.Enregistrement, enregistrementSave);
                                inv2.setrange("Document Type", inv2."Document Type"::Inventaire);
                                inv2.setrange("Document No.", invSave);
                                inv2.setrange(user, userSave);
                                inv2.setrange(Magasin, magSave);
                                inv2.setrange(Emplacement, emp);
                                inv2.setfilter(Enregistrement, enregistrementSave);
                                inv2.setrange(article, itemNo);
                                inv2.setfilter(comptage, compSave);
                                if inv2.Find('-') then begin
                                    inv2.Qte := inv.qte;
                                    Evaluate(inv2.comptage, compSave);
                                    if inv2.Modify() then
                                        MAJOrderRecordLine(inv2);
                                end
                                else
                                    if inv.insert() then
                                        MAJOrderRecordLine(inv);
                            end;
                end;


                trigger finish(item: JsonObject)
                var
                    USER: Record "CB USER";
                    inv: text[50];
                    art: text;
                    artToken: JsonToken;
                    compToken: JsonToken;
                    us: text;
                    comp: text;
                begin
                    inv := invSave;
                    us := userSave;
                    item.SelectToken('art', artToken);
                    item.SelectToken('comp', compToken);
                    artToken.WriteTo(art);
                    art := art.Replace('"', '');

                    compToken.WriteTo(comp);
                    comp := comp.Replace('"', '');

                    USER.Reset();
                    USER.SetRange(User, us);
                    if USER.FindFirst() then;

                    Message('Enregistrement Terminé');
                end;

                trigger UpdateBinQty(binQty: JsonObject)
                var
                    INV: Record "CB Historique Scan";
                    item: record Item;

                    articleNo: text;
                    articleNoToken: JsonToken;
                    empl: text;
                    emplToken: JsonToken;
                    comp: text;
                    compToken: JsonToken;
                    qtyempl: Decimal;
                begin

                    binQty.SelectToken('articleNo', articleNoToken);
                    articleNoToken.WriteTo(articleNo);
                    articleNo := articleNo.Replace('"', '');

                    binQty.SelectToken('empl', emplToken);
                    emplToken.WriteTo(empl);
                    empl := empl.Replace('"', '');

                    binQty.SelectToken('comp', compToken);
                    compToken.WriteTo(comp);
                    comp := comp.Replace('"', '');

                    compSave := comp;




                    item.Get(articleNo);



                    INV.reset();
                    INV.SetRange(INV.Magasin, magSave);
                    INV.setrange(INV.article, articleNo);
                    INV.SetFilter(INV.Enregistrement, enregistrementSave);
                    INV.SetFilter(INV.comptage, comp);
                    INV.SetFilter(INV."Document No.", invSave);
                    if empl <> '' then
                        INV.SetFilter(Emplacement, empl);




                    qtyempl := 0;
                    if INV.FindSet() THEN
                        repeat


                            qtyempl := qtyempl + INV.Qte;

                        until INV.Next() = 0;


                    CurrPage.html.UpdateQty(item."No.", item.Description, item."Base Unit of Measure", qtyempl, item.Inventory, 0, '');

                end;

                trigger finish2(item: JsonObject)
                var
                    USER: Record "CB USER";
                    INVV: Record "CB Historique Scan";
                    inv: text[50];
                    art: text;
                    artToken: JsonToken;
                    compToken: JsonToken;
                    us: text;
                    comp: text;
                begin
                    inv := invSave;
                    us := userSave;
                    item.SelectToken('art', artToken);
                    item.SelectToken('comp', compToken);
                    artToken.WriteTo(art);
                    art := art.Replace('"', '');

                    compToken.WriteTo(comp);
                    comp := comp.Replace('"', '');

                    USER.Reset();
                    USER.SetRange(User, us);
                    if USER.FindFirst() then;

                    INVV.Reset();
                    INVV.SetRange("Document No.", inv);
                    INVV.SetFilter(Enregistrement, enregistrementSave);
                    INVV.SetRange(user, us);
                    if INVV.FindSet() then;
                    Page.Run(76001, INVV);
                end;
            }
        }
    }
    actions
    {
        area(Processing)
        {
        }
    }
    procedure finish3(item: JsonObject)
    var
        USER: Record "CB USER";
        adcs: Record "ADCS User";
        InvMgt: Codeunit "CB Inventory Mgt";
        art: Text;
        artToken: JsonToken;
        compToken: JsonToken;
        comp: Text;
        us: Text;
    begin
        item.SelectToken('art', artToken);
        artToken.WriteTo(art);
        art := art.Replace('"', '');

        item.SelectToken('comp', compToken);
        compToken.WriteTo(comp);
        comp := comp.Replace('"', '');

        us := userSave;
        USER.Reset();
        USER.SetRange(User, us);
        if USER.FindFirst() then;
        adcs.Get(us);

        if InvMgt.IsDirectedPutAwayAndPick(adcs."STF Location") then
            InvMgt.FinalizeWhseInventory(
                InvMgt.GetWhsePhysInvTemplateName(),
                invSave,
                adcs."STF Location")
        else
            InvMgt.FinalizeItemInventory(
                InvMgt.GetItemPhysInvTemplateName(),
                invSave,
                adcs."STF Location");

        Message('Inventaire validé avec succès.');
    end;

    procedure Login(): Text
    var
        US: Record "ADCS User";
        out: Text;
    begin

        out := '<!DOCTYPE html> <html> <head><meta name="viewport" content="width=device-width, initial-scale=1"> <style>html { overflow-y: hidden; } body {font-family: Arial, Helvetica, sans-serif;} form {border: 3px solid #f1f1f1;} input[type=text], input[type=password] { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } select{ width: 100%; padding: 10px 10px; margin: 2px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } button { background-color: #04AA6D; color: white; padding: 20px 15px; margin: 6px 0; border: none; cursor: pointer; width: 100%; } button:hover { opacity: 0.8; } .cancelbtn { width: auto; padding: 10px 18px; background-color: #f44336; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } .container { padding: 16px; } span.psw { float: right; padding-top: 16px; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } </style> </head> ';
        out += '<body> <h2>Accès Inventaire</h2><!--<div><center><img width="100px"height="100px" src="C:\Users\ILAHBIB\Desktop\LeMoteur\LeMoteurCodebarre\SRC\Pages\logo.png"/></center></div>--> <div class="container"> <label for="uname"><b>Utilisateur</b></label>';
        out += '<select id="user" name="uname">';
        out += '<option value="' + '' + '">' + '' + '</option>';
        if US.FindSet() then
            repeat
                out += '<option value="' + US.name + '">' + US.Name + '</option>';
            until US.Next() = 0;
        out += '</select> ';

        out += '<label for="psw"><b>Mot de passe</b></label> ';
        out += '<input  id="passInput" type="password" placeholder="Enter Mot de passe" onKeyPress="if(event.keyCode==13) login();"name="psw" required> ';


        out += '<button onClick="login()">Se connecter</button> </div> </body> </html>';

        exit(out);
    end;


    procedure Login2(usname: Text): Text
    var
        US: Record "CB USER";
        out: Text;
        comptage: text;
        adcs: record "ADCS User";
        batchName: Text;
        InvMgt: Codeunit "CB Inventory Mgt";
    begin
        adcs.Get(usname);
        US.Reset();
        US.SetRange(User, usname);
        out := '<!DOCTYPE html><html><script>function call(){ if (event.keyCode === 13) { go(); } } </script> </script> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style>label{font-size:12px;} body {font-family: Arial, Helvetica, sans-serif;} form {border: 3px solid #f1f1f1;} input[type=text], input[type=password] { width: 100%; padding: 2px 4px; margin: 2px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box;font-size:10px; } select{ width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } button { background-color: #04AA6D; color: white; padding: 15px 20px; margin: 8px 0; border: none; cursor: pointer; width: 100%; } button:hover { opacity: 0.8; } .cancelbtn { width: auto; padding: 10px 18px; background-color: #f44336; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } .container { padding: 16px; } span.psw { float: right; padding-top: 16px; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 1000px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } </style> </head> ';
        out += '<body> <h2>Inventaire </h2> <div class="container"> ';
        out += '<label for="mag"><b>Identifiant d''inventaire</b></label>';

        out += '<select id="maga" name="maga"  onChange=" remplir(value)" >';
        out += '<option ></option>';
        if US.FindSet() then
            repeat
                batchName := '';
                case US."CB Inv. Journal Type" of
                    US."CB Inv. Journal Type"::"Feuille Entrepôt":
                        batchName := US."CB Whse. Inv. Jnl Batch";
                    US."CB Inv. Journal Type"::"Feuille Article":
                        batchName := US."CB Inv. Journal Batch";
                end;

                if batchName <> '' then begin
                    comptage := Format(US."CB Comptage");
                    out += '<option value="' + US.User + '/' + adcs."STF Location" + '/' + batchName + '/' + Format(US."CB Comptage") + '/' + comptage + '">' + US.User + '/' + adcs."STF Location" + '/' + batchName + '/' + Format(US."CB Comptage") + '/' + comptage + '</option>';
                end;
            until US.Next() = 0;

        out += '</select> ';
        out += '<label for="magasin"><b>Magasin</b></label>';
        out += '<input  id="mag" type="text"  name="mag" readonly="readonly">';
        out += '<label for="inventaire"><b>Inventaire</b></label>';
        out += '<input id="inv" type="text"  name="inv" readonly="readonly"  >';
        out += '<label for="enregistrement"><b>Enregistrement</b></label>';
        out += '<input  id="enregistrement" type="text"  name="enregistrement"  readonly="readonly"  >';
        out += '<label for="comp"><b>Comptage</b></label>';
        out += '<input id="comp" type="text"  name="comp" readonly="readonly"  >';
        out += '<button id="gu" name="gu" onKeyDown="if(event.keyCode==13) go();" onClick="go()" >Accéder à l''inventaire</button>';


        exit(out);

    end;

    procedure AddItem(inv: Text[50]; mag: Text; comptage: Integer; compUs: Integer): Text
    var
        out: TextBuilder;
    begin
        out.Append(
            '<!DOCTYPE html><html><head>' +
            '<meta name="viewport" content="width=device-width, initial-scale=1">' +
            '<style>' +

            'body{font-family:Arial,Helvetica,sans-serif;background:#f9f9f9;margin:0;padding:0;}' +

            '.container{max-width:margin:auto;padding:1rem;background:#fff;' +
            'box-shadow:0 0 0.6rem rgba(0,0,0,0.1);}' +

            'h2,h3{text-align:center;margin:0.6rem 0;}' +

            'label{display:block;margin-top:0.8rem;font-weight:bold;}' +

            'input,textarea,select{width:100%;padding:0.7rem;font-size:1rem;' +
            'border:0.08rem solid #ccc;border-radius:0.3rem;box-sizing:border-box;}' +

            'textarea{resize:vertical;min-height:4rem;}' +

            '.readonly{background:#f5f5f5;}' +

            '.row{display:flex;gap:4%;width:100%;}' +
            '.col{flex:1;}' +

            '.buttons{display:flex;gap:5%;margin-top:1.2rem;}' +

            'button{flex:1;padding:0.9rem;font-size:1rem;border:none;' +
            'border-radius:0.3rem;cursor:pointer;color:#fff;background:#04AA6D;}' +

            '.secondary{background:cadetblue;}' +

            '@media(max-width:40rem){.row{flex-direction:column;}}' +

            '</style></head>'
        );

        out.Append(
            '<body><div class="container">' +

            '<h2 style="color:red;">Inventaire : ' + inv +
            ' - Comptage : ' + Format(comptage) + '</h2>' +

            '<h3 style="color:cadetblue;">Magasin : ' + mag + '</h3>' +

            '<input type="hidden" id="comp" value="' + Format(comptage) + '">' +
            '<label  for="emp"><b>Emplacement</b></label> <input  id="empl" type="text" name="emp" onkeypress="if(event.keyCode==13) focuscab();">' +

            '<label>Code à barre</label>' +
            '<input id="cab" tabindex="-1" enterkeyhint="done" ' +

            'onkeypress="if(event.keyCode==13) passerCab(this);"style="width:48%;" autocomplete="off"><input placeholder="Quantité" style="width:48%;margin-left:2%;" type="text" id="cabq" tabindex="-1" enterkeyhint="done" name="cabquantity" onKeyPress="if(event.keyCode==13) passerCabQuantity(this);" required>' +

            '<label>Article</label>' +
            '<input id="articleNo" class="readonly" readonly>' +

            '<label>Description</label>' +
            '<textarea id="desc" class="readonly" readonly></textarea>' +

            '<label>Quantité</label>' +
            '<input id="qte" tabindex="-1" enterkeyhint="done" ' +
            'onkeypress="if(event.keyCode==13) next();">' +

            '<label>Articles non scannés</label>' +
            '<input id="nonScanned" readonly ' +
            'onclick="handleNonScannedClick()" ' +
            'style="cursor:pointer;background:#e0f7ff;font-weight:bold;text-align:center;">' +

            '<input id="message" style="margin-top:0.6rem;border:none;background:transparent;">' +

            '<div class="buttons">' +
                '<button class="secondary" onclick="reset()">Réinitialiser</button>' +
                '<button class="secondary" onclick="finish2()">Aperçu</button>' +
                '<button onclick="next1()">Valider</button>' +
            '</div>' +

            '</div></body></html>'
        );

        exit(out.ToText());
    end;



    local procedure MAJOrderRecordLine(inv2: Record "CB Historique Scan")
    var
        Location: Record Location;
    begin
        if not Location.Get(inv2.Magasin) then
            Error('Magasin %1 introuvable.', inv2.Magasin);

        if Location."Directed Put-away and Pick" then
            MAJWhseJournalLine(inv2)
        else
            MAJItemJournalLine(inv2);
    end;

    local procedure MAJWhseJournalLine(inv2: Record "CB Historique Scan")
    var
        InvMgt: Codeunit "CB Inventory Mgt";
        WhseJnlLine: Record "Warehouse Journal Line";
        ExistingWhseJnlLine: Record "Warehouse Journal Line";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TemplateName: Code[10];
        LineNo: Integer;
        ComptageNo: Integer;
        FinalQty: Decimal;
        DocNo: Code[20];
        RegDate: Date;
    begin
        TemplateName := InvMgt.GetWhsePhysInvTemplateName();
        Evaluate(ComptageNo, compSave);
        FinalQty := inv2.Qte + old_quantity;

        InvMgt.CheckAlreadyCountedWhse(TemplateName, invSave, inv2.Magasin, inv2.article, inv2.Emplacement, ComptageNo);

        WhseJnlLine.Reset();
        WhseJnlLine.SetRange("Journal Template Name", TemplateName);
        WhseJnlLine.SetRange("Journal Batch Name", invSave);
        WhseJnlLine.SetRange("Location Code", inv2.Magasin);
        WhseJnlLine.SetRange("Item No.", inv2.article);
        WhseJnlLine.SetRange("Bin Code", inv2.Emplacement);
        if WhseJnlLine.FindFirst() then begin
            SetWhseComptageQty(WhseJnlLine, ComptageNo, FinalQty);
            WhseJnlLine.Validate("Qty. (Phys. Inventory)", FinalQty);
            WhseJnlLine.Modify(true);
        end else begin
            DocNo := '';
            RegDate := Today;
            ExistingWhseJnlLine.Reset();
            ExistingWhseJnlLine.SetRange("Journal Template Name", TemplateName);
            ExistingWhseJnlLine.SetRange("Journal Batch Name", invSave);
            if ExistingWhseJnlLine.FindLast() then begin
                LineNo := ExistingWhseJnlLine."Line No." + 10000;
                if ExistingWhseJnlLine."Registering Date" <> 0D then
                    RegDate := ExistingWhseJnlLine."Registering Date";
                if ExistingWhseJnlLine."Whse. Document No." <> '' then
                    DocNo := ExistingWhseJnlLine."Whse. Document No.";
            end else begin
                LineNo := 10000;
                if WhseJnlBatch.Get(TemplateName, invSave, inv2.Magasin) then
                    if WhseJnlBatch."Registering No. Series" <> '' then
                        DocNo := NoSeriesMgt.GetNextNo(WhseJnlBatch."Registering No. Series", RegDate, false);
            end;

            WhseJnlLine.Init();
            WhseJnlLine."Journal Template Name" := TemplateName;
            WhseJnlLine."Journal Batch Name" := invSave;
            WhseJnlLine."Line No." := LineNo;
            WhseJnlLine.Validate("Registering Date", RegDate);
            WhseJnlLine.Validate("Entry Type", WhseJnlLine."Entry Type"::"Positive Adjmt.");
            if DocNo <> '' then
                WhseJnlLine.Validate("Whse. Document No.", DocNo);
            WhseJnlLine.Validate("Location Code", inv2.Magasin);
            WhseJnlLine.Validate("Item No.", inv2.article);
            WhseJnlLine."From Bin Code" := GetAdjustmentBinCode(inv2.Magasin);
            WhseJnlLine."From Zone Code" := GetBinZoneCode(inv2.Magasin, WhseJnlLine."From Bin Code");
            WhseJnlLine."From Bin Type Code" := GetBinTypeCode(inv2.Magasin, WhseJnlLine."From Bin Code");
            WhseJnlLine.Validate("To Zone Code", GetBinZoneCode(inv2.Magasin, inv2.Emplacement));
            WhseJnlLine.Validate("To Bin Code", inv2.Emplacement);
            WhseJnlLine.Validate("Zone Code", GetBinZoneCode(inv2.Magasin, inv2.Emplacement));
            WhseJnlLine.Validate("Bin Code", inv2.Emplacement);
            WhseJnlLine."Phys. Inventory" := true;
            WhseJnlLine."Whse. Document Type" := WhseJnlLine."Whse. Document Type"::"Whse. Phys. Inventory";
            SetWhseComptageQty(WhseJnlLine, ComptageNo, FinalQty);
            WhseJnlLine.Validate("Qty. (Phys. Inventory)", FinalQty);
            WhseJnlLine.Insert(true);
        end;

        UpdateNonScannedCount();
    end;

    local procedure MAJItemJournalLine(inv2: Record "CB Historique Scan")
    var
        InvMgt: Codeunit "CB Inventory Mgt";
        ItemJnlLine: Record "Item Journal Line";
        ExistingItemJnlLine: Record "Item Journal Line";
        ItemJnlBatch: Record "Item Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TemplateName: Code[10];
        LineNo: Integer;
        ComptageNo: Integer;
        FinalQty: Decimal;
        DocNo: Code[20];
        PostingDate: Date;
    begin
        TemplateName := InvMgt.GetItemPhysInvTemplateName();
        Evaluate(ComptageNo, compSave);
        FinalQty := inv2.Qte + old_quantity;

        InvMgt.CheckAlreadyCountedItem(TemplateName, invSave, inv2.Magasin, inv2.article, inv2.Emplacement, ComptageNo);

        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", invSave);
        ItemJnlLine.SetRange("Location Code", inv2.Magasin);
        ItemJnlLine.SetRange("Item No.", inv2.article);
        if inv2.Emplacement <> '' then
            ItemJnlLine.SetRange("Bin Code", inv2.Emplacement);
        if ItemJnlLine.FindFirst() then begin
            SetItemComptageQty(ItemJnlLine, ComptageNo, FinalQty);
            ItemJnlLine.Validate("Qty. (Phys. Inventory)", FinalQty);
            ItemJnlLine.Modify(true);
        end else begin
            DocNo := '';
            PostingDate := Today;
            ExistingItemJnlLine.Reset();
            ExistingItemJnlLine.SetRange("Journal Template Name", TemplateName);
            ExistingItemJnlLine.SetRange("Journal Batch Name", invSave);
            if ExistingItemJnlLine.FindLast() then begin
                LineNo := ExistingItemJnlLine."Line No." + 10000;
                if ExistingItemJnlLine."Posting Date" <> 0D then
                    PostingDate := ExistingItemJnlLine."Posting Date";
                if ExistingItemJnlLine."Document No." <> '' then
                    DocNo := ExistingItemJnlLine."Document No.";
            end else begin
                LineNo := 10000;
                if ItemJnlBatch.Get(TemplateName, invSave) then
                    if ItemJnlBatch."No. Series" <> '' then
                        DocNo := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series", PostingDate, false);
            end;

            ItemJnlLine.Init();
            ItemJnlLine."Journal Template Name" := TemplateName;
            ItemJnlLine."Journal Batch Name" := invSave;
            ItemJnlLine."Line No." := LineNo;
            ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
            ItemJnlLine.Validate("Posting Date", PostingDate);
            if DocNo <> '' then
                ItemJnlLine.Validate("Document No.", DocNo)
            else
                ItemJnlLine.Validate("Document No.", invSave);
            ItemJnlLine.Validate("Item No.", inv2.article);
            ItemJnlLine.Validate("Location Code", inv2.Magasin);
            if inv2.Emplacement <> '' then
                ItemJnlLine.Validate("Bin Code", inv2.Emplacement);
            ItemJnlLine."Phys. Inventory" := true;
            SetItemComptageQty(ItemJnlLine, ComptageNo, FinalQty);
            ItemJnlLine.Validate("Qty. (Phys. Inventory)", FinalQty);
            ItemJnlLine.Insert(true);
        end;

        UpdateNonScannedCount();
    end;

    local procedure SetWhseComptageQty(var WhseJnlLine: Record "Warehouse Journal Line"; ComptageNo: Integer; Quantity: Decimal)
    begin
        case ComptageNo of
            1:
                begin
                    WhseJnlLine."CB Comptage 1" := Quantity;
                    WhseJnlLine."CB Comptage Actif" := 1;
                end;
            2:
                begin
                    WhseJnlLine."CB Comptage 2" := Quantity;
                    WhseJnlLine."CB Comptage Actif" := 2;
                end;
            3:
                begin
                    WhseJnlLine."CB Comptage 3" := Quantity;
                    WhseJnlLine."CB Comptage Actif" := 3;
                end;
        end;
    end;

    local procedure SetItemComptageQty(var ItemJnlLine: Record "Item Journal Line"; ComptageNo: Integer; Quantity: Decimal)
    begin
        case ComptageNo of
            1:
                begin
                    ItemJnlLine."CB Comptage 1" := Quantity;
                    ItemJnlLine."CB Comptage Actif" := 1;
                end;
            2:
                begin
                    ItemJnlLine."CB Comptage 2" := Quantity;
                    ItemJnlLine."CB Comptage Actif" := 2;
                end;
            3:
                begin
                    ItemJnlLine."CB Comptage 3" := Quantity;
                    ItemJnlLine."CB Comptage Actif" := 3;
                end;
        end;
    end;

    local procedure UpdateNonScannedCount()
    var
        WhseJnlLine: Record "Warehouse Journal Line";
        ItemJnlLine: Record "Item Journal Line";
        InvMgt: Codeunit "CB Inventory Mgt";
        TemplateName: Code[10];
        a: Integer;
    begin
        a := 0;
        if InvMgt.IsDirectedPutAwayAndPick(magSave) then begin
            TemplateName := InvMgt.GetWhsePhysInvTemplateName();
            WhseJnlLine.Reset();
            WhseJnlLine.SetRange("Journal Template Name", TemplateName);
            WhseJnlLine.SetRange("Journal Batch Name", invSave);
            WhseJnlLine.SetRange("Location Code", magSave);
            WhseJnlLine.SetRange("CB Inventaire Validé", false);
            WhseJnlLine.SetRange("CB Comptage 1", 0);
            if WhseJnlLine.FindSet() then
                a := WhseJnlLine.Count;
        end else begin
            TemplateName := InvMgt.GetItemPhysInvTemplateName();
            ItemJnlLine.Reset();
            ItemJnlLine.SetRange("Journal Template Name", TemplateName);
            ItemJnlLine.SetRange("Journal Batch Name", invSave);
            ItemJnlLine.SetRange("Location Code", magSave);
            ItemJnlLine.SetRange("CB Inventaire Validé", false);
            ItemJnlLine.SetRange("CB Comptage 1", 0);
            if ItemJnlLine.FindSet() then
                a := ItemJnlLine.Count;
        end;
        CurrPage.html.nonscanned(Format(a));
    end;

    local procedure GetAdjustmentBinCode(LocationCode: Code[10]): Code[20]
    var
        Location: Record Location;
    begin
        if Location.Get(LocationCode) then
            exit(Location."Adjustment Bin Code");
        exit('');
    end;

    local procedure GetBinZoneCode(LocationCode: Code[10]; BinCode: Code[20]): Code[10]
    var
        Bin: Record Bin;
    begin
        if Bin.Get(LocationCode, BinCode) then
            exit(Bin."Zone Code");
        exit('');
    end;

    local procedure GetBinTypeCode(LocationCode: Code[10]; BinCode: Code[20]): Code[10]
    var
        Bin: Record Bin;
    begin
        if Bin.Get(LocationCode, BinCode) then
            exit(Bin."Bin Type Code");
        exit('');
    end;

    local procedure analyseScannedBin(cabv: Text) result: Text
    begin
        result := cabv.Trim().Replace(' ', '');
    end;

    local procedure analyseScannedCode(cabv: Text) result: Text
    var
        cabNoBlank: Text;
        cabBlank: Text;
        cabToReturn: Text;
        i: Integer;
        j: Integer;
        cabTab: List of [Text];
        cabTabNoBlank: List of [Text];
    begin
        cabTab := cabv.Split(' ');
        if (cabv.EndsWith('SSEI')) then
            result := cabv.TrimEnd()
        else begin
            if (cabTab.Count > 2) then begin
                i := 1;
                repeat
                    cabBlank := '';
                    if cabTab.Get(i) <> '' then
                        cabBlank := cabTab.Get(i);
                    cabNoBlank := cabBlank.Trim().Replace(' ', '');
                    if cabNoBlank <> '' then
                        cabTabNoBlank.Add(cabNoBlank);
                    i := i + 1;
                until (i = cabTab.Count + 1);
                if cabTabNoBlank.Count > 1 then begin
                    j := 1;
                    repeat
                        cabToReturn := cabToReturn + cabTabNoBlank.Get(j);
                        j := j + 1;


                    until (j = cabTabNoBlank.Count);
                end;
            end
            else
                cabToReturn := cabv;
            result := cabToReturn.Trim().Replace(' ', '').Replace('.', '');
        end;
    end;

    var
        userSave, item_no_text, item_description, emplsave : Text;
        magSave: Text;
        invSave: Text;
        enregistrementSave: Text;
        empSave: Text;
        compSave: Text;
        old_quantity: decimal;
        cab_exists_flag: integer;
}
