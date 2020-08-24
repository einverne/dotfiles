
log = hs.logger.new('autoscript', 'debug')

function keyboardCallback(data)
--	if data.eventType == "added" then
--		log.i(data.productName .. data.vendorName .. data.vendorID .. data.productID .. "added")
--	end
--	if data.eventType == "removed" then
--		log.i(data.productName .. data.vendorName .. data.vendorID .. data.productID .. "removed")
--	end
	log.i(data)
end

local keyboardWatcher = hs.usb.watcher.new(keyboardCallback)
keyboardWatcher:start()
