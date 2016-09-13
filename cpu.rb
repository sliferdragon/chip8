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
        registerI = ""
        skip_counter_increment = false;
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
                        @v_reg[instruction[1].to_i(16)] = (resultBinary[diff..resultLength-1].to_i(2).t_s(16))
                    else
                        @v_reg[instruction[1].to_i(16)] =  result.to_s(16)   
                    end
                        
                    puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)} + #{instruction[1].to_i(16)}  and update VF if overflow exists"
                        
                elsif (instruction[3] == "5") then # sub Y, X in X                    
                    vx = @v_reg[instruction[1].to_i(16)].to_i(16)
                    vy = @v_reg[instruction[2].to_i(16)].to_i(16)
                    
                    if(vx >= vy)then
                        @v_reg[instruction[1].to_i(16)] =  (vx - vy).to_s(16)
                    else 
                        @v_reg["F".to_i(16)] = "1"
                        resultBinary = 31.downto(0).map { |b| (vx - vy)[b] }.join.sub(/^0*/, "")
                        resultLength = resultBinary.length
                        diff = resultLength - 8;
                        @v_reg[instruction[1].to_i(16)] = (resultBinary[diff..resultLegth-1].to_i(2).t_s(16))
                    end
                     puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[1].to_i(16)} - #{instruction[2].to_i(16)}  and update VF if borrow happened"
                        
                elsif (instruction[3] == "6") then # shift right register X    
                    
                    value = v_reg[instruction[1].to_i(16)].to_i(16).to_s(2)
                    @v_reg["F".to_i(16)] = value[value.length]
                    shiftedValue = value.to_i(2) >> 1 
                    @v_reg[instruction[1].to_i(16)] = shiftedValue.to_s(16)
                    
                    puts "instrucion is #{instruction} shift regv#{instruction[1].to_i(16)} right"
                elsif (instruction[3] == "7") then # 8XY7 subtract register VX from register VY, result stored in register VX    
                     vx = @v_reg[instruction[1].to_i(16)].to_i(16)
                     vy = @v_reg[instruction[2].to_i(16)].to_i(16)
                    
                    if(vy >= vx)then
                        @v_reg[instruction[1].to_i(16)] =  (vy - vx).to_s(16)
                    else 
                        @v_reg["F".to_i(16)] = "1"
                        resultBinary = 31.downto(0).map { |b| (vy - vx)[b] }.join.sub(/^0*/, "")
                        resultLength = resultBinary.length
                        diff = resultLength - 8;
                        @v_reg[instruction[1].to_i(16)] = (resultBinary[diff..resultLegth-1].to_i(2).t_s(16))
                    end
                     puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = #{instruction[2].to_i(16)} - #{instruction[1].to_i(16)}  and update VF if borrow happened"
                elsif (instruction[3] == "E") then  # 8X0E shift register VX left, bit 7 stored into register VF
                    
                    value = @v_reg[instruction[1].to_i(16)].to_i(16).to_s(2)
                    valueLength = value.length
                    diff = valueLength - 8;
                    valuein8bits = resultBinary[diff..resultLegth-1]
                    @v_reg["F".to_i(16)] = value[0]
                    shiftedValue = value.to_i(2) << 1 
                    @v_reg[instruction[1].to_i(16)] = shiftedValue.to_s(16)
                    puts "instrucion is #{instruction} shift regv#{instruction[1].to_i(16)} left"
                end
                    
            when (instruction[0] == "9") #skip next instruction if register VX != register VY
                if ( @v_reg[instruction[1].to_i(16)] != @v_reg[instruction[2].to_i(16)])   then 
                    skip_counter_increment = true
                    i = i + 4
                end
                puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} not equals regv#{instruction[2].to_i(16)} jump next instruction"
          
            when (instruction[0] == "A") #Load index register (I) with constant NNN
                registerI = instruction[1..3]            
                puts "instrucion is #{instruction} Load #{instruction[1..3]} into register I"
          
            when (instruction[0] == "B") #Jump to address NNN + register V0 
                skip_counter_increment = true     
                i = instruction[1..3].to_i(16)+@v_reg[0].to_i(16)
                puts "instrucion is #{instruction} jump to address #{instruction[1..3]} plus V0"
          
            when (instruction[0] == "C") #register VX = random number AND KK
                @v_reg[instruction[1].to_i(16)] = (Random.rand(16) && instruction[2..3].to_i(16)).to_s(16)
                puts "instrucion is #{instruction} regv#{instruction[1].to_i(16)} = random number and #{instruction[2..3]}"
          
            when (instruction[0] == "D") #Draw sprite at screen location (register VX,register VY) height N
                #screen
            when (instruction[0] == "d") #Draws extended sprite at screen location rx,ry
                #screen
            when (instruction[0] == "e") 
                if (instruction == "ek9e") then #skip if key (register rk) pressed
                    #keyboard
                elsif (instruction == "eka1") then #skip if key (register rk) not pressed
                    #keyboard
                end
            when (instruction[0] == "f")
                if (instruction[1] == "r")then
                    if (instruction[2..3] == "07")then #get delay timer into vr
                        # not implemented as we don't support timer
                    elsif (instruction[2..3] == "0a")then #wait for for keypress,put key in register vr
                        #keyboard
                    elsif (instruction[2..3] == "15") then #set the delay timer to vr
                        # not implemented as we don't support timer
                    elsif (instruction[2..3] == "18") then #set the sound timer to vr
                        # not implemented as we don't support timer
                    elsif (instruction[2..3] == "1e") then #add register vr to the index register
                        registerI = (registerI.to_i(16) + @v_reg[instruction[1].to_i(16)].to_i(16)).to_s(16)
                        puts "instrucion is #{instruction} add reg #{instruction[i].to_i(16)} to index register"
                    elsif (instruction[2..3] == "29") then #point I to the sprite for hexadecimal character in vr
                        #screen
                    elsif (instruction[2..3] == "33") #store the bcd representation of register vr at location I,I+1,I+2; Doesn't change I
                        vr = @v_reg[instruction[1].to_i(16)]
                        firstChar = vr[0]
                        secondChar = vr[1]
                        thirdChar = vr[2]
                        @memory[registerI.to_i(16)] = to_bcd(firstChar.to_i(16))
                        @memory[registerI.to_i(16)+1] = to_bcd(secondChar.to_i(16))
                        @memory[registerI.to_i(16)+2] = to_bcd(thirdChar.to_i(16))
                        puts "instrucion is #{instruction} store the bcd representation of reg#{instruction[1].to_i(16)} at location I,I+1,I+2; Doesn't change I"
                    elsif (instruction[2..3] == "55") then #store registers v0-vr at location I onwards
                        lastIndex = instruction[1].to_i(16)

                        for index in 0..lastIndex
                            @memory[registerI.to_i(16) + index + 1] = @v_reg[index]
                        end
                        puts "instrucion is #{instruction} store registers v0-v#{instruction[1].to_i(16)} at location I onwards"
                    end                            
                            
                elsif (instruction[1] == "x")then
                    if(instruction[2..3] == "65")then #load registers v0-vr from location I onwards
                        lastIndex = instruction[1].to_i(16)

                        for index in 0..lastIndex
                            @v_reg[index] = @memory[registerI.to_i(16) + index + 1] 
                        end
                        puts "instrucion is #{instruction} load registers v0-v#{instruction[1].to_i(16)} from location I onwards"
                    end 
                end 

                
                
            end
           if (! skip_counter_increment) then 
			 i = i + 2				
           end
		end    
	end
    def to_bcd(n)
        str = n.to_s
        bin = ""
        str.each_char do |c|
            bin << c.to_i.to_s(2).rjust(4,'0')
        end
        
        if(bin.length < 8)then 
            bin = "0000"+bin
        end 
        
        return bin
    end


end
