# Fish-Game
Math game to entertain pet fish.

### How to Play 
Entertain your pet fish by performing a simple math exercise. The math exercise consists of adding one to each of the digits of the string of digits as fast as possible before the timer runs out. For example 2139 becomes 3240. When you get a certain number of points, the pet fish will react by swimming or jumping. Enter numbers by using the number keypad. To start the game press the start button which will reveal the digits and start the timer. The orientation of the fish can also be changed by swiping the image. Restarting the game puts the fish back in its original location and restarts the timer and score. The player can choose between several different types of fish to play with.

### Layout of Game 
- Start page: can go to about or play (when clicked can go to players page or settings page) 
- About page: instructions for game (back button goes to start page) 
- Settings page: create a character to play with (back button goes to start page) 
- Players page: past saved players (back button goes to start page) 
- Game page: play the game! (Quit button goes to start page, can play again or go back to start page upon ending game) 

# Development Specifics

### Universal iOS app 
Displays on other devices
Game is in portrait mode only 

### Localization 
English and Chinese 

### Web enabled 
Weather API is incorporated to change the aquarium based on the current weather in Rochester 

### Custom Colors 
Color palette: light blue, dark blue, light gray 

### Core data
Core data is used to pass the character from the settings page to the game page and from the players table view page to the game page. These 5 attributes persist. 
1. Fish Name 
2. Fish Type 
3. Fish Image 
4. Score 
5. UUID 

### MVC
All view controllers end in VC  
All models are in the Models folder 

### Table Views 
(Players page) 
Stores the past created players and saves their score 
These cells can be clicked to play with the character again and improve their score 

### View controllers 
1. Start page 
2. About page 
3. Settings page 
4. Players page 
5. Game page 

### Picker Views 
(Settings page) 
Can choose the type of fish and a corresponding image changes with this selection 

### UIView animations 
(In game page) 
Fish swims: when the user gets 3 
Fish jumps: when the user gets 6 points 
Start button fades away when clicked 

### UIView transition 
(In about page) 
Fish curl up: top fish 
Fish curl down: bottom fish 

### Gesture 
(Game page) 
Swipe fish: flips fish to change its orientation 
Tap anywhere: hides keyboard to see quit button 

### Alerts 
(Start page) 
Play button: action sheet with 3 choices 

(Players page) 
Delete button: alert with 2 choices 

(Game page) 
Quit button: action sheet with 2 choices 
Game over popup: action sheet with 2 choices

### User defaults 
(Start page) 
The initial whale image 
(About page) 
The top fish image 
The bottom fish image
