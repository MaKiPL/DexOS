;=========================================================;
; EditData.                                      30/03/11 ;
;---------------------------------------------------------;
; DexOS OS V0.03                                          ;
; by Craig Bamford.                                       ;
;                                                         ;
;=========================================================;

 ;----------------------------------------------------;
 ; Data                                               ;
 ;----------------------------------------------------;
align 4 
Ytable		    dd 0, 160, 320, 480, 640, 800, 960,1120,1280,1440,1600,1760,1920
		    dd 2080,2240,2400,2560,2720,2880,3040,3200,3360,3520,3680,3840
		    dd 4000,4160, 4320, 4480, 4640, 4800, 4960,5120,5280,5440,5600,5760,5920
		    dd 6080,6240,6400,6560,6720,6880,7040,7200,7360,7520,7680,7840
BufferAddOn1	    dd 0
FileHandle2	    dd 0
EndOfFile	    dd 0
TopOfScreen	    dd 0
FileBufferAddOn     dd 0
FileBufferAddOn1    dd 0
OutPutMonitor	    dd 0
StringAddess	    dd 0
ListDownCount	    dd 0
progMenu1	    dd 0
FddSecLoadedCount   dd 0
FddFilesForMenu     dd 0
FileNumberCount     dd 0 
FileNumberCount2    dd 0
ListCount	    dd 0
FileAddress	    dd 0
PageUpPointer	    dd 0
EndOfTexFile	    dd 0
NumberOfLinesInFile dd 0
LineCount	    dd 0
ColStart	    dd 0
EndOfLineAddOn	    dd 0
EOLNumber	    dd 0
EOFlNumber	    dd 0
C4tfNumbeoFLoops    dd 0
EdiAddress	    dd 0
NumberOfBinFile     dd 0
WrittenFileName     dd 0
test1		    dw 0
ConVarY 	    dw 0
WinY		    dw 0
WinX		    dw 0
LoadWinY	    dw 0
Hz		    dw 0
CursorX 	    dw 0
CursorY 	    dw 0
TotalLine	    dw 0
PosX		    db 0
PosY		    db 0
ExitEditor	    db 0
ErrorCode	    db 0
ShowText	    db 0
MenuBar 	    db 0
BarExit 	    db 0
EOFtest 	    db 0
color4		    db 0
DriveVar	    db 0
StandaredColor	    db 0
StandaredPalette    dd 0

box_colors1	    db 3fh ;78h
box_colors	    db 1Fh  ;8Fh 
window_colors	    db 3Fh
box_selection_colors db 9Fh ;0Fh

Fatmod		    dd	NoModuleLoaded
ID		    db 'DEXOSFAT',0

WinAbout:    db 54
	     db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
	     db '�                                                    �'
	     db '�                                                    �'  
	     db '�            _____         _______                   �'    
	     db '�           |  __ \       |__   __|                  �'
	     db '�           | |  | | _____  _| | _____  __           �'
	     db '�           | |  | |/ _ \ \/ / |/ _ \ \/ /           �'
	     db '�           | |__| |  __/>  <| |  __/>  <            �'
	     db '�           |_____/ \___/_/\_\_|\___/_/\_\           �'
	     db '�                                                    �'
	     db '�                                                    �'
	     db '�                                                    �'
	     db '�              Text mode IDE for DexOS.              �'
	     db '�         Coded by Craig Bamford (a.k.a Dex)         �'
	     db '�                     v0.03 2011                     �'
	     db '�                                                    �'
	     db '�                   WWW.DEX-OS.COM                   �'
	     db '�                                                    �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

WinCommands: db 54
	     db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
	     db '�                  DexTex Commands                   �'
	     db '냐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캐'
	     db '� Home       - Move to the start of current line.    �'
	     db '� End        - Move to the end of current line.      �'
	     db '� Alt        - Hightlight menu bar.                  �'
	     db '� PageUp     - Scroll up one page.                   �'
	     db '� PageDown   - Scroll down one page.                 �'
	     db '� Enter      - Start a new line.                     �'
	     db '� Backspace  - Delete the char to the left of cursor.�'
	     db '� Ctrl+d     - Delete the current line.              �'
	     db '� ArrowLeft  - Move cursor left one.                 �'
	     db '� ArrowRight - Move cursor right one.                �'
	     db '� ArrowUp    - Move cursor one line up.              �'
	     db '� ArrowDown  - Move cursor one line down.            �'
	     db '�                                                    �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

WinFasm:    db 74
	     db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
	     db '�                             Assemble file                              �'
	     db '냐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캐'
	     db '� Fasm>                                                                  �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '�                                                                        �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

;WinLoadSave:    db 53
	     db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
	     db '�                    Load/Save As                   �'
	     db '냐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '�                                                   �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'

WinLoadSave: db 53
	     db 20h, 0c9h,0cdh,20h,'Open ', 42	dup(0cdh),0bbh ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 20h,20h,'File:',42  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0bah, 49  dup(' ') ,0bah ,20h
	     db 20h, 0c8h, 49  dup(0cdh),0bch ,20h		       


WinFile      db 15,8,color2a
	     db '旼컴컴컴컴컴컴�'
	     db '� Load        �'
	     db '� Save        �'
	     db '� Save As     �'
	     db '� New         �'
	     db '� Assemble    �'
	     db '� Exit        �'
	     db '읕컴컴컴컴컴컴�'
WinEdit      db 18,6,color2a
	     db '旼컴컴컴컴컴컴컴커'
	     db '� Cut     Ctrl+X �'
	     db '� Copy    Ctrl+C �'
	     db '� Paste   Ctrl+V �'
	     db '� Clear   Del    �'
	     db '읕컴컴컴컴컴컴컴켸'
WinSearch    db 13,4,color2a
	     db '旼컴컴컴컴컴�'
	     db '� Find....  �'
	     db '� Find Next �'
	     db '읕컴컴컴컴컴�'
WinHelp      db 17,4,color2a
	     db '旼컴컴컴컴컴컴컴�'
	     db '� Commands      �'
	     db '� About DexTex  �'
	     db '읕컴컴컴컴컴컴컴�'

load_fun123	db 30
	     db '旼Load File컴컴컴컴컴컴컴컴컴�'
	     db '�                            �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴켸'
load_fun     db 30
	     db '旼Load File컴컴컴컴컴컴컴컴컴�'
	     db '�   �                    �   �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

Save_AsA:     db 32
	     db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
	     db '�         Save File As         �'
	     db '�                              �'
	     db '�                              �'
	     db '�                              �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

Save_AsYesNo: db 32
	     db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
	     db '�     File already exists      �'
	     db '�  Do you want to replace it ? �'
	     db '�                              �'
	     db '�         Yes      No          �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

Fdd_Error:   db 32
	     db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
	     db '� ***  READ\WRITE  ERROR!  *** �'
	     db '�                              �'
	     db '�   Press anykey to continue   �'
	     db '�                              �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

TopBarMem    db '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 (C) Craig Bamford 쳐컴�'
	     db '쿏exOS                                                                         �'
	     db '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

BorderTop    db '                                                                                '
	     db '                                                                                '
BorderMid    db '                                                                                '
BorderBot    db '                                                                                '

WinHead1     db '   File     Edit     Search     Help  '

msg1	     db 0xd2,0x08, ' A:\Noname.txt                                              Line:0000  Col:0000',0

win_info     db '                                       '  ;----+
	     db '    � Total '				   ;    |
  str_ttl    db 	    '     '			   ;    |
win_info2    db 		 ' � Line '		   ;  Info
  str_y      db 			 '     '	   ;    |
win_info3    db 			      ' Col '	   ;    |
  str_x      db 				   '    '  ;----+
AddONspacer  db '    '
FileName: times  128  db 0
FileName1 db 'Untitled.txt',0,0,0
ThisDir: times	128  db 0

;=======================================================  ;
;  File data                                      *New*   ;
;=======================================================  ;
    drive	   db 0
    DriveNew	   db 0 				  ;
		   db ' is $'				  ;
    Drive2	   db 0 				  ;
		   db ':\$'				  ;
ChangeDirTest	   db 0 				  ;
ListBufferAddOn    dd 0 				  ;
File_Count	   dd 0 				  ;
 FileNames1	   db '*.*',0				  ; file name
FileNames	   db '*',0				  ; file name
;=======================================================  ;
;  DTA Buffer                                             ;
;=======================================================  ;
    DTAbuffer:	   db 22 dup(?) 			  ; header info - not used
    fileTime:	   dw 0 				  ; time
    fileDate:	   dw 0 				  ; date
    fileSize:	   dd 0 				  ; size
    fileName:	   db 14 dup(0) 			  ; name
    fileNameExt:   db 3 dup(0)				  ; file ext
    EndOfString:   db 0,0, '$'				  ;
    TempBuff1:	   db 68 dup(' ')			  ;
		   db 0 				  ;

