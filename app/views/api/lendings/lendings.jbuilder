json.status 200
json.lendings @lendings do |lending|
	json.partial!('lendings/lending', lending: lending)
end
