puts "Think of an animal..."

#while !have_the_correct_answer
#  
#end
puts "Is it an elephant? (y or n)"
answer = gets.chomp

if answer == 'y'
  puts "I win. Pretty smart, aren't I?"
else
  puts "ok you win. What animal where you thinking of?"
  animal = gets.chomp

  puts "oh a #{animal}!"
end

puts "Play again? (y or n)"

play_again = gets

if play_again == 'y'
  sleep 5
else
  exit 0
end

