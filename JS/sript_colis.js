function Render(html) {
    HTMLContainer.innerHTML = "";
    HTMLContainer.insertAdjacentHTML('beforeend', html);

}

function PICK() {
    var pass = document.getElementById('passInput');
    var user = document.getElementById('user');
    const user2 = {
        "us": user.value,
        "ps": pass.value,
        "role": "PICK"
    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('CheckUser', [user2]);
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


async function remplirqte() {
    var cabq = document.getElementById('cabq');
    cabq.focus();
    cabq.select();



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



function go() {
    var cmdv = document.getElementById('cmdv');

    const info = {
        "cmdv": cmdv.value,

    }
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('info', [info]);



}
// Function to add a row to the table
function rempliremp(emp, quantity) {
    var table = document.getElementById("tableEmp");
    var row = table.insertRow(-1);
    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);

    cell1.innerText = emp;
    cell2.innerText = quantity;

    var cab = document.getElementById("article");
    cab.focus();
    cab.select();
}

function afficheMessage(msg, color) {
    var message = document.getElementById('message');
    message.value = msg;
    message.style.backgroundColor = color;
}
// Function to initialize page and handle Article input
function WhenLoaded() {
    var cab = document.getElementById("article");
    cab.addEventListener("keypress", function(e) {
        if (e.key === "Enter") {
            // Clear table (keep header)
            var table = document.getElementById("tableEmp");
            while (table.rows.length > 1) {
                table.deleteRow(1);
            }

            // Call NAV function (example)
            const cabv = { "cab": cab.value };
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("CheckCAB", [cabv]);
        }
    });

    cab.focus();
    cab.select();
}