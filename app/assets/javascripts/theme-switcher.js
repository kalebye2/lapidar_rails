window.onload = () => {
	var stored = localStorage;
	if (stored.length == 0) stored.theme = "dark";
	document.body.className = stored.theme;

	const themes = ["dark", "light"];

	const switch_btn = document.getElementById("btn-theme-switch");
	const el_body = document.body;


	function switch_theme() {
		var th = 0;
		for (i in themes) {
			if (themes[i - 1] === stored.theme) {
				th = i;
			}
		}
		stored.theme = themes[th];
		el_body.className = stored.theme;
	}

	switch_btn.onclick = switch_theme;
}
