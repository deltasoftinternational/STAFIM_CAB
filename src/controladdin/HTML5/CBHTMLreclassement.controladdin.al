
controladdin "CB HTML reclassement"
{
    StartupScript = 'JS/startup.js';
    Scripts = 'JS/reclassement.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 700;
    procedure qntynonvalide();
    procedure scan();
    procedure reset();
    event ControlReady();
    event AddItem0();
    event info(info: JsonObject);
    event CheckUser(user: JsonObject);
    event item(item: JsonObject);
    event finish(finish: JsonObject);
    event UpdateBinQty(binQty: JsonObject);
    event finish2(finish: JsonObject);
    event comptage(compt: JsonObject);
    event CheckCAB(cab: JsonObject);
    event CheckCAB_2(cab: JsonObject);
    event CheckCAB_3(cab: JsonObject);
    event back_to_login(emplc: JsonObject);


    event calculer_quantité(emplc: JsonObject);
    event Terminer(emplc: JsonObject);
    event Valider_commande_achat(emplc: JsonObject);
    //<<
    //defining the js function WhenLoaded as procedure so it can be called in the page code
    procedure WhenLoaded();
    procedure recepfocus();
    procedure qtevalide(qte: Decimal; quantité: Decimal);

    procedure recepverify();
    procedure recepfocus2(cmdv: Text);
    procedure quantiténonvalide();
    procedure cabnonvalide();
    //>>
    procedure Render(HTML: Text);

    procedure cabVerif(CodeBin: code[20]);
    procedure recep(name: Text; batchname: text);
    procedure recep2(magasin: Text);
    procedure focusdest();
    procedure clearallrec();
    procedure addRow(Location_Code: Text; Bin_Code: Text; Quantity_Base: decimal);
    procedure populateitem(itemno: text; description: text)

    //<<
    //Added qtes(quantité dans le magasin actuel) and qtei(quantité du stock total )
    procedure autoComplete(itemNo: code[20]; desc: Text; emps: Text; unite: text; qte: Decimal; qtes: Decimal; qti: Decimal; bb: Text; qteemp: Decimal; empl: Text; Quantitéexp: Text; Quantitérecue: Text);
    //>>
    procedure getlocationd(valider: text; lineno: text; lastlineno: Text; Description: text; qtevalide: text);

    procedure updatewsa(url: Text; name: Text; Document_Type: Text; numTransfertSave: Text; line: Text; Quantity: Decimal);
    procedure updatews(Qte: Text);

    procedure UpdateQty(itemNo: code[20]; desc: Text; unite: text; qte: Decimal; qtes: Decimal; qti: Decimal; bb: Text);
    procedure Valider_commande_achat2();
    procedure calculer_quantité2();
    procedure articlenonvalide();

    procedure getwsa(urlgetbin: Text; arttext: Text; magasin: text; name: Text; urlglobal: text; emp: text; societeparts: text; societegros: text; username: text; password: text);
    procedure postws(url: text; numRecep: text; Line_No: Decimal; date: text; articleNo: text; desc: text; magSave: text; empl: text; empld: text; Qte: Decimal; username: text; password: text);

}