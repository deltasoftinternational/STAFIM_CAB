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



function remplirdescription(description) {
    var desc = document.getElementById('desc');
    desc.value = description;
}



// Function to add a row to the table
function rempliremp(emp, quantity) {
    var table = document.getElementById("tableEmp");
    var row = table.insertRow(-1); // add at the end
    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);

    cell1.innerText = emp;
    cell2.innerText = quantity;

    // Refocus on the article input for next scan
    var cab = document.getElementById("article");
    cab.focus();
    cab.select();
}

// Function to initialize page and handle Article input
function WhenLoaded() {
    var cab = document.getElementById("article");
    var desc = document.getElementById("desc");
    cab.addEventListener("keypress", function(e) {
        if (e.key === "Enter") {
            // Clear table (keep header)
            var table = document.getElementById("tableEmp");
            while (table.rows.length > 1) {
                table.deleteRow(1);
            }
            desc.value = ""

            // Call NAV function (example)
            const cabv = { "cab": cab.value };
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("CheckCAB", [cabv]);
        }
    });

    cab.focus();
    cab.select();
}