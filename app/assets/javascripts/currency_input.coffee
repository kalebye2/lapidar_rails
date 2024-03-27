window.currency_input_validate = (input) ->
#	maxnum = 999999999999999
#	normal = parseInt(input.value.replace(/\D/g, ""))
#	
#	if normal >= maxnum
#		normal = maxnum
#
#	if normal == 0
#		input.value = "0,00"
#	else
#		wholeNum = Math.floor(normal / 100)
#		centsNum = normal % 100
#		input.value = '' + wholeNum + ',' + ((centsNum + '0').slice(0, 2))

	input.onkeydown = (e) ->
		inputInvalid = ["0,0", "0", ""]
		cursor = input.selectionStart
		
		if inputInvalid.includes(input.value)
			input.value = "0,00"

		valueNormalized = parseInt(input.value.replace(/\D/g, ""))

		# pobrema do valor frutuante
		if valueNormalized > 999999999999999
			valueNormalized = 999999999999999
		else
			valueWhole = Math.floor valueNormalized / 100
			valueCents = valueNormalized % 100
			input.value = '' + valueWhole + ',' + ((valueCents + '0').slice(0, 2))

		if e.key == "Backspace"
			input.setSelectionRange(cursor + 1, cursor + 1)
		else
			input.setSelectionRange(cursor, cursor)

		null
