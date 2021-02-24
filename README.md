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
int main()
 {
      if(somvar != someothervar)
      {
          /* do a bunch of stuff */
      }
 }
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
and will set the default keys to ( C-, ) that toggle Fastway On/Off


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

Note that you can change most of these keys to your own bindings.



## Other Example Uses


### Writing

If you are a writer, either books, plays, films or anything else like that then using
Fastway either on its own or combined with a package like Iedit (https://github.com/victorhge/iedit)
can provide a quick way to edit your documents.

Lets just say your in the middle of writing your next blockbuster and you want to make
some changes.... In this example (excerpt from Harry Potter) i decide i want to change 
the character called Nearly Headless Nick to Nearly Headless Henry in the whole buffer....

![alt text](https://github.com/super-tomcat/Fastway/blob/main/fast_way_writing_example_1.gif?raw=true)


