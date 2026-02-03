page 76007 "CB Inventaire"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            usercontrol(html; "BC HTML")
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
                    INV: Record "CB Historique Scan";
                    bb: Text;
                    bbToken: JsonToken;
                    compToken: JsonToken;
                    comp: Text;
                    cabFirstPart: text;
                    cabFirstPartToken: JsonToken;
                    qtyempl: Decimal;
                    cleanedCab: text;
                    cleanedBin: text;
                    lines: Record "Phys. Invt. Order Line";
                    rl: Record "Phys. Invt. Record Line";
                    a: integer;


                begin
                    cab.SelectToken('cab', cabToken);
                    cabToken.WriteTo(cabv);
                    cabv := cabv.Replace('"', '');

                    cab.SelectToken('b', bbToken);
                    bbToken.WriteTo(bb);
                    bb := bb.Replace('"', '');


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
                    end else begin
                        ITEM2.setfilter("No.", '%1|%2|%3', '' + cabv + '', '' + cleanedCab + '', '' + cleanedCab.trim() + '');

                        if ((ITEM2.Find('-'))) then begin
                            b := true;
                            itemNo := ITEM2."No.";

                        end;
                    end;


                    if (not b) then begin
                        Bin.Setrange("Location Code", magSave);
                        Bin.SetFilter(Code, '%1|%2|%3', '' + cabv + '', '' + cleanedBin + '', '' + cleanedBin.trim() + '');
                        if Bin.Find('-') then begin
                            CurrPage.html.cabVerif(Bin.code);
                            rl.reset();
                            rl.SetRange("Order No.", invSave);
                            rl.SetFilter("Recording No.", enregistrementSave);
                            rl.setrange(Recorded, false);
                            if rl.FindSet() then
                                a := RL.Count;
                            CurrPage.html.nonscanned(Format(a));
                        end
                        else
                            CurrPage.html.cabVerif('');
                    end
                    else begin
                        lines.Reset();
                        lines.SetRange("Document No.", invSave);
                        lines.SetRange("Item No.", itemNo);
                        lines.Setrange("Bin Code", empl);
                        lines.setfilter("No. Finished Rec.-Lines", '<>%1', 0);
                        if comp = '2' then begin
                            lines.Setrange("DLT Gap COUNT1 vs Calculated", 0);
                            lines.setfilter("DLT Counting 1", '<>%1', 0);
                            if lines.findSet() then
                                Error('L''article est déja scanné correctement dans un autre comptage');
                        end;
                        if comp = '3' then begin
                            lines.Setrange("DLT Gap COUNT2 vs COUNT1", 0);
                            if lines.findSet() then
                                if (lines."DLT Counting 1" <> 0) or (lines."DLT Counting 2" <> 0) or ((lines."DLT Gap COUNT1 vs Calculated" = 0) and (lines."DLT Counting 1" <> 0)) then
                                    Error('L''article est déja scanné correctement dans un autre comptage');
                        end;
                        INV.reset();
                        INV.SetRange(Magasin, magSave);
                        INV.setrange(article, itemNo);
                        INV.SetFilter("Document No.", invSave);
                        INV.SetFilter(Enregistrement, enregistrementSave);
                        INV.SetFilter(comptage, comp);
                        INV.SetFilter(Emplacement, empl);
                        INV.CalcSums(Qte);
                        qtyempl := inv.Qte;
                        if (item2.get(itemNo)) then
                            CurrPage.html.autoComplete(item2."No.", item2.Description, '', item2."Base Unit of Measure", qtyempl + 1, item2.Inventory, item2.Inventory, bb);
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
                    item.SelectToken('emp', empToken);
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
                            if (num < 1) then
                                Message('La quantité saisie est inférieur à 1')
                            else begin
                                inv."Document Type" := inv."Document Type"::Inventaire;
                                inv.Qte := num;
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

    procedure AddItem(inv: text[50]; mag: Text; comptage: Integer; compUs: Integer): Text
    var
        out: Text;
    begin
        out := '<!DOCTYPE html><html><head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style>';
        out += 'html, body {margin: 0; height: 100%; overflow: hidden; font-family: Arial, Helvetica, sans-serif; font-size:14px;}';
        out += 'form {border: 3px solid #f1f1f1;}';
        out += 'label { font-weight: bold; font-size: 16px; }';
        out += 'input[type=text], input[type=password] { width: 90%; padding: 12px 10px; font-size: 16px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; }';
        out += 'select { width: 90%; padding: 12px 10px; font-size: 16px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; }';
        out += 'button { background-color: #04AA6D; color: white; padding: 15px 20px; margin: 8px 0; border: none; cursor: pointer; width: 100%; font-size: 16px; }';
        out += 'button:hover { opacity: 0.8; }';
        out += '.cancelbtn { width: auto; padding: 10px 15px; background-color: #f44336; }';
        out += '.imgcontainer { text-align: center; margin: 10px 0 15px 0; }';
        out += 'img.avatar { width: 40%; border-radius: 50%; }';
        out += '.container { padding: 16px;opacity:0.5; }';
        out += 'span.psw { float: right; padding-top: 13px; }';
        out += '@media screen and (max-width: 1000px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } }';
        out += '.loader { border: 16px solid #f3f3f3; border-radius: 50%; border-top: 16px solid blue; border-bottom: 16px solid blue; width: 120px; height: 120px; -webkit-animation: spin 2s linear infinite; animation: spin 2s linear infinite; position: absolute;z-index:10; top: 20%; left: 40%; text-align: center; font-size: 10px; }';
        out += '@-webkit-keyframes spin { 0% { -webkit-transform: rotate(0deg); } 100% { -webkit-transform: rotate(360deg); } }';
        out += '@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }';
        out += '</style></head>';
        out += '<body><center><b><label style="color : red;font-weight: bold; font-size: 17px;">Inventaire : ' + inv + '</label><label style="color : red;font-weight: bold; font-size: 17px;"> - Comptage : ' + Format(comptage) + ' </label><br><label style="color :cadetblue;font-size:17px;font-weight: bold;">Magasin : ' + mag + ' </label></b></center>  <div id="spinner"class="loader"></div><div id="container" class="container">';
        out += '<input  id="comp" type="text" style="Display:none" name="comp" value="' + Format(comptage) + '"\>';
        out += '<label for="cab" style="width:140px;display: inline-block;"><b>Code à barre </b></label>';
        out += '<input type="text" tabindex="-1" enterkeyhint="done" style="width:180px;display: inline-block;" id="cab" type="text" name="cab" onKeyPress="if(event.keyCode==13) passerCab(this); "  autocomplete="off" required><br> ';

        out += '<label for="article" style="width:140px;display: inline-block;"><b>Article      </b></label>';
        out += '<input  style="width:180px;display: inline-block;" id="articleNo" type="text"  name="article" readonly="readonly" disabled="true" required><br> ';
        out += '<label for="desc" style="width:140px;display: inline-block;vertical-align: middle;"><b>Description</b></label>';
        out += '<textarea style="padding:12px 10px;width:180px;min-height:60px;display:inline-block;resize:vertical;border:1px solid #ccc;box-sizing:border-box;font-size:16px;vertical-align: middle;" id="desc" name="desc" readonly disabled></textarea><br>';
        out += '<!--<div id=qt style="display: flex;flex-direction: row;justify-content: space-evenly;">-->';
        out += '<!--<div id=qte1 style="">-->';
        out += '<label style="width:140px;display: inline-block;" for="qte"><b>Quantité</b> <label id="unite"></label></label>  ';
        out += '<input tabindex="-1" enterkeyhint="done" style="width:180px;display: inline-block;" id="qte" type="text"  name="qte"  onKeyDown="if(event.keyCode==27) qte.select();"  onKeyPress="if(event.keyCode==13) next();"  required><br>';
        out += '<label style="width:140px;display: inline-block;" for="nonScanned"><b>Articles non scannés</b></label>';
        out += '<input type="text" id="nonScanned" name="nonScanned" value="" readonly ';
        out += 'onclick="handleNonScannedClick()" ';
        out += 'style="cursor:pointer;width:180px;display:inline-block;background-color:#e0f7ff;';
        out += 'border:2px solid #0077cc;color:#0077cc;text-align:center;font-weight:bold;border-radius:5px;';
        out += 'transition:background 0.3s, border 0.3s;"><br>';



        out += '<!--</div>-->';
        out += '<div id=qte2 style="display:none;">';
        out += '<label for="qtei"><center><b>Q.Magasin</b></label> <label id="unite"></center></label> ';
        out += '<input  id="qtei" type="text"  name="qtei" style="width:80%; " required readonly="readonly" >';
        out += '<!--</div>-->';
        out += '<div id=qte3 style="display:none;">';
        out += '<label for="qtes"><center><b>Q.Stock</b></label> <label id="unite"></center></label> ';
        out += '<input  id="qtes" type="text"  name="qtes"  style="width:80%;" required readonly="readonly">';
        out += '</div>';
        out += '</div>';
        out += '';
        out += '<select onclick="refreshEmpl()" style="width:160px;display: none;" id="emp" name="emp">';
        out += '</select>';
        out += '<input  id="empl" type="text" disabled="true" onchange="MAJEmp()"   name="empl"  style="padding: 8px 13px;width:335px;display: inline-block;"> <br>';
        out += '<input  id="message" type="text" name="message"  style="padding: 3px 5px;width:335px;display: inline-block;  background: rgba(0, 0, 0, 0);  border: none; "><br>';
        out += '<button onclick="reset()" style="width: 10%;float: left;">↻</button>';
        out += '<button onclick="finish2()" style="background-color: cadetblue;width: 30%; margin-left:5px;">Aperçu</button>';
        out += '<button onClick="next1()" id="btnvalid"  onKeyPress="passerCab(this)" style="width: 50%;float: right;">Valider</button>';
        out += '<!--  <input  id="emp" type="text"  name="emp" readonly="readonly"> <button onclick="reset()">Réinitialiser</button>-->';
        out += '<label id="cabcopy" style="display:none;"></label></body> </html>';
        exit(out);
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
            recordLine.Validate("Quantity", inv2.Qte);
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
            recordline.validate(Quantity, inv2.Qte);
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
        userSave: Text;
        magSave: Text;
        invSave: Text;
        enregistrementSave: Text;
        empSave: Text;
        compSave: Text;
}
