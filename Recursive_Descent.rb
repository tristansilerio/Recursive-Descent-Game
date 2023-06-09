# Ruby Group - Kyle, Tom, Tristan
# Creative Project - Recursive Descent Game 
# Autobattler-type game where the player has to fight 
# through 3 stages in order to defeat DrRacket for stealing
# the programming languages. Each stage becomes more difficult,
# but with the help of buyable pets and items, the player can 
# increase their chances of winning! 
#
###############################################################
require 'ruby2d' #GUI

# song/sound declarations for use in-game
Music.volume= 25
$song= Music.new('einmal.mp3')
$song.play
$song.loop= true

$song1= Music.new('stage_1.mp3')
$song2= Music.new('winter.mp3')
$song3= Music.new('demon.mp3')

$intro_dialogue=Music.new('intro.wav')
$molette_cry=Sound.new("molette_cry.wav")
$molette_talk=Sound.new("molette_in.wav")
$snek_friend_cry=Sound.new("snek_cry.wav")
$snek_friend_talk=Sound.new("snek_in.wav")
$skeleton_cry=Sound.new("ahoohawawow.wav")
$skeleton_talk=Sound.new("unmanneddrones.wav")
$froginthroat_cry=Sound.new("frogoutahere.wav")
$froginthroat_talk=Sound.new("froginthroat.wav")
$black_cat_cry=Sound.new("cat_cry.wav")
$black_cat_talk=Sound.new("meow.wav")
$bomberman_cry=Sound.new("kaboom.wav")
$bomberman_talk=Sound.new("yeahgood.wav")

$green_slime_cry= Sound.new("green_slime_out.wav")
$bean_cry= Sound.new("owow_fast.wav")
$eye_cry= Sound.new("eyedye.wav")
$skele_cry= Sound.new("skele_out.wav")
$skele_red_cry= Sound.new("skele_red_out.wav")
$snowbot_cry= Sound.new("error.wav")
$blood_slime_cry= Sound.new("blood_slime_out.wav")
$dr_racket_cry= Sound.new("dr_gone.wav")

$next= Sound.new('next.wav')
$yell= Sound.new('annoyance.wav')
$coins= Sound.new('coins.wav')
$laugh= Sound.new('laugh.wav')
$loser= Sound.new('drterror.wav')
$welcome= Sound.new('welcome.wav')

# boolean identifies to help idenitfy different stages of the game
$test_flag=false
$winflag= false
$friend_death=false
$enemy_death=false
$before_fight=true
$shopping= false
$on_title_page=true
$on_credits_page=false
$text_flag= false
$lose_case = false 
$win_case = false 

$let_me_out=Text.new("Click on screen to exit intro sequence!", x: 800, y: 600, z:10000)
$let_me_out.remove


$players_items= []

$num= 0

#Shop Variables#################################################
$shopkeep= Image.new('shopkeep.png', x:0 , y: 360, z: 11)
$shopbg= Image.new('shop_back0.png', x:0, y:360, z:10)
$shop_end= Image.new('end_shop.png', x: 1152, y: 260, z: 100)
$shop_counter= Quad.new(x1: 256, y1: 720, x2: 384, y2: 580, x3: 1152, y3: 580, x4: 1280, y4:720, color: 'brown', z: 10)
$shop_end.remove
$shopkeep.remove
$shop_counter.remove 
$spet1
$spet2
$spet3
$spet1_image
$spet2_image
$spet3_image
$item1_image
$item2_image
$item3_image
$sitem1
$sitem2
$sitem3
$item1_flag= true
$item2_flag= true
$item3_flag= true
$money= 0
$money_counter
$gold= Image.new("sackogold.png", z: 15)
#End Shop Variables###############################################

$play_button= Image.new("advance.png", x: 1120, y: 10, z: 11)
$play_button.remove
$round = 0 #current level that the player is on
$cur= 0

#Declare Title Screen images to be added 
$bg= Image.new("bg.png")
$intro_background=Image.new("intro.png",z:205)
$intro_background.remove
$title_background=Image.new("title.png", z: 200)
$credits_background=Image.new("credits_page.png",x:0,y:0, z: 205)
$credits_background.remove
$title_play_button=Image.new("title_play_button.png", x: 25, y:285, z: 201)
$title_play_intro_cutscene=Image.new("play_intro_cutscene.png",x:435,y: 285, z:201)
$title_credits=Image.new("credits.png",x: 845,y: 285, z:201)
$shop_directions=Text.new('Prepare for battle!', x: 500, y: 400, style: 'bold', size: 40, color: 'black', z: 1000)
$shop_directions2=Text.new('Pets cost 2 Gold & Items cost 1 Gold!', x: 325, y: 450, style: 'bold', size: 40, color: 'black', z: 1000)
$shop_directions3=Text.new('Choose wisely!', x: 520, y: 500, style: 'bold', size: 40, color: 'olive', z: 1000)
$noMoney = Text.new("You have insufficient funds!", x:475, y: 500, style: 'bold', size: 40, color: 'black', z: 1000)
$almostNoMoney = Text.new("You have insufficient funds for a pet! Try an item!", x:325, y: 500, style: 'bold', size: 40, color: 'black', z: 1000)
$fullTeam = Text.new("Your team is full! Try buying items!", x:350, y: 500, style: 'bold', size: 40, color: 'black', z: 1000)
$title_background.remove
$title_play_button.remove
$title_play_intro_cutscene.remove
$title_credits.remove
$shop_directions.remove 
$shop_directions2.remove 
$shop_directions3.remove 
$noMoney.remove
$almostNoMoney.remove   
$fullTeam.remove


################################
set title: "Recursive Descent"

set width: 1280
set height: 720
################################



def title_screen
    $on_title_page=true
    $bg.remove
    $title_background.add
    $title_play_button.add
    $title_play_intro_cutscene.add
    $title_credits.add
end

#Declare win and lose slides for the player to see when game is won or lost 
$winslide= Image.new("winslide.png", z:9999)
$winslide.remove
$loss=Image.new("loss.png",z:9999)
$loss.remove



#Begin Pet class#########################################################################################################
class Pet
    def initialize(hp, attack, name, position, type)
        @pet_hp= hp
        @pet_attack= attack
        @pet_name= name
        @pet_x= 0
        @pet_y= 0
        @position= position #which array position on each team?
        @hp_x= 20
        @hp_y= 160 
        @att_x= 80
        @att_y= 160 #sword and heart locations
        @hp_text= ""
        @att_text= ""
        @pet_z
        @hp_z
        @att_z
        
        
        if type== "player"
            if(@position == 0)
                @pet_x = 400
                @pet_y = 325
            elsif(@position == 1)
                @pet_x = 200
                @pet_y = 325
            elsif(@position == 2)
                @pet_x = 0
                @pet_y = 325
            end
        elsif type== "enemy"
            if(@position == 0)
                @pet_x = 600
                @pet_y = 325
            elsif(@position == 1)
                @pet_x = 800
                @pet_y = 325
            elsif(@position == 2)
                @pet_x = 1000
                @pet_y = 325
            end
        end #set pets and enemies in the correct location

        @img= Image.new(@pet_name, x:@pet_x, y: @pet_y , width:150, height:150, z:10)
        @img.remove
        @hp= Image.new("Heart.png", x:@pet_x +@hp_x, y:@pet_y +@hp_y, z:10)
        @hp.remove
        @att= Image.new("Dmg.png", x:@pet_x +@att_x, y:@pet_y +@att_y, z:10)
        @att.remove
        @att_text= Text.new(@pet_attack, x:@pet_x +@att_x +10, y:@pet_y +@att_y +20, color: 'white', z:11)
        @att_text.remove
        @hp_text= Text.new(@pet_hp, x:@pet_x +@hp_x +10, y:@pet_y +@hp_y +20, color: 'white', z:11)
        @hp_text.remove #set up all pet related images

        if($shopping == true)
            if(position == 0)
                @pet_x = 600
                @pet_y = 100
            elsif(position == 1)
                @pet_x = 400
                @pet_y = 100
            elsif(position == 2)
                @pet_x = 200
                @pet_y = 100
            end
            @simg = Image.new(name, x:@pet_x, y: @pet_y, width:150, height:150)
            @sdmg = Image.new("Dmg.png", x: @pet_x + 20, y: @pet_y + 150)
            @sdmg_text = Text.new(@pet_attack, x: @pet_x + 40, y: @pet_y + 160, color: 'white')
            @shp = Image.new("Heart.png", x: @pet_x + 70, y: @pet_y + 150)
            @shp_text  = Text.new(@pet_hp, x: @pet_x + 90, y: @pet_y + 160, color: 'white')
            #displays pet images and health/attack in shop screen after purchase
        else


            if type == "player"
                @img= Image.new(@pet_name, x:@pet_x, y: @pet_y , width:200, height:200)
                #########################################################################
                @att= Image.new("Dmg.png", x:@pet_x +100, y:@pet_y +220)
                @att_text= Text.new(@pet_attack, x:@pet_x +120, y:@pet_y +230, color: 'white')
                #########################################################################
                @hp= Image.new("Heart.png", x:@pet_x +220, y:@pet_y +220)
                @hp_text= Text.new(@pet_hp, x:@pet_x +225, y:@pet_y +230, color: 'white')
                #########################################################################
                @pet_title= Text.new(@pet_name.delete(".png"), x:@pet_x, y:@pet_y -150, color:'black')
                #########################################################################
            end
        end
    end

#This was removed on 5/5/2022, now this is handled through polymorphism.
    #def cry
        #if(@pet_name=="bean.png")
        #    $bean_cry.play
        #elsif(@pet_name=="black_cat.png")
        #    $black_cat_cry.play

        #elsif(@pet_name=="blood_slime.png")
        #    $blood_slime_cry.play
        #elsif(@pet_name=="bomberman.png")
        #    $bomberman_cry.play
        #elsif(@pet_name=="froginthroat.png")
        #    $froginthroat_cry.play
        #elsif(@pet_name=="green_slime.png")
        #    $green_slime_cry.play
        #elsif(@pet_name=="Molette.png")
        #    $molette_cry.play
        #elsif(@pet_name=="skele.png")
        #    $skele_cry.play
        #elsif(@pet_name=="skele_red.png")
        #    $skele_red_cry.play
        #elsif(@pet_name=="skeleton.png")
        #    $skeleton_cry.play
        #elsif(@pet_name=="snek_friend.png")
        #    $snek_friend_cry.play
        #elsif(@pet_name=="snowbot.png")
        #    $snowbot_cry.play
        #elsif(@pet_name=="Dr_Racket.png")
        #    $dr_racket_cry.play
        #end
    #end #plays the correct pet noise on death

    def set_attack(val)
        @pet_attack+= val
    end #for use with items

    def set_hp(val)
        @pet_hp+= val
    end #for use with items

    def get_position
        return @position
    end #for drawing the pets after a battle 

    def set_position(pos)
        @position = pos 
    end #for manually having to switch pets positions for drawing

    def modify_pet_hp(attack_val)
        @pet_hp = @pet_hp - attack_val
        if @pet_hp <= 0
            @pet_hp= 0       
        end
        @hp_text.remove
        @hp_text= Text.new(@pet_hp, x:@pet_x +@hp_x +70, y:@pet_y +@hp_y +20, color: 'white', z:11)
    end #change and display pet_hp depending on attack values

    def getImage
        return @img
    end #for calling upon the image of the pet 

    def addImage
        @img.add
        @att.add
        @hp.add
        @hp_text.add
        @att_text.add
    end #for adding image of the pet

    def removeImage
        @img.remove
        @att.remove
        @hp.remove
        @hp_text.remove
        @att_text.remove

    end #for removing image of the pet

    def getHP
        return @pet_hp
    end 
    
    def getAttack
        return @pet_attack
    end

    def getName
        return @pet_name
    end

    def setX(x)
        @img.remove
        @hp.remove
        @att.remove
        @att_text.remove
        @hp_text.remove
        @pet_x=x
        @hp_x=x
        @att_x=x
        @img= Image.new(@pet_name, x:@pet_x, y: @pet_y , width:150, height:150, z:10)
        if $shopping==false
          @hp_x=0
          @att_x =0 
        end
        @hp= Image.new("Heart.png", x:@pet_x +@hp_x+60, y:@pet_y +@hp_y, z:10)
        @att= Image.new("Dmg.png", x:@pet_x +@att_x+10, y:@pet_y +@att_y, z:10)
        @att_text= Text.new(@pet_attack, x:@pet_x +@att_x +20, y:@pet_y +@att_y +20, color: 'white', z:11)
        @hp_text= Text.new(@pet_hp, x:@pet_x +@hp_x +70, y:@pet_y +@hp_y +20, color: 'white', z:11)
    end #set X value of Pet with HP and Atk Vals. placed accordingly  

    def setY(y)
        @img.remove
        @hp.remove
        @att.remove
        @att_text.remove
        @hp_text.remove
        @pet_y=y
        @hp_y=y
        @att_y=y
        @img= Image.new(@pet_name, x:@pet_x, y: @pet_y , width:150, height:150, z:10)
        if $shopping==false
            @hp_y= 150
            @att_y = 150
          end
        @hp= Image.new("Heart.png", x:@pet_x +@hp_x+60, y:@pet_y +@hp_y, z:10)
        @att= Image.new("Dmg.png", x:@pet_x +@att_x+10, y:@pet_y +@att_y, z:10)
        @att_text= Text.new(@pet_attack, x:@pet_x +@att_x +20, y:@pet_y +@att_y +20, color: 'white', z:11)
        @hp_text= Text.new(@pet_hp, x:@pet_x +@hp_x +70, y:@pet_y +@hp_y +20, color: 'white', z:11)
    end  #set Y value of Pet with HP and Atk Vals. placed accordingly  

    def setZ(z)
        @img.remove
        @hp.remove
        @att.remove
        @att_text.remove
        @hp_text.remove
        @pet_z=z
        @hp_z=z
        @att_z=z
        @img= Image.new(@pet_name, x:@pet_x, y: @pet_y , width:150, height:150, z:@pet_z)
        @hp= Image.new("Heart.png", x:@pet_x +@hp_x+60, y:@pet_y +@hp_y, z:@hp_z)
        @att= Image.new("Dmg.png", x:@pet_x +@att_x+10, y:@pet_y +@att_y, z:@att_z)
        @att_text= Text.new(@pet_attack, x:@pet_x +@att_x +20, y:@pet_y +@att_y +20, color: 'white', z:@hp_z)
        @hp_text= Text.new(@pet_hp, x:@pet_x +@hp_x +70, y:@pet_y +@hp_y +20, color: 'white', z:@att_z)
    end  #set Z value of Pet with HP and Atk Vals. placed accordingly  

end
#End Pet class #####################################################################################################################################


#Subclasses of pet. 
#The only differences between pets are the sounds they make, so the only functions needed here are the cry functions.
#Everything else is inherited from the pet class, and the talk function is handled by the petArray class.
#################################################################################################################
class Bean < Pet
    def cry
        $bean_cry.play
    end
end

class Black_cat < Pet
    def cry
        $black_cat_cry.play
    end
end

class Eye < Pet
    def cry
        $eye_cry.play
    end
end

class Blood_slime < Pet
    def cry
        $blood_slime_cry.play
    end
end

class Bomberman < Pet
    def cry
        $bomberman_cry.play
    end
end

class Froginthroat < Pet
    def cry
        $froginthroat_cry.play
    end
end

class Green_slime < Pet
    def cry
        $green_slime_cry.play
    end
end

class Molette < Pet
    def cry
        $molette_cry.play
    end
end

class Skele < Pet
    def cry
        $skele_cry.play
    end
end

class Skele_red < Pet
    def cry
        $skele_red_cry.play
    end
end

class Skeleton < Pet
    def cry
        $skeleton_cry.play
    end
end

class Snek_friend < Pet
    def cry
        $snek_friend_cry.play
    end
end

class Snowbot < Pet
    def cry
        $snowbot_cry.play
    end
end

class Dr_Racket < Pet
    def cry
        $dr_racket_cry.play
    end
end
######################################################################
#end derivatives of the pet class.

#Begin Shop_item class #############################################################################################################################
class Shop_item
    @sitem_name
    def initialize
        @sitem_name = $possible_shop_items[rand($possible_shop_items.length)]
    end #set shop items randomly 

    def getName
        return @sitem_name
    end #return name of shop item 
end
#End Shop_item class ###############################################################################################################################



#Begin Item class #####################################################################################################################################
class Item
@item_name = ""
    def initialize(name)
        @item_name = name #simply the png name (please include .png at end)
        @inv_img
    end #intialize the item

    def getName
        return @item_name
    end #return name of item

    def erase
        @inv_img.remove
    end #erase the item 

    def draw(position)
        x= 200 + position* 150
        y= 10
        @inv_img= Image.new(@item_name, x:x, y:y, z:15)
    end #draw the item

    def evoke
        if(@item_name == "battery.png")
            count= 0
            while (count < $player_pets.length)
                $player_pets.getAt(count).set_attack(10)
                count+= 1
            end
        elsif(@item_name == "sigil.png")
            if $round > 1
                $round-= 1
            end
        elsif(@item_name == "health_pot.png")
            count=0 
            while (count < $player_pets.length)
                $player_pets.getAt(count).set_hp(8)
                count+= 1
            end
        elsif(@item_name == "deus.png")
            $player_pets.getAt(0).set_attack(40)
        elsif(@item_name == "flying_waffle.png")
            $player_pets.getAt(0).set_hp(15)
        end

    end #for modifying in-game attriubtes based on the bought item
end
#End Item class #####################################################################################################################################

# Intialize the Shop Pets and Items
$possible_shop_pets = ["Molette.png", "froginthroat.png", "black_cat.png","bomberman.png","snek_friend.png", "skeleton.png"]
$possible_shop_items = ["health_pot.png","sigil.png","battery.png", "deus.png", "flying_waffle.png"]


#Begin Shop_pet class #####################################################################################################################################
class Shop_pet
    @shop_pet_x = 0
    @shop_pet_name = ""
    @shop_pet_attk= 0
    @shop_pet_hp= 0
    def initialize(shop_position)
        @shop_pet_name = $possible_shop_pets[rand($possible_shop_pets.length)]
        if shop_position == 1
            @shop_pet_x = 384
        elsif shop_position == 2
            @shop_pet_x = 514
        else
            @shop_pet_x = 644
        end
        @shop_pet_attk = rand(10..25)
        @shop_pet_hp = rand(40..60)
    end #intialize and place pet in the right location in the shop phase

    def getName
        return @shop_pet_name
    end #for getting name of shop pet

    def getX
        return @shop_pet_x
    end #for getting X-coordinate of shop pet

    def getattk
        return @shop_pet_attk
    end #for getting Y-coordinate of shop pet


    def gethp
        return @shop_pet_hp
    end #for getting pet_hp of shop pet

end 
#End Shop_pet class #####################################################################################################################################


#Begin PetArray class ##########################################################################
class PetArray
    include Enumerable #PetArray is now enumerable
    #include Pet
    def initialize
        @pet_array= Array.new
    end
    #each functions to draw/move all Pets in a PetArray with one call
    #####################################
    def add_each
        @pet_array.each {|p| p.addImage}
    end

    def move_each(x,y) 
        @pet_array.each {|b| b.setX(x-=200)}
        @pet_array.each {|d| d.setY(y)}
    end

    def move_eache(x,y)
        @pet_array.each {|b| b.setX(x+=200)}
        @pet_array.each {|d| d.setY(y)}
    end
    #####################################
    def is_empty
        return @pet_array.empty?
    end 

    def kill
        @pet_array[0].removeImage
        @pet_array.delete_at(0)
    end #removes pet from the screen and PetArray

    def talk
        if(@pet_array[@pet_array.length-1].getName=="black_cat.png")
            $black_cat_talk.play
        elsif(@pet_array[@pet_array.length-1].getName=="bomberman.png")
            $bomberman_talk.play
        elsif(@pet_array[@pet_array.length-1].getName=="froginthroat.png")
            $froginthroat_talk.play
        elsif(@pet_array[@pet_array.length-1].getName=="Molette.png")
            $molette_talk.play
        elsif(@pet_array[@pet_array.length-1].getName=="skeleton.png")
            $skeleton_talk.play
        elsif(@pet_array[@pet_array.length-1].getName=="snek_friend.png")
            $snek_friend_talk.play
        end
    end #plays correct pet noise on purchase in shop

    def add(item)
        @pet_array.push(item)
    end # for adding item to the array

    def length
        return @pet_array.length
    end # return length of the pet team

    def getAt(i)
        return @pet_array.at(i)
    end # for getting the pet id at a given position

    def setAt(i, pet)
        @pet_array[i]= pet
    end # setting a certain pet at a given position in the pet array 
end
#End PetArray class#######################################################

# Repititve buy functions for each pet and item in the shop #  
def titleCleanup #remove the title screen graphics to make way for next screen
    $title_background.remove
    $title_play_button.remove
    $title_play_intro_cutscene.remove
    $title_credits.remove
    $on_title_page=false
end 

def rebuildTitle #replace the title screen in the correct position
    $title_background.add
    $title_play_button.add
    $title_play_intro_cutscene.add
    $title_credits.add
    $on_title_page=true
end 

def buyPet(forSale) # Buy Pet function that updates the global variables relative to the game
    if ($player_pets.length < 3 && $money > 1) 
        $shop_directions.remove
        $shop_directions2.remove
        $shop_directions3.remove
        if (forSale.getName == "Molette.png")
            $player_pets.add(Molette.new(forSale.gethp, forSale.getattk, forSale.getName, $player_pets.length, "player"))
        elsif (forSale.getName == "bomberman.png")
            $player_pets.add(Bomberman.new(forSale.gethp, forSale.getattk, forSale.getName, $player_pets.length, "player"))
        elsif(forSale.getName == "snek_friend.png")
            $player_pets.add(Snek_friend.new(forSale.gethp, forSale.getattk, forSale.getName, $player_pets.length, "player"))
        elsif(forSale.getName == "skeleton.png")
            $player_pets.add(Skeleton.new(forSale.gethp, forSale.getattk, forSale.getName, $player_pets.length, "player"))
        elsif(forSale.getName == "froginthroat.png")
            $player_pets.add(Froginthroat.new(forSale.gethp, forSale.getattk, forSale.getName, $player_pets.length, "player"))
        elsif(forSale.getName == "black_cat.png") 
            $player_pets.add(Black_cat.new(forSale.gethp, forSale.getattk, forSale.getName, $player_pets.length, "player"))
        end
        $player_pets.talk
        $money-= 2
        $money_counter.remove
        $money_counter = Text.new($money.to_s, x: 70, y: 10, size: 40, color: "brown")
    elsif $money == 1 && $players_items.length != 3
        $noMoney.remove
        $almostNoMoney.add
    elsif $player_pets.length == 3 && $money != 0
        $noMoney.remove
        $fullTeam.add
    else 
        $fullTeam.remove
        $almostNoMoney.remove
        $noMoney.add
    end 
end #end BuyPet

def buyItem(forSale)  #Buy Item function that updates the global variables realitve to the game
    if $money > 0
        $almostNoMoney.remove
        $shop_directions.remove
        $shop_directions2.remove
        $shop_directions3.remove
        $fullTeam.remove
        $coins.play
        $money-= 1
        $money_counter.remove
        $money_counter = Text.new($money.to_s, x: 70, y: 10, size: 40, color: "brown")
        $players_items.push(Item.new(forSale.getName))
        $players_items[$cur].draw($cur)
        $cur+= 1
        return true 
    else
        $almostNoMoney.remove
        $noMoney.add
        return false 
    end  
end  # end BuyItem


# Mouse-Click events --> progression of game and "repainting" of window during the stages of the game
on :mouse_up do |event|
    case event.button
    when :left 
        if($on_title_page==true)
            if($title_play_button.contains? Window.mouse_x, Window.mouse_y) #if play button on title screen is pressed, advance game
                titleCleanup
                $bg.add
                shop_phase
            elsif($title_play_intro_cutscene.contains? Window.mouse_x, Window.mouse_y) #if cutscene button on title screen is pressed, show cutscene
                titleCleanup
                $intro_background.add
                $let_me_out.add
                $intro_dialogue.play   
                $on_intro_page=true
            elsif($title_credits.contains? Window.mouse_x, Window.mouse_y) #if credits button is pressed, show credits
                titleCleanup
                $credits_background.add
                $on_credits_page=true
            end
        elsif ($on_title_page==false && $on_credits_page==true) #exit out of credits screen with a click
            if($credits_background.contains? Window.mouse_x, Window.mouse_y)
                rebuildTitle
                $credits_background.remove
                $on_credits_page=false
            end
        elsif ($on_intro_page==true && $on_title_page==false) #exit out of cutscene with a click
            if($intro_background.contains? Window.mouse_x, Window.mouse_y)
                rebuildTitle
                $intro_background.remove
                $let_me_out.remove
                $intro_dialogue.stop
                $song.play
                Music.volume= 25
                $on_intro_page=false
            end
        end
        # Shop phase events --> what happens for different clicks and interactions in the shop phase
        if ($shopping==true) #shop keep dialogue
            if ($shopkeep.contains? Window.mouse_x, Window.mouse_y) #voice line for the shop keep
                $yell.play
            end
            if ($shop_end.contains? Window.mouse_x, Window.mouse_y) && ($player_pets.length > 0)#if the next button is clicked, advance to next stage
                $next.play
                phase_change
            elsif ($spet1_image.contains? Window.mouse_x, Window.mouse_y) # when a pet is bought in the store
                buyPet($spet1)
            elsif ($spet2_image.contains? Window.mouse_x, Window.mouse_y) # second pet
                buyPet($spet2)
            elsif ($spet3_image.contains? Window.mouse_x, Window.mouse_y) # third pet 
                buyPet($spet3)
            elsif ($item1_image.contains? Window.mouse_x, Window.mouse_y) && ($item1_flag== true) # when an item is bought
                if buyItem($sitem1)
                    $item1_image.remove
                    $item1_flag= false
                end 
            elsif ($item2_image.contains? Window.mouse_x, Window.mouse_y) && ($item2_flag== true) #item 2 
                if buyItem($sitem2)
                    $item2_image.remove
                    $item2_flag= false
                end 
            elsif ($item3_image.contains? Window.mouse_x, Window.mouse_y) && ($item3_flag== true) # item 3 
                if buyItem($sitem3)
                    $item3_image.remove
                    $item3_flag= false
                end 
            end
        else
            if ($play_button.contains? Window.mouse_x, Window.mouse_y) # when the "Advance" button is clicked, start combat
                combat_phase($player_pets,$round)
            end
            #$shopping
        end
    end 
end 
# End Mouse-Click events 

# Combat Function # 
def combat_phase(pets, round) 
    player_team = $player_pets.clone #copies values from $player_pets to player_team
    enemy_team = $enemy_pets.clone #copies values from $enemy_pets to enemy_team
    if player_team.length == 3   #if 3 pets on team
        if enemy_team.length > 0 #only allow combat if there are enemies in enemy_team
            friend = player_team.getAt(0)
            enemy = enemy_team.getAt(0)
            combat(player_team.getAt(0), enemy_team.getAt(0), player_team, enemy_team) 
            if($friend_death==true && $enemy_death==true) #if both pets are defeated
                player_team.getAt(0).cry
                player_team.kill
                enemy_team.kill
                $enemy_death = false #reset flag
                $friend_death = false
            elsif ($friend_death==true) #if friend is defeated
                player_team.getAt(0).cry
                player_team.kill
                $friend_death=false
            elsif ($enemy_death == true) #if enemy is defeated
                enemy_team.getAt(0).cry
                enemy_team.kill
                $enemy_death = false
            end
        end
    
    elsif player_team.length == 2 #if 2 pets on team
        if enemy_team.length > 0
            friend = player_team.getAt(0)
            enemy = enemy_team.getAt(0)
            combat(player_team.getAt(0), enemy_team.getAt(0), player_team, enemy_team)
            if($friend_death==true && $enemy_death==true)
                player_team.getAt(0).cry
                player_team.kill
                enemy_team.kill
                $enemy_death = false
                $friend_death = false
            elsif ($friend_death==true)
                player_team.getAt(0).cry
                player_team.kill
                $friend_death=false
            elsif ($enemy_death == true)
                enemy_team.getAt(0).cry
                enemy_team.kill
                $enemy_death = false
            end
        end

    elsif player_team.length == 1 #if 1 pet on team
        if enemy_team.length > 0
            friend = player_team.getAt(0)
            enemy = enemy_team.getAt(0)
            combat(player_team.getAt(0), enemy_team.getAt(0), player_team, enemy_team)
            if($friend_death==true && $enemy_death==true)
                player_team.getAt(0).cry
                player_team.kill
                enemy_team.kill
                $enemy_death = false
                $friend_death = false
            elsif ($friend_death==true)
                player_team.getAt(0).cry
                player_team.kill
                $friend_death=false
            elsif ($enemy_death == true)
                enemy_team.getAt(0).cry
                enemy_team.kill
                $enemy_death = false
            end
        end
    end

    if (player_team.length == 0) #lose case
        $lose_case = true 
        exit_out 
    elsif (enemy_team.length==0) #win case
        if $round == 3
            $win_case = true 
            exit_out
        end
        if $winflag== false
            combat_cleanup(player_team)
            phase_change
        end
    end


end

def combat(friend, enemy, friend_team, enemy_team) # Actual combat calculations that determine 
    while (friend.getHP > 0 && enemy.getHP > 0)    # the deaths between a pair of pets 
            friend.modify_pet_hp(enemy.getAttack)  # Updates are then made to each team 
            enemy.modify_pet_hp(friend.getAttack)
            if (friend.getHP <=0 && enemy.getHP <=0)
                $friend_death=true
                $enemy_death=true
            elsif friend.getHP <= 0
                $friend_death=true
            elsif enemy.getHP <= 0
                $enemy_death=true
        end
    end
end

def combat_cleanup(temp_player_team)     # After combat is over, player enters shop_phase where the remaining pets are to be moved to display
    for i in 0..temp_player_team.length-1 do   # in a different location than combat Some times pets can have the same position despite where they might be displayed on the screen this check make sure that the pets do not overlap.       
        if $player_pets.getAt(i).get_position == 0 # The pet's location in the Pet Array 
            $player_pets.getAt(i).setX(200)        # determines their new location on-screen 
            $player_pets.getAt(i).setY(100)        
        elsif $player_pets.getAt(i).get_position == 1 # if pet = PetArray[1]...
            $player_pets.getAt(i).setX(400)
            $player_pets.getAt(i).setY(100)
        elsif $player_pets.getAt(i).get_position == 2  # if pet = PetArray[2]...
            $player_pets.getAt(i).setX(600)
            $player_pets.getAt(i).setY(100)
        end 
    end # end for loop 

    #Clean up the remnants of the past battle including pets and buttons
    $play_button.remove
    temp_counter=0

    while(temp_counter < $players_items.length)
        $players_items[temp_counter].erase
        temp_counter+= 1
    end
    $item1_flag= true
    $item2_flag= true
    $item3_flag= true
end
# End Combat Functions # 

# Shop_phase function #
def shop_phase        # Every time this function is called, add the elements and images of the
    $players_items= []  # shop phase on screen, including new pets to buy, items, remaining gold, etc. 
    $cur= 0
    $spet1= Shop_pet.new(1)
    $spet1_image= Image.new($spet1.getName,x: $spet1.getX, y: 600, width: 75, height: 75, z: 12)
    $spet2= Shop_pet.new(2)
    $spet2_image= Image.new($spet2.getName,x: $spet2.getX, y: 600, width: 75, height: 75, z: 12)
    $spet3= Shop_pet.new(3)
    $spet3_image= Image.new($spet3.getName,x: $spet3.getX, y: 600, width: 75, height: 75, z: 12)
    $sitem1=Shop_item.new
    $item1_image= Image.new($sitem1.getName, x: 774, y: 600, width: 75, height: 75, z: 12)
    $sitem2=Shop_item.new
    $item2_image= Image.new($sitem2.getName, x: 904, y: 600, width: 75, height: 75, z: 12)
    $sitem3=Shop_item.new
    $item3_image= Image.new($sitem3.getName, x: 1044, y: 600, width: 75, height: 75, z: 12)
    $spet1_image.add
    $spet2_image.add
    $spet3_image.add
    $money+= 6
    $gold.add
    $money_counter = Text.new($money.to_s, x: 70, y: 10, size: 40, color: "brown", z: 15)
    $shopping= true
    $shop_counter.add
    $shopkeep.add
    $shopbg.add
    $shop_end.add
    $shop_directions.add    
    $shop_directions2.add    
    $shop_directions3.add    

end

def shop_cleanup      # After the player is done in the shop and the "next" button is pushed, 
    $shopping= false    # this function clears the window of the shop elements and prepares the 
    $before_fight=true  # player for battle! 
    $spet1_image.remove
    $spet2_image.remove
    $spet3_image.remove
    $item1_image.remove
    $item2_image.remove
    $item3_image.remove
    $shop_counter.remove
    $shopkeep.remove
    $shopbg.remove
    $gold.remove
    $shop_end.remove
    $shop_directions.remove 
    $shop_directions2.remove 
    $shop_directions3.remove 
    $noMoney.remove
    $almostNoMoney.remove   
    $fullTeam.remove
end #removes shop images and sets flags for combat
# End Shop Functions #

def exit_out # Simple Exit Out function for when you win the game! 
    if $lose_case
        Window.clear
        $loss.add
        $song.stop
        $song1.stop
        $song2.stop
        $song3.stop
        $loser.play
    elsif $win_case
        Window.clear
        $winslide.add
        $winflag= true
        $dr_racket_cry.play
    end 

    Text.new("Click on screen to exit out!", x: 1000, y: 600, z:10000)
    on :mouse_down do |event| # Mouse Click means close 
        close
    end
end

# Phase Change Function #
def phase_change          # Function is called for every fighting stage of the game 
    if ($shopping==true)  # and redraws the player's pets into battle locations, changes 
        shop_cleanup    # the background, etc. This function also advances the # of rounds. 
        $round+= 1        
        if ($before_fight==true) # Check if player is in before_fight stage to use items before battle
            temp_counter=0
            while(temp_counter < $players_items.length)
                $players_items[temp_counter].evoke
                temp_counter+= 1
            end
            $before_fight=false
        end
        if $player_pets.length == 3        # The following if-elsif-else statements draws the player's pets
            $player_pets.add_each          # changed from hard-coded positions to an iterable draw/move
            if $round==1
                $player_pets.move_each(600,380)
            elsif $round ==2
                $player_pets.move_each(600,450)
            else #round 3
                $player_pets.move_each(600,380)
            end
        elsif $player_pets.length == 2
            $player_pets.add_each
            if $round==1
                $player_pets.move_each(600,380)
            elsif $round == 2
                $player_pets.move_each(600,450)
            else #round 3 
                $player_pets.move_each(600,380)
            end
        elsif $player_pets.length == 1
            $player_pets.add_each
            if $round==1
                $player_pets.move_each(600,380)
            elsif $round==2
                $player_pets.move_each(600,450)
            else $round==3
                $player_pets.move_each(600,380)
            end
        end
        # Draw the enemies depending on the current round #
        # and set their locations to the right spot.      #
        if $round==1
            $enemy_pets.setAt(0, Green_slime.new(30,28,"green_slime.png", 0, "enemy"))
            $enemy_pets.setAt(1, Bean.new(30,30,"bean.png", 1, "enemy"))
            $enemy_pets.add_each
            $enemy_pets.move_eache(600,400)
            $bg.remove
            $bg= Image.new("bg1.png")
        elsif $round==2
            $enemy_pets.setAt(0, Skele.new(20,28,"skele.png", 0, "enemy"))
            $enemy_pets.setAt(1, Snowbot.new(20,30,"snowbot.png", 1, "enemy"))
            $enemy_pets.setAt(2, Eye.new(10,30,"eye.png", 2, "enemy"))
            $enemy_pets.add_each
            $enemy_pets.move_eache(500,450)
            $bg.remove
            $bg= Image.new("tundra.png")
        elsif $round==3
            $enemy_pets.setAt(0, Blood_slime.new(20,28,"blood_slime.png", 0, "enemy"))
            $enemy_pets.setAt(1, Skele_red.new(20,30,"skele_red.png", 1, "enemy"))
            $enemy_pets.setAt(2, Dr_Racket.new(10,30,"Dr_Racket.png", 2, "enemy"))
            $enemy_pets.add_each            
            $enemy_pets.getAt(0).setX(675)
            $enemy_pets.getAt(0).setY(350)
            $enemy_pets.getAt(1).setX(850)
            $enemy_pets.getAt(1).setY(350)
            $enemy_pets.getAt(2).setX(1025)
            $enemy_pets.getAt(2).setY(325)
            $bg.remove
            $bg= Image.new("bg3.png")
        end
        # Add the "Advance" button to the battle screen so that the  #
        # player can advance in the fight and see if they win or     #
        # lose.                                                      #
        $play_button.add
        # Each round, has different music --> play new music for each round
        if $round==1 
            $song.stop
            $song1.play
            Music.volume= 25
            $song1.loop= true
        elsif $round==2
            $song.stop
            $song2.play
            Music.volume= 25
            $song2.loop= true
        else
            $song2.stop
            $song3.play
            $welcome.play
            Music.volume= 25
            $song3.loop= true
        end
    else # If phase change after a battle, change screen to the shop phase
        shop_phase
    end
end
# End Phase Change Function # 

#############################################
# BEGIN THE GAME! 
$player_pets= PetArray.new
$enemy_pets= PetArray.new
$player_pets2= PetArray.new
title_screen

show
