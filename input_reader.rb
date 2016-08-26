class InputReader
	
	def initialize()
		@returnMemory = []
		romfile = File.open("./c8games/PONG","rb")
		data = IO.binread(romfile)
		hexData = data.unpack('H*')[0]
		(hexData.length/2).times do |i|
			start_inst = i*2
			len_inst = start_inst + 2
			@returnMemory.push << hexData[start_inst...len_inst]
		end
	end
	
	def getRomMemory()
		return @returnMemory
	end
end
