json.status 200
json.requests @reqs do |req|
	json.partial!('requests/request2', req: req)
end
