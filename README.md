# Fastway
Fast way to move to positions on the current line in Emacs

![alt text](https://github.com/super-tomcat/Fastway/blob/main/fastway.png?raw=true)


Coming Soon :-)

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

## Other Example Uses

### Writing

If you are a writer, either books, plays, films or anything else like that then using
Fastway either on its own or combined with a package like Iedit (https://github.com/victorhge/iedit)
can provide a quick way to edit your documents.

Lets just say your in the middle of writing your next blockbuster and you want to make
some changes.... In this example (excerpt from Harry Potter) i decide i want to change 
the character called Nearly Headless Nick to Nearly Headless Henry in the whole buffer....

![alt text](https://github.com/super-tomcat/Fastway/blob/main/fast_way_writing_example_1.gif?raw=true)


