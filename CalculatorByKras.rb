puts "Calculator by Krasnikov is launched."

require 'prime'

$number1 = 0
$number2 = 0
$memory = nil
$stack = []

class Command
	def execute()
	end
end

class PlusCommand < Command
	def execute()
		$number1 = $number1 + $number2
		return $number1
	end
end

class MinusCommand < Command
	def execute()
		$number1 = $number1 - $number2
		return $number1
	end
end

class DivideCommand < Command
	def execute()
		if $number2 != 0
			$number1 = $number1 / $number2
		else
			raise StandardError.new
		end
		return $number1
	end
end

class MultiplyCommand < Command
	def execute()
		$number1 = $number1 * $number2
		return $number1
	end
end

class FactorialCommand < Command
	def execute()
		n = $number1
		if n <= 0
			return nil
		end
		ans = 1
		while n > 0
			ans = ans * n
			n -= 1
		end
		$number1 = ans
		return $number1
	end
end

class PrimesCommand < Command
	def execute()
		n = 0
		while n < $number2
			if n != 2 && n != 3 && n.prime?
				$stack << n
			end
			n += 1
		end
		$number1 = $stack.last
		return $number1
	end
end

class PushCommand < Command
	def execute()
		$stack << $number1
    	return $number1
	end
end

class PopCommand < Command
	def execute()
		if !$stack.empty?
    		$number1 = $stack.pop
    	else
    		raise StandardError.new
    	end
    	return $number1
	end
end

class ModCommand < Command
	def execute()
		$number1 = $number1.modulo($number2)
		return $number1
	end
end

class PowCommand < Command
	def execute()
		$number1 = $number1 ** $number2
		return $number1
	end
end

class SinCommand < Command
	def execute()
		$number1 = Math.sin($number1)
		return $number1
	end
end

class CosCommand < Command
	def execute()
		$number1 = Math.cos($number1)
		return $number1
	end
end

class TanCommand < Command
	def execute()
		$number1 = Math.tan($number1)
		return $number1
	end
end

class CtanCommand < Command
	def execute()
		$number1 = Math.cos($number1) / Math.sin($number1)
		return $number1
	end
end

class DoubleminusCommand < Command
	def execute()
		$number1 = $number1 - 1
		return $number1
	end
end

class ExpCommand < Command
	def execute()
		$number1 = Math.exp($number1)
		return $number1
	end
end

class LnCommand < Command
	def execute()
		$number1 = Math.log($number1) / Math.log(2.71828)
		return $number1
	end
end

class MwCommand < Command
	def execute()
		$memory = $number1
		return $number1
	end
end

class MrCommand < Command
	def execute()
		if $memory != nil
			$number1 = $memory
		else
			raise StandardError.new
		end
		return $number1
	end
end

class Calculator
	attr_reader :commands
	attr_reader :utype
	attr_reader :btype
	attr_reader :flagStarted

	def initialize()
		@commands = Hash.new
		@utype = ["!", "mw", "mr", "sin", "cos", "tan", "ctan",
		 "exp", "ln", "--", "push", "pop"]
		@btype = ["+", "-", "/", "*", "mod", "pow"]
		@flagStarted = false
	end

	def start()
		while true
			if !flagStarted
				@flagStarted = true
				puts "Input first operand"
				begin
					$number1 = gets.chomp
					if $number1.include? "."
				    	$number1 = Float($number1)
				    else
				    	$number1 = Integer($number1)
				    end
					puts "Input operation"
					oper = gets.chomp
					if oper.include? "q"
						break
					else
						execute(oper)
					end
				rescue StandardError, ArgumentError => e
		        	puts "Error. Try Again!"
		        	@flagStarted = false
		        end
			else
				puts "Input operation"
				oper = gets.chomp
				if oper.include? "q"
					break
				else
					begin
						execute(oper)
					rescue StandardError => e
		        		puts "Error. Try Again!"
		        		@flagStarted = false
		        	end
				end
			end
		end
		puts "Bye!"
	end

	def register_command(command_type, command)
        if command_type != nil && command != nil 
            commands[command_type] = command
        end
    end

    def execute(command_type)
        if commands.include?(command_type)
        	if utype.include?(command_type)
        		if command_type == "push"
        			@flagStarted = false
        		end
        		commands[command_type].execute()
	        else
	        	if(command_type == "primes")
	        		puts "Input edge for primes"
	        	else
	        		puts "Input second operand"
	        	end
	        	$number2 = gets.chomp
	        	if $number2.include? "."
				   	$number2 = Float($number2)
				else
				    $number2 = Integer($number2)
				end
	        	commands[command_type].execute()
	        end
	        if $number1.is_a? (Float)
	        	puts "Answer is:"
	        	puts $number1.round(2)
	        else
	        	puts "Answer is:"
	        	puts $number1
	        end
        else
        	puts "Wrong operation. Try again!"
        end
    end
end

calculator = Calculator.new
calculator.register_command("+", PlusCommand.new)
calculator.register_command("-", MinusCommand.new)
calculator.register_command("*", MultiplyCommand.new)
calculator.register_command("/", DivideCommand.new)
calculator.register_command("--", DoubleminusCommand.new)
calculator.register_command("mod", ModCommand.new)
calculator.register_command("pow", PowCommand.new)
calculator.register_command("!", FactorialCommand.new)
calculator.register_command("sin", SinCommand.new)
calculator.register_command("cos", CosCommand.new)
calculator.register_command("tan", TanCommand.new)
calculator.register_command("ctan", CtanCommand.new)
calculator.register_command("exp", ExpCommand.new)
calculator.register_command("ln", LnCommand.new)
calculator.register_command("mw", MwCommand.new)
calculator.register_command("mr", MrCommand.new)
calculator.register_command("primes", PrimesCommand.new)
calculator.register_command("push", PushCommand.new)
calculator.register_command("pop", PopCommand.new)
calculator.start()