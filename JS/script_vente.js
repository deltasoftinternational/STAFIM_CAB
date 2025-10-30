function Render(html) {
    HTMLContainer.innerHTML = "";
    HTMLContainer.insertAdjacentHTML('beforeend', html);

}




function afficherModal() {
    const modal = document.getElementById('myModal');
    modal.style.display = 'block';
}

function fermerModal() {

    var article = document.getElementById('articleNo');
    var cab = document.getElementById('cab');
    var desc = document.getElementById('desc');
    var qtea = document.getElementById('qtea');
    var emp = document.getElementById('emp');

    const item = {
        "art": article.value,
        "cab": cab.value,
        "des": desc.value,
        "qtea": qtea.value,
        "qteaf": qteaf.value,
        "emp": emp.value,

    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('fermerModal', [item]);
}

function cabnonvalide() {
    var cab = document.getElementById('cab');
    var cabq = document.getElementById('cabq');

    var article = document.getElementById('articleNo');
    var quanta = document.getElementById('qtea');
    var quants = document.getElementById('qtes');

    var Lot = document.getElementById('Lot');

    var desc = document.getElementById('desc');
    cabq.value = "";
    article.value = "";
    desc.value = "";
    quanta.value = "";
    Lot.value = "";
    quants.value = "";

    cab.value = "";
    cab.focus();
    afficheMessage(" Article non  valide", 'Orange');


}

function next1() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qtea = document.getElementById('qtes');
    var qteaf = document.getElementById('qtea');
    var emp = document.getElementById('emp');
    var Lot = document.getElementById('Lot');
    var daeEx = document.getElementById('daeEx');
    var increment = document.getElementById('increment');
    if (increment && increment.checked) {
        increment = 'TRUE';
    } else {
        increment = 'FALSE';
    }


    const item = {
        "art": article.value,
        "des": desc.value,
        "qtea": qtea.value,
        "qteaf": qteaf.value,
        "cab": cab.value,
        "emp": emp.value,
        "Lot": Lot.value,
        "daeEx": daeEx.value,
        "vide": 'FALSE'
    }


    cab.innerHTML = "";
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('item', [item]);

    if (qtea.value != '') {

        afficheMessage('scan : ' + qtea.value + ' ' + cab.value, 'GreenYellow');

        if (increment === 'FALSE') {
            qtea.focus();
            qtea.select();

        } else {
            cab.focus();
            cab.select();
        }

    }
}


function check() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');

    var emp = document.getElementById('emp');

    var qtes = document.getElementById('qtes');
    var qtea = document.getElementById('qtea');

    var cabcopy = document.getElementById('cabcopy');
    var Lot = document.getElementById('Lot');
    var daeEx = document.getElementById('daeEx');

    var b = true;

    cab.focus();
    cab.select();
    var increment = document.getElementById('increment');
    if (increment && increment.checked) {
        increment = 'TRUE';
    } else {
        increment = 'FALSE';
    }


    if (cab.value == "") {
        article.value = "";
        desc.value = "";
        Lot.value = "";
        daeEx.value = "";

        qtea.value = "";


    }


    if (cabcopy.innerText == cab.value) {
        b = true;

    } else {
        b = false;
        cabcopy.innerText = cab.value;
    }

    const cabv = { "cab": cab.value, "b": b, 'articleNo': article.value, "Lot": Lot.value, "daeEx": daeEx.value, "qtea": qtea.value, "qtes": qtes.value, "increment": increment }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB', [cabv]);
    if (increment === 'FALSE') {
        qtes.focus();
        qtes.select();

    } else {
        cab.focus();
        cab.select();
    }

}


function ViderCAB() {
    var cab = document.getElementById('cab');
    cab.focus();
    cab.select();
}

function next2() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qtea = document.getElementById('qtes');
    var qteaf = document.getElementById('qtea');
    var emp = document.getElementById('emp');
    var Lot = document.getElementById('Lot');
    var daeEx = document.getElementById('daeEx');
    var cabq = document.getElementById('cabq');
    cabq.value = "0";

    const item = {
        "art": article.value,
        "des": desc.value,
        "qtea": qtea.value,
        "qteaf": qteaf.value,
        "cab": cab.value,
        "emp": emp.value,
        "Lot": Lot.value,
        "daeEx": daeEx.value,
        "vide": 'TRUE'
    }


    cab.innerHTML = "";
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('item', [item]);

    if (qtea.value != '') {

        afficheMessage('scan : ' + qtea.value + ' ' + cab.value, 'GreenYellow');

        cab.focus();

        cab.focus();
        cab.select();
    }
}





function autoComplete(barcodeNo, itemNo, descv, qtea, bb, quantitya) {
    var cabElement = document.getElementById('allcab');
    cabElement.style.width = '100%';
    cabElement.style.display = '';
    cabElement.style.flexDirection = '';
    cabElement.style.alignItems = '';





    var article = document.getElementById('articleNo');
    var cab = document.getElementById('cab');
    var desc = document.getElementById('desc');
    var quantaf = document.getElementById('qtea');
    var quanta = document.getElementById('qtes');

    var cabcopy = document.getElementById('cabcopy');
    cab.value = barcodeNo;
    cab.focus();
    cab.select();
    if (cab.value != "") {
        cab.innerHTML = "";
        cab.value = barcodeNo;

        article.value = itemNo;
        desc.value = descv;
        quanta.value = qtea;
        quantaf.value = quantitya;


        if (bb === "false" || cabcopy.innerText == "") {
            quanta.value = qtea;


        } else {
            if (quanta.value != "") {


            } else {
                quanta.value = qtea;


            }

        }


    }
    next1();



}















function login() {
    var pass = document.getElementById('passInput');
    var user = document.getElementById('user');
    var role = document.getElementById('role');




    const user2 = {
        "us": user.value,
        "ps": pass.value,
        "role": role.value
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckUser', [user2]);



}

function selectRow(row, value) {
    // Remove highlight from all rows in the same table
    var rows = row.parentElement.querySelectorAll("tr");
    rows.forEach(r => {
        r.style.backgroundColor = "#fff";
    });

    // Highlight the selected row
    row.style.backgroundColor = "#c8f7c5";

    // Update the hidden input field with the selected value
    var cmdv = document.getElementById("cmdv");
    if (cmdv) {
        cmdv.value = value;
        cmdv.focus();
        cmdv.select();
    }
}

function remplir() {
    var cmdvl = document.getElementById('cmdvl');
    var cmdv = document.getElementById('cmdv');
    cmdv.value = cmdvl.value;
    cmdv.focus();
    cmdv.select();




}

function go() {
    var cmdv = document.getElementById('cmdv');

    const info = {
        "cmdv": cmdv.value,

    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('info', [info]);



}

function back() {
    var cab = document.getElementById('cab');

    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qtea = document.getElementById('qtes');
    var qteaf = document.getElementById('qtea');
    const item = {
        "art": article.value,
        "cab": cab.value,
        "des": desc.value,
        "qtea": qtea.value,
        "qteaf": qteaf.value,
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('back_to_login', [item]);

}



function Ventefocus() {

    var Vente = document.getElementById('Vente');
    Vente.focus();



}

function passerCabQuantity() {
    var cab = document.getElementById('cab');
    var cabq = document.getElementById('cabq');
    cab.focus();
    cab.select();
    const item = {
        "cabq": cabq.value
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('remplirqte2', [item]);


}
async function remplirqte() {
    var cabq = document.getElementById('cabq');
    cabq.focus();
    cabq.select();



}





function rempliremp(value) {

    var emp = document.getElementById('emp');


    emp.value = value;

    // const cabv = { "cab": cab.value, "b": b, 'articleNo': article.value, "Lot": Lot.value, "daeEx": daeEx.value, "qtea": qtea.value, "qtes": qtes.value, "increment": increment, "emplacement": emp.value }
    // Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB', [cabv]);

}

function remplirqtestock(stock) {
    var qtestock = document.getElementById('qtestock');
    qtestock.value = stock;
}


function Viderqte() {
    var cab = document.getElementById('cab');
    var qtes = document.getElementById('qtes');
    var qtea = document.getElementById('qtea');
    var qtescan = document.getElementById('qtescan');

    qtes.value = "";
    qtescan.value = "";
    qtea.value = "";

    cab.focus();
    cab.select();
    afficheMessage('Quantité doit étre inférieur à la quantité demandée ! ', 'GreenYellow');

}

function terminer() {
    const info = {
        "cmdv": "",

    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('terminer', [info]);
}

function SelectCab() {
    var cab = document.getElementById('cab');
    cab.focus();
    cab.select();
}

function WhenLoaded() {

    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var cabq = document.getElementById('cabq');
    var desc = document.getElementById('desc');

    var emp = document.getElementById('emp');

    var qtes = document.getElementById('qtes');
    var qtea = document.getElementById('qtea');

    var cabcopy = document.getElementById('cabcopy');
    var Lot = document.getElementById('Lot');
    var daeEx = document.getElementById('daeEx');
    var Colis = document.getElementById('Colis');

    var b = true;

    cab.addEventListener('keypress', function(e) {

        if ((e.keyCode == 13)) {
            let value = cab.value;
            if (value.length > 0 && (value[0] === 'P' || value[0] === 'Q')) {
                value = value.substring(1);
                cab.value = value;
            }

            cab.focus();
            cab.select();

            var increment = document.getElementById('increment');
            if (increment && increment.checked) {
                increment = 'TRUE';
            } else {
                increment = 'FALSE';
            }

            if (cab.value == "") {
                article.value = "";
                desc.value = "";
                Lot.value = "";
                daeEx.value = "";

                qtea.value = "";
                cabq.value = "";


            }


            if (cabcopy.innerText == cab.value) {
                b = true;

            } else {
                b = false;
                cabcopy.innerText = cab.value;
            }
            const cabv = { "cab": cab.value, "b": b, 'articleNo': article.value, "Lot": Lot.value, "daeEx": daeEx.value, "qtea": qtea.value, "qtes": qtes.value, "increment": increment, "emplacement": emp.value, "Colis": Colis.value, "cabq": cabq.value }
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB', [cabv]);
        }
    });
    cab.focus();
    cab.select();


}

function finish() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var daeEx = document.getElementById('daeEx');

    var desc = document.getElementById('desc');
    var qtea = document.getElementById('qtes');
    var qteaf = document.getElementById('qtea');
    var emp = document.getElementById('emp');
    var Lot = document.getElementById('Lot');


    const item = {
        "art": article.value,
        "des": desc.value,
        "qtea": qtea.value,
        "qteaf": qteaf.value,
        "cab": cab.value,
        "emp": emp.value,
        "Lot": Lot.value,
        "daeEx": daeEx.value,
    }
    if (article.value != '') {
        afficheMessage('Succès de validation ! ', 'GreenYellow');
    } else {
        changeColor(White);
    }
    qtea.focus();
    qtea.innerHTML = "";

    var regex = /^[0-9]+$/;
    if (!regex.test(qtea.value)) {
        qtea.value = "";
        afficheMessage('Format non valide ', 'Red');
    } else {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('finish', [item]);
        article.value = "";
        desc.value = "";
        qtea.value = "";
        cab.value = "";
        Lot.value = "";
        daeEx.value = "";
    }
}


function passerQte(enCours) {

    qtea.focus();
    qtea.select();

}

function passerCab(enCours) {
    var cab = document.getElementById('cab');

    cab.focus();
    cab.select();
}


function finish2() {
    var article = document.getElementById('articleNo');


    const item = {
        "art": article.value


    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('finish2', [item]);
    cab.focus();

}


function reset() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var emp = document.getElementById('emp');
    var unite = document.getElementById('unite');
    var errorMessage = document.getElementById('errorMessage');
    var qtea = document.getElementById('qtea');
    var qtes = document.getElementById('qtes');
    var qtestock = document.getElementById('qtestock');


    var Lot = document.getElementById('Lot');
    var daeEx = document.getElementById('daeEx');
    var cabq = document.getElementById('cabq');
    cabq.value = "";
    qtestock.value = "";
    qtes.value = "";
    article.value = "";
    desc.value = "";

    cab.value = "";
    qtea.value = "";
    Lot.value = "";
    daeEx.value = "";
    unite.value = "";
    changeColor('White');
    afficheMessage("", 'white');
    cab.focus();

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