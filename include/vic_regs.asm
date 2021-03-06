	;vic-ii registers in the context of the C64
	;
	VIC_II_BASE 	= 	$d000
	SPR0_X		= 	VIC_II_BASE
	SPR0_Y		= 	$d001
	SPR1_X		= 	$d002
	SPR1_Y		= 	$d003
	SPR2_X		= 	$d004
	SPR2_Y		= 	$d005
	SPR3_X		= 	$d006
	SPR3_Y		= 	$d007
	SPR4_X		= 	$d008
	SPR4_Y		= 	$d009
	SPR5_X		= 	$d00a
	SPR5_Y		= 	$d00b
	SPR6_X		= 	$d00c
	SPR6_Y		= 	$d00d
	SPR7_X		= 	$d00e
	SPR7_Y		= 	$d00f
	SPRX_MSB	=	$d010 ;MSb of sprite x positions 
	VIC_CTRL_1	=	$d011 ; RST8|ECM|BMM|DEN|RSEL|X|YSCRL|...
	RASTER		=	$d012
	LP_X		=	$d013
	LP_Y		=	$d014
	SPR_ENABLE	=	$d015
	VIC_CTRL_2	=	$d016
	SPRY_EXPAND	=	$d017
	VIC_MEMPTR	=	$d018
	VIC_IRQ		=	$d019
	VIC_IRQENABLE	=	$d01a
	SPR_PRIORITY	=	$d01b
	SPR_MCOLOR	=	$d01c
	SPRX_EXPAND	=	$d01d
	SPR_SCOLLIDE	=	$d01e
	SPR_DCOLLIDE	=	$d01f
	BORDER		=	$d020
	BACKGROUND	=	$d021
	MCOLOR0		=	$d022
	MCOLOR1		=	$d023
	MCOLOR2		=	$d024
	SPR_MCOLOR0	=	$d025
	SPR_MCOLOR1	=	$d026
	SPR0_COLOR	=	$d027
	SPR1_COLOR	=	$d028
	SPR2_COLOR	=	$d029
	SPR3_COLOR	=	$d02a
	SPR4_COLOR	=	$d02b
	SPR5_COLOR	=	$d02c
	SPR6_COLOR	=	$d02d
	SPR7_COLOR	=	$d02e
	
	BLACK		= 	$00
	WHITE		=	$01
	RED		=	$02
	CYAN		=	$03
	PURPLE		=	$04
	GREEN		=	$05
	BLUE		=	$06
	YELLOW		=	$07
	ORANGE		=	$08
	BROWN		=	$09
	PINK		=	$0a
	DK_GREY		=	$0b
	MED_GREY	=	$0c
	LT_GREEN	=	$0d
	LT_BLUE		=	$0e
	LT_GREY		=	$0f
	
	