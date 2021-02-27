# Fastway
Fast way to move to positions on the current line in Emacs

![alt text](https://github.com/super-tomcat/Fastway/blob/main/fastway.png?raw=true)


Reason for writing this.... in Emacs we have Avy and Ace-jump (and similar packages) for quickly moving to most places on the screen,
which work very well, however i found them a bit overwhelming, lots of chars popping up everywhere showing where to jump to, plus out
of habit i usually found myself already on the line i wanted to edit before thinking about Avy which kind of defeated the object.

Having found myself already on the line i'd then do something like lots of right cursors or even Ctrl-right and Ctr-left cursors etc
to get where i wanted, which, depending on how long the line was could involve quite a few keypresses, hence Fastway was born.


Fastway also came about after seeing this thread on Reddit where someone asked if EMACS/VIM are more efficient than other graphical editors?

https://www.reddit.com/r/linux/comments/6vflvy/is_emacsvim_really_that_much_more_efficient/

Somebody replied giving an example of how they could quickly edit some sections of code using Vim, it went something like this:

This is the example code they gave:
```
1  int main()
2  {
3       if(somvar != someothervar)
4       {
5           /* do a bunch of stuff */
6       }
7  }
``` 
OK... so, I want to change the condition on line 3 to someothervar > 4 and I want to change the entire block inside on line 5...

Notepad...
 down, down, ctrl right, ctrl right, ctrl right, shift, ctrl right, right, right, right del, someothervar > 4, down down,
 home, shift, (down however many times, depending on the length of the stuff in the brackets), del, (we'll assume autoindent is
 done for you), /* do other stuff */

Vim:
```
:3<cr>f(ci(someothervar > 4<esc>:5<cr>ci{/*do other stuff */<esc>
```  
  Okay, so if we count the keypresses in the Vim version above, i'd say its about 51
  
So i thought, well you know what, Emacs can do better than that! So i created Fastway just to prove it....

EMACS: Using Fastway:
(approx 28 keypresses)
```
<M-g> 
<M-g> 
3
<Return>
Turn Fastway Mode On with <C-,> (Check [char] Mode on and Regex Words Highlighted)
s
s
<Ctrl-Shift-Left-Cursor>
<Delete>
<Ctrl-Right-Cursor>
 > 4
<M-g>
<M-g>
5
<Return>
a
<Ctrl-Shift right cursor>
<Ctrl-Shift right cursor>
<Ctrl-Shift right cursor>
<Delete>
other
```
Done :-)

And here is an animated gif showing exactly how its done...

![alt text](https://github.com/super-tomcat/Fastway/blob/main/fastway_example_2.gif?raw=true)

If you wanted to do this with Fastway in Cursor Mode (which depending on what you have
to edit or change maybe a better mode to be in because it virtually allows full editing
to take place while Fastway is on) you could do it like this, which is only about 2 more
keypresses than in Char Mode:
(approx 30 keypresses) 
```
<M-g> 
<M-g> 
3
<Return>
Turn Fastway Mode On with <C-,> (Check [curs] Mode on and Regex Words Highlighted)
<right cursor>
<right cursor>
<right cursor>
<Ctrl-Shift-Left-Cursor>
<Delete>
<Ctrl-Right-Cursor>
 > 4
<M-g>
<M-g>
5
<Return>
<right cursor>
<right cursor>
<Ctrl-Shift right cursor>
<Ctrl-Shift right cursor>
<Ctrl-Shift right cursor>
<Delete>
other
```
Done :-)

See further on for more example uses...

Installing into Emacs....
============================================================================

You need to put the file (fastway-mode.el) in a folder where Emacs
can see it.
If you are not sure how to do this then you can do what i do...

I have created a new folder inside my Emacs (.emacs.d) folder
called: site-lisp

In this folder i put all my seperate .el files that i want to load and
use when Emacs starts.

Once you have created this folder, put the file: fastway-mode.el inside it.

To make Emacs see the files in this folder you need to add this line to
the top of your Emacs init.el file:

```(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))```

You can now load any of the files in this folder, usually by adding something
like:

```(require 'fastway-mode)```

to your Emacs init file and then set any customization you need.

If you know how to you can also byte-compile the fastway-mode.el file, just
open it in Emacs and go: Emacs-Lisp > Byte Compile This File, from the Emacs
menu and its done.

Example Configuration....
============================================================================
Add these lines to the end of your Emacs init.el file.
These will make sure Fastway loads every time Emacs starts so its ready to use
and will set the default keys that toggle Fastway On/Off to ```C-,```

```
(require 'fastway-mode)
(global-set-key (kbd fastway-toggle-key-default) 'fastway-toggle)
```


Default Keys:
===========================================
```
C-,           Toggles Fastway On/Off
C-.           Cycles through regex used for matches
M-C-,         Cycles through overlays used to highlight matches
M-C-'         Switches between Cursor and Character movement modes
<right>       Move point to next match on the right
<left>        Move point to next match on the left
C-C f k       Display fastway keys
```

Note that you can change most of these keys to your own bindings, see
Customization further on for how to do that.


Quick overview:
=============================================

This is a quick overview to get you up and running with Fastway.                                      

Make sure you have a file loaded in Emacs preferably one that contains a fair amount                  
of text.

Switch Fastway on by pressing ```C-,``` (see further back for installation if this does not work)

Note the Fastway message appear in the mini buffer and the ```Fastway[curs]``` entry in the mode line.      
If there is any text on the current line you should see that the first letter of each                 
word is highlighted.

Practice pressing the left and right cursor keys to move point to each highlight.
Point will always move to the nearest highlight depending on which direction (left or right) you want to move in.                                                                                  
You can also press the up and down cursor keys to move to other lines and as you                      
do this note how the highlighting updates for each line.

As you edit the line Fastway will automatically update the highlighting on the line.                  
Try changing a word to a different word and watch the highlighting update.                            
You can also switch between different highlighting modes by pressing ```M-C-,``` (for Windows users         
that key combination is ```Alt-Ctrl and ,```)

The first time you try it the highlights should change to just being underlined.

Fastway comes with 4 different highlighting modes which also includes a mode that completly           
switches highlighting off but Fastway will still work, this is for more experienced users who         
do not want to be distracted by any highlighting.

You can also customize any of these highlighting modes.

Practice switching between the different highlighting modes now with ```M-C-,```

Once you have settled on a highlighting you prefer you can customize Fastway so that every time       
Fastway starts it will use that highlighting, read further on for notes about Customization.

To turn Fastway off just press ```C-,``` again.                                                             
                                                                                                      
Fastway has 2 modes of movement along a line, either cursor mode or character mode.                   

When you first try Fastway you will be in cursor mode, you can see what mode you are                  
in at any time by looking at the emacs mode line, if you are in cursor mode then you                  
will see: ```Fastway[curs]``` in the mode line, and if you are in character mode you will                   
see: ```Fastway[char]``` in the mode line.

You can switch between each mode when ever you want by pressing ```M-C-'``` (for windows users              
that key combination is: ```Alt-Ctrl and '```)

So what is the difference between cursor and character mode?

When Fastway is in cursor mode you can use the left and right cursor                                  
keys (these keys can be customized) to move point to each highlight on the line.                      
However when Fastway is in character mode you can also press the corresponding key                    
of the highlighted character to move point to that position.

So it may seem that character mode is the best mode to be in since it allows more                     
ways to move point to where you need it, however there are some things you need to                    
be aware of....                                                                                          
When you are in character mode you will not be able to edit any characters that are                   
the same as those highlighted, this is because Fastway has to intercept the keys                      
when you press them, however if you are in cursor mode then you can edit those                        
characters.

So you have to weigh up whether you can get by with cursor mode and also gain virtually               
full editing of the line at the same time.                                                            
Or do you want the slightly quicker (in most cases) way of moving point to where you want             
it by using Fastway in character mode but lose the ability to do some editing.                        
You can of course just switch Fastway off to re-gain full editing again.

How does Fastway know which characters to highlight and move to?                           
                                                                                           
Fastway uses Regular Expressions to determine which characters to highlight and move to.

However you only need to know Regular Expressions if you want to change how Fastway        
does it, Fastway comes with 3 built in Regular Expressions (more may be added in time,     
such as adding the capability to move to the ends of words as well) that you can switch    
to at any time.

When you first use Fastway the default regular expression will highlight the start of      
words (ascii characters only) and numbers.                                                 
This regular expression works well for a wide range of text editing situations.

However if you are a programmer for example then you may also require a regular expression 
that lets you jump to other characters besides the start of words and numbers, examples include mathematical symbols such as +, *, -, etc                                          
Well Fastway has that option built in.

In fact to cycle through the 3 different regular expressions for matching make sure        
Fastway is running then press the keys: ```C-.```                                                
Each time you press ```C-.``` you will see a message in the Emacs mini buffer that tells you     
what type of characters Fastway will now move to and also you should see the highlights    
on the current line update depending on what characters are on the current line.

The following 3 types of regular expressions are included with Fastway:                    
                                                                                           
Words and Numbers                                                                          
Delimeters and Numbers                                                                     
Words joined with - and Numbers (included mainly for Lisp programmers out there)           
                                                                                           
As previously stated, if you are familiar with Regular Expressions then you can change     
any of these to your liking, see the Customization section for more details.               
                                                                                           
And finally, while you are learning to use Fastway its easy to forget the keys, to help    
with that you can at any time while Fastway is turned on bring up a new window displaying  
Fastways keys, to do that just press ```C-c then f then k```                                                                     


Customization
=============================================
The following options can be customized, in Emacs press M-x and enter
```customize-group``` then enter ```fastway``` to see the following....

```
Fastway Char Mode Case Sensitive
```
   If this is On (t) then in Character mode, keys are case sensitive, which means
   for example you will need to press W (shift-w) to move to W characters, etc. If 
   this is Off (nil)(default) then pressing either w or W (shift-w) will move to
   both w and W.

```
Fastway Character Movement Modeline String
```
   Modeline string appended to ‘fastway-main-modeline-string’ when Fastway is in character movement mode.

```
Fastway Cursor Movement Modeline String 
```
   Modeline string appended to ‘fastway-main-modeline-string’ when Fastway is in cursor movement mode.

```
Fastway Default Movement Mode
```
   Use this option to set Fastways default movement. Cursor Movement lets you use
   2 keys to move left and right to each match, the advantage with this mode is that
   you can still edit the line while its on, the disadvantage compared to Character
   Movement is that it may take more key presses to get to where you want. 
   Character Movement lets you press keys corresponding to the match you want to move
   to, in some cases it can take less keys to get to where you want than with Cursor
   Movement, the disadvantage is that you cannot edit the line while this mode is on.
   You can also switch between either mode while Fastway is on.

```
Fastway Default Regex Index
```
   This is the index to the regex you want to start each session of Fastway with.
   This must be in range of the total number of regex you have in ‘fastway-line-match-regex’.
   Also see ‘fastway-start-with-last-used-regex’ to overide this each time you switch Fastway on
   during the current session.

```
Fastway Display Message
```
   If this is On (non nil) (default) then whenever you switch Fastway on or off
   a message will also be displayed.

```
Fastway Key Move Left
```
   If fastway is in Cursor mode then this is the key used to move to the next position on the left.
   This key will only apply when Fastway is switched on.

```
Fastway Key Move Right
```
   If fastway is in Cursor mode then this is the key used to move to the next position on the right.
   This key will only apply when Fastway is switched on.

```
Fastway Key Movement Mode Switch
```
   Key used to switch between Fastway movement modes, only works when Fastway
   is already on. 
   The modeline will update to show which mode you are in.

```
Fastway Key Overlay Switch
```
   Key used to switch between overlays in ‘fastway-matches-overlay-face-1’,
    ‘fastway-matches-overlay-face-2’ and ‘fastway-matches-overlay-face-3’or
   to turn the overlay off. This key will only apply when Fastway is switched on.

```
Fastway Key Regex Switch
```
   Key used to switch between different regex in ‘fastway-line-match-regex’.
   Each regex determines what positions will be highlighted and jumped to.
   This key will only apply when Fastway is switched on.

```
Fastway Key Show Keys
```
   Display fastway keys in seperate window

```
Fastway Line Match Regex
```
   These are the regular expressions that Fastway uses to find matches.
   Each element should look like ("Name" "Regex"), the Name string will be shown
   as a message when you switch between them while Fastway is on, the Regex string
   will only apply to the current line that point is on, even if a region is active.

```
Fastway Main Modeline String
```
   The main string displayed in the modeline when Fastway is on.

```
Fastway Matches Overlay Face 1 face
```
   Face number 1 which is used to highlight the Fastway positions you will jump to.
   See ‘fastway-overlay-default-choice’ to set this to the default when you start a new
   session

```
Fastway Matches Overlay Face 2 face
```
   Face number 2 which is used to highlight the Fastway positions you will jump to.
   See ‘fastway-overlay-default-choice’ to set this to the default when you start a new
   session
   
```
Fastway Matches Overlay Face 3 face
```
   Face number 3 which is used to highlight the Fastway positions you will jump to.
   See ‘fastway-overlay-default-choice’ to set this to the default when you start a new
   session

```
Fastway Overlay Default Choice
```
   Use this option to set Fastways default overlay. In other words how the matches
   are highlighted when Fastway is first switched on. You can only choose one
   face out of two, or you can elect to have no overlay which means no highlighting.

```
Fastway Overlay Priority
```
   The priority of the overlay used to indicate matches.

```
Fastway Start With Last Used Regex
```
   If this is On (non nil) (default) then whenever you switch Fastway on during the
   current session it will start with the last used regex. If this is Off (nil) then
   whenever you switch Fastway on it will always start with the Regex pointed to
   by ‘fastway-default-regex-index’.

```
Fastway Toggle Key Default
```
   Key used to toggle Fastway mode on/off.






## Other Example Uses


### Writing

If you are a writer, either books, plays, films or anything else like that then using
Fastway either on its own or combined with a package like Iedit (https://github.com/victorhge/iedit)
can provide a quick way to edit your documents.

Lets just say your in the middle of writing your next blockbuster and you want to make
some changes.... In this example (excerpt from Harry Potter) i decide i want to change 
the character called Nearly Headless Nick to Nearly Headless Henry in the whole buffer....

![alt text](https://github.com/super-tomcat/Fastway/blob/main/fast_way_writing_example_1.gif?raw=true)


