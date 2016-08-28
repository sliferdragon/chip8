require_relative "input_reader"

def main()
	input = InputReader.new()
	memoryStack =[]
	memoryStack[0x0000]=0
	memoryStack[0x1000]=0
	regsV=[]
	input.getRomMemory().each_with_index do |instruction,counter|
		memoryStack[0x200+counter]=instruction
	end
	puts "Started"
end

main()
