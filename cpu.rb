class CPU8
	def initialize(memory,size,regs)
		@memoryStack = memory
		@rom_size = size
		@v_reg = regs 
	end
	
	def cpu_loop()
		i = 0x200
		i_stack = 0
		return_addr = 0
		return_stack = []
		while i < (0x200+@rom_size)
			instruction = @memoryStack[i]+@memoryStack[i+1]	
			
			case instruction[0]
			
			when '1'
				return_addr = i
				i = instruction[1..3].to_i(16)-2
				puts "instrucion is #{instruction} return addr is #{return_addr} current i = #{i}"
			when '2'
				return_stack.push(i)
				i = instruction[1..3].to_i(16)-2
				puts "instrucion is #{instruction} jump return addr is #{return_stack.last()} current i = #{i}"
			when '6'
				@v_reg[instruction[1].to_i(16)] = instruction[2..3]		
				puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{@v_reg[instruction[1].to_i(16)]}"
			end	
		
			i = i + 2				
		end
	end
end
