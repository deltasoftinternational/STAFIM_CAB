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

function selectQte() {}

function selectionner() { if (event.keyCode === 13) { selectQte() } }

function cabVerif(codeBin) {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var quant = document.getElementById('qte');
    var desc = document.getElementById('desc');
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");
    if (cab.value != "") {
        cab.value = "";
        article.value = "";
        //input.value = "";
        quant.value = "";
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
    var comp = document.getElementById('comp');
    var empl = document.getElementById('empl');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
        "cab": cab.value,
        "empl": empl.value,
        "comp": comp.value
    }

    cab.innerHTML = "";
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('item', [item]);

    if (qte.value != '')
        afficheMessage(qte.value + ' Ok pour : ' + article.value, 'GreenYellow');
    cab.focus();
}

function autoComplete(itemNo, descv, emps, unit, qte, qti, qtes, bb) {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var empl = document.getElementById('empl');
    var quant = document.getElementById('qte');

    var btnvalid = document.getElementById('btnvalid');

    if (empl.value != '') {
        article.value = itemNo;
        desc.value = descv;
        quant.value = qtes;



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

function focuscab() {
    var cabq = document.getElementById('cab');
    cabq.focus();
    cabq.select();
}

function focusqte() {
    var cabq = document.getElementById('cabq');
    cabq.focus();
    cabq.select();
}

function focusemp() {
    var empl = document.getElementById('empl');
    empl.focus();
    empl.select();
}

function passerCabQuantity() {
    var cab = document.getElementById('cab');
    var cabq = document.getElementById('cabq');
    var empl = document.getElementById('empl');
    cab.focus();
    cab.select();
    const item = {
        "cabq": cabq.value,
        "empl": empl.value
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('remplirqte2', [item]);


}

function passerCab(enCours) {
    var cab = document.getElementById('cab');
    var comp = document.getElementById('comp');
    var empl = document.getElementById('empl');


    const item = {
        "cab": cab.value,
        "comp": comp.value,
        "cabFirstPart": cab.value,
        "empl": empl.value
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB', [item]);
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
    var cabcopy = document.getElementById('cabcopy');
    var comp = document.getElementById('comp');
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");
    var b = true;
    var cabSplit;
    var cabFirstPart;
    cab.addEventListener('keypress', function(e) {


        if (e.key === 'Enter' || e.keyCode === 13) {

            cab.focus();
            cab.select();
            if (cab.value == "") {
                article.value = "";
                //input.value="";
                desc.value = "";
                qte.value = "";

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
    empl.focus();

}

function next() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var comp = document.getElementById('comp');
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");


    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
        "cab": cab.value,
        "empl": empl.value,
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
        cab.value = "";
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
    var empl = document.getElementById('empl');
    var input = document.getElementById("nonScanned");
    article.value = "";
    desc.value = "";
    qte.value = "";
    cab.value = "";
    cab.focus();
    input.value = "";
    empl.value = "";
    changeColor('White');
    afficheMessage("", 'white');
}

function refreshEmpl() {
    var articleNo = document.getElementById('articleNo');
    var empl = document.getElementById('empl');
    var comp = document.getElementById('comp');

    const binQty = {
        "comp": comp.value,
        "articleNo": articleNo.value,
        "empl": empl.value

    }
    if (articleNo.value != '')
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('UpdateBinQty', [binQty]);

}

function MAJEmp() {
    var empl = document.getElementById('empl');
    var opt = document.createElement("option");
    opt
    opt.value = empl.value;
    opt.innerHTML = empl.value;
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
    article.value = itemNo;
    desc.value = descv;
    quant.value = qte;




    if (emps == '') {}
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