function remplir(id) {
    let text = id;
    var lrecep = document.getElementById('lrecep');
    var recep = document.getElementById('recep');
    recep.value = lrecep.value;
    recep.focus();
    recep.select();
}



function addRow(magasin, emp, qte) {
    document.getElementById('tablepop').style.display = 'block';
    const tableBody = document.getElementById('tableBody');

    // Create a new row element
    const row = document.createElement('tr');

    // Create and append the 'Mag' column
    const magasinCell = document.createElement('td');
    magasinCell.textContent = magasin;
    row.appendChild(magasinCell);

    // Create and append the 'Emp' column
    const empCell = document.createElement('td');
    empCell.textContent = emp;
    row.appendChild(empCell);

    // Create and append the 'Qte' column
    const qteCell = document.createElement('td');
    qteCell.textContent = qte;
    row.appendChild(qteCell);
    // Append the new row to the table body
    tableBody.appendChild(row);
}

// Function to add a row with a different color and unselectable
function addRow2(magasin, emp, qte) {
    document.getElementById('tablepop').style.display = 'block';
    const tableBody = document.getElementById('tableBody');

    // Create a new row element
    const row = document.createElement('tr');

    // Add the 'no-select' class to this row for different color and unselectable behavior
    row.classList.add('no-select');

    // Create and append the 'Mag' column
    const magasinCell = document.createElement('td');
    magasinCell.textContent = magasin;
    row.appendChild(magasinCell);

    // Create and append the 'Emp' column
    const empCell = document.createElement('td');
    empCell.textContent = emp;
    row.appendChild(empCell);

    // Create and append the 'Qte' column
    const qteCell = document.createElement('td');
    qteCell.textContent = qte;
    row.appendChild(qteCell);

    // Append the new row to the table body
    tableBody.appendChild(row);
}


// Function to clear the table
function clearTable() {
    // Get the table body by ID
    document.getElementById('tablepop').style.display = 'none';

    const tableBody = document.getElementById('tableBody');

    // Remove all existing rows in the table body
    tableBody.innerHTML = ''; // This removes all rows
}

function addRow4(magasin, emp, qte) {
    document.getElementById('tablepop').style.display = 'block';
    const tableBody = document.getElementById('tableBody');

    // Create a new row element
    const row = document.createElement('tr');

    // Add the 'no-select' class and 'blue' class for a hard blue color
    row.classList.add('no-select', 'hard-blue'); // Hard blue for this row

    // Create and append the 'Mag' column
    const magasinCell = document.createElement('td');
    magasinCell.textContent = magasin;
    row.appendChild(magasinCell);

    // Create and append the 'Emp' column
    const empCell = document.createElement('td');
    empCell.textContent = emp;
    row.appendChild(empCell);

    // Create and append the 'Qte' column
    const qteCell = document.createElement('td');
    qteCell.textContent = qte;
    row.appendChild(qteCell);

    // Append the new row to the table body
    tableBody.appendChild(row);
}

function addRow3(magasin, emp, qte) {
    document.getElementById('tablepop').style.display = 'block';
    const tableBody = document.getElementById('tableBody');

    // Create a new row element
    const row = document.createElement('tr');

    // Add the 'light-gray' class for a lighter gray color and make it unselectable
    row.classList.add('no-select', 'light-gray');

    // Create and append the 'Mag' column
    const magasinCell = document.createElement('td');
    magasinCell.textContent = magasin;
    row.appendChild(magasinCell);

    // Create and append the 'Emp' column
    const empCell = document.createElement('td');
    empCell.textContent = emp;
    row.appendChild(empCell);

    // Create and append the 'Qte' column
    const qteCell = document.createElement('td');
    qteCell.textContent = qte;
    row.appendChild(qteCell);

    // Append the new row to the table body
    tableBody.appendChild(row);
}

// Function to add a hard blue row (addRow4) and make it unselectable
function addRow4(magasin, emp, qte) {
    document.getElementById('tablepop').style.display = 'block';
    const tableBody = document.getElementById('tableBody');

    // Create a new row element
    const row = document.createElement('tr');

    // Add the 'hard-blue' class for a hard blue color and make it unselectable
    row.classList.add('no-select', 'hard-blue');

    // Create and append the 'Mag' column
    const magasinCell = document.createElement('td');
    magasinCell.textContent = magasin;
    row.appendChild(magasinCell);

    // Create and append the 'Emp' column
    const empCell = document.createElement('td');
    empCell.textContent = emp;
    row.appendChild(empCell);

    // Create and append the 'Qte' column
    const qteCell = document.createElement('td');
    qteCell.textContent = qte;
    row.appendChild(qteCell);

    // Append the new row to the table body
    tableBody.appendChild(row);
}



function clearallrec() {
    clearTable();
    var source = document.getElementById('empl');
    var dest = document.getElementById('empld');
    var qte = document.getElementById('qte');
    var qtevalide = document.getElementById('qtevalide');
    source.value = "";
    dest.value = "";
    qte.value = "";
    qtevalide.value = "";
    clearTable();

}






function getlocationd(valider, lineno, lastlineno, Description, qtevalide3) {

    //alert(url);
    var source = document.getElementById('empl');
    var qte = document.getElementById('qte');
    var qtevalide = document.getElementById('qtevalide');
    var dest = document.getElementById('empld');
    var articleNo = document.getElementById('articleNo');
    var current = new Date();
    var date = new Date(current.getTime());
    var option = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' };
    var datetime = date.toLocaleString('en-US', option);
    qtevalide.value = qtevalide3;
    const cabv = {
        "articleNo": articleNo.value,
        "qtevalide": qtevalide.value,
        "empl": empl.value,
        "empld": empld.value,
        "valider": valider,
        "lineno": lineno,
        "qte": qte.value,
        "date": datetime,
        "lastlineno": lastlineno,
        "Description": Description
    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB_3', [cabv]);


}

function postws(url, numRecep, Line_No, date, articleNo, desc, magSave, empl, empld, Qte, username, password) {
    const myArray = date.split(",");
    date1 = myArray[0];
    const myArray2 = date1.split("/");
    var date2 = myArray2[2] + "-" + myArray2[0] + "-" + myArray2[1];
    const myHeaders = new Headers();
    myHeaders.append("Content-Type", "application/json");
    myHeaders.append("Authorization", "Basic " + btoa(username + ":" + password));

    const raw = JSON.stringify({
        "Journal_Template_Name": "TRANSFERT",
        "Journal_Batch_Name": numRecep,
        "Line_No": Line_No,
        "Posting_Date": date2,
        "Document_Date": date2,
        "Item_No": articleNo,
        "Document_No": "BARCODE",
        "Gen_Prod_Posting_Group": "PR_19",
        "Location_Code": magSave,
        "Bin_Code": empl,
        "New_Location_Code": magSave,
        "New_Bin_Code": empld,

        "Quantity": Qte,




    });

    const requestOptions = {
        method: "POST",
        headers: myHeaders,
        body: raw,
        redirect: "follow"
    };

    fetch(url, requestOptions)
        .then((response) => response.text())
        .then((result) => console.log(result))
        .catch((error) => console.error(error));

    var qte = document.getElementById('qte');
    var qtevalide = document.getElementById('qtevalide');
    qtevalide.value = Qte;
    qte.value = "0";



}

function updatews(Qte) {

    var qte = document.getElementById('qte');
    var qtevalide = document.getElementById('qtevalide');
    qte.value = "";
    qte.focus();
    qte.select();
    qtevalide.value = Qte;


}


function Render(html) {
    HTMLContainer.innerHTML = "";
    HTMLContainer.insertAdjacentHTML('beforeend', html);
}
//<<



function cabVerif(codeBin) {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');

    var quant = document.getElementById('qte');
    var quanti = document.getElementById('qtei');
    var quants = document.getElementById('qtes');
    var empl = document.getElementById('empl');
    var quantité = document.getElementById('quantité');
    cab.value = '';
    article.value = '';
    desc.value = '';
    quant.value = '';
    quanti.value = '';
    quants.value = '';
    empl.value = '';
    emp.value = '';
    quantité.value = '';

    afficheMessage('Article non valide ! ', 'Orange')
        //alert("article non valide !");
}

function qtevalide(qte, quantité) {
    var qtevalide = document.getElementById('qtevalide');
    var quant = document.getElementById('qte');
    qtevalide.value = quantité;
    quant.value = qte;



}

function scan() {
    var audio = new Audio("https://web.opendrive.com/api/v1/download/file.json/MzFfNDg1NzQ2NTRf?temp_key=%B1%C6%A7%C1%AB&inline=1");

    audio.play();
}

function articlenonvalide() {
    var qte = document.getElementById('qte');
    qte.value = '';
    afficheMessage("Dépassement de la quantité requise", 'Orange');

}

function recepverify() {

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('AddItem0');


}

function recep(name, batchname) {


    var lrecep = document.getElementById('lrecep');

    var opt = document.createElement("option");
    opt.value = name;
    opt.innerHTML = name;

    lrecep.appendChild(opt);






}

function recep2(Magasin) {



    var lrecep = document.getElementById('lmag');
    var opt = document.createElement("option");


    opt.value = Magasin;
    opt.innerHTML = Magasin;
    lrecep.appendChild(opt);



}

function next1(valider) {
    var empl = document.getElementById('empl');
    var empld = document.getElementById('empld');
    var articleNo = document.getElementById('articleNo');
    var qte = document.getElementById('qte');
    qte.focus();
    qte.select();
    if (empl.value != "") {
        const cabv = {
            "articleNo": articleNo.value,
            "empl": empl.value,
            "empld": empld.value,
            "valider": valider
        }


        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB_2', [cabv]);
    }
}

function qntynonvalide() {
    afficheMessage('Quantité non valide ! ', 'Orange');
}

function quantiténonvalide() {
    var qte = document.getElementById('qte');
    qte.value = '';
    afficheMessage("La quantité saisie est inférieure à 0", 'Orange');

}

function cabnonvalide() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var qtei = document.getElementById('qtei');
    var qtes = document.getElementById('qtes');
    var empl = document.getElementById('empl');
    var quantité = document.getElementById('quantité');
    article.value = "";
    desc.value = "";
    qte.value = "";
    quantité.value = "";
    qtei.value = "";
    qtes.value = "";
    cab.value = "";
    cab.focus();
    emp.value = "";
    empl.value = "";
    afficheMessage("Veuillez scanner un article", 'Orange');

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



function passerCab(enCours) {

    cab.focus();
    cab.select();
}

function go() {
    var recep = document.getElementById('recep');
    var lmag = document.getElementById('lmag');



    const info = {
        "recep": recep.value,
        "mag": lmag.value

    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('info', [info]);




}

function refreshempld() {
    var empl = document.getElementById('empl');
    var empld = document.getElementById('empld');
    var articleNo = document.getElementById('articleNo');
    if (empl.value != "") {
        empld.focus();
        empld.select();
        const cabv = {
            "articleNo": articleNo.value,
            "empl": empl.value,
            "empld": empld.value,
            "valider": "0"
        }


        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB_2', [cabv]);
    }

}

function refreshqty() {
    var empl = document.getElementById('empl');
    var articleNo = document.getElementById('articleNo');
    var empld = document.getElementById('empld');
    var qte = document.getElementById('qte');
    if ((empld.value != "") && (empl.value != "")) {
        qte.focus();
        qte.select();
        const cabv = {
            "articleNo": articleNo.value,
            "empl": empl.value,
            "empld": empld.value,
            "valider": "0"
        }


        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB_2', [cabv]);

    }

}

function populateitem(itemno, description) {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    article.value = itemno;
    desc.value = description;

}

function focusdest() {
    var dest = document.getElementById('empld');
    dest.focus();
    dest.select();

}

function WhenLoaded() {
    //setTimeout(() => {


    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var qtes = document.getElementById('qtes');
    var cabcopy = document.getElementById('cabcopy');
    var quantité = document.getElementById('quantité');
    var empl = document.getElementById('empl');
    var b = true;
    var cabSplit;
    var cabFirstPart;
    var cabLastPart;
    var cabTosend;
    const tableBody = document.getElementById('tableBody');

    tableBody.addEventListener('click', function(event) {
        // Check if the clicked element is a table row (<tr>)
        if (event.target.tagName === 'TD') {
            const row = event.target.closest('tr'); // Get the closest <tr> element

            // If the row has the 'no-select' class, don't allow selection
            if (row.classList.contains('no-select')) {
                return; // Exit the function and do not allow row selection
            }

            const emp = row.cells[1].textContent; // Get the 'Emp' column data from the row (index 1)

            // Highlight the clicked row by adding the 'selected' class
            const rows = document.querySelectorAll('#tableBody tr');
            rows.forEach(r => r.classList.remove('selected')); // Remove previous selection
            row.classList.add('selected'); // Add 'selected' class to the clicked row
            var articleNo = document.getElementById('articleNo');
            var empl = document.getElementById('empl');
            var empld = document.getElementById('empld');
            empl.value = emp;
            const cabv = {
                "articleNo": articleNo.value,
                "empl": empl.value,
                "empld": empld.value,
                "valider": "0"
            }


            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB_2', [cabv]);


        }

    });


    cab.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            var quantité = document.getElementById('quantité');
            var news = cab.value.split(' ')[0];
            var cleaned = news.replace('-000000', '');
            cleaned = cleaned.replace('-00000', '');
            cleaned = cleaned.replace('-0000', '');
            cleaned = cleaned.replace('-000', '');
            if (article.value == cleaned) {
                cab.value = cleaned;
            }

            if (cab.value == "") {
                article.value = "";
                desc.value = "";
                qte.value = "";
                qtes.value = "";
                quantité.value = "";

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
                "cabFirstPart": cabFirstPart,
                "empl": empl.value
            }


            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckCAB', [cabv]);
        }
    });
    cab.focus();

    //}, 1800);
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
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('finish', [item]);



}

function finish2() {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('finish2', [item]);
    cab.focus();

}

function reset() {
    var cab = document.getElementById('cab');
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    var qtes = document.getElementById('qtes');
    var empl = document.getElementById('empl');
    var qtevalide = document.getElementById('qtevalide');
    var empld = document.getElementById('empld');
    empld.value = "";
    cab.value = "";
    article.value = "";
    desc.value = "";
    qte.value = "";
    qtes.value = "";
    empl.value = "";


    qtevalide.value = "";
    clearTable();
    cab.focus();
    cab.select();

}
//>>

function refreshEmpl() {
    afficheMessage("Veuillez valider", 'Yellow');
    var empl = document.getElementById('empl');

    empl.value = emp.value;



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
    // var emp = document.getElementById('emp');
    var quant = document.getElementById('qte');
    var quanti = document.getElementById('qtei');
    var quants = document.getElementById('qtes');
    //emp.innerHTML = "";
    article.value = itemNo;
    desc.value = descv;
    quant.value = qte;



    // if (emps != '') {
    //     emp.style.display = "width:120px;display: inline-block;";
    //     labelEmp.style.display = "width:120px;display: inline-block;";
    // }
    // empst = emps.split(',');
    // for (i = 0; i < empst.length - 1; i++) {
    //     var opt = document.createElement("option");
    //     opt.value = empst[i];
    //     opt.innerHTML = empst[i];
    //     emp.appendChild(opt);
    // }
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

function back() {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    const item = {
            "art": article.value,
            "des": desc.value,
            "qte": qte.value
        }
        //alert('hello');

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('back_to_login', [item]);
    //var cmdv = document.getElementById('cmdv');
    //cmdv.focus();
    //go();
}

function recepfocus() {

    var recep = document.getElementById('recep');
    recep.focus();



}

function calculer_quantité2() {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('calculer_quantité', [item]);
    //Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Valider_commande_vente', [item]);
    cab.focus();

}

function Valider_commande_achat2() {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Valider_commande_achat', [item]);
    cab.focus();

}

function Terminer() {
    var article = document.getElementById('articleNo');
    var desc = document.getElementById('desc');
    var qte = document.getElementById('qte');
    const item = {
        "art": article.value,
        "des": desc.value,
        "qte": qte.value,
    }

    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Terminer', [item]);
    cab.focus();

}

function recepfocus2(text) {
    var cmdv = document.getElementById('cmdv');
    var recep = document.getElementById('recep');
    cmdv.value = text;
    recep.focus();
}

function validation() { //IL
    document.body.style.background = 'GreenYellow';
}

function afficheMessage(msg, color) { //LI 15/12/2022
    var message = document.getElementById('message');
    message.value = msg;
    message.style.backgroundColor = color;
}