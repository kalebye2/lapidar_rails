console.log("Anamnese");

function init() {
	var tabela = document.getElementById("tabela-anamnese");
	console.log(tabela);
	const tds = tabela.querySelectorAll('td');
	console.log(tds);

	tds.forEach(td => {
		td.setAttribute('contentEditable', true);
	});
}

//window.onload = init;
