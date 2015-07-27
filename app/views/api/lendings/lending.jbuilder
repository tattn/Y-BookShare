json.status 200
json.lending do
	json.partial!('lendings/lending', lending: @lending)
end
