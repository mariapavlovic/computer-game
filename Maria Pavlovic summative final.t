View.Set ("graphics:800;600,nobuttonbar,offscreenonly")

var font : int := Font.New ("arial:20") % fonts
var font2 : int := Font.New ("Courier:20:bold")
var font3 : int := Font.New ("arial:18")
var font4 : int := Font.New ("Broadway:50")
var x, y, b : int % mouse clicks
var playgame : int % play game choice from menu
var level : int
var levelstr : string
var win : boolean % completed level 3
var winexit : boolean % exit after level 3 or menu
var alive : boolean := true % play if player is alive, exit out of game loop if false
var score : int := 0 % score of player
var scorestr : string % score counter
var endoption : int % 1 = play again, 2 = exit, 3 = menu, 5 = game win
% player
var chars : array char of boolean % key down
var playerX : int := maxx div 2 % starting X position of player
var playerY : int := maxy-550 % starting Y position of player
var playspeed : int := 3 % player speed
var playrad : int := 20 % player radius
var playercol : int := 3
% walls
var falling : int := 0 % wall falling
var wallspeed : int := 1 % wall speed
var wallspacel : int := Rand.Int (20, 590) % end of left wall
var wallspacer : int % end of right wall
var space : int := Rand.Int (80, 200) % space between walls
var wallYleft : int := maxy % starting top side of wall
var wallYright : int := maxy
var wallLbottom : int := wallYleft - 20 % starting bottom side of wall
var wallRbottom : int := wallYright - 20
var morewalls : array 1 .. 3 of int
var upperbound : int := 600
var wallcolour : int := 7
% wall 2
var wallspacel2 : int := Rand.Int (20, 590) % end of left wall
var wallspacer2 : int % end of right wall
var space2 : int := Rand.Int (80, 200) % space between walls
var wallYleft2 : int := maxy % starting top side of wall
var wallYright2 : int := maxy
var wallLbottom2 : int := wallYleft2 - 20 % starting bottom side of wall
var wallRbottom2 : int := wallYright2 - 20
var walldist : int := 300
var falling2 : int := falling - walldist
% pictures
var gameover : int := Pic.FileNew ("MariaP-gameover.jpg")
var fire : int := Pic.FileNew ("MariaP-fire.jpg")
var instructionpic : int := Pic.FileNew ("MariaP-instructions.jpg")
% var instructionpic : int := Pic.FileNew ("diagram.jpg")
%Music.PlayFileLoop ("backgroundmusic.mp3")

process clicky % button clicks sound effect
    Music.PlayFile ("MariaP-camclick.wav")
end clicky

process levell % player finishes level sound effect
    Music.PlayFile ("MariaP-levelup.wav")
end levell

process lose % player hit sound effect
    Music.PlayFile ("MariaP-collision.mp3")
end lose

process shutdown % player hit sound effect
    Music.PlayFile ("MariaP-shutdown.wav")
end shutdown

% cool music
Music.PlayFileLoop ("MariaP-backgroundmusic.mp3")


loop 
    % MENU
    cls
    drawfillbox (0, 0, maxx, maxy, 0) % background
    Font.Draw ("Firewall Block", 150, 400, font4, 54)

    drawfillbox (250, 300, 340, 340, 54) % play button
    Font.Draw ("PLAY", 260, 310, font, 0)

    drawfillbox (360, 300, 580, 340, 54) % instructions button
    Font.Draw ("INSTRUCTIONS", 370, 310, font, 0)

    Pic.Draw (fire, 0, 0, picMerge)
    View.Update
    
    loop
	Mouse.Where (x, y, b)
	if b = 1 and x > 250 and x < 340 and y > 300 and y < 340 then
	    playgame := 1 % play
	    fork clicky
	    exit
	elsif b = 1 and x > 360 and x < 580 and y > 300 and y < 340 then
	    playgame := 2 % instructions
	    fork clicky
	    exit
	end if
    end loop

    if playgame = 2 then % INSTRUCTIONS SCREEN
	drawfillbox (0, 0, maxx, maxy, 0)
	Font.Draw ("Instructions:", 30, 540, font, 54)
	Font.Draw ("Move the player side to side", 30, 510, font3, 7)
	Font.Draw ("using the left and right arrow" , 30, 480, font3, 7)
	Font.Draw ("keys.", 30, 450, font3, 7)
	Font.Draw ("Avoid the firewalls that are" , 30, 410, font3, 7)
	Font.Draw ("trying to block you!", 30, 380, font3, 7)
	drawfillbox (30, 305, 110, 345, 54) % play button
	Font.Draw ("PLAY", 35, 315, font, 0)
	Pic.Draw (instructionpic, 370, 140, picMerge)
	Pic.Draw (fire, 0, 0, picMerge)
	View.Update
	loop
	    Mouse.Where (x, y, b) % play button from instruction screen
	    if b = 1 and x > 30 and x < 110 and y > 305 and y < 345 then
		playgame := 1
		fork clicky
		exit
	    end if
	end loop
    end if

    if playgame = 1 then % PLAY - SHOWING LEVELS
	drawfillbox (0, 0, maxx, maxy, 0)
	Font.Draw ("LEVELS", 250, 450, font4, 54)
	drawfillbox (100, 300, 200, 380, 54) % level 1
	Font.Draw ("1", 130, 320, font4, 0)
	drawfillbox (350, 300, 450, 380, 54) % 2
	Font.Draw ("2", 380, 320, font4, 0)
	drawfillbox (600, 300, 700, 380, 54) % 3
	Font.Draw ("3", 630, 320, font4, 0)
	Pic.Draw (fire, 0, 0, picMerge)
	View.Update
	loop
	    Mouse.Where (x, y, b)
	    if b = 1 and x > 100 and x < 200 and y > 300 and y < 380 then
		level := 1              % level 1
		playgame := 3
		fork clicky
		exit
	    elsif b = 1 and x > 350 and x < 450 and y > 300 and y < 380 then
		level := 2              % 2
		playgame := 3
		fork clicky
		exit
	    elsif b = 1 and x > 600 and x < 700 and y > 300 and y < 380 then
		level := 3              % 3
		playgame := 3
		fork clicky
		exit
	    end if
	    View.Update
	end loop
    end if

    if playgame = 3 then
	loop % GAME LOOP
	    cls
	    % PLAYER
	    drawfilloval (playerX, playerY, playrad, playrad, playercol)
	    Input.KeyDown (chars)
	    if chars (KEY_RIGHT_ARROW) and playerX + playrad < maxx then % player moving right
		playerX += playspeed
	    elsif chars (KEY_LEFT_ARROW) and playerX - playrad > 0 then % moving left
		playerX -= playspeed
	    end if

	    % WALLS MOVING DOWN
	    wallspacer := wallspacel + space     % space between the walls
	    drawfillbox (0, wallYleft - falling, wallspacel, wallLbottom - falling, wallcolour)
	    drawfillbox (maxx, wallYright - falling, wallspacer, wallRbottom - falling, wallcolour)

	    % LEVELS
	    if level = 1 then % LEVEL 1
		wallspeed := 1
		playercol := 3
		falling += wallspeed
		if falling > maxy then % wall reaches bottom
		    score += 1 % player gains point
		    falling := 0 % wall starts from top again
		    wallspacel := Rand.Int (20, 600) % resets wall spaces
		    if wallspacel > 350 then
			wallspacel := Rand.Int (20, 300)
		    else
			wallspacel := Rand.Int (460, 600)
		    end if
		    space := Rand.Int (100, 200)
		end if
		
	    elsif level = 2 then % LEVEL 2
		wallspeed := 1
		playercol := 54
		wallcolour := 57
		falling += wallspeed
		falling2 += wallspeed                
		wallspacer2 := wallspacel2 + space2
		if falling2 >= 0 then
		    drawfillbox (0, wallYleft2 - falling2, wallspacel2, wallLbottom2 - falling2, wallcolour)
		    drawfillbox (maxx, wallYright2 - falling2, wallspacer2, wallRbottom2 - falling2, wallcolour)
		end if
		if falling > maxy then % wall reaches bottom
		    score += 1 % player gains point
		    falling := 0 % wall starts from top again
		    wallspacel := Rand.Int (20, 600) % resets wall spaces
		    space := Rand.Int (80, 150)
		    if wallspacel2 > 350 then
			wallspacel := Rand.Int (20, 300)
		    else
			wallspacel := Rand.Int (460, 600)
		    end if
		end if
		if falling2 > maxy then % wall 2
		    space2 := Rand.Int (100, 200)
		    score += 1
		    falling2 := 0 % wall starts from top again
		    wallspacel2 := Rand.Int (20, 600) % resets wall spaces
		    if wallspacel > 350 then
			wallspacel2 := Rand.Int (20, 300)
		    else
			wallspacel2 := Rand.Int (460, 600)
		    end if
		end if

	    elsif level = 3 then % LEVEL 3
		wallspeed := 2 % faster walls
		wallcolour := 79
		playercol := 64
		playspeed := 4
		falling += wallspeed
		falling2 += wallspeed
		wallspacer2 := wallspacel2 + space2
		if falling2 >= 0 then
		    drawfillbox (0, wallYleft2 - falling2, wallspacel2, wallLbottom2 - falling2, wallcolour)
		    drawfillbox (maxx, wallYright2 - falling2, wallspacer2, wallRbottom2 - falling2, wallcolour)
		end if
		if falling > maxy then % wall reaches bottom       
		    wallcolour := Rand.Int (0,20)
		    space := Rand.Int (80, 150)
		    score += 1 % player gains point
		    falling := 0 % wall starts from top again
		    wallspacel := Rand.Int (20, 600) % resets wall spaces
		end if
		if falling2 > maxy then     % wall reaches bottom
		    space2 := Rand.Int (100, 200)
		    score += 1 % player gains point
		    falling2 := falling - walldist % wall starts from top again
		    wallspacel2 := Rand.Int (20, 600) % resets wall spaces
		end if
	    end if
	    %%
	    
	    % LEVEL SIGN
	    levelstr := intstr (level)
	    Font.Draw ("LEVEL "+levelstr, 340, 560, font2, 54)
	    
	    % SCORE COUNTER
	    delay (5)
	    scorestr := intstr (score)
	    Font.Draw ("SCORE: " + scorestr, 30, 560, font2, 54)
	    View.Update
	    

	    % NEXT LEVEL
	    if score = 5 and level = 1 then % end of level 1
		cls
		levelstr := intstr (level)
		Font.Draw ("You have reached the end of level " + levelstr, 110, 330, font2, 7)
		drawfillbox (230, 270, 400, 300, 54) % next level button
		Font.Draw ("NEXT LEVEL", 235, 275, font, 0)
		drawfillbox (420, 270, 490, 300, 54) % exit button
		Font.Draw ("EXIT", 425, 275, font, 0)
		drawfillbox (510, 270, 600, 300, 54) % back to menu button
		Font.Draw ("MENU", 515, 275, font, 0)
		fork levell
		View.Update
		loop
		    Mouse.Where (x, y, b)
		    if b = 1 and x > 230 and x < 400 and y > 270 and y < 300 then % next level (level 2)
			fork clicky
			level := 2 % reset variables
			score := 0
			playerX := maxx div 2
			falling := 0
			falling2 := falling - walldist
			wallspacel := Rand.Int (20, 650)
			wallspacel2 := Rand.Int (20, 650)
			space := Rand.Int (100, 200)
			space2 := Rand.Int (100, 200)
			wallspacer2 := wallspacel2 + space2
			exit
		    elsif b = 1 and x > 510 and x < 600 and y > 270 and y < 300 then % menu
			fork clicky
			endoption := 3 
			alive := false
			exit
		    elsif b = 1 and x > 420 and x < 490 and y > 270 and y < 300 then % exit
			fork clicky
			endoption := 2
			alive := false
			exit
		    end if
		end loop
	    elsif score = 15 and level = 2 then % end of level 2
		cls
		levelstr := intstr (level)
		Font.Draw ("You have reached the end of level " + levelstr, 110, 330, font2, 7)
		drawfillbox (230, 270, 400, 300, 54) % next level button
		Font.Draw ("NEXT LEVEL", 235, 275, font, 0)
		drawfillbox (420, 270, 490, 300, 54) % exit button
		Font.Draw ("EXIT", 425, 275, font, 0)
		drawfillbox (510, 270, 600, 300, 54) % back to menu button
		Font.Draw ("MENU", 515, 275, font, 0)
		fork levell
		View.Update
		loop
		    Mouse.Where (x, y, b)
		    if b = 1 and x > 230 and x < 400 and y > 270 and y < 300 then % next level (level 3)
			fork clicky
			level := 3 % reset variables
			score := 0
			playerX := maxx div 2
			falling := 0
			falling2 := falling - walldist
			wallspacel := Rand.Int (20, 650)
			wallspacel2 := Rand.Int (20, 650)
			space := Rand.Int (100, 200)
			space2 := Rand.Int (100, 200)
			wallspacer2 := wallspacel2 + space2
			exit
		    elsif b = 1 and x > 510 and x < 600 and y > 270 and y < 300 then % menu
			fork clicky
			endoption := 3 
			alive := false
			exit
		    elsif b = 1 and x > 420 and x < 490 and y > 270 and y < 300 then % exit
			Music.PlayFileStop     
			fork clicky
			endoption := 2
			alive := false
			exit
		    end if
		end loop
	    elsif score = 20 and level = 3 then % end of level 3 --- end of game
	    cls
	    fork levell
	    endoption := 5
		win := true % exit with win
		alive := false
	    end if
	    %%

	    % COLLISION
	    if playerX - playrad < wallspacel and playerY + playrad > wallLbottom - falling and playerY - playrad < wallYleft - falling or playerX + playrad > wallspacer and playerY + playrad > wallRbottom - falling and playerY - playrad < wallYright - falling or (level = 2 or level = 3) and playerX - playrad < wallspacel2 and playerY + playrad > wallLbottom2 - falling2 and playerY - playrad < wallYleft2 - falling2 or (level = 2 or level = 3) and playerX + playrad > wallspacer2 and playerY + playrad > wallRbottom2 - falling2 and playerY - playrad < wallYright2 - falling2 then
		Music.PlayFileStop     
		fork lose
		delay (100)
		cls
		drawfillbox (230, 270, 400, 300, 54) % replay button
		Font.Draw ("PLAY AGAIN", 235, 275, font, 0)

		drawfillbox (420, 270, 490, 300, 54) % exit button
		Font.Draw ("EXIT", 425, 275, font, 0)

		drawfillbox (510, 270, 600, 300, 54) % back to menu button
		Font.Draw ("MENU", 515, 275, font, 0)

		Font.Draw ("YOU DIED!", 230, 350, font4, 54)
		View.Update
		loop
		    Mouse.Where (x, y, b) 
		    if b = 1 and x > 230 and x < 400 and y > 270 and y < 300 then % replay
			fork clicky
			Music.PlayFileLoop ("MariaP-backgroundmusic.mp3")
			endoption := 1 % play again
			alive := true % resetting level
			score := 0
			playerX := maxx div 2
			falling := 0
			falling2 := falling - walldist
			wallspacel := Rand.Int (20, 650)
			wallspacel2 := Rand.Int (20, 650)
			space := Rand.Int (100, 200)
			space2 := Rand.Int (100, 200)
			wallspacer2 := wallspacel2 + space2
			exit
		    elsif b = 1 and x > 420 and x < 490 and y > 270 and y < 300 then % exit
			fork clicky
			endoption := 2 
			alive := false
			exit
		    elsif b = 1 and x > 510 and x < 600 and y > 270 and y < 300 then % menu
			fork clicky
			Music.PlayFileLoop ("MariaP-backgroundmusic.mp3")
			endoption := 3 
			alive := false
			exit
		    end if
		end loop
	    end if
	    %%

	    exit when alive = false
	end loop
    end if
%%%%%%%% end of game loop

    if endoption = 2 then % game over screen - exit screen
	cls
	fork shutdown
	Pic.Draw (gameover, 115, 170, picCopy)
	delay (400)
	exit
    end if
    
    if endoption = 5 and win = true then % game over --- WIN
	cls
	Font.Draw ("You have finished the game", 30, 460, font2, 7)
	Font.Draw ("YOU WON!", 230, 340, font4, 54)
	drawfillbox (280, 270, 370, 300, 54) % back to menu button
	Font.Draw ("MENU", 285, 275, font, 0)
	drawfillbox (480, 270, 550, 300, 54) % exit button
	Font.Draw ("EXIT", 485, 275, font, 0)
	View.Update
	loop
	    Mouse.Where (x, y, b) 
	    if b = 1 and x > 480 and x < 550 and y > 270 and y < 300 then % exit
		fork shutdown
		delay (400)
		winexit := true
		exit
	    elsif b = 1 and x > 280 and x < 370 and y > 270 and y < 300 then % menu
		fork clicky
		endoption := 3 
		winexit := false
		exit
	    end if
	end loop
	View.Update
	if winexit = true then
	    cls
	    Pic.Draw (gameover, 115, 170, picCopy) % game over picture
	    exit
	end if
    end if
	
    if endoption = 3 then % menu
	cls
	alive := true  % resetting variables
	score := 0
	wallcolour := 7
	playerX := maxx div 2
	falling := 0
	falling2 := falling - walldist
	wallspacel := Rand.Int (20, 650)
	space := Rand.Int (100, 200)
	space2 := Rand.Int (100, 200)
	playgame := 3
	View.Update
    end if
    
    
    
end loop

%%%% end menu loop
