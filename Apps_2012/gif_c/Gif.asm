;=========================================================;
; GIF viewer                                   11/04/2012 ;
;---------------------------------------------------------;
; DexOS V6, cli gif demo.                                 ;
;                                                         ;
; (c) Craig Bamford, All rights reserved.                 ;                          
;=========================================================;
format binary as 'dex'					  ;
	ColorOrder equ Dex4U				  ;
use32							  ;
	ORG   0x1A00000 				  ; where our program is loaded to
	jmp   start					  ; jump to the start of program.
	db    'DEX6'					  ;
	include 'Gif.inc'				  ;
;=======================================================  ;
; Start of program.                                       ;
;=======================================================  ;
start:							  ;
	mov	ax,18h					  ;
	mov	ds,ax					  ;
	mov	es,ax					  ;
;=======================================================  ;
; Get calltable address.                                  ;
;=======================================================  ;
	mov	edi,Functions				  ; fill the function table
	mov	al,0					  ; so we have some usefull functions
	mov	ah,0x0a 				  ;
	int	50h					  ;
;=======================================================  ;
; Load vesa info.                                         ;
;=======================================================  ;
	mov	ax,4f00h				  ; Set the vesa mode
	mov	bx,0x4115				  ;
	mov	edi,Mode_Info				  ; fill in vesa info
	call	[RealModeInt10h]			  ;
	jc	VesaError1				  ;
;=======================================================  ;
; uncompress.                                             ;
;=======================================================  ;      
uncompress:						  ;
	cmp	dword[file_area],'GIF8' 		  ;
	jnz	ImageError				  ;
	mov	esi,file_area				  ;
	mov	ecx,[esi+0xa]				  ;
	add	esi,0xd 				  ;
	bt	ecx,7					  ;
	jnc	NoGlobalColor				  ;
	mov	[ColorTableFlag],1			  ;
	mov	[globalColor],esi			  ;
NoGlobalColor:						  ;
	mov	esi,file_area				  ;
	mov	edi,header				  ;
	mov	eax,gif_hash_offset			  ;
	call	ReadGIF 				  ;
DrawImage:						  ;
	call	BackGround				  ;
	pushad						  ;
	cmp	[ColorTableFlag],0			  ;
	je	ColorFlag0				  ;
	mov	esi,file_area				  ;
	xor	ecx,ecx 				  ;
	mov	cl,[esi+0xb]				  ;
	mov	ebx,ecx 				  ;
	mov	esi,dword[globalColor]			  ;
	shl	ecx,2					  ;
	sub	ecx,ebx 				  ;
	add	esi,ecx 				  ;
	lodsd						  ;
	shl	eax,8					  ;
	mov	ebx,eax 				  ;
	call	Mirror_ebx				  ;
	mov	dword[BackGroundColor],ebx		  ;
ColorFlag0:						  ;
	popad						  ;
;=======================================================  ;
; load image to screen buffer.                            ;
;=======================================================  ;
	mov	[countInECX],ecx			  ;
	mov	[hexnumber],bl				  ;
	mov	[HeaderAddOn],0 			  ;
	mov	[countIMAGES],0 			  ;
;=======================================================  ;
; Reprogam timer for 100 ticks.                           ;
;=======================================================  ;
	mov	cx,100					  ;
	call	[InterruptTimer]			  ;
align 4 						  ;
;=======================================================  ;
; mainLoop                                                ;
;=======================================================  ;
mainLoop:						  ;
	mov	eax,[countIMAGES]			  ;
	shl	eax,5					  ;
	add	eax,[GifListAddress]			  ;
	mov	edi,[eax]				  ;
	mov	[headerTEST],edi			  ;
	mov	edi,[eax+18]				  ;
	and	edi,3					  ;
	;push   eax                                       ;
	;mov    eax,edi                                   ;
	;call   [WriteHex32]                              ;
	;pop    eax                                       ;
	cmp	edi,0					  ;
	je	DisplacementOK				  ;
	cmp	edi,1					  ;
	je	DisplacementOK				  ;
	cmp	edi,2					  ;
	jne	NotThis1				  ;
	call	GetVesaScreenPointer			  ;
	mov	[BufferPointer],edi			  ;
	call	RestoreBackGround			  ;
	jmp	DisplacementOK				  ;
NotThis1:						  ;
	cmp	edi,3					  ;
	jne	DisplacementOK				  ;
bbb:							  ;
	mov	edi,0					  ;
Restore2Previous:					  ;
	call	BackGroundImage 			  ;
DisplacementOK: 					  ;
	mov	eax,[countIMAGES]			  ;
	shl	eax,5					  ;
	add	eax,[GifListAddress]			  ;
	mov	edi,[eax]				  ;
	mov	[headerTEST],edi			  ;
	mov	edi,[eax+4]				  ;
	mov	[anim_delay],edi			  ;
	xor	ebx,ebx 				  ;
	mov	bx,word[eax+8]				  ;
	mov	[VesaStartX],ebx			  ;
	mov	bx,word[eax+16] 			  ;
	mov	[VesaStartY],ebx			  ;
	mov	bx,word[eax+12] 			  ;
	mov	word[ImageX],bx 			  ;
	mov	bx,word[eax+14] 			  ;
	mov	word[ImageY],bx 			  ;
	mov	[TranspYesNo],0 			  ;
	mov	bl,byte[eax+22] 			  ;
	cmp	bl,1					  ;
	jne	TranspNO				  ;
	mov	[TranspYesNo],1 			  ;
	pushad						  ;
	mov	esi,file_area				  ;
	xor	ecx,ecx 				  ;
	mov	cl,byte[eax+23] 			  ;
	mov	ebx,ecx 				  ;
	mov	esi,dword[globalColor]			  ;
	shl	ecx,2					  ;
	sub	ecx,ebx 				  ;
	add	esi,ecx 				  ;
	lodsd						  ;
	shl	eax,8					  ;
	mov	ebx,eax 				  ;
	call	Mirror_ebx				  ;
	mov	dword[TranspColor],ebx			  ;
	popad						  ;
TranspNO:						  ;
	call	GetVesaScreenPointer			  ;
	mov	[BufferPointer],edi			  ;
	call	PutGif					  ;
	call	BuffToScreen				  ;
	cmp	[countInECX],1				  ;
	je	JustOneImage				  ;
	mov	eax,[anim_delay]			  ;
	call	[SetDelay]				  ;
	inc	[countIMAGES]				  ;
	mov	eax,[countInECX]			  ;
	cmp	[countIMAGES],eax			  ;
	jb	Itsok					  ;
	mov	[countIMAGES],0 			  ;
Itsok:							  ;
	call	[KeyPressedNoWait]			  ;
	cmp	al,0					  ;
	je	mainLoop				  ;
;=======================================================  ;
; Exit Menu.                                              ;
;=======================================================  ;
DemoEnd:						  ;
	call	SetTimeBack2Default			  ;
	mov	ax,03h					  ;  move the number of the mode to ax
	call	[RealModeInt10h]			  ;  and enter the mode using int 10h
	xor	eax,eax 				  ;
	call	[SetCursorPos]				  ;
	ret						  ;
							  ;
;=======================================================  ;
; JustOneImage                                            ;
;=======================================================  ;
JustOneImage:						  ;
	call	SetTimeBack2Default			  ;
	call	[WaitForKeyPress]			  ;
	mov	ax,03h					  ;  move the number of the mode to ax
	call	[RealModeInt10h]			  ;  and enter the mode using int 10h
	xor	eax,eax 				  ;
	call	[SetCursorPos]				  ;
	ret						  ;

;=======================================================  ;
; Display Vesa Error message.                             ;
;=======================================================  ;
VesaError1:						  ;
	mov	ax,03h					  ;  move the number of the mode to ax
	call	[RealModeInt10h]			  ;  and enter the mode using int 10h
	xor	eax,eax 				  ;
	call	[SetCursorPos]				  ;
	mov	esi,msg1				  ;
	call	[PrintString_0] 			  ;
	call	[WaitForKeyPress]			  ;
	ret						  ;
;=======================================================  ;
; Load file error.                                        ;
;=======================================================  ;
LoadfileError:						  ;
	mov	ax,03h					  ;  move the number of the mode to ax
	call	[RealModeInt10h]			  ;  and enter the mode using int 10h
	xor	eax,eax 				  ;
	call	[SetCursorPos]				  ;
	mov	esi,msg2				  ;
	call	[PrintString_0] 			  ;
	call	[WaitForKeyPress]			  ;
	ret						  ;
;=======================================================  ;
; information.                                            ;
;=======================================================  ;
information:						  ;
	mov	ax,03h					  ;  move the number of the mode to ax
	call	[RealModeInt10h]			  ;  and enter the mode using int 10h
	xor	eax,eax 				  ;
	call	[SetCursorPos]				  ;
	mov	esi,msg3				  ;
	call	[PrintString_0] 			  ;
	call	[WaitForKeyPress]			  ;
	ret						  ;
;=======================================================  ;
; Display Vesa Error message.                             ;
;=======================================================  ; 
ImageError:						  ;
	mov	ax,03h					  ;  move the number of the mode to ax
	call	[RealModeInt10h]			  ;  and enter the mode using int 10h
	xor	eax,eax 				  ;
	call	[SetCursorPos]				  ;
	mov	esi,msg4				  ;
	call	[PrintString_0] 			  ;
	call	[WaitForKeyPress]			  ;
	ret						  ;
							  ;
align 4 						  ;
;=======================================================  ;
; PutgIF                    ;put a GIF pic on screen      ;
;=======================================================  ;
PutGif: 						  ;
	call  PutBmp32					  ;
	ret						  ;
							  ;
;=======================================================  ;
; BackGroundImage                                         ;
;=======================================================  ;
BackGroundImage:					  ;
	pushad						  ;
	push	dword[TranspColor]			  ;
	mov	eax,edi 				  ;
	shl	eax,5					  ;
	add	eax,[GifListAddress]			  ;
	mov	edi,[eax]				  ;
	mov	[headerTEST],edi			  ;
	xor	ebx,ebx 				  ;
	mov	bx,word[eax+8]				  ;
	mov	[VesaStartX],ebx			  ;
	mov	bx,word[eax+16] 			  ;
	mov	[VesaStartY],ebx			  ;
	mov	bx,word[eax+12] 			  ;
	mov	word[ImageX],bx 			  ;
	mov	bx,word[eax+14] 			  ;
	mov	word[ImageY],bx 			  ;
	mov	[TranspYesNo],0 			  ;
	mov	bl,byte[eax+22] 			  ;
	cmp	bl,1					  ;
	jne	TranspNO_BG				  ;
	mov	[TranspYesNo],1 			  ;
	pushad						  ;
	mov	esi,file_area				  ;
	xor	ecx,ecx 				  ;
	mov	cl,byte[eax+23] 			  ;
	mov	ebx,ecx 				  ;
	mov	esi,dword[globalColor]			  ;
	shl	ecx,2					  ;
	sub	ecx,ebx 				  ;
	add	esi,ecx 				  ;
	lodsd						  ;
	shl	eax,8					  ;
	mov	ebx,eax 				  ;
	call	Mirror_ebx				  ;
	mov	dword[TranspColor],ebx			  ;
	popad						  ;
TranspNO_BG:						  ;
	call	GetVesaScreenPointer			  ;
	mov	[BufferPointer],edi			  ;
	call	PutGif					  ;
	pop	dword[TranspColor]			  ;
	popad						  ;
	ret						  ;
							  ;
;=======================================================  ;
; RestoreBackGround                                       ;
;=======================================================  ;
RestoreBackGround:					  ;
	 pushad 					  ;
	 push	 es					  ;
	 mov	 esi,header				  ;
	 lodsd						  ;
	 mov	 word[ImageXX],ax			  ;
	 mov	 ax,[ModeInfo_XResolution]		  ;
	 sub	 ax,word[ImageXX]			  ;
	 shl	 eax,2					  ;
	 mov	 dword[ImageXaddOn],eax 		  ;
	 mov	 esi,header				  ;
	 add	 esi,4					  ;
	 lodsd						  ;
	 mov	 word[ImageYY],ax			  ;
	 mov	 edi,[BufferPointer]			  ;
	 xor	 ecx,ecx				  ;
	 mov	 cx,word[ImageYY]			  ;
	 mov	 eax,dword[BackGroundColor]		  ;
PutBGcolorLoop: 					  ;
	 push	 ecx					  ;
	 mov	 cx,word[ImageXX]			  ;
	 rep	 stosd					  ;
	 add	 edi,[ImageXaddOn]			  ;
	 pop	 ecx					  ;
	 loop	 PutBGcolorLoop 			  ;
	 pop	 es					  ;
	 popad						  ;
	 ret						  ;
align 4 						  ;
;=======================================================  ;
;  BackGround                                             ;
;=======================================================  ;
BackGround:						  ;
	 pushad 					  ;
	 push  es					  ;
	 mov   edi,VesaBuffer				  ;
	 xor   eax,eax					  ;
	 mov   ecx,eax					  ;
	 mov   ax,[ModeInfo_XResolution]		  ;
	 mov   cx,[ModeInfo_YResolution]		  ;
	 mul   ecx					  ;
	 mov   ecx,eax					  ;
	 mov   eax,0x00ffffff				  ;
	 cld						  ;
	 cli						  ;
	 rep   stosd					  ;
	 sti						  ;
	 pop   es					  ;
	 popad						  ;
	 ret						  ;
align 4
;=======================================================  ;
; PutBmp32                                                ;
;=======================================================  ;
PutBmp32:						  ;
	 pushad 					  ;
	 push	 es					  ;
	 mov	 esi,header				  ;
	 lodsd						  ;
	 mov	 ax,[ModeInfo_XResolution]		  ;
	 sub	 ax,word[ImageX]			  ;
	 shl	 eax,2					  ;
	 mov	 dword[ImageXaddOn],eax 		  ;
	 mov	 esi,header				  ;
	 add	 esi,4					  ;
	 lodsd						  ;
	 mov	 ax,[ModeInfo_YResolution]		  ;
	 sub	 ax,word[ImageY]			  ;
	 mov	 dword[ImageYaddOn],eax 		  ;
	 mov	 esi,[headerTEST]			  ;
	 add	 esi,[HeaderAddOn]			  ;
	 mov	 edi,[BufferPointer]			  ;
	 xor	 ecx,ecx				  ;
	 mov	 cx,word[ImageY]			  ;
PutImageLoop1:						  ;
	 push	 ecx					  ;
	 mov	 cx,word[ImageX]			  ;
@@:							  ;
	 lodsd						  ;
	 dec	 esi					  ;
	 and	 eax,0x00ffffff 			  ;
	 cmp	 [TranspYesNo],0			  ;
	 je	 NotBGcolor				  ;
	 cmp	 eax,dword[TranspColor] 		  ;
	 jne	 NotBGcolor				  ;
	 inc	 edi					  ;
	 inc	 edi					  ;
	 inc	 edi					  ;
	 inc	 edi					  ;
	 jmp	 BGcolor				  ;
NotBGcolor:						  ;
	 stosd						  ;
BGcolor:						  ;
	 loop	 @b					  ;
	 add	 edi,[ImageXaddOn]			  ;
	 pop	 ecx					  ;
	 loop	 PutImageLoop1				  ;
	 mov	 [s_var],1				  ;
	 pop	 es					  ;
	 popad						  ;
	 ret						  ;
align 4 						  ;
;=======================================================  ;
; PutBmp24.                                               ;
;=======================================================  ;
PutBmp24:						  ;
	 pushad 					  ;
	 push	 es					  ;
	 mov	 edi,VesaBuffer 			  ;
	 xor	 eax,eax				  ;
	 mov	 ecx,eax				  ;
	 mov	 ax,[ModeInfo_XResolution]		  ;
	 mov	 cx,[ModeInfo_YResolution]		  ;
	 mul	 ecx					  ;
	 mov	 ecx,eax				  ;
	 mov	 eax,0xffffffff 			  ;
	 cld						  ;
@@:							  ;
	 stosd						  ;
	 dec	 edi					  ;
	 loop	 @b					  ;
	 mov	 esi,header				  ;
	 lodsd						  ;
	 mov	 word[ImageX],ax			  ;
	 mov	 ax,[ModeInfo_XResolution]		  ;
	 sub	 ax,word[ImageX]			  ;
	 mov	 dword[ImageXaddOn24],eax		  ;
	 shl	 eax,2					  ;
	 sub	 eax,dword[ImageXaddOn24]		  ;
	 mov	 dword[ImageXaddOn],eax 		  ;
	 mov	 esi,header				  ;
	 add	 esi,4					  ;
	 lodsd						  ;
	 mov	 word[ImageY],ax			  ;
	 mov	 ax,[ModeInfo_YResolution]		  ;
	 sub	 ax,word[ImageY]			  ;
	 mov	 dword[ImageYaddOn],eax 		  ;
	 mov	 esi,header+8				  ;
	 mov	 edi,VesaBuffer 			  ;
	 xor	 ecx,ecx				  ;
	 mov	 cx,word[ImageY]			  ;
PutImageLoop2:						  ;
	 push	 ecx					  ;
	 mov	 cx,word[ImageX]			  ;
@@:							  ;
	 lodsd						  ;
	 dec	 esi					  ;
	 stosd						  ;
	 dec	 edi					  ;
	 loop	 @b					  ;
	 add	 edi,[ImageXaddOn]			  ;
	 pop	 ecx					  ;
	 loop	 PutImageLoop2				  ;
	 pop	 es					  ;
	 popad						  ;
	 ret						  ;
align 4 						  ;
;=======================================================  ;
; get_params.                                             ;
;=======================================================  ;
get_params:						  ;
	mov	esi,[command_line]			  ;
	mov	edi,FileToLoad				  ;
	lodsb						  ;
	cmp	al,' '					  ;
	jne	bad_params				  ;
	lodsb						  ;
	cmp	al,0x1f 				  ;
	jbe	bad_params				  ;
	cmp	al,0x80 				  ;
	jae	bad_params				  ;
	cmp	al,' '					  ;
	je	bad_params				  ;
	stosb						  ;
	mov	ecx,7					  ;
Cliloop:						  ;
	lodsb						  ;
	cmp	al,'.'					  ;
	je	DoExt1					  ;
	stosb						  ;
	loop	Cliloop 				  ;
	lodsb						  ;
	cmp	al,'.'					  ;
	jne	bad_params				  ;
DoExt1: 						  ;
	stosb						  ;
	mov	cx,3					  ;
	rep	movsb					  ;
	mov	al,0					  ;
	stosb						  ;
	mov	ax,word[es:edi-4]			  ;
	cmp	ax,'bm' 				  ;
	je	get_params_ok				  ;
	cmp	ax,'BM' 				  ;
	je	get_params_ok				  ;
	cmp	ax,'GI' 				  ;
	je	get_params_ok				  ;
	cmp	ax,'gi' 				  ;
	jne	bad_params				  ;
;=======================================================  ;
; get_params_ok                                           ;
;=======================================================  ; 
get_params_ok:						  ;
	clc						  ;
	ret						  ;
;=======================================================  ;
; bad_params.                                             ;
;=======================================================  ; 
bad_params:						  ;
	stc						  ;
	ret						  ;
align 4 						  ;
;=======================================================  ;
;  BuffToScreen.  ;Puts whats in the buffer to screen     ;
;=======================================================  ;
BuffToScreen:						  ;
	cmp	[ModeInfo_BitsPerPixel],24		  ;
	jne	Try32					  ;
	call	BuffToScreen24				  ;
	jmp	wehavedone24				  ;
Try32:							  ;
	cmp	[ModeInfo_BitsPerPixel],32		  ;
	jne	wehavedone24				  ;
	call	BuffToScreen32				  ;
wehavedone24:						  ;
	 ret						  ;
align 4 						  ;
;=======================================================  ;
; BuffToScreen32                                          ;
;=======================================================  ;
BuffToScreen32: 					  ;
	 pushad 					  ;
	 push	 es					  ;
	 mov	 ax,8h					  ;
	 mov	 es,ax					  ;
	 mov	 edi,[ModeInfo_PhysBasePtr]		  ;
	 mov	 esi,VesaBuffer 			  ;
	 xor	 eax,eax				  ;
	 mov	 ecx,eax				  ;
	 mov	 ax,[ModeInfo_XResolution]		  ;
	 mov	 cx,[ModeInfo_YResolution]		  ;
	 mul	 ecx					  ;
	 mov	 ecx,eax				  ;
	 cld						  ;
	 cli						  ;
	 rep	 movsd					  ;
	 sti						  ;
	 pop	 es					  ;
	 popad						  ;
	 ret						  ;
							  ;
;=======================================================  ;
;  BuffToScreen24                                         ;
;=======================================================  ;
BuffToScreen24: 					  ;
	 pushad 					  ;
	 push	 es					  ;
	 mov	 ax,8h					  ;
	 mov	 es,ax					  ;
	 xor	 eax,eax				  ;
	 mov	 ecx,eax				  ;
	 mov	 ax,[ModeInfo_YResolution]		  ;
	 mov	 ebp,eax				  ;
	 lea	 eax,[ebp*2+ebp]			  ;
	 mov	 edi,[ModeInfo_PhysBasePtr]		  ;
	 mov	 esi,VesaBuffer 			  ; ScreenBuffer
	 cld						  ;
.l1:							  ;
	 mov	 cx,[ModeInfo_XResolution]		  ;
	 shr	 ecx,2					  ;
.l2:							  ;
	 mov	 eax,[esi]				  ; eax = -- R1 G1 B1
	 mov	 ebx,[esi+4]				  ; ebx = -- R2 G2 B2
	 shl	 eax,8					  ; eax = R1 G1 B1 --
	 shrd	 eax,ebx,8				  ; eax = B2 R1 G1 B1
	 stosd						  ;
							  ;
	 mov	 ax,[esi+8]				  ; eax = -- -- G3 B3
	 shr	 ebx,8					  ; ebx = -- -- R2 G2
	 shl	 eax,16 				  ; eax = G3 B3 -- --
	 or	 eax,ebx				  ; eax = G3 B3 R2 G2
	 stosd						  ;
							  ;
	 mov	 bl,[esi+10]				  ; ebx = -- -- -- R3
	 mov	 eax,[esi+12]				  ; eax = -- R4 G4 B4
	 shl	 eax,8					  ; eax = R4 G4 B4 --
	 mov	 al,bl					  ; eax = R4 G4 B4 R3
	 stosd						  ;
							  ;
	 add	 esi,16 				  ;
	 loop	 .l2					  ;
							  ;
	 sub	 ebp,1					  ;
	 ja	 .l1					  ;
							  ;
	 pop	 es					  ;
	 popad						  ;
	 ret						  ;
align 4 						  ;
;=======================================================  ;
; Mirror ebx                                              ;
;=======================================================  ;   
Mirror_ebx:						  ;
	push  edi					  ;
	push  es					  ;
	mov   ax,18h					  ;
	mov   es,ax					  ;
	mov   edi,Ebx_buffer				  ;
	mov   byte[es:edi+3],bl 			  ;
	shr   ebx,8					  ;
	mov   byte[es:edi+2],bl 			  ;
	shr   ebx,8					  ;
	mov   byte[es:edi+1],bl 			  ;
	shr   ebx,8					  ;
	mov   byte[es:edi+0],bl 			  ;
	mov   ebx,dword[Ebx_buffer]			  ;
	pop   es					  ;
	pop   edi					  ;
	ret						  ;
align 4 						  ;
;=======================================================  ;
; inc_vesa_screen_pointer.                                ;
;=======================================================  ; 
GetVesaScreenPointer:					  ;
	push	eax					  ;
	push	ebx					  ;
	mov	edi,VesaBuffer				  ;
	xor	ebx,ebx 				  ;
	mov	ebx,[VesaStartX]			  ;
	shl	ebx,2					  ;
@@:							  ;
	add	edi, ebx				  ;
	mov	ebx,[VesaStartY]			  ;
	xor	eax,eax 				  ;
	mov	ax,[ModeInfo_XResolution]		  ;
	shl	eax,2					  ;
@@:							  ;
	mul	ebx					  ;
	add	edi,eax 				  ;
	pop	ebx					  ;
	pop	eax					  ;
	ret						  ;
align 4 						  ;
;=======================================================  ;
; SetTimeBack2Default.                                    ;
;=======================================================  ; 
SetTimeBack2Default:					  ;
	push	ecx					  ;
	mov	ecx,0					  ;
	call	[InterruptTimer]			  ;
	pop	ecx					  ;
	ret						  ;
							  ;
;=======================================================  ;
; data.                                                   ;
;=======================================================  ; 
msg1: db " Vesa mode not supported",13,10		  ;
      db " Press any key to exit. ",13,10,0		  ;
							  ;
msg2: db " Error!, file not found. ",13,10		  ;
      db " Press any key to exit. ",13,10,0		  ;
							  ;
msg3: db " Error!, No comandline, GIF file found. ",13,10 ;
      db " Press any key to exit. ",13,10,0		  ;
							  ;
msg4: db " Error!, Not a valid or GIF file. ",13,10	  ;
      db " Press any key to exit. ",13,10,0		  ;
;=======================================================  ;
; Vars.                                                   ;
;=======================================================  ;
s_var		       db 0				  ;
ImageXX 	       dw 0				  ;
ImageYY 	       dw 0				  ;
align 4 						  ;
Ebx_buffer	       dd 0				  ;
rd 100							  ;
BufferPointer	       dd 0				  ;
VesaStartX	       dd 0				  ;
VesaStartY	       dd 0				  ;
Ytop		       dw 0				  ;
Xleft		       dw 0				  ;
testhex 	       dd 0				  ;
headerTEST	       dd 0				  ;
countInECX	       dd 0				  ;
hexnumber	       db 0				  ;
img_count333	       db 0				  ;
GifListAddress	       dd 0				  ;
GifListAddressNEW      dd 0				  ;
countIMAGES	       dd 0				  ;
ImageAddress	       dd 0				  ;
align 4 						  ;
ImageX		       dw 0				  ;
ImageY		       dw 0				  ;
ImageXaddOn	       dd 0				  ;
ImageYaddOn	       dd 0				  ;
ImageXaddOn24	       dd 0				  ;
MenuList	       dd 0				  ;
HeaderAddOn	       dd 0				  ;
CoverUpColor	       dd 0				  ;
MenuListCount	       dd 0				  ;
command_line	       dd 0				  ;
BackGroundColor        dd 0				  ;
TranspColor	       dd 0				  ;
TranspYesNo	       db 0				  ;
FileToLoad:	       rb 80				  ;
align 4 						  ;
file_area:						  ;
file  'Test.gif'					  ;
kkk		       rd 10000 			  ;
IM_END: 						  ;
align 4 						  ;
header: 	       rd 800*600			  ;
align 4 						  ;
gif_hash_offset:       rd 4096+1			  ; hash area size for unpacking
include 'Dex.inc'					  ; Here is where we includ our "Dex.inc" file
align 4 						  ;
GifList:	       rd 1000* 20			  ;
align 4 						  ;
VesaBuffer:						  ;