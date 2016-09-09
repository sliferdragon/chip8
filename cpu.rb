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
			when '3'
				if @v_reg[insturcion[1].to_i(16)] == instruction[2..3] then
					i = i + 2
					puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{@v_reg[instruction[1].to_i(16)]} and #{instruction[2..3]} == So Skipping"
                end
			when '4'
				if @v_reg[insturcion[1].to_i(16)] != instruction[2..3] then
					i = i + 2
					puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{@v_reg[instruction[1].to_i(16)]} and #{instruction[2..3]} != So Skipping"				
                end                    
			when '5'
				if @v_reg[insturcion[1].to_i(16)] == @v_reg[insturcion[2].to_i(16)] then
					i = i + 2
					puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{@v_reg[instruction[1].to_i(16)]} and regv#{instruction[2].to_i(16)} = #{@v_reg[instruction[2].to_i(16)]} == So Skipping"
				end			
			when '6'
				@v_reg[instruction[1].to_i(16)] = instruction[2..3]		
				puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2..3]}"			                            
            when '7'
                @v_reg[instruction[1].to_i(16)] = (@v_reg[instruction[1].to_i(16)].to_i(16) + instruction[2..3].to_i(16)).to_s(16)		    
                puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{@v_reg[instruction[1].to_i(16)]} + #{ instruction[2..3]}"
                    
            when '8'
                if instruction[3] == "0" then  #mov from Y to X
                    
                    @v_reg[instruction[1].to_i(16)] = @v_reg[instruction[2].to_i(16)]
                    puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)}"
                    
                elsif instruction[3] == "1" then # or Y and X in X
                    
                    @v_reg[instruction[1].to_i(16)] = (@v_reg[instruction[2].to_i(16)].to_i(16) | @v_reg[instruction[1].to_i(16)].to_i(16)).to_s(16)
                    puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)} or #{instruction[1].to_i(16)} "                
                    
                elsif (instruction[3] == "2") then # and Y, X in X
                    
                    @v_reg[instruction[1].to_i(16)] = (@v_reg[instruction[2].to_i(16)].to_i(16) & @v_reg[instruction[1].to_i(16)].to_i(16)).to_s(16)
                    puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)} and #{instruction[1].to_i(16)} "
                    
                elsif (instruction[3] == "3") then  # xor Y, X in X
                    
                    @v_reg[instruction[1].to_i(16)] = (@v_reg[instruction[2].to_i(16)].to_i(16) ^ @v_reg[instruction[1].to_i(16)].to_i(16)).to_s(16)
                    puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)} xor #{instruction[1].to_i(16)} "                
                    
                elsif (instruction[3] == "4") then # add Y, X in X and VF = 1 if overflow exists 
                    
                    result = @v_reg[instruction[2].to_i(16)].to_i(16) + v_reg[instruction[1].to_i(16)].to_i(16)
                    if (result > 255) then
                        @v_reg["F".to_i(16)] = "1"
                        resultBinary = sprintf("%08b", result)
                        resultLength = resultBinary.length
                        diff = resultLength - 8; 
                        v_reg[instruction[1].to_i(16)] = (resultBinary[diff..resultLength-1].to_i(2).t_s(16))
                    else
                        v_reg[instruction[1].to_i(16)] =  result.to_s(16)   
                    end
                        
                    puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)} + #{instruction[1].to_i(16)}  and update VF if overflow exists"
                        
                elsif (instruction[3] == "5") then # sub Y, X in X                    
                    vx = v_reg[instruction[1].to_i(16)].to_i(16)
                    vy = v_reg[instruction[2].to_i(16)].to_i(16)
                    
                    if(vx >= vy)then
                        v_reg[instruction[1].to_i(16)] =  (vx - vy).to_s(16)
                    else 
                        @v_reg["F".to_i(16)] = "1"
                        resultBinary = 31.downto(0).map { |b| (vx - vy)[b] }.join.sub(/^0*/, "")
                        resultLength = resultBinary.length
                        diff = resultLength - 8;
                        v_reg[instruction[1].to_i(16)] = (resultBinary[diff..resultLegth-1].to_i(2).t_s(16))
                    end
                     puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[1].to_i(16)} - #{instruction[2].to_i(16)}  and update VF if borrow happened"
                        
                elsif (instruction[3] == "6") then # shift right register X    
                    
                    value = v_reg[instruction[1].to_i(16)].to_i(16).to_s(2)
                    @v_reg["F".to_i(16)] = value[value.length]
                    shiftedValue = value.to_i(2) >> 1 
                    v_reg[instruction[1].to_i(16)] = shiftedValue.to_s(16)
                    
                elsif (instruction[3] == "7") then # 8XY7 subtract register VX from register VY, result stored in register VX    
                     vx = v_reg[instruction[1].to_i(16)].to_i(16)
                     vy = v_reg[instruction[2].to_i(16)].to_i(16)
                    
                    if(vy >= vx)then
                        v_reg[instruction[1].to_i(16)] =  (vy - vx).to_s(16)
                    else 
                        @v_reg["F".to_i(16)] = "1"
                        resultBinary = 31.downto(0).map { |b| (vy - vx)[b] }.join.sub(/^0*/, "")
                        resultLength = resultBinary.length
                        diff = resultLength - 8;
                        v_reg[instruction[1].to_i(16)] = (resultBinary[diff..resultLegth-1].to_i(2).t_s(16))
                    end
                     puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)} - #{instruction[1].to_i(16)}  and update VF if borrow happened"
                elsif (instruction[3] == "E") then  # 8X0E shift register VX left, bit 7 stored into register VF
                    
                    value = v_reg[instruction[1].to_i(16)].to_i(16).to_s(2)
                    valueLength = value.length
                    diff = valueLength - 8;
                    valuein8bits = resultBinary[diff..resultLegth-1]
                    @v_reg["F".to_i(16)] = value[0]
                    shiftedValue = value.to_i(2) << 1 
                    v_reg[instruction[1].to_i(16)] = shiftedValue.to_s(16)
                    
                end
                    
            
                end
			i = i + 2				
		end
	end
end
