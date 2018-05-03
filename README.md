# BullsAndCows

Little game, where computer makes some 4-digit number with unique digits, player tries to guess it. 
On each player's attempt server sends him response, that contains Bullas number that shows how many digits take right position,
and Cows number, that shows how many digits contains in computer's number. Server send string in format ${bulls}Б${cows}К.

Also server counts plaeyrs' rating. Your score is average of your attempts to guess number in completed games. If you completed no games,
you have zero score.  **Try to climb to the top!**

Web service made with String 5. I used MVC and Security parts of this.
