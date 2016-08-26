require_relative "input_reader"
input = InputReader.new()
input.getRomMemory().each do |i|
	puts i 
end
