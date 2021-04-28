puts "Calculator by Krasnikov is launched."

require 'prime'

def unaryOperations(operand, operator)
	oper = operator.downcase
	case oper
	when "mw" then $memory = operand
	when "mr" then $result = $memory
    when "!" then $result = factorial(operand)
    when "sin" then $result = Math.sin(operand)
    when "cos" then $result = Math.cos(operand)
    when "tan" then $result = Math.tan(operand)
    when "ctan" then $result = Math.cos(operand)/Math.sin(operand)
    when "exp" then $result = Math.exp(operand)
    when "ln"
    	$result = operand
    	$result = Math.log($result) / Math.log(2.71828)
    when "--" then $result = operand - 1
    when "push" 
    	$stack << operand
    	$result = operand
    when "pop"
    	if !$stack.empty?
    		$result = $stack.pop
    	else
    		raise StandardError.new
    	end
    else
      return false
    end
    return true
end

def factorial(n)
	if n < 0
		return nil
	end
	ans = 1
	while n > 0
		ans = ans * n
		n -= 1
	end
	return ans
end

def primes(n)
	while n > 0
		if n.prime?
			$stack << n
		end
		n -= 1
	end
	return $stack.first
end

$stack = []
errorRaised = false
unaryOperationFlag = false
flagLaunched = false
$memory = nil
$result = 1
turnedOff = false

while true
unaryOperationFlag = false
begin
	if(!flagLaunched)
    	firstOperand = gets.chomp
    		if firstOperand.include? "."
		    	firstOperand = firstOperand.to_f
		    else
		    	firstOperand = firstOperand.to_i
		    end
    		operator = gets.chomp
    	if unaryOperations(firstOperand, operator)
    		unaryOperationFlag = true
    		if operator != "mw"
    			if $result.is_a? (Float)
			    	puts $result.round(2)
			    else
			    	puts $result
				end
    		end
    	elsif operator.include? "q"
    		turnedOff = true
    		raise StandardError.new
    	else
	    	operator = operator.to_sym
	    	secondOperand = gets.chomp
		    if secondOperand.include? "."
			   	secondOperand = secondOperand.to_f
			else
			    secondOperand = secondOperand.to_i
			end
    	end
    else
    	firstOperand = $result
    	operator = gets.chomp
    	if unaryOperations(firstOperand, operator)
    		unaryOperationFlag = true
    		if operator == "mr" && $memory == nil
    			raise StandardError.new
    		elsif operator != "mw"
    			if $result.is_a? (Float)
			    	puts $result.round(2)
			    else
			    	puts $result
				end
    		end
    	elsif operator.include? "q"
    		turnedOff = true
    		raise StandardError.new
    	else
    		operator = operator.to_sym
    		secondOperand = gets.chomp
	    	if secondOperand.include? "."
		    	secondOperand = secondOperand.to_f
		    else
		    	secondOperand = secondOperand.to_i
		    end
    	end
    end
rescue StandardError => e
	errorRaised = true
	if turnedOff
		puts "Calculator shut down!"
		break
	else
		puts "It's empty for now. Try Again!"
	end
end

    if operator == "mw" || (operator == "mr" && $memory == nil)
       	flagLaunched = false
    else
		flagLaunched = true
    end

	begin
		if unaryOperationFlag == false
		    case operator
		    when :+ then $result = firstOperand + secondOperand
		    when :- then $result = firstOperand - secondOperand
		    when :* then $result = firstOperand * secondOperand
		    when :/ 
		    	if secondOperand != 0
		    		$result = firstOperand / secondOperand
		    	else
		    		raise StandardError.new
		    	end
		    when :mod then $result = firstOperand.modulo(secondOperand)
		    when :pow then $result = firstOperand**secondOperand
		    when :primes then $result = primes(secondOperand)
		    else
		      raise StandardError.new
		    end
		    if $result.is_a? (Float)
		    	puts $result.round(2)
		    else
		    	puts $result
			end
	    end
	rescue StandardError => e
		flagLaunched = false
		if !errorRaised
			puts "Error. Try Again!"
		end
	end
    

  end