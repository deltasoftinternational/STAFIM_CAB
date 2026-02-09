

page 76010 "CB Reclassement"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            usercontrol(html; "CB HTML reclassement")
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
                    ADCSUser.Init();
                    user.SelectToken('us', userToken);
                    user.SelectToken('ps', passToken);

                    userToken.WriteTo(usname);
                    passToken.WriteTo(uspass);

                    usname := usname.Replace('"', '');
                    uspass := uspass.Replace('"', '');

                    if ADCSUser.Get(usname) then begin
                        if (ADCSUser."CB Password" <> uspass)
                        then
                            Error('Mot de passe incorrect !');

                        cmdvSave := '';
                        CurrPage.html.Render(Login2());
                        reclass(ADCSUser."STF Location");


                    end
                    else
                        Error('Nom incorrect !');
                    userSave := usname;
                end;
                //bouton accéder inventaire
                trigger info(info: JsonObject)
                var
                    recep: text;
                    mag: text;
                    recepToken: JsonToken;
                    magtoken: JsonToken;
                    Warehouse_Journal_Batch: record "Warehouse Journal Batch";

                begin


                    info.SelectToken('recep', recepToken);
                    recepToken.WriteTo(recep);
                    recep := recep.Replace('"', '');
                    info.SelectToken('mag', magtoken);


                    magtoken.WriteTo(mag);
                    mag := mag.Replace('"', '');

                    magSave := mag;

                    recep := recep.Replace('"', '');
                    Warehouse_Journal_Batch.Reset();

                    Warehouse_Journal_Batch.SetRange("Journal Template Name", batchname);
                    Warehouse_Journal_Batch.setrange("location code", mag);
                    Warehouse_Journal_Batch.setrange(Name, recep);
                    if not Warehouse_Journal_Batch.FindSet() then
                        error('feuille de reclassement non valide');

                    CurrPage.html.recepverify();

                    numRecepSave := recep;



                end;

                trigger CheckCAB(cab: JsonObject)
                var
                    emplToken: JsonToken;
                    empl: Text;
                    cabToken: JsonToken;
                    cabv, descripton : Text;
                    item: record item;
                    ICR: Record "Item Reference";
                    bbToken: JsonToken;
                    cabFirstPart: text;
                    cabFirstPartToken: JsonToken;
                    cleanedCab: text;
                    cleanedBin: text;
                    arttext: Text;
                    Bin_Content: record "Bin Content";
                    Bin: record "Bin";
                    BinType: Record "Bin Type";

                begin
                    cab.SelectToken('cab', cabToken);
                    cabToken.WriteTo(cabv);
                    cabv := cabv.Replace('"', '');


                    cab.SelectToken('b', bbToken);
                    bbToken.WriteTo(bb);
                    bb := bb.Replace('"', '');





                    cab.SelectToken('cabFirstPart', cabFirstPartToken);
                    cabFirstPartToken.WriteTo(cabFirstPart);
                    cabFirstPart := cabFirstPart.Replace('"', '');


                    cab.SelectToken('empl', emplToken);
                    emplToken.WriteTo(empl);
                    empl := empl.Replace('"', '');

                    cleanedCab := analyseScannedCode(cabv);
                    cleanedBin := analyseScannedBin(cabv);
                    arttext := cleanedCab;
                    ICR.Reset();
                    ICR.SetRange(ICR."Reference Type", ICR."Reference Type"::"Bar Code");
                    ICR.SetRange(ICR."Reference No.", cleanedCab);
                    if (ICR.Findset()) then
                        repeat
                            arttext := ICR."Item No.";
                        until (ICR.Next() = 0);
                    if item.get(arttext) then
                        descripton := item.Description
                    else begin
                        CurrPage.html.reset();
                        error('article non existant');
                    end;


                    CurrPage.html.populateitem(arttext, descripton);
                    CurrPage.html.clearallrec();
                    Bin_Content.Reset();
                    Bin_Content.SetRange("Item No.", arttext);
                    Bin_Content.SetRange("location code", magsave);
                    Bin_Content.setfilter("Quantity (Base)", '>%1', 0);
                    if Bin_Content.findset() then
                        repeat
                            Bin_Content.calcfields("Quantity (Base)");
                            Bin.get(Bin_Content."Location Code", Bin_Content."Bin Code");
                            if Bin."Bin Type Code" = '' then
                                CurrPage.html.addRow(Bin_Content."Location Code", Bin_Content."Bin Code", Bin_Content."Quantity (Base)");
                            if Bin."Bin Type Code" <> '' then
                                if BinType.Get(Bin."Bin Type Code") then
                                    if not BinType.Receive then
                                        CurrPage.html.addRow(Bin_Content."Location Code", Bin_Content."Bin Code", Bin_Content."Quantity (Base)");

                        until Bin_Content.next() = 0;
                end;



                trigger CheckCAB_2(art: JsonObject)
                var
                    arttexttoken: JsonToken;
                    arttext: Text;

                    locationtoken: JsonToken;
                    validertoken: JsonToken;
                    location: Text;
                    locationd: Text;
                    valider: Text;
                    item: record item;
                    Bin_Content: record "Bin Content";
                    Bin: record "Bin";
                    lineno: decimal;
                    Warehouse_Journal_Line: record "Warehouse Journal Line";
                    description: text;
                begin
                    lineno := 0;



                    art.SelectToken('articleNo', arttexttoken);
                    arttexttoken.WriteTo(arttext);
                    arttext := arttext.Replace('"', '');





                    art.SelectToken('empl', locationtoken);
                    locationtoken.WriteTo(location);
                    location := location.Replace('"', '');

                    art.SelectToken('empld', locationtoken);
                    locationtoken.WriteTo(locationd);
                    locationd := locationd.Replace('"', '');

                    art.SelectToken('valider', validertoken);
                    validertoken.WriteTo(valider);
                    valider := valider.Replace('"', '');
                    if item.get(arttext) then
                        description := item.Description
                    else begin
                        CurrPage.html.reset();
                        error('Article non existant');
                    end;

                    Bin_Content.Reset();
                    Bin_Content.setrange("Item No.", arttext);
                    Bin_Content.SetFilter("Quantity (Base)", '>%1', 0);
                    Bin_Content.setrange("Bin Code", location);
                    if not Bin_Content.FindSet() then begin
                        CurrPage.html.reset();
                        error('Veuillez vérifier l''emplacement');
                    end;
                    Bin.Reset();
                    Bin.setrange("Location Code", magsave);
                    Bin.setrange("Code", locationd);
                    if not Bin.FindSet() then
                        CurrPage.html.focusdest()

                    else begin
                        Warehouse_Journal_Line.Reset();
                        Warehouse_Journal_Line.SetRange("Journal Template Name", batchname);
                        Warehouse_Journal_Line.SetRange("Journal Batch Name", feuillesave);
                        Warehouse_Journal_Line.SetRange("Item No.", arttext);
                        Warehouse_Journal_Line.SetRange("from Bin Code", location);
                        Warehouse_Journal_Line.SetRange("To Bin Code", locationd);
                        if Warehouse_Journal_Line.FindSet() then begin
                            lineno := Warehouse_Journal_Line."Line No.";
                            CurrPage.html.getlocationd(valider, format(lineno), '0', description, Format(Warehouse_Journal_Line.Quantity));
                        end
                        else begin
                            Warehouse_Journal_Line.Reset();
                            Warehouse_Journal_Line.SetCurrentKey("Line No.");
                            Warehouse_Journal_Line.SetRange("Journal Template Name", batchname);
                            Warehouse_Journal_Line.SetRange("Journal Batch Name", feuillesave);
                            if Warehouse_Journal_Line.findlast() then begin
                                lineno := Warehouse_Journal_Line."Line No.";

                                CurrPage.html.getlocationd(valider, '0', format(lineno), description, '0');
                            end
                            else
                                CurrPage.html.getlocationd(valider, '0', '0', description, '0');
                        end;
                    end;



                end;

                trigger CheckCAB_3(art: JsonObject)
                var
                    articleNo: text;
                    qtevalide: text;
                    qtevalided: Decimal;
                    empl: text;
                    empld: text;
                    valider: text;
                    lineno: text;
                    lastlineno: text;

                    articleNoToken: JsonToken;
                    qtevalideToken: JsonToken;
                    emplToken: JsonToken;
                    empldToken: JsonToken;
                    validerToken: JsonToken;
                    linenoToken: JsonToken;
                    lastlinenoToken: JsonToken;
                    dateToken: JsonToken;
                    date: text;
                    qteToken: JsonToken;

                    inv: Record "CB Historique Scan";
                    qtescan: decimal;
                    qte: text;

                    desc: text;

                begin
                    art.SelectToken('Description', datetoken);
                    datetoken.WriteTo(desc);
                    desc := desc.Replace('"', '');

                    art.SelectToken('date', datetoken);
                    datetoken.WriteTo(date);
                    date := date.Replace('"', '');

                    art.SelectToken('articleNo', articleNotoken);
                    articleNotoken.WriteTo(articleNo);
                    articleNo := articleNo.Replace('"', '');

                    art.SelectToken('qtevalide', qtevalidetoken);
                    qtevalidetoken.WriteTo(qtevalide);
                    qtevalide := qtevalide.Replace('"', '');
                    Evaluate(qtevalided, qtevalide);

                    art.SelectToken('empl', empltoken);
                    empltoken.WriteTo(empl);
                    empl := empl.Replace('"', '');
                    art.SelectToken('empld', empldtoken);
                    empldtoken.WriteTo(empld);
                    empld := empld.Replace('"', '');

                    art.SelectToken('valider', validertoken);
                    validertoken.WriteTo(valider);
                    valider := valider.Replace('"', '');

                    art.SelectToken('lineno', linenotoken);
                    linenotoken.WriteTo(lineno);
                    lineno := lineno.Replace('"', '');

                    art.SelectToken('lastlineno', lastlinenotoken);
                    lastlinenotoken.WriteTo(lastlineno);

                    lastlineno := lastlineno.Replace('"', '');
                    if lastlineno = '0' then
                        lastlineno := '10000';




                    art.SelectToken('qte', qtetoken);
                    qtetoken.WriteTo(qte);
                    qte := qte.Replace('"', '');
                    if qte = '' then
                        qte := '0';
                    Evaluate(qtescan, qte);

                    inv.Reset();
                    inv.SetRange("Document Type", inv."Document Type"::"Reclassement");
                    inv.SetRange("Document No.", feuillesave);
                    inv.SetRange(Emplacement, empl);
                    inv.SetRange(dest, empld);
                    inv.SetRange(Magasin, magSave);
                    inv.SetRange(article, articleNo);
                    inv.SetRange(user, userSave);
                    if inv.FindFirst() then begin
                        inv.Description := desc;
                        inv."Document Type" := inv."Document Type"::Reclassement;
                        inv.user := userSave;
                        if (valider = '0') then begin
                            inv.Qte := qtescan;
                            inv."Qte" := qtevalided;
                            inv.Modify();

                        end;
                        if (valider = '1') then begin
                            if qtescan = 0 then begin
                                inv.Qte := 0;
                                inv."Qte" := 0;
                                inv.Modify();
                            end
                            else begin
                                inv.Qte := 0;
                                inv."Qte" := qtevalided + qtescan;
                                inv.Modify();
                            end;
                            if lineno <> '0' then begin
                                Evaluate(Line_No, lineno);
                                updatereclassement(Line_No, feuillesave, inv."Qte");
                                CurrPage.html.updatews(Format(inv."Qte"));
                            end
                            else begin
                                Evaluate(Line_No, lastlineno);
                                Line_No := Line_No + 10000;
                                inserteclassement(Line_No, feuillesave, inv."Qte", articleNo, empl, empld);
                                CurrPage.html.updatews(Format(inv."Qte"));
                            end;


                        end;
                    end
                    else begin
                        inv.init();
                        inv.Description := desc;
                        inv."Document Type" := inv."Document Type"::Reclassement;
                        inv.user := userSave;
                        inv."Document Type" := inv."Document Type"::"Reclassement";
                        inv."Document No." := feuillesave;
                        inv.Emplacement := empl;
                        inv.dest := empld;
                        inv.Magasin := magSave;
                        inv.article := articleNo;
                        inv.user := userSave;

                        if (valider = '0') then begin
                            inv.Qte := qtescan;
                            inv."Qte" := qtevalided;
                            inv.Insert();

                        end;
                        if (valider = '1') then begin
                            if qtescan = 0 then begin
                                inv.Qte := 0;
                                inv."Qte" := 0;
                                inv.Insert();

                            end
                            else begin
                                inv.Qte := 0;
                                inv."Qte" := qtevalided + qtescan;
                                inv.Insert();

                            end;
                            if lineno <> '0' then begin
                                Evaluate(Line_No, lineno);
                                updatereclassement(Line_No, feuillesave, inv."Qte");
                                CurrPage.html.updatews(Format(inv."Qte"));

                            end
                            else begin
                                Evaluate(Line_No, lastlineno);
                                Line_No := Line_No + 10000;
                                inserteclassement(Line_No, feuillesave, inv."Qte", articleNo, empl, empld);
                                CurrPage.html.updatews(Format(inv."Qte"));
                            end;
                        end;
                    end;
                end;






                trigger UpdateBinQty(binQty: JsonObject)
                var
                    INV: Record "CB Historique Scan";
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







                    INV.reset();
                    INV.SetRange(INV.Magasin, magSave);
                    INV.SetFilter(INV.article, articleNo);
                    INV.SetFilter(INV.comptage, comp);
                    INV.SetFilter(INV."Document No.", invSave);
                    if empl <> '' then
                        INV.SetFilter(Emplacement, empl);

                    // if BinContent.Findset() then;

                    // Message('test2 %1', BinContent.Count);


                    qtyempl := 0;
                    if INV.FindSet() THEN
                        repeat
                            qtyempl := qtyempl + INV.Qte;
                        until INV.Next() = 0;
                end;

                trigger back_to_login(emplc: JsonObject)
                begin
                    cmdvSave := '';
                    CurrPage.html.Render(Login2());
                    reclass(magsave);
                    CurrPage.html.recepfocus();


                end;

                trigger AddItem0()

                begin

                    CurrPage.html.Render(AddItem(numRecepSave));

                    CurrPage.html.WhenLoaded();

                end;





                trigger finish2(item: JsonObject)
                var
                    INVV: Record "CB Historique Scan";
                    inv: text[50];
                    art: text;
                    artToken: JsonToken;
                    us: text;
                begin
                    inv := invSave;
                    us := userSave;
                    item.SelectToken('art', artToken);
                    artToken.WriteTo(art);
                    art := art.Replace('"', '');





                    INVV.Init();

                    INVV.SetRange(INVV."Document Type", INVV."Document Type"::"Reclassement");

                    INVV.SetRange("Document No.", numRecepSave);

                    INVV.SetFilter(article, art);
                    // INVV.SetRange(Enregistrement, USER.no);
                    if INVV.FindSet() then
                        Page.run(50341, INVV);
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

    procedure updatereclassement(lineno: decimal; feuille: text; quantity: decimal)
    var
        Warehouse_Journal_Line: record "Warehouse Journal Line";
    begin
        Warehouse_Journal_Line.get(batchname, feuille, magsave, lineno);
        Warehouse_Journal_Line.validate("Quantity", quantity);
        Warehouse_Journal_Line.modify();
    end;

    procedure inserteclassement(lineno: decimal; feuille: text; quantity: decimal; item: text; source: text; dest: text)
    var
        Warehouse_Journal_Line: record "Warehouse Journal Line";
    begin
        Warehouse_Journal_Line.Init();
        Warehouse_Journal_Line."Journal Template Name" := batchname;
        Warehouse_Journal_Line."Journal Batch Name" := feuille;
        Warehouse_Journal_Line."Registering Date" := today;
        Warehouse_Journal_Line."Line No." := lineno;
        Warehouse_Journal_Line.Validate("Location Code", magSave);
        Warehouse_Journal_Line.Validate("Item No.", item);
        Warehouse_Journal_Line.Validate("From Bin Code", source);
        Warehouse_Journal_Line.Validate("To Bin Code", dest);
        Warehouse_Journal_Line.validate("Quantity", quantity);
        Warehouse_Journal_Line.Insert(true);
    end;

    procedure Login(): Text
    var
        //SO: Record "Company Information";
        US: Record "ADCS User";
        out: Text;
    begin

        //SO.FindSet();
        out := '<!DOCTYPE html> <html> <head><meta name="viewport" content="width=device-width, initial-scale=1"> <style>html { overflow-y: hidden; } body {font-family: Arial, Helvetica, sans-serif;} form {border: 3px solid #f1f1f1;} input[type=text], input[type=password] { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } select{ width: 100%; padding: 10px 10px; margin: 2px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } button { background-color: #04AA6D; color: white; padding: 20px 15px; margin: 6px 0; border: none; cursor: pointer; width: 100%; } button:hover { opacity: 0.8; } .cancelbtn { width: auto; padding: 10px 18px; background-color: #f44336; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } .container { padding: 16px; } span.psw { float: right; padding-top: 16px; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } </style> </head> ';
        out += '<body> <h2>Reclassement</h2><!--<div><center><img width="100px"height="100px" src="C:\Users\KSBOUI\Documents\AL\LeMoteurCodebarres\SRC\Pages\logo.png"/></center></div>--> <div class="container"> <label for="uname"><b>Utilisateur</b></label>';
        out += '<select id="user" name="uname">';
        out += '<option value="' + US.Name + '">' + US.Name + '</option>';
        while US.Next() <> 0 do
            out += '<option value="' + US.name + '">' + US.Name + '</option>';
        out += '</select> ';

        out += '<label for="psw"><b>Mot de passe</b></label> ';
        out += '<input  id="passInput" type="password" placeholder="Enter Mot de passe" onKeyPress="if(event.keyCode==13) login();"name="psw" required> ';


        out += '<button onClick="login()">Se connecter</button> </div> </body> </html>';

        exit(out);
    end;


    procedure Login2(): Text
    var

        out: Text;

    begin

        out := '<!DOCTYPE html><html><script>function call(){ if (event.keyCode === 13) { go(); } } </script> </script> <head> <meta name="viewport" content="width=device-width, initial-scale=1"> <style>html { overflow-y: hidden; } body {font-family: Arial, Helvetica, sans-serif;} form {border: 3px solid #f1f1f1;} input[type=text], input[type=password] { width: 100%; padding: 12px 20px; margin: 8px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } select{ width: 100%; padding: 10px 10px; margin: 2px 0; display: inline-block; border: 1px solid #ccc; box-sizing: border-box; } button { background-color: #04AA6D; color: white; padding: 20px 15px; margin: 6px 0; border: none; cursor: pointer; width: 100%; } button:hover { opacity: 0.8; } .cancelbtn { width: auto; padding: 10px 18px; background-color: #f44336; } .imgcontainer { text-align: center; margin: 24px 0 12px 0; } img.avatar { width: 40%; border-radius: 50%; } .container { padding: 16px; } span.psw { float: right; padding-top: 16px; } /* Change styles for span and cancel button on extra small screens */ @media screen and (max-width: 300px) { span.psw { display: block; float: none; } .cancelbtn { width: 100%; } } </style> </head> ';
        out += '<body> <h2>Feuille  de reclassement</h2> <div class="container"> ';




        out += '</select> ';
        out += '<label for="lrecep"><b>Feuilles</b></label>';
        out += '<select type="hidden" style="display: inline-block;" id="lrecep" name="lrecep"   onChange=" remplir(value)" >';

        out += '</select> ';
        out += '<input  id="recep" name="recep" type="text" placeholder="Code à barre" onKeyPress="if(event.keyCode==13) go(); " required> ';
        out += '<label for="lrecep">Magasin</label>';

        out += '<select type="hidden" style="Width:20%;" id="lmag" name="lmag" >';

        out += '</select> ';



        out += '<button id="gu" name="gu" onKeyDown="if(event.keyCode==13) go();" onClick="go()" >Accéder à la feuille de reclassement</button>';

        exit(out);



    end;

    procedure AddItem(numRecep: Text[50]): Text
    var
        out: TextBuilder;
    begin
        feuillesave := numRecep;

        out.Append(
        '<!DOCTYPE html>' +
        '<html>' +
        '<head>' +
        '<meta name="viewport" content="width=device-width, initial-scale=1">' +

        '<style>' +

        'html,body{margin:0;padding:0;font-family:Arial,Helvetica,sans-serif;background:#f9f9f9;}' +

        '.container{margin:auto;' +
        '}' +

        'label{font-weight:bold;margin-top:0.6rem;display:block;}' +

        'input,select,button{width:100%;padding:0.6rem;font-size:1rem;' +
        'border:0.08rem solid #ccc;border-radius:0.3rem;box-sizing:border-box;}' +

        'input[readonly],input[disabled]{background:#f3f3f3;}' +

        '.row{display:flex;gap:0.6rem;width:100%;}' +
        '.col{flex:1;}' +

        '.buttons{display:flex;gap:0.6rem;margin-top:1rem;height: 48px;}' +
        '.buttons button{flex:1;border:none;color:#fff;background:#04AA6D;cursor:pointer;}' +

        '.secondary{background:cadetblue;}' +

        '#message{border:none;background:transparent;margin-top:0.5rem;}' +

        '#tablepop{display:none;width:100%;max-height:12rem;overflow-y:auto;' +
        'border:1px solid #ccc;border-radius:0.4rem;margin:0.6rem 0;}' +

        '#tablepop table{width:100%;border-collapse:collapse;table-layout:fixed;}' +
        '#tablepop th,#tablepop td{padding:0.4rem;font-size:0.9rem;text-align:center;' +
        'border-bottom:1px solid #ddd;}' +

        '#tablepop tbody tr:hover{background:#f1f1f1;cursor:pointer;}' +
        '#tablepop tbody tr.selected{background:#cce5ff;}' +
        '#tablepop tbody tr.no-select{background:#f8d7da;color:#721c24;pointer-events:none;}' +
        '#tablepop tbody tr.light-gray{background:#d6d6d6;color:black;pointer-events:none;}' +
        '#tablepop tbody tr.hard-blue{background:#003366;color:white;pointer-events:none;}' +

        '.loader{border:0.8rem solid #f3f3f3;border-radius:50%;' +
        'border-top:0.8rem solid blue;border-bottom:0.8rem solid blue;' +
        'width:5rem;height:5rem;animation:spin 2s linear infinite;' +
        'position:fixed;top:40%;left:40%;z-index:10;}' +

        '@keyframes spin{0%{transform:rotate(0deg);}100%{transform:rotate(360deg);}}' +


        '</style>' +
        '</head>'
        );

        out.Append(
        '<body>' +



        '<div class="container">' +

        '<div style="text-align:center;">' +
        '<label style="color:red;font-size:1rem;">' + numRecep + '(' + userSave + ')</label>' +
        '</div>' +

        '<label for="cab">Code à barre</label>' +
        '<input id="cab" type="text" name="cab" ' +
        'onKeyPress="if(event.keyCode==13) passerCab(this);" autocomplete="off">' +

        '<label for="articleNo">Article</label>' +
        '<input id="articleNo" type="text" readonly disabled>' +

        '<div id="tablepop">' +
        '<table>' +
        '<thead>' +
        '<tr><th>Mag</th><th>Emp</th><th>Qte</th></tr>' +
        '</thead>' +
        '<tbody id="tableBody"></tbody>' +
        '</table>' +
        '</div>' +

        '<div class="row">' +
            '<div class="col">' +
                '<label for="empl">Emplacement</label>' +
                '<input id="empl" type="text" onKeyPress="if(event.keyCode==13) refreshempld();">' +
            '</div>' +
            '<div class="col">' +
                '<label for="empld">Déstinataire</label>' +
                '<input id="empld" type="text" onKeyPress="if(event.keyCode==13) refreshqty();">' +
            '</div>' +
        '</div>' +

        '<div class="row">' +
            '<div class="col">' +
                '<label for="qte">Quantité</label>' +
                '<input id="qte" type="text" onKeyPress="if(event.keyCode==13) next1(0);">' +
            '</div>' +
            '<div class="col">' +
                '<label>&nbsp;</label>' +
                '<input id="qtevalide" type="text" readonly disabled>' +
            '</div>' +
        '</div>' +

        '<div id="qte2" style="display:none;">' +
            '<label for="qtei">Q.Magasin</label>' +
            '<input id="qtei" type="text" readonly>' +
        '</div>' +

        '<div id="qte3" style="display:none;">' +
            '<label for="qtes">Q.Stock</label>' +
            '<input id="qtes" type="text" readonly>' +
        '</div>' +

        '<input id="message" type="text">' +

        '<div class="buttons">' +
            '<button onclick="reset()">↻</button>' +
            '<button class="secondary" onclick="finish2()">Aperçu</button>' +
            '<button onclick="next1(1)">Valider</button>' +
        '</div>' +

        '<input id="desc" style="display:none;" readonly disabled>' +
        '<input id="quantité" style="display:none;" readonly disabled>' +
        '<label id="cabcopy" style="display:none;"></label>' +

        '</div>' +
        '</body>' +
        '</html>'
        );

        exit(out.ToText());
    end;




    procedure reclass(mag: text)
    var
        Warehouse_Journal_Template: record "Warehouse Journal Template";
        Warehouse_Journal_Batch: record "Warehouse Journal Batch";
        name: text;
        location: record location;
    begin
        CurrPage.html.recep('', '');
        Warehouse_Journal_Template.Reset();
        Warehouse_Journal_Template.setrange("Type", Warehouse_Journal_Template.Type::Reclassification);
        if Warehouse_Journal_Template.findlast() then begin
            batchname := Warehouse_Journal_Template.name;
            Warehouse_Journal_Batch.Reset();

            Warehouse_Journal_Batch.SetRange("Journal Template Name", Warehouse_Journal_Template.name);
            Warehouse_Journal_Batch.setrange("location code", mag);
            if Warehouse_Journal_Batch.FindSet() then
                repeat

                    name := Warehouse_Journal_Batch.Name;
                    CurrPage.html.recep(name, batchname);

                until Warehouse_Journal_Batch.Next() = 0;
        end;
        if mag <> '' then
            CurrPage.html.recep2(mag)
        else begin
            CurrPage.html.recep2('');
            if location.FindSet() then
                repeat
                    CurrPage.html.recep2(location.Code);
                until location.next() = 0;
        end;
        CurrPage.html.recepfocus();
    end;



    local procedure analyseScannedBin(cabv: Text) result: Text
    var

    begin
        //result := COPYSTR(cabv.TrimEnd(), 1, 20);
        result := COPYSTR(cabv.Trim(), 1, 20);
    end;



    local procedure analyseScannedCode(cabv: Text) result: Text
    var

    begin
        // if Text.StrLen(cabToReturn) > 20 then
        result := COPYSTR(cabv.Trim(), 1, 20);
    end;




    var
        Line_No: Decimal;
        bb, batchname : Text;
        userSave: Text;
        magSave: Text;
        numRecepSave: Text;
        cmdvSave: Text;
        invSave: Text;
        compSave: Text;
        feuillesave: text;
}

