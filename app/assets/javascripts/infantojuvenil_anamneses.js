function init() {
	var tabela = document.getElementById("tabela-anamnese");
	const tds = tabela.querySelectorAll('td');

	tds.forEach(td => {
		td.setAttribute('contentEditable', true);
	});
}

//window.onload = init;
