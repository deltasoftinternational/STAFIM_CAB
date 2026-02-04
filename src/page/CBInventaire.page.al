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
                    RL: Record "Phys. Invt. Record Line";
                    ModalResult: Action;
                begin
                    RL.Reset();
                    RL.SetCurrentKey("Bin Code");
                    RL.SetAscending("Bin Code", true);
                    RL.SetRange("Order No.", invSave);
                    RL.SetFilter("Recording No.", enregistrementSave);
                    RL.SetRange(Recorded, false);
                    if RL.FindSet() then begin
                        ModalResult := Page.RunModal(76009, RL); // Waits for page close
                        RL.Reset();
                        RL.SetRange("Order No.", invSave);
                        RL.SetFilter("Recording No.", enregistrementSave);
                        RL.SetRange(Recorded, false);
                        if RL.FindSet() then
                            a := RL.Count;
                        CurrPage.html.nonscanned(Format(a));
                    end;
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
                    ENR: Record "Phys. Invt. Record Header";
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

                    USER.reset();
                    USER.SetRange(User, us);
                    if USER.Findfirst() then;

                    ENR.Get(User.Enregistrement, user.no);
                    ENR.SetFilter(ENR."Recording No.", enregistrementSave);
                    ENR.SetFilter(ENR."Order No.", invSave);
                    if ENR.FindFirst() then;

                    ENR.Modify();

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
                    ENR: Record "Phys. Invt. Record Header";
                    INVV: Record "CB Historique Scan";
                    INVBC: Record "Phys. Invt. record Line";
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

                    USER.reset();
                    USER.SetRange(User, us);
                    if USER.Findfirst() then;

                    INVV.reset();
                    INVBC.reset();

                    INVBC.SetRange("Order No.", inv);
                    INVBC.SetRange("Recording No.", USER.no);
                    USER.Next();


                    ENR.Get(User.Enregistrement, user.no);
                    ENR.SetFilter(ENR."Recording No.", enregistrementSave);
                    ENR.SetFilter(ENR."Order No.", invSave);
                    INVV.SetRange("Document No.", inv);
                    INVV.SetFilter(Enregistrement, enregistrementSave);
                    INVV.SetRange(user, us);
                    if INVV.FindSet() then;
                    Page.run(76001, INVV);
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
        adcs: record "ADCS User";

        ENR: Record "Phys. Invt. Record Header";
        bcInv: Record "CB Historique Scan";
        physInvRecord: Record "Phys. Invt. record Line";
        physInvOrder: Record "Phys. Invt. Order Line";
        art: text;
        artToken: JsonToken;
        compToken: JsonToken;
        comp: text;
        us: text;
    begin
        item.SelectToken('art', artToken);
        artToken.WriteTo(art);
        art := art.Replace('"', '');

        item.SelectToken('comp', compToken);
        compToken.WriteTo(comp);
        comp := comp.Replace('"', '');

        us := userSave;
        USER.reset();
        USER.SetRange(User, us);
        if USER.FindFirst() then;
        bcInv.Reset();
        physInvRecord.Reset();
        physInvRecord.SetRange("Order No.", invSave);
        physInvRecord.SetRange("Recording No.", USER.no);
        ENR.Get(USER.Enregistrement, USER.no);
        bcInv.SetRange("Document No.", invSave);
        bcInv.SetRange(user, us);
        bcInv.SetRange(Enregistrement, USER.no);
        adcs.get(us);



        while bcInv.Next() <> 0 do begin
            physInvRecord.Reset();
            physInvRecord.SetRange("Order No.", invSave);

            physInvRecord.SetRange("Recording No.", USER.no);
            physInvRecord.SetRange("Item No.", bcInv.article);
            if physInvRecord.FindSet() then begin
                /*case bcInv.comptage of
                    1:
                        physInvRecord.Validate("BC Quantity 1", bcInv.Qte);
                    2:
                        begin
                            physInvRecord.Validate("BC Quantity 2", bcInv.Qte);
                            
                        end;

                    3:
                        physInvRecord.Validate("BC Quantity 3", bcInv.Qte);
                end;*/
                physInvOrder.Get(user.Enregistrement, physInvRecord."Line No.");
                physInvOrder."Location Code" := adcs."STF Location";
                physInvOrder."Bin Code" := bcInv.Emplacement;
                physInvOrder."Variant Code" := physInvRecord."Variant Code";
                physInvOrder."Qty. Exp. Calculated" := true;
                physInvRecord."Location Code" := adcs."STF Location";
                physInvRecord.Recorded := true;
                physInvRecord."Bin Code" := bcInv.Emplacement;
                physInvRecord.Modify();
                physInvOrder.Modify();
            end;
        end;

        physInvRecord.Reset();
        physInvRecord.SetRange("Order No.", invSave);
        physInvRecord.SetRange("Recording No.", USER.no);
        bcInv.Reset();
        bcInv.SetRange("Document No.", invSave);
        bcInv.SetRange(user, us);
        bcInv.SetRange(Enregistrement, USER.no);

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
        enrt: record "Phys. Invt. Record Header";
        comptage: text;
        adcs: record "ADCS User";
    begin
        adcs.get(usname);
        US.Reset();
        US.SetRange(User, usname);
        out := '<!DOCTYPE html><html><script>function call(){ if (event.keyCode === 13) { go(); } } </script> </script> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style>label{font-size:12px;} body {font-family: Arial, Helvetica, sans-serif;} form {border: 3px solid #f1f1f1;} input[type=text], input[type=password] { width: 100%; padding: 2px 4px; margin: 2px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box;font-size:10px; } select{ width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } button { background-color: #04AA6D; color: white; padding: 15px 20px; margin: 8px 0; border: none; cursor: pointer; width: 100%; } button:hover { opacity: 0.8; } .cancelbtn { width: auto; padding: 10px 18px; background-color: #f44336; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } .container { padding: 16px; } span.psw { float: right; padding-top: 16px; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 1000px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } </style> </head> ';
        out += '<body> <h2>Inventaire </h2> <div class="container"> ';
        out += '<label for="mag"><b>Identifiant d''inventaire</b></label>';

        out += '<select id="maga" name="maga"  onChange=" remplir(value)" >';
        out += '<option ></option>';
        if US.FindSet() then
            repeat
                enrt.Reset();
                enrt.SetRange("Order No.", US.Enregistrement);
                enrt.SetRange("Recording No.", US.no);
                if enrt.FindSet() then begin

                    case enrt."DLT Counting No." of
                        enrt."DLT Counting No."::"First Counting":
                            comptage := '1';
                        enrt."DLT Counting No."::"Second Counting":
                            comptage := '2';
                        else
                            comptage := '3';
                    end;

                    out += '<option value="' + US.User + '/' + adcs."STF Location" + '/' + US.Enregistrement + '/' + Format(US.no) + '/' + comptage + '">' + US.User + '/' + adcs."STF Location" + '/' + US.Enregistrement + '/' + Format(US.no) + '/' + comptage + '</option>';

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
        recordLine: Record "Phys. Invt. Record Line";
        rl: Record "Phys. Invt. Record Line";
        a: integer;

        allRecordLine: Record "Phys. Invt. Record Line";
        orderLine: Record "Phys. Invt. Order Line";
        orderLine2: Record "Phys. Invt. Order Line";
        allOrderLine: Record "Phys. Invt. Order Line";
        binContent: Record "Bin Content";
    begin
        //recordLine.Reset();
        recordLine.SetCurrentKey("Order No.", "Recording No.", "Item No.", "Bin Code", "Location Code");
        recordLine.SetRange("Order No.", inv2."Document No.");
        recordLine.SetRange("Recording No.", inv2.Enregistrement);
        recordLine.SetRange("Item No.", inv2.article);
        recordLine.SetRange("Bin Code", inv2.Emplacement);
        recordLine.SetRange("Location Code", inv2.Magasin);
        if recordLine.Find('-') then begin
            recordLine.Validate("Quantity", inv2.Qte + old_quantity);
            recordLine.Modify();
        end
        else begin
            if compsave <> '1' then
                error('L''article n''existe pas dans l''enregistrement inventaire');

            //allRecordLine.Reset();
            allRecordLine.SetRange("Order No.", inv2."Document No.");
            allRecordLine.SetRange("Recording No.", inv2.Enregistrement);
            if allRecordLine.FindSet() then;
            recordLine.Init();
            recordLine."Order No." := inv2."Document No.";
            recordLine."Recording No." := inv2.Enregistrement;
            recordLine."Line No." += 10000 * (allRecordLine.count + 2);
            recordLine.Validate("Item No.", inv2.article);
            recordline.validate(Quantity, inv2.Qte + old_quantity);
            recordLine."Bin Code" := inv2.Emplacement;
            recordLine."Location Code" := inv2.Magasin;
            recordLine.Insert();
            //binContent.Reset();
            binContent.SetRange("Item No.", inv2.article);
            binContent.SetRange("Location Code", inv2.Magasin);
            binContent.SetRange("Bin Code", inv2.Emplacement);
            if binContent.FindFirst() then;
            binContent.CalcFields("Quantity (Base)");
            //allOrderLine.Reset();
            orderLine2.Reset();
            orderLine2.Setrange("Document No.", inv2."Document No.");
            orderLine2.Setrange("Item No.", inv2.article);
            orderLine2.Setrange("Bin Code", inv2.Emplacement);
            if not orderLine2.FindSet() then begin
                allOrderLine.SetRange("Document No.", inv2."Document No.");
                if allOrderLine.Find('-') then;
                orderLine."Document No." := inv2."Document No.";
                orderLine."Line No." += 10000 * (allOrderLine.count + 2);
                orderLine.Validate("Item No.", inv2.article);
                orderLine."Bin Code" := inv2.Emplacement;
                orderLine."Location Code" := inv2.Magasin;
                orderLine.Validate("Qty. Expected (Base)", binContent."Quantity (Base)");
                orderLine."Qty. Exp. Calculated" := true;
                orderLine.Insert();
                orderLine.CreateDimFromDefaultDim();
                orderLine.Modify();
            end;
        end;
        RL.SetRange("Order No.", invSave);
        RL.SetFilter("Recording No.", enregistrementSave);
        RL.setrange(Recorded, false);
        if rl.FindSet() then
            a := RL.Count;
        CurrPage.html.nonscanned(Format(a));
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
