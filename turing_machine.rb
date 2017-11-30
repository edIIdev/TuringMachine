class TuringMachine
	attr_accessor :input_tape, :state, :final_states
	def initialize()
		@input_tape = File.read("input").delete("\n").split("")
		@reading_head = 0		
		@states = File.read("states").delete("\n").split(',')
		@final_states = File.read("final_states").delete("\n").split(',')
		@state = @states.first
		@tape_alphabet = File.read("tape_alphabet").delete("\n").split(',')
		@input_alphabet = File.read("input_alphabet").delete("\n").split(',')
		@blank = " "
		@transitions = {}		
		load_transitions
	end

	def load_transitions
		transitions = File.read("transitions").split "\n"
		transitions.each do |transition|
			splited = transition.split(',')
			if (!(@transitions[splited[0].to_sym].kind_of? Hash)) then
				@transitions[splited[0].to_sym] = {}
			end
			if (!(@transitions[splited[0].to_sym][splited[1].to_sym].kind_of? Array) ) then
				@transitions[splited[0].to_sym][splited[1].to_sym] = splited[2, 4]
			end
		end
	end

	def transition(state, tape_symbol)
		return @transitions[state.to_sym][tape_symbol.to_sym]		
	end

	def run
		while transition(@state, input_tape[@reading_head]).kind_of? Array do
			t = transition(@state, input_tape[@reading_head])	
			print @state
			@state = t[0]
			@input_tape[@reading_head] = t[1]		
			if t[2] == '>'
				@reading_head = @reading_head+1
				@input_tape << " " if @reading_head > @input_tape.size-1
			else
				@reading_head = @reading_head-1
			end
			puts " -> " + @state
			puts @input_tape.inspect
			#gets
		end
	end	 	
end

tm = TuringMachine.new
puts "Input tape:"+tm.input_tape.inspect
begin
	tm.run
rescue
	puts "STOP!"
end
puts "Last state:"+tm.state
puts tm.final_states.include? tm.state
puts
