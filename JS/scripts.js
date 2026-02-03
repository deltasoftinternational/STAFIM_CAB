function remplir(id) {
    let text = id;
    const myArray = text.split("/");
    var inv = document.getElementById('inv');
    var mag = document.getElementById('mag');
    var enregistrement = document.getElementById('enregistrement');
    var comp = document.getElementById('comp');
    enregistrement.value = myArray[3];
    inv.value = myArray[2];
    mag.value = myArray[1];
    comp.value = myArray[4];
}

function Render(html) {
    HTMLContainer.innerHTML = "";
    HTMLContainer.insertAdjacentHTML('beforeend', html);
}
setTimeout(function() { selectQte(); }, 1000);

function selectQte() {
    qte.select();
}

function selectionner() { if (event.keyCode === 13) { selectQte() } }

function cabVerif(codeBin) {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var quant = document.getElementById('qte');
    var quanti = document.getElementById('qtei');
    var desc = document.getElementById('desc');
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");
    if (cab.value != "") {
        cab.value = "";
        article.value = "";
        //input.value = "";
        quant.value = "";
        quanti.value = "";
        desc.value = "";
        cab.focus();
        if (codeBin != "") {
            empl.value = codeBin;
            afficheMessage("Scanner article", 'Yellow');
        } else {
            afficheMessage('Article non valide ! ', 'Orange')
        }
    }
}

function next1() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var qtei = document.getElementById('qtei');
    var emp = document.getElementById('emp');
    var qtes = document.getElementById('qtes');
    var comp = document.getElementById('comp');
    var empl = document.getElementById('empl');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
        "cab": cab.value,
        "emp": empl.value,
        "comp": comp.value
    }


    cab.innerHTML = "";
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('item', [item]);

    if (qte.value != '')
        afficheMessage(qte.value + ' Ok pour : ' + article.value, 'GreenYellow');
    cab.focus();
}

function autoComplete(itemNo, descv, emps, unit, qte, qti, qtes, bb) {
    var empst = [];
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var labelEmp = document.getElementById('labelEmp');
    var unite = document.getElementById('unite');
    var emp = document.getElementById('emp');
    var empl = document.getElementById('empl');
    var quant = document.getElementById('qte');
    var quanti = document.getElementById('qtei');
    var quants = document.getElementById('qtes');
    var btnvalid = document.getElementById('btnvalid');
    if (empl.value != '') {
        emp.innerHTML = "";
        article.value = itemNo;
        desc.value = descv;
        quants.value = qtes;



        if (bb === "false" || cabcopy.innerText == "") {
            quant.value = qte;
            quanti.value = qti;
        } else {
            if (quant.value != "") {
                quant.value = parseInt(quant.value) + 1;
            } else {
                quant.value = qte;
                quanti.value = qti;
            }
        }



        if (bb) {
            btnvalid.focus();
        }

        next1();

    } else
        afficheMessage("N° d'emplacement manquant", 'Orange');
}

function login() {
    var pass = document.getElementById('passInput');
    var user = document.getElementById('user');
    const user2 = {
        "us": user.value,
        "ps": pass.value
    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckUser', [user2]);
}

function passerQte(enCours) {




}

function passerCab(enCours) {

    cab.focus();
    cab.select();
}

function go() {
    var mag = document.getElementById('mag');
    var inv = document.getElementById('inv');
    var comp = document.getElementById('comp');
    var enregistrement = document.getElementById('enregistrement');




    const info = {
        "mag": mag.value,
        "inv": inv.value,
        "comp": comp.value,
        "enregistrement": enregistrement.value
    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('info', [info]);
}

function nonscanned(Amount) {
    var input = document.getElementById("nonScanned");
    input.value = Amount;
}

function handleNonScannedClick() {
    var input = document.getElementById("nonScanned");

    const scan = {
        "input": input.value,

    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('scan', [scan]);

}

function WhenLoaded() {
    document.getElementById('spinner').style.display = 'none';
    document.getElementById('container').style.opacity = 1;
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var qtes = document.getElementById('qtes');
    var cabcopy = document.getElementById('cabcopy');
    var comp = document.getElementById('comp');
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");
    var b = true;
    var cabSplit;
    var cabFirstPart;
    var cabLastPart;
    var cabTosend;

    cab.addEventListener('keypress', function(e) {


        if (e.key === 'Enter' || e.keyCode === 13) {

            cab.focus();
            cab.select();
            if (cab.value == "") {
                article.value = "";
                //input.value="";
                desc.value = "";
                qte.value = "";
                qtes.value = "";

            } else {

                cabFirstPart = "";
            }

            if (cabcopy.innerText == cab.value) {
                b = true;

            } else {
                b = false;
                cabcopy.innerText = cab.value;
            }
            const cabv = {
                "cab": cab.value,
                "b": b,
                "comp": comp.value,
                "cabFirstPart": cabFirstPart,
                "empl": empl.value
            }
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB', [cabv]);
            next1();
        }
    });
    cab.focus();

}

function next() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var qtei = document.getElementById('qtei');
    var emp = document.getElementById('emp');
    var qtes = document.getElementById('qtes');
    var comp = document.getElementById('comp');
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");


    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
        "cab": cab.value,
        "emp": empl.value,
        "comp": comp.value
    }
    if (article.value != '') {
        afficheMessage('Succès de validation ! ', 'GreenYellow');
    } else
        changeColor(White);
    cab.focus();
    cab.innerHTML = "";
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('item', [item]);
    if (isNaN(qte.value) || (qte.value <= 0)) {
        qte.value = "";
    } else {
        article.value = "";
        //input.value="";
        desc.value = "";
        qte.value = "";
        qtei.value = "";
        qtes.value = "";
        cab.value = "";
        emp.value = "";
    }


}


function finish() {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var comp = document.getElementById('comp');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
        "comp": comp.value
    }
    console.log('finish');
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('finish', [item]);



}

function finish2() {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var comp = document.getElementById('comp');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
        "comp": comp.value
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('finish2', [item]);
    cab.focus();

}

function reset() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var qtei = document.getElementById('qtei');
    var qtes = document.getElementById('qtes');
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");
    article.value = "";
    desc.value = "";
    qte.value = "";
    qtei.value = "";
    qtes.value = "";
    cab.value = "";
    cab.focus();
    emp.value = "";
    input.value = "";
    empl.value = "";
    changeColor('White');
    afficheMessage("", 'white');
}

function refreshEmpl() {
    var articleNo = document.getElementById('articleNo');
    var emp = document.getElementById('emp');
    var empl = document.getElementById('empl');
    var comp = document.getElementById('comp');
    empl.value = emp.value;

    const binQty = {
        "comp": comp.value,
        "articleNo": articleNo.value,
        "empl": empl.value

    }
    if (articleNo.value != '')
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('UpdateBinQty', [binQty]);

}

function MAJEmp() {
    var emp = document.getElementById('emp');
    var empl = document.getElementById('empl');
    emp.value = "";
    emp.innerHTML = "";
    var opt = document.createElement("option");
    opt
    opt.value = empl.value;
    opt.innerHTML = empl.value;
    emp.appendChild(opt);
}

function changeEmpl() {
    var empl = document.getElementById('empl');
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('UpdateBinQty', [item]);
    cab.focus();
}

function UpdateQty(itemNo, descv, unit, qte, qti, qtes, bb) {

    var empst = [];
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var labelEmp = document.getElementById('labelEmp');
    var unite = document.getElementById('unite');
    var quant = document.getElementById('qte');
    var quanti = document.getElementById('qtei');
    var quants = document.getElementById('qtes');
    article.value = itemNo;
    desc.value = descv;
    quant.value = qte;




    if (emps == '') {
        emp.style.display = "width:120px;display: inline-block;";
        labelEmp.style.display = "width:120px;display: inline-block;";
    }
    unite.innerHTML = '(' + unit + ')';
}

function changeColor(color) {
    var message = document.getElementById('message');
    message.style.background = color;
}

function validation() {
    document.body.style.background = 'GreenYellow';
}

function afficheMessage(msg, color) {
    var message = document.getElementById('message');
    message.value = msg;
    message.style.backgroundColor = color;
}