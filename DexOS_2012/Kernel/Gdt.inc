;=========================================================;
; Gdt                                          01/04/2011 ;
;---------------------------------------------------------;
; Defines gdt descriptors.                                ;
;                                                         ;
; (c) Craig Bamford, All rights reserved.                 ;
;=========================================================;
align 4                                                  
;=======================================================  ;
;  gdt                                                    ;
;=======================================================  ; 
gdt:					                  ;
	dw 0				                  ; (0h) Null Segment
	dw 0				                  ;
	db 0				                  ;
	db 0                                              ;				   
	db 0                                              ;				   
	db 0	                                          ;			   
;=======================================================  ;
;  linear_sel_1                                           ;
;=======================================================  ; 
linear_sel_1:	                                          ;
       dw 0xFFFF			                  ; (8h) linear Data segment, read/write, expand down
       dw 0		                                  ;			   
       db 0                                               ;
       db 10010010b	                                  ;			   
       db 11001111b	                                  ;			  
       db 0                                               ;
;=======================================================  ;
;  sys_code_1                                             ;
;=======================================================  ; 
sys_code_1:				                  ; (10h) Code segment, read/execute, nonconforming
       dw 0FFFFh                                          ;
       dw 0                                               ;
       db 0                                               ;
       db 10011010b                                       ;
       db 11001111b                                       ;
       db 0                                               ;
;=======================================================  ;
;  sys_data_1                                             ;
;=======================================================  ; 
sys_data_1:		                		  ; (18h) Data segment, read/write, expand down
       dw 0FFFFh                                          ;
       dw 0                                               ;
       db 0                                               ;
       db 10010010b                                       ;
       db 11001111b                                       ;
       db 0                                               ;
;=======================================================  ;
;  Real_code_1                                            ;
;=======================================================  ; 
Real_code_1:	                		          ; (20h) Real mode code segment
       dw 0xFFFF                                          ;
       dw 0		                                  ;				 
       db 0                                               ;
       db 10011010b		                          ;				  
       db 0		                                  ;				  
       db 0                                               ;
;=======================================================  ;
;  Real_data_1                                            ;
;=======================================================  ; 
Real_data_1:        				          ; (28h) Real mode data segment
       dw 0xFFFF                                          ;
       dw 0	                                          ;					  
       db 0                                               ;
       db 10010010b                                       ;						  
       db 0	                                          ;					  
       db 0                                               ;
gdt_end:                                                  ;				   
