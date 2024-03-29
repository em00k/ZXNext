' Quick Sprite Example
' NextBuild (ZXB/CSpect)
' emook2018 - use keys 1 and 2 to mess with the sine wav (dirty!)

paper 0: border 0 : bright 0: ink 7 : cls 

dim frame,mx,my,yy,xx as ubyte 
dim offset as fixed 
DIM add as fixed=2.799
 
poke 23607,60					' for cspect to set the font correctly

#DEFINE NextReg(REG,VAL)\
	ASM\
	DW $91ED\
	DB REG\
	DB VAL\
	END ASM 

#DEFINE OUTINB\
	Dw $ED90

'Initalize the sprite to sprite ram

InitSprites()

' http://devnext.referata.com/wiki/Board_feature_control
NextReg($14,$e3)  					' glbal transparency 
NextReg($40,$18)    				' $40 Palette Index Register  I assume that colours 0-7 ink 8-15 bright ink 16+ paper etc? 	' 24 = paper bright 0 
NextReg($41,$e3)  					' $41
NextReg($7,$1)  					' go 7mhz 

' Bit	Function
' 7	Enable Lores Layer
' 6-5	Reserved
' 3-4	If %00, ULA is drawn under Layer 2 and Sprites; if %01, it is drawn between them, if %10 it is drawn over both
' 2	If 1, Layer 2 is drawn over Sprites, else sprites drawn over layer 2
' 1	Enable sprites over border
' 0	Enable sprite visibility

NextReg($15,%00001001)  	

' to draw a sprite on screen
' UpdateSprite(x AS UBYTE,y AS UBYTE, spriteid AS UBYTE, pattern AS UBYTE, mflip as ubyte)

mx = 64
my = 80
id = 0 
offset=0

' lets do a loop and move some stuff around 

do

	for id = 0 to 10
		yy=peek(@sinpos+cast(uinteger,offset))<<1
		xx=peek(@sinposb+cast(uinteger,offset))<<1
		UpdateSprite(mx+xx,my+yy,id,frame,0)
		if mx <64+16*10 : mx=mx+16 : else : mx=64 : endif 
		if offset+add<63 : offset=offset+add : else : offset=0 : endif 
		
	next id 
	for id = 11 to 21
		yy=peek(@sinpos+cast(uinteger,offset))<<1
		xx=peek(@sinposb+cast(uinteger,offset))<<1
		UpdateSprite(mx+xx,my+yy,id,frame,0)
		if mx <64+16*10 : mx=mx+16 : else : mx=64 : endif 
		if offset+add<63 : offset=offset+add : else : offset=0 : endif 
		
	next id 
	if frame<15 : frame=frame+1 : else : frame=0 : endif 

	pause 2

	if inkey="2"
		add=add+0.1
		print at 0,0;add;"  "
		pause 10
	endif 
	if inkey="1"
		add=add-0.1
		print at 0,0;add;"  "
		pause 10
	endif 
loop

sinpos:
	asm
		db 8,7,6,5,4,4,3,2,2,1,1,0,0,0,0,0
		db 0,0,0,0,0,1,1,2,2,3,3,4,5,6,6,7
		db 8,9,9,10,11,12,12,13,13,14,14,15,15,15,15,15
		db 15,15,15,15,15,14,14,13,13,12,11,11,10,9,8,8
	end asm
	
sinposb:
	asm
		db 0,0,0,1,1,1,1,1,1,2,2,2,3,3,3,4
		db 4,4,5,5,5,6,6,6,7,7,7,7,7,7,8,8
		db 8,8,7,7,7,7,7,7,6,6,6,5,5,5,4,4
		db 4,3,3,3,2,2,2,1,1,1,1,1,1,0,0,0
	end asm

Sub InitSprites()
		' REM Mac ball sprite 16x16px * 16 frames
	ASM 

		;Select slot #0
		ld a, 0
		ld bc, $303b
		out (c), a

		ld b,16								; we set up a loop for 16 sprites 		
		ld hl,Ball1				  			; point to Ball1 data
sploop:
		push bc
		ld bc,$005b					
		otir
		pop bc 
		djnz sploop
		jp sprexit

Ball1:
		db  $E3, $E3, $E3, $E3, $E3, $F5, $F5, $F4, $F4, $F5, $F5, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $FA, $F4, $F4, $F4, $F4, $F4, $F4, $F0, $ED, $F6, $E3, $E3, $E3;
		db  $E3, $E3, $F9, $F8, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $ED, $E9, $F2, $E3, $E3;
		db  $E3, $FA, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $F4, $EC, $E9, $E9, $F6, $E3;
		db  $E3, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $ED, $E9, $E9, $ED, $E3;
		db  $F9, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F0, $ED, $E9, $E9, $E9, $F2;
		db  $F9, $F8, $F8, $D8, $B8, $B8, $D8, $F8, $F4, $F0, $ED, $E9, $E9, $E9, $E9, $ED;
		db  $F8, $D8, $98, $78, $58, $78, $78, $B4, $F0, $ED, $E9, $E9, $E9, $E9, $E9, $CE;
		db  $D8, $98, $58, $58, $59, $58, $55, $52, $CE, $E9, $E9, $E9, $E9, $E9, $CE, $AE;
		db  $B9, $58, $59, $58, $58, $55, $37, $53, $AF, $CE, $CE, $CE, $CE, $AE, $AE, $AF;
		db  $99, $58, $58, $58, $59, $36, $33, $33, $AF, $AE, $AE, $AE, $AE, $AE, $AE, $D3;
		db  $E3, $79, $58, $58, $55, $37, $33, $37, $6F, $AE, $AE, $AE, $AE, $AE, $AE, $E3;
		db  $E3, $9A, $58, $58, $55, $37, $33, $33, $33, $8F, $AF, $AE, $AE, $AE, $D7, $E3;
		db  $E3, $E3, $99, $58, $55, $37, $33, $33, $33, $37, $53, $8F, $8F, $B3, $E3, $E3;
		db  $E3, $E3, $E3, $99, $79, $36, $33, $33, $33, $33, $33, $37, $77, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $7A, $37, $33, $33, $37, $77, $E3, $E3, $E3, $E3, $E3;



Ball2:
		db  $E3, $E3, $E3, $E3, $E3, $F8, $F5, $F4, $F4, $F5, $F5, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $FA, $F8, $F8, $F8, $F4, $F4, $F4, $F0, $F4, $F4, $E3, $E3, $E3;
		db  $E3, $E3, $F9, $F8, $F4, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $F4, $F2, $E3, $E3;
		db  $E3, $FA, $F8, $F8, $F8, $F8, $F4, $F8, $F8, $F4, $F4, $F4, $F4, $E9, $F6, $E3;
		db  $E3, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $E9, $ED, $E3;
		db  $F9, $F8, $78, $78, $79, $78, $F8, $F8, $F8, $F4, $F0, $F4, $F4, $E9, $E9, $F2;
		db  $79, $58, $58, $59, $58, $58, $78, $F8, $F8, $F0, $F4, $F4, $E9, $E9, $E9, $ED;
		db  $79, $58, $98, $78, $58, $59, $78, $75, $F0, $F4, $F4, $E9, $E9, $E9, $E9, $ED;
		db  $79, $98, $58, $58, $59, $36, $37, $72, $CE, $E9, $E9, $E9, $E9, $E9, $E9, $ED;
		db  $B9, $58, $58, $58, $37, $33, $37, $AF, $AE, $E9, $E9, $E9, $E9, $E9, $E9, $E9;
		db  $99, $58, $59, $37, $37, $36, $33, $AF, $AF, $AE, $E9, $E9, $E9, $E9, $E9, $D3;
		db  $E3, $79, $58, $37, $33, $37, $33, $AE, $AE, $AE, $AE, $AE, $AE, $AE, $AE, $E3;
		db  $E3, $9A, $58, $37, $33, $37, $33, $AE, $AE, $8F, $AE, $AE, $AE, $AE, $D7, $E3;
		db  $E3, $E3, $99, $37, $33, $37, $33, $37, $AE, $AE, $AE, $8F, $8F, $B3, $E3, $E3;
		db  $E3, $E3, $E3, $37, $37, $36, $33, $33, $33, $AF, $AE, $AE, $AE, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $37, $37, $33, $37, $37, $AF, $E3, $E3, $E3, $E3, $E3;



Ball3:
		db  $E3, $E3, $E3, $E3, $E3, $F8, $F8, $F8, $F8, $F5, $F5, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $FA, $F8, $F8, $F8, $F8, $F8, $F8, $F0, $F4, $F4, $E3, $E3, $E3;
		db  $E3, $E3, $F9, $F8, $F4, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F2, $E3, $E3;
		db  $E3, $FA, $79, $58, $79, $F8, $F4, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $E3;
		db  $E3, $79, $58, $58, $58, $59, $79, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $E3;
		db  $79, $59, $78, $79, $78, $58, $58, $F8, $F8, $F8, $F0, $F4, $F4, $F4, $F4, $F2;
		db  $79, $58, $58, $58, $58, $58, $78, $58, $F8, $F8, $F4, $F4, $F4, $F4, $F4, $ED;
		db  $79, $58, $98, $78, $37, $37, $36, $55, $D4, $F4, $F4, $F4, $F4, $F4, $E9, $ED;
		db  $79, $98, $58, $37, $37, $33, $37, $8E, $CE, $E9, $F4, $F4, $E9, $E9, $E9, $ED;
		db  $B9, $58, $37, $33, $37, $33, $AE, $AF, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $E9;
		db  $99, $37, $33, $33, $37, $36, $AE, $AF, $AF, $E9, $E9, $E9, $E9, $E9, $E9, $D3;
		db  $E3, $37, $33, $33, $33, $37, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $E9, $E9, $E3;
		db  $E3, $37, $37, $37, $33, $AF, $AE, $AE, $AE, $8F, $E9, $E9, $E9, $E9, $ED, $E3;
		db  $E3, $E3, $37, $37, $33, $37, $AE, $AE, $AE, $AE, $AE, $8F, $8F, $B3, $E3, $E3;
		db  $E3, $E3, $E3, $37, $37, $36, $AE, $AE, $AE, $AE, $AE, $AE, $AE, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $37, $37, $AE, $AE, $AE, $AF, $E3, $E3, $E3, $E3, $E3;



Ball4:
		db  $E3, $E3, $E3, $E3, $E3, $F8, $F8, $F8, $F8, $F8, $F8, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $79, $79, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $E3, $E3, $E3;
		db  $E3, $E3, $79, $59, $58, $58, $79, $F8, $F8, $F8, $F8, $F8, $F4, $F2, $E3, $E3;
		db  $E3, $FA, $79, $58, $79, $58, $58, $78, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $E3;
		db  $E3, $79, $58, $59, $58, $59, $59, $78, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $E3;
		db  $79, $59, $78, $78, $78, $58, $58, $58, $79, $F8, $F8, $F8, $F4, $F4, $F4, $F2;
		db  $79, $58, $37, $37, $37, $37, $36, $58, $79, $F8, $F8, $F4, $F4, $F4, $F4, $F4;
		db  $79, $37, $33, $33, $33, $37, $33, $56, $B4, $F8, $F4, $F4, $F4, $F4, $F4, $F4;
		db  $37, $33, $33, $37, $33, $33, $AF, $8E, $CE, $E9, $F4, $F4, $F4, $F4, $F4, $F4;
		db  $37, $33, $37, $33, $37, $AE, $AF, $AF, $E9, $E9, $F4, $F4, $F4, $F4, $E9, $ED;
		db  $37, $37, $33, $33, $AE, $AE, $AE, $ED, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $D3;
		db  $E3, $37, $33, $37, $AE, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $E3;
		db  $E3, $37, $33, $33, $AE, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $E9, $E9, $ED, $E3;
		db  $E3, $E3, $37, $37, $AE, $AE, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $ED, $E3, $E3;
		db  $E3, $E3, $E3, $37, $AE, $AE, $AE, $AE, $AE, $AE, $E9, $E9, $ED, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $AE, $AE, $AE, $AE, $AE, $AF, $E3, $E3, $E3, $E3, $E3;



Ball5:
		db  $E3, $E3, $E3, $E3, $E3, $79, $79, $79, $F8, $F8, $F8, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $79, $79, $59, $58, $58, $78, $F8, $F8, $F8, $F4, $E3, $E3, $E3;
		db  $E3, $E3, $79, $59, $58, $58, $79, $58, $58, $F8, $F8, $F8, $F8, $F8, $E3, $E3;
		db  $E3, $FA, $79, $58, $79, $58, $58, $79, $58, $79, $F8, $F8, $F8, $F8, $F4, $E3;
		db  $E3, $79, $37, $37, $37, $59, $59, $78, $59, $78, $F8, $F8, $F8, $F8, $F4, $E3;
		db  $37, $37, $33, $37, $33, $33, $37, $58, $58, $79, $F8, $F8, $F8, $F8, $F4, $F2;
		db  $37, $33, $33, $37, $33, $37, $37, $36, $78, $F8, $F8, $F8, $F8, $F4, $F4, $F4;
		db  $37, $37, $33, $33, $33, $37, $33, $52, $95, $F8, $F8, $F8, $F4, $F4, $F4, $F4;
		db  $37, $33, $33, $37, $AF, $AE, $AF, $8E, $F4, $E9, $F4, $F4, $F4, $F4, $F4, $F4;
		db  $37, $33, $33, $AE, $AE, $AE, $AF, $AF, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4;
		db  $37, $37, $AF, $AE, $AE, $AE, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4;
		db  $E3, $37, $AE, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $E3;
		db  $E3, $37, $AF, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $ED, $E3;
		db  $E3, $E3, $AE, $AE, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $E9, $E9, $ED, $E3, $E3;
		db  $E3, $E3, $E3, $AE, $AF, $AE, $AF, $E9, $E9, $E9, $E9, $E9, $ED, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $AE, $AE, $AE, $E9, $ED, $ED, $E3, $E3, $E3, $E3, $E3;



Ball6:
		db  $E3, $E3, $E3, $E3, $E3, $79, $79, $79, $79, $79, $F8, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $79, $79, $59, $58, $58, $58, $58, $79, $F8, $F4, $E3, $E3, $E3;
		db  $E3, $E3, $37, $37, $37, $58, $79, $58, $58, $58, $58, $F8, $F8, $F8, $E3, $E3;
		db  $E3, $37, $33, $37, $33, $37, $37, $79, $58, $58, $58, $F8, $F8, $F8, $F4, $E3;
		db  $E3, $37, $33, $37, $33, $33, $33, $78, $58, $79, $58, $F8, $F8, $F8, $F8, $E3;
		db  $37, $37, $33, $33, $33, $33, $33, $37, $58, $79, $78, $F8, $F8, $F8, $F8, $F8;
		db  $37, $33, $33, $33, $37, $37, $37, $33, $59, $58, $79, $F8, $F8, $F8, $F8, $F8;
		db  $37, $37, $AF, $AE, $AE, $AF, $AF, $72, $75, $F8, $F8, $F8, $F8, $F8, $F8, $F4;
		db  $37, $AF, $AE, $AE, $AF, $AE, $AF, $8E, $D4, $F8, $F8, $F8, $F8, $F8, $F4, $F4;
		db  $AF, $AE, $AE, $AE, $AE, $AE, $E9, $AF, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4;
		db  $AE, $AE, $AE, $AE, $AE, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4;
		db  $E3, $AE, $AE, $AE, $AE, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E3;
		db  $E3, $37, $AE, $AE, $ED, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $E3;
		db  $E3, $E3, $AE, $AE, $AE, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $E3, $E3;
		db  $E3, $E3, $E3, $AE, $AF, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $ED, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $ED, $ED, $E9, $E9, $ED, $ED, $E3, $E3, $E3, $E3, $E3;



Ball7:
		db  $E3, $E3, $E3, $E3, $E3, $79, $79, $79, $79, $79, $F8, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $37, $37, $33, $37, $58, $58, $58, $79, $79, $79, $E3, $E3, $E3;
		db  $E3, $E3, $37, $37, $33, $33, $33, $37, $58, $58, $58, $58, $79, $F8, $E3, $E3;
		db  $E3, $37, $33, $33, $33, $37, $33, $33, $37, $58, $58, $58, $58, $F8, $F4, $E3;
		db  $E3, $37, $33, $37, $33, $33, $33, $33, $37, $79, $59, $58, $58, $F8, $F8, $E3;
		db  $37, $37, $AE, $AE, $AE, $AF, $33, $37, $37, $79, $78, $59, $78, $F8, $F8, $F8;
		db  $AF, $AE, $AE, $AE, $AE, $AE, $AF, $37, $37, $58, $58, $58, $F8, $F8, $F8, $F8;
		db  $AE, $AE, $AE, $AE, $AE, $AE, $AF, $AE, $56, $78, $78, $F8, $F8, $F8, $F8, $F8;
		db  $AE, $AF, $AE, $AE, $AF, $E9, $E9, $8E, $D4, $F8, $F8, $F8, $F8, $F8, $F8, $F8;
		db  $AF, $AE, $AE, $AE, $E9, $E9, $E9, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8;
		db  $AE, $AE, $AE, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F4;
		db  $E3, $AE, $AE, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E3;
		db  $E3, $37, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E3;
		db  $E3, $E3, $AE, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $E3, $E3;
		db  $E3, $E3, $E3, $ED, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $ED, $ED, $E9, $E9, $ED, $F4, $E3, $E3, $E3, $E3, $E3;



Ball8:
		db  $E3, $E3, $E3, $E3, $E3, $79, $37, $37, $37, $79, $F8, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $37, $37, $33, $37, $33, $33, $37, $79, $79, $79, $E3, $E3, $E3;
		db  $E3, $E3, $37, $37, $33, $33, $33, $37, $33, $37, $58, $58, $79, $F8, $E3, $E3;
		db  $E3, $37, $AF, $AF, $AF, $37, $33, $33, $33, $33, $58, $58, $58, $59, $79, $E3;
		db  $E3, $AE, $AE, $AE, $AE, $AE, $AF, $33, $37, $33, $78, $58, $58, $58, $79, $E3;
		db  $AE, $AE, $AE, $AE, $AE, $AE, $AE, $37, $37, $33, $78, $59, $79, $58, $79, $F8;
		db  $AF, $AE, $AE, $AE, $AE, $AE, $AF, $AE, $37, $37, $58, $58, $58, $59, $F8, $F8;
		db  $AE, $AE, $AF, $AE, $E9, $E9, $AF, $AE, $56, $79, $78, $58, $58, $78, $F8, $F8;
		db  $AE, $AF, $E9, $E9, $E9, $E9, $E9, $8E, $B5, $78, $78, $79, $F8, $F8, $F8, $F8;
		db  $AF, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8;
		db  $AE, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8;
		db  $E3, $E9, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $E3;
		db  $E3, $ED, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $E3;
		db  $E3, $E3, $AE, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E3, $E3;
		db  $E3, $E3, $E3, $ED, $E9, $E9, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $ED, $ED, $F4, $F4, $F4, $F4, $E3, $E3, $E3, $E3, $E3;



Ball9:
		db  $E3, $E3, $E3, $E3, $E3, $79, $37, $37, $37, $37, $37, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $AF, $AF, $33, $37, $33, $33, $33, $33, $37, $79, $E3, $E3, $E3;
		db  $E3, $E3, $AE, $AE, $AE, $AE, $AE, $37, $33, $37, $33, $33, $78, $F8, $E3, $E3;
		db  $E3, $37, $AF, $AF, $AF, $AE, $AE, $AF, $33, $33, $33, $37, $58, $59, $79, $E3;
		db  $E3, $AE, $AE, $AE, $AE, $AE, $AE, $AE, $37, $33, $33, $37, $59, $58, $79, $E3;
		db  $AE, $AE, $AF, $AE, $AE, $AE, $AE, $AE, $AF, $37, $33, $37, $78, $58, $79, $79;
		db  $AF, $AE, $E9, $E9, $E9, $E9, $AF, $AF, $37, $37, $33, $78, $59, $59, $58, $79;
		db  $ED, $E9, $E9, $E9, $E9, $E9, $AF, $AE, $72, $37, $78, $58, $58, $78, $58, $79;
		db  $E9, $E9, $E9, $E9, $E9, $E9, $E9, $F4, $75, $79, $78, $78, $58, $58, $78, $79;
		db  $ED, $E9, $E9, $E9, $E9, $F4, $F4, $F4, $F8, $78, $78, $78, $59, $79, $F8, $F8;
		db  $AE, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8;
		db  $E3, $E9, $E9, $E9, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $E3;
		db  $E3, $ED, $E9, $E9, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $E3;
		db  $E3, $E3, $AE, $E9, $F4, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $E3, $E3;
		db  $E3, $E3, $E3, $ED, $F4, $F4, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $F4, $F4, $F4, $F4, $F4, $F4, $E3, $E3, $E3, $E3, $E3;



Ball10:
		db  $E3, $E3, $E3, $E3, $E3, $AE, $AE, $AF, $37, $37, $37, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $AF, $AF, $AE, $AE, $AE, $AF, $33, $33, $37, $37, $E3, $E3, $E3;
		db  $E3, $E3, $AE, $AF, $AE, $AE, $AE, $AE, $AE, $37, $33, $37, $37, $37, $E3, $E3;
		db  $E3, $37, $AF, $AF, $AF, $AE, $AE, $AF, $AE, $AF, $33, $37, $33, $33, $79, $E3;
		db  $E3, $E9, $E9, $E9, $E9, $AE, $AF, $AE, $AE, $AE, $33, $37, $33, $37, $79, $E3;
		db  $ED, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $33, $37, $33, $37, $79, $79;
		db  $ED, $E9, $E9, $E9, $E9, $E9, $E9, $AF, $AE, $37, $37, $33, $37, $58, $58, $79;
		db  $ED, $E9, $E9, $E9, $E9, $E9, $AF, $AE, $8E, $37, $37, $37, $58, $79, $58, $79;
		db  $E9, $E9, $E9, $E9, $F4, $F4, $F4, $D4, $75, $36, $79, $79, $58, $58, $78, $79;
		db  $ED, $E9, $E9, $F4, $F4, $F4, $F4, $F8, $78, $78, $58, $78, $59, $79, $58, $79;
		db  $AE, $E9, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $79, $78, $58, $58, $58, $59, $79;
		db  $E3, $E9, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $78, $78, $59, $78, $79, $E3;
		db  $E3, $ED, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $E3;
		db  $E3, $E3, $F4, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $E3, $E3;
		db  $E3, $E3, $E3, $ED, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $F4, $F4, $F4, $F8, $F8, $F8, $E3, $E3, $E3, $E3, $E3;



Ball11:
		db  $E3, $E3, $E3, $E3, $E3, $AE, $AE, $AF, $AE, $AE, $37, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $AF, $AF, $AE, $AE, $AE, $AF, $AE, $AF, $37, $37, $E3, $E3, $E3;
		db  $E3, $E3, $ED, $E9, $E9, $E9, $AE, $AE, $AE, $AE, $AE, $37, $33, $37, $E3, $E3;
		db  $E3, $ED, $E9, $E9, $E9, $E9, $E9, $AF, $AE, $AF, $AE, $33, $33, $37, $79, $E3;
		db  $E3, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $37, $33, $33, $37, $E3;
		db  $ED, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $AF, $AE, $37, $33, $37, $33, $37;
		db  $ED, $E9, $E9, $E9, $E9, $E9, $E9, $AF, $AF, $AF, $37, $37, $33, $33, $37, $79;
		db  $E9, $E9, $F4, $F4, $F4, $F4, $F4, $AE, $8E, $37, $37, $37, $33, $33, $37, $79;
		db  $ED, $F4, $F4, $F4, $F4, $F4, $F4, $D4, $56, $37, $37, $33, $37, $37, $59, $79;
		db  $F4, $F4, $F4, $F4, $F4, $F4, $F8, $F8, $59, $78, $59, $59, $79, $79, $58, $79;
		db  $F4, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $78, $78, $78, $58, $58, $58, $59, $79;
		db  $E3, $F4, $F4, $F4, $F4, $F8, $F8, $F8, $78, $58, $58, $79, $58, $78, $79, $E3;
		db  $E3, $ED, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $78, $59, $58, $58, $59, $79, $E3;
		db  $E3, $E3, $F4, $F4, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $78, $79, $79, $E3, $E3;
		db  $E3, $E3, $E3, $ED, $F4, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $F8, $F8, $F8, $F8, $F8, $F8, $E3, $E3, $E3, $E3, $E3;



Ball12:
		db  $E3, $E3, $E3, $E3, $E3, $ED, $AE, $AF, $AE, $AE, $37, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $AF, $ED, $E9, $E9, $E9, $AF, $AE, $AF, $AE, $AE, $E3, $E3, $E3;
		db  $E3, $E3, $ED, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $AE, $AE, $37, $E3, $E3;
		db  $E3, $ED, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $AE, $33, $79, $E3;
		db  $E3, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $AE, $37, $37, $E3;
		db  $ED, $E9, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $AE, $AF, $AE, $AF, $37, $33, $37;
		db  $F4, $F4, $F4, $F4, $F4, $F4, $F4, $AE, $E9, $AF, $AE, $AE, $37, $33, $33, $37;
		db  $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F0, $8E, $AE, $AE, $37, $33, $33, $37, $37;
		db  $F4, $F4, $F4, $F4, $F4, $F8, $F8, $B5, $52, $37, $37, $33, $37, $33, $33, $37;
		db  $F4, $F4, $F4, $F4, $F8, $F8, $F8, $78, $59, $37, $33, $33, $33, $33, $37, $36;
		db  $F4, $F4, $F4, $F8, $F8, $F8, $F8, $59, $78, $78, $37, $37, $37, $37, $59, $79;
		db  $E3, $F4, $F4, $F8, $F8, $F8, $F8, $78, $58, $58, $59, $79, $79, $79, $79, $E3;
		db  $E3, $ED, $F4, $F8, $F8, $F8, $F8, $78, $58, $79, $58, $58, $58, $58, $79, $E3;
		db  $E3, $E3, $F4, $F8, $F8, $F8, $F8, $F8, $58, $58, $58, $78, $58, $79, $E3, $E3;
		db  $E3, $E3, $E3, $F8, $F8, $F8, $F8, $F8, $F8, $58, $59, $79, $79, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $F8, $F8, $F8, $F8, $F8, $79, $E3, $E3, $E3, $E3, $E3;



Ball13:
		db  $E3, $E3, $E3, $E3, $E3, $ED, $ED, $ED, $E9, $AE, $37, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $AF, $ED, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $E3, $E3, $E3;
		db  $E3, $E3, $ED, $E9, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $37, $E3, $E3;
		db  $E3, $ED, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $AE, $E3;
		db  $E3, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $AE, $E3;
		db  $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $AE, $AE, $AF, $AE, $AF, $37;
		db  $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $AE, $AE, $AE, $AE, $37, $37;
		db  $F4, $F4, $F4, $F4, $F8, $F8, $F4, $F0, $8E, $AE, $AF, $AE, $AE, $AF, $37, $37;
		db  $F4, $F4, $F8, $F8, $F8, $F8, $F8, $75, $72, $AF, $AE, $AF, $37, $33, $37, $37;
		db  $F4, $F8, $F8, $F8, $F8, $F8, $78, $78, $37, $37, $33, $33, $33, $33, $33, $36;
		db  $F4, $F8, $F8, $F8, $F8, $F8, $78, $79, $36, $37, $33, $37, $37, $37, $33, $37;
		db  $E3, $F8, $F8, $F8, $F8, $78, $58, $59, $59, $37, $37, $33, $33, $33, $37, $E3;
		db  $E3, $F8, $F8, $F8, $F8, $78, $59, $78, $58, $79, $58, $37, $37, $37, $79, $E3;
		db  $E3, $E3, $F4, $F8, $F8, $F8, $58, $58, $59, $58, $59, $79, $58, $79, $E3, $E3;
		db  $E3, $E3, $E3, $F8, $F8, $F8, $78, $58, $58, $58, $58, $79, $79, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $F8, $F8, $79, $59, $79, $79, $E3, $E3, $E3, $E3, $E3;



Ball14:
		db  $E3, $E3, $E3, $E3, $E3, $ED, $ED, $ED, $E9, $AE, $ED, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $E9, $E9, $AE, $E3, $E3, $E3;
		db  $E3, $E3, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $E9, $AE, $37, $E3, $E3;
		db  $E3, $ED, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $E9, $AE, $AE, $E3;
		db  $E3, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $AE, $AE, $AE, $E3;
		db  $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $AE, $AE, $AF, $AE;
		db  $F4, $F4, $F8, $F8, $F8, $F8, $F4, $F4, $E9, $E9, $E9, $AE, $AE, $AE, $AE, $AE;
		db  $F8, $F8, $F8, $F8, $F8, $F8, $F8, $D4, $8E, $E9, $AF, $AE, $AE, $AF, $AE, $AE;
		db  $F8, $F8, $F8, $F8, $F8, $F8, $78, $75, $8E, $AF, $AE, $AE, $AE, $AE, $AE, $AF;
		db  $F8, $F8, $F8, $F8, $F8, $79, $79, $36, $37, $AF, $AE, $AE, $AE, $AE, $33, $36;
		db  $F4, $F8, $F8, $F8, $78, $58, $58, $36, $33, $33, $33, $37, $37, $37, $33, $37;
		db  $E3, $F8, $F8, $F8, $58, $58, $58, $78, $33, $33, $33, $33, $33, $33, $37, $E3;
		db  $E3, $F8, $F8, $F8, $58, $58, $58, $78, $37, $33, $33, $33, $37, $33, $79, $E3;
		db  $E3, $E3, $F4, $F8, $59, $58, $58, $58, $79, $37, $37, $33, $33, $37, $E3, $E3;
		db  $E3, $E3, $E3, $F8, $79, $59, $79, $59, $58, $78, $59, $37, $37, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $BA, $79, $79, $79, $59, $79, $79, $E3, $E3, $E3, $E3, $E3;



Ball15:
		db  $E3, $E3, $E3, $E3, $E3, $F4, $F4, $F4, $E9, $AF, $ED, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $AE, $E3, $E3, $E3;
		db  $E3, $E3, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $ED, $E3, $E3;
		db  $E3, $ED, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $AE, $E3;
		db  $E3, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $AE, $E3;
		db  $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $AF, $AF;
		db  $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $E9, $E9, $E9, $E9, $AE, $AE, $AE;
		db  $F8, $F8, $F8, $F8, $F8, $F8, $F8, $D4, $8E, $E9, $E9, $E9, $AE, $AF, $AE, $AE;
		db  $F8, $F8, $F8, $F8, $78, $58, $59, $56, $8E, $AF, $AE, $AE, $AE, $AE, $AE, $AE;
		db  $F8, $F8, $F8, $78, $58, $79, $79, $37, $37, $AF, $AE, $AE, $AE, $AE, $AE, $AE;
		db  $F4, $F8, $79, $58, $79, $58, $36, $33, $37, $AF, $AE, $AE, $AE, $AE, $AE, $AE;
		db  $E3, $F8, $58, $59, $58, $58, $37, $33, $37, $33, $37, $AE, $AE, $AE, $AF, $E3;
		db  $E3, $F8, $78, $58, $58, $58, $37, $33, $37, $33, $33, $33, $37, $33, $79, $E3;
		db  $E3, $E3, $79, $59, $58, $58, $59, $37, $33, $37, $37, $33, $37, $37, $E3, $E3;
		db  $E3, $E3, $E3, $79, $79, $59, $78, $59, $37, $33, $33, $37, $37, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $79, $79, $79, $36, $37, $37, $E3, $E3, $E3, $E3, $E3;



Ball16:
		db  $E3, $E3, $E3, $E3, $E3, $F4, $F4, $F4, $F4, $F4, $ED, $E3, $E3, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $AE, $E3, $E3, $E3;
		db  $E3, $E3, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $F4, $F4, $E9, $E9, $ED, $E3, $E3;
		db  $E3, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $F4, $E9, $E9, $E9, $AE, $E3;
		db  $E3, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $E9, $E9, $E9, $ED, $E3;
		db  $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $F4, $E9, $E9, $E9, $E9, $ED;
		db  $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F8, $F4, $F4, $E9, $E9, $E9, $E9, $E9, $ED;
		db  $F8, $F8, $79, $58, $59, $58, $78, $95, $8E, $E9, $E9, $E9, $E9, $E9, $E9, $AF;
		db  $F8, $78, $58, $58, $78, $79, $59, $52, $8E, $E9, $E9, $E9, $E9, $E9, $AE, $AE;
		db  $79, $58, $58, $59, $58, $78, $37, $37, $37, $AF, $AE, $AE, $AE, $AE, $AE, $AE;
		db  $79, $59, $79, $58, $78, $37, $33, $33, $AF, $AE, $AE, $AE, $AE, $AE, $AE, $AE;
		db  $E3, $79, $58, $58, $58, $37, $33, $33, $AE, $AE, $AE, $AE, $AE, $AE, $AF, $E3;
		db  $E3, $F8, $78, $59, $59, $37, $33, $33, $37, $AE, $AE, $AE, $AE, $AE, $AE, $E3;
		db  $E3, $E3, $79, $59, $58, $33, $37, $37, $33, $37, $33, $AF, $AF, $AE, $E3, $E3;
		db  $E3, $E3, $E3, $79, $79, $37, $33, $33, $37, $33, $33, $37, $37, $E3, $E3, $E3;
		db  $E3, $E3, $E3, $E3, $E3, $79, $37, $37, $37, $37, $37, $E3, $E3, $E3, $E3, $E3;

			
	sprexit:

		
	end asm 
		
end sub

sub UpdateSprite(x AS UBYTE,y AS UBYTE, spriteid AS UBYTE, pattern AS UBYTE, mflip as ubyte)
	rem               5            7          9                  11              13
	ASM 
		;REM get ID spriteid
		ld a,(IX+9)
		; REM selct sprite  
		ld bc, $303b
		out (c), a
		; REM sprite port 
		ld bc, $57
		; REM now send 4 bytes 
		;REM  get x and send byte 1
		ld a,(IX+5) 
		out (c), a          ;   X POS 		
		;REM  get y and send byte 2
		ld a,(IX+7)
		out (c), a          ;   X POS		
		; REM no palette offset and no rotate and mirrors flags send  byte 3
		ld a,(IX+13)
		out (c), a 
		; REM Sprite visible and show pattern #0 byte 4
		ld a,(IX+11)
		or 128 
		out (c), a	
	END ASM 
end sub

 