;lkmon.prg
	.include "../../include/ltk_dos_addresses.asm"
	.include "../../include/ltk_equates.asm"
	.include "../../include/kernal.asm"
	.include "../../include/sid_regs.asm"

	*=$1c20 
L1c20               
	jsr S29cd
	jsr LTK_Krn_BankOut
	lda #$10
	sta $3518
	ldx #$00
	stx $66
	stx $67
	stx $68
	jsr $9f03
	clc
	adc #$9e
	tax
	lda #$02
	adc #$00
	tay
	lda #$0a
	clc
	jsr LTK_HDDiscDriver
	.byte <LTK_FileHeaderBlock,>LTK_FileHeaderBlock,$01 ;LTK_FileHeaderBlock
                    
L1c48
	ldx $91f0
	ldy $91f2
	lda LTK_Var_CPUMode
	sta L2ecf
	bpl L1c61
	lda #$00
	sta $ff00
	ldx $91f1
	ldy $91f3
L1c61
	cld
	stx $2ed2
	sty $2ed3
	jsr LTK_Krn_BankIn
	cli
	lda #$c0
	jsr SETMSG
	ldx #<str_Startup
	ldy #>str_Startup ;$304c
	jsr Print_Message
	ldx #<str_NormalMem
	ldy #>str_NormalMem ;$2f13
	jsr Print_Message
	lda L2ecf
	bmi L1c86
	sta $9d
L1c86
	bit $2ed0
	bpl L1c9d
	lda $1fcd
	beq L1c9d
	lda #$ff
	sta $1fcd
	jsr S1fd2
	lda #$00
	sta $1fcd
L1c9d
	jsr S27f9
	ldx #$00
	stx $7a
L1ca4
	jsr CHRIN
	sta LTK_Command_Buffer,x
	inx
	cpx #$58
	bcs L1ccb
	cmp #$0d
	bne L1ca4
	lda #$00
	sta $01ff,x
L1cb8
	jsr S2835
	beq L1c86
	cmp #$20
	beq L1cb8
	ldx #$24
L1cc3
	cmp $316b,x
	beq L1cd8
	dex
	bpl L1cc3
L1ccb
	lda #$1d
	jsr CHROUT
	lda #$3f
	jsr CHROUT
	jmp L1c86
                    
L1cd8
	cpx #$1b
	bcs L1cfa
	cpx #$18
	bcs L1cf2
	cpx #$14
	bcs L1cf7
	txa
	asl a
	tax
	lda $3191,x
	pha
	lda $3190,x
	pha
	jmp L26f1
                    
L1cf2
	sta $93
	jmp L2335
                    
L1cf7
	jmp L28ee
                    
L1cfa
	txa
	sec
	sbc #$1b
	asl a
	tax
	lda $31b9,x
	pha
	lda $31b8,x
	pha
	rts
                    
L1d09
	lda #$00
	bit L2ecf
	bmi L1d18
	sta $c8
	ldx #$80
	stx $9d
	bne L1d1c
L1d18
	sta $ea
	sta $7f
L1d1c
	sta LTK_Command_Buffer
	ldx #<str_Aborted  
	ldy #>str_Aborted  ;$2fd7 
	jsr Print_Message
	jsr L2a57
	bit L2ecf
	bmi L1d2f
	rts
                    
L1d2f
	pla
	pla
	jmp ($0a00)
                    
L1d34
	bcs L1d67
	lda $62
	cmp #$02
	bne L1d3f
	jsr LTK_Krn_BankOut
L1d3f
	bit L2ecf
	bmi L1d54
	lda $60
	sta S1d4e + 1
	lda $61
	sta S1d4e + 2
S1d4e
	jsr S1d4e
	jmp L1d61
                    
L1d54
	sta $02
	lda $60
	sta $04
	lda $61
	sta $03
	jsr $ff6e
L1d61
	jsr LTK_Krn_BankIn
	jmp L1c86
                    
L1d67
	jmp L1ccb

Print_Message
	pha
	stx pm_loop + 1
	sty pm_loop + 2
	ldy #$00
pm_loop
	lda pm_loop,y
	beq pm_done
	jsr CHROUT
	iny
	bne pm_loop
	inc pm_loop + 2
	bne pm_loop
pm_done               
	pla
	rts
                    
S1d85
	bit $2ed4
	bmi L1dc3
	pha
	txa
	pha
	tya
	pha
	sec
	jsr PLOT
	txa
	pha
	tya
	pha
L1d97
	sec
	jsr PLOT
	bit L2ecf
	bpl L1daa
	lda $d7
	beq L1daa
	cpy #$4f
	beq L1db6
	bne L1dae
L1daa
	cpy #$27
	beq L1db6
L1dae
	lda #$20
	jsr CHROUT
	jmp L1d97
                    
L1db6
	pla
	tay
	pla
	tax
	clc
	jsr PLOT
	pla
	tay
	pla
	tax
	pla
L1dc3
	rts
                    
S1dc4
	sei
	stx $31fe
	jsr S1f1f
	bcs L1e1b
	bit $2ed0
	bpl L1dd9
	clc
	jsr S1e91
	jmp L1de4
                    
L1dd9
	ldx $68
	cpx #$02
	bne L1de4
	jsr LTK_Krn_BankOut
	ldx #$0f
L1de4
	bit $2ed0
	bpl L1dec
	jsr S1fd0
L1dec
	bit L2ecf
	bmi L1df6
	lda ($66),y
	jmp L1dfd
                    
L1df6
	lda #$66
	ldx $68
	jsr $ff74
L1dfd
	bit $2ed0
	bmi L1e0b
	ldx $68
	cpx #$02
	bne L1e0b
	jsr LTK_Krn_BankIn
L1e0b
	bit $2ed0
	clc
	bpl L1e16
	sec
	jsr S1e91
	clc
L1e16
	ldx $31fe
	cli
	rts
                    
L1e1b
	pha
	tya
	pha
	cli
	ldx #<str_NonExistAddr
	ldy #>str_NonExistAddr ;$2fb1
	jsr Print_Message
	jsr BeepIfAllowed
	pla
	tay
	pla
	ldx $31fe
	sec
	rts
	
S1e31
	sei
	stx $31fe
	jsr S1f1f
	bcs L1e1b
	bit $2ed0
	bpl L1e43
	clc
	jsr S1e91
L1e43
	ldx #$66
	stx $02b9
	bit $2ed0
	bmi L1e58
	ldx $68
	cpx #$02
	bne L1e58
	jsr LTK_Krn_BankOut
	ldx #$0f
L1e58
	bit $2ed0
	bpl L1e65
	jsr S1fd2
	ldx #$01
	stx $1fcd
L1e65
	bit L2ecf
	bmi L1e6e
	sta ($66),y
	bpl L1e73
L1e6e
	ldx $68
	jsr $ff77
L1e73
	bit $2ed0
	bmi L1e81
	ldx $68
	cpx #$02
	bne L1e81
	jsr LTK_Krn_BankIn
L1e81
	bit $2ed0
	clc
	bpl L1e8c
	sec
	jsr S1e91
	clc
L1e8c
	ldx $31fe
	cli
	rts
                    
S1e91
	pha
	tya
	pha
	bcs L1ed8
	lda $66
	sec
	sbc L2e89
	tax
	lda $67
	sbc L2e8a
	tay
	bit $2ed0
	bpl L1eaf
	lda $68
	sbc L2e8b
	sta $68
L1eaf
	txa
	clc
	adc #$d8
	tax
	tya
	adc #$35
	tay
	bit $2ed0
	bpl L1ec3
	lda $68
	adc #$00
	sta $68
L1ec3
	tya
	sec
	sbc $1fce
	tay
	bit $2ed0
	bpl L1ed5
	lda $68
	sbc $1fcf
	sta $68
L1ed5
	jmp L1f17
                    
L1ed8
	lda $66
	sec
	sbc #$d8
	tax
	lda $67
	sbc #$35
	tay
	bit $2ed0
	bpl L1eee
	lda $68
	sbc #$00
	sta $68
L1eee
	txa
	clc
	adc L2e89
	tax
	tya
	adc L2e8a
	tay
	bit $2ed0
	bpl L1f05
	lda $68
	adc L2e8b
	sta $68
L1f05
	tya
	clc
	adc $1fce
	tay
	bit $2ed0
	bpl L1f17
	lda $68
	adc $1fcf
	sta $68
L1f17
	sty $67
	stx $66
	pla
	tay
	pla
	rts
                    
S1f1f
	pha
	lda $66
	pha
	lda $67
	pha
	lda $68
	pha
	tya
	clc
	adc $66
	sta $66
	bcc L1f37
	inc $67
	bne L1f37
	inc $68
L1f37
	bit $2ed0
	bpl L1f45
	ldx $68
	cpx L2e8b
	bcc L1fb8
	bne L1f55
L1f45
	ldx $67
	cpx L2e8a
	bcc L1fb8
	bne L1f55
	ldx $66
	cpx L2e89
	bcc L1fb8
L1f55
	bit $2ed0
	bpl L1f63
	ldx L2e8e
	cpx $68
	bcc L1fb8
	bne L1f73
L1f63	
	ldx L2e8d
	cpx $67
	bcc L1fb8
	bne L1f73
	ldx L2e8c
	cpx $66
	bcc L1fb8
L1f73
	lda $66
	sec
	sbc L2e89
	sta $1fc6
	lda $67
	sbc L2e8a
	sta $1fc5
	lda $68
	sbc L2e8b
	sta $1fc4
	ldx #$09
L1f8e
	lsr $1fc4
	ror $1fc5
	ror $1fc6
	cpx #$02
	bne L1fa9
	lda $1fc6
	and #$fe
	sta $1fce
	lda $1fc5
	sta $1fcf
L1fa9
	dex
	bne L1f8e
	pla
	sta $68
	pla
	sta $67
	pla
	sta $66
	clc
	pla
	rts
                    
L1fb8
	sec
	pla
	sta $68
	pla
	sta $67
	pla
	sta $66
	pla
	rts
                    
L1fc4
	.byte $00,$00,$00,$00,$00,$00,$ff,$ff
	.byte $ff,$00,$00,$00 
S1fd0
	clc
	.byte $24 
S1fd2
	sec
	pha
	tya
	pha
	bcs L1fef
	lda $1fc6
	ldx $1fc5
	cmp $1fcb
	bne L1fe8
	cpx $1fcc
	beq L201a
L1fe8
	clc
	jsr S201e
	jmp L201a
                    
L1fef
	lda $1fcb
	ldx $1fcc
	cmp #$ff
	bne L1ffd
	cpx #$ff
	beq L2010
L1ffd
	bit $1fcd
	bmi L200c
	cmp $1fc6
	bne L200c
	cpx $1fc5
	beq L201a
L200c
	sec
	jsr S201e
L2010
	lda $1fc6
	ldx $1fc5
	clc
	jsr S201e
L201a
	pla
	tay
	pla
	rts
                    
S201e
	php
	sta $1fc9
	sta $1fc7
	stx $1fc8
	jsr LTK_Krn_BankOut
	ldx $2bb1
	ldy $2bb3
	bit $2ed6
	bpl L20a5
	ldx $91f8
	cpx #$0a
	bcs L204c
	sec
	adc $9201
	tax
	lda $1fc8
	adc $9200
	tay
	jmp L20a5
                    
L204c
	lda #$02
	sta $31
	lda #$92
	sta $32
	lda $91f0
	bne L2060
	lda $91f1
	cmp #$f1
	bcc L2093
L2060
	ldy #$08
L2062
	lsr $1fc8
	ror $1fc9
	dey
	bne L2062
	lda $1fc9
	asl a
	tay
	bcc L2074
	inc $32
L2074
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
	lda $1fca
	cmp #$ff
	beq L20ce
	clc
	jsr LTK_HDDiscDriver
	.byte $a6,$37,$01
L208b               
	lda #$a6
	sta $31
	lda #$37
	sta $32
L2093
	lda $1fc7
	asl a
	tay
	bcc L209c
	inc $32
L209c
	lda ($31),y
	pha
	iny
	lda ($31),y
	tax
	pla
	tay
L20a5
	lda $1fca
	cmp #$ff
	beq L20ce
	clc
	jsr S20d3
	plp
	jsr LTK_HDDiscDriver
	.byte $d8,$35,$01
L20b7               
	.byte $b2
L20b8
	.byte $c2 
L20b9
	.byte $d2 
L20ba
	sec
	jsr S20d3
L20be               
	jsr LTK_Krn_BankIn
L20c1
	lda $1fc6
	sta $1fcb
	lda $1fc5
	sta $1fcc
	rts
                    
L20ce
	plp
	jsr LTK_Krn_BankIn
	rts
                    
S20d3
	pha
	txa
	pha
	tya
	pha
	ldx #$09
	ldy #$00
	bcs L20f3
L20de
	lda $80aa,y
	sta $2107,x
	and #$f7
	sta $80aa,y
	iny
	iny
	iny
	iny
	iny
	dex
	bpl L20de
	bmi L2101
L20f3
	lda $2107,x
	sta $80aa,y
	iny
	iny
	iny
	iny
	iny
	dex
	bpl L20f3
L2101               
	pla
	tay
	pla
	tax
	pla
	rts
 ;$2107
 	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
L2111               
	lda #$ff
	.byte $2c
	lda #$00
	sta $2ed5
	bcs L2123
	jsr S284d
	jsr L26f1
	bcc L2129
L2123
	lda #$0b
	sta $60
	bne L2143
L2129
	jsr S285a
	bcc L2162
	ldx #$03
	bit L2ecf
	bpl L213a
	bit $d7
	bpl L213a
	inx
L213a
	lsr $62
	ror $61
	ror $60
	dex
	bne L213a
L2143
	jsr STOP
	beq L215f
	jsr S21a0
	lda #$08
	bit L2ecf
	bpl L2157
	bit $d7
	bpl L2157
	asl a
L2157
	jsr S289e
	jsr S286e
	bcs L2143
L215f
	jmp L1c86
                    
L2162
	jmp L1ccb
                    
L2165
	bcs L2188
	jsr S284d
	ldy #$00
L216c
	jsr L26f1
	bcs L2188
	lda $60
	jsr S1e31
	iny
	bit L2ecf
	bpl L2184
	bit $d7
	bpl L2184
	cpy #$10
	bcc L216c
L2184
	cpy #$08
	bcc L216c
L2188
	pha
	lda #$8d
	jsr CHROUT
	lda #$91
	jsr CHROUT
	jsr CHROUT
	pla
	jsr S21a0
	jmp L1c86
                    
L219d
	jmp L1c86
                    
S21a0
	jsr S27f9
	lda #$3e
	jsr CHROUT
	jsr S27d4
	ldy #$00
	beq L21b2
L21af
	jsr S27ea
L21b2
	jsr S1dc4
	bcc L21c1
	lda #$00
	sta $60
	sta $61
	sta $62
	beq L2207
L21c1
	jsr S280e
	iny
	cpy #$08
	bit L2ecf
	bpl L21d2
	bit $d7
	bpl L21d2
	cpy #$10
L21d2
	bcc L21af
	bit $2ed5
	bmi L2207
	lda #$3a
	jsr CHROUT
	lda #$12
	jsr CHROUT
	ldy #$00
L21e5
	jsr S1dc4
	pha
	and #$7f
	cmp #$20
	pla
	bcs L21f2
	lda #$2e
L21f2
	jsr CHROUT
	iny
	bit L2ecf
	bpl L2203
	bit $d7
	bpl L2203
	cpy #$10
	bcc L21e5
L2203	
	cpy #$08
	bcc L21e5
L2207
	rts
                    
L2208
	lda #$00
	bit $80a9
	sta $93
	lda #$00
	sta $31ff
	jsr S28c0
	bcs L221e
	jsr L26f1
	bcc L2221
L221e
	jmp L1ccb
                    
L2221
	bit $93
	bpl L2251
	sec
	lda $66
	sbc $60
	lda $67
	sbc $61
	bcs L2251
	lda $63
	adc $60
	sta $60
	lda $64
	adc $61
	sta $61
	lda $65
	adc $62
	sta $62
	ldx #$02
L2244
	lda $3203,x
	sta $66,x
	dex
	bpl L2244
	lda #$80
	sta $31ff
L2251
	jsr S27f9
	ldy #$00
L2256
	jsr STOP
	beq L22c7
	jsr S1dc4
	ldx #$60
	stx $02b9
	stx $02c8
	ldx $62
	cpx #$02
	bne L2271
	jsr LTK_Krn_BankOut
	ldx #$0f
L2271
	sei
	bit $93
	bpl L2282
	bit L2ecf
	bmi L227f
	sta ($60),y
	bpl L2282
L227f
	jsr $ff77
L2282
	ldx $62
	cpx #$02
	bne L228a
	ldx #$0f
L228a
	bit L2ecf
	bmi L2294
	cmp ($60),y
	jmp L2297
                    
L2294
	jsr $ff7a
L2297
	jsr LTK_Krn_BankIn
	cli
	beq L22a6
	jsr S27d4
	jsr S27ea
	jsr S27ea
L22a6
	bit $31ff
	bmi L22b6
	inc $60
	bne L22bf
	inc $61
	bne L22bf
	jmp L1ccb
                    
L22b6
	jsr S286e
	jsr S28ac
	jmp L22c2
                    
L22bf
	jsr S289c
L22c2
	jsr S2888
	bcs L2256
L22c7
	jmp L1c86
                    
L22ca
	jsr S28c0
	bcs L2332
	ldy #$00
	jsr S2835
	cmp #$27
	bne L22ee
	jsr S2835
	cmp #$00
	beq L2332
L22df
	sta $31cc,y
	iny
	jsr S2835
	beq L2303
	cpy #$20
	bne L22df
	beq L2303
L22ee
	sty $0100
	jsr S26ef
L22f4
	lda $60
	sta $31cc,y
	iny
	jsr L26f1
	bcs L2303
	cpy #$20
	bne L22f4
L2303
	sty $93
	jsr S27f9
L2308
	ldy #$00
L230a
	jsr S1dc4
	bcs L232f
	cmp $31cc,y
	bne L2322
	iny
	cpy $93
	bne L230a
	jsr S27d4
	jsr S27ea
	jsr S27ea
L2322
	jsr STOP
	beq L232f
	jsr S289c
	jsr S2888
	bcs L2308
L232f
	jmp L1c86
                    
L2332
	jmp L1ccb
                    
L2335
	ldy #$08
	sty $ba
	sty $b9
	ldy #$00
	bit L2ecf
	bpl L2346
	sty $c6
	sty $c7
L2346
	sty $b7
	sty $90
	lda #$0a
	sta $bc
	lda #$80
	sta $bb
L2352
	jsr S2835
	beq L23b4
	cmp #$20
	beq L2352
	cmp #$22
	bne L2374
	ldx $7a
L2361
	lda LTK_Command_Buffer,x
	beq L23b4
	inx
	cmp #$22
	beq L2377
	sta ($bb),y
	inc $b7
	iny
	cpy #$11
	bcc L2361
L2374
	jmp L1ccb
                    
L2377
	stx $7a
	jsr S2835
	beq L23b4
	jsr L26f1
	bcs L23b4
	lda $60
	sta $ba
	jsr L26f1
	bcs L23b4
	jsr S284d
	bit L2ecf
	bpl L2396
	sta $c6
L2396
	jsr L26f1
	bcs L23d0
	jsr S27f9
	ldx $60
	ldy $61
	lda $93
	cmp #$53
	bne L2374
	lda #$00
	sta $b9
	lda #$66
	jsr SAVE
L23b1	
	jmp L1c86
                    
L23b4
	lda $93
	cmp #$56
	beq L23c0
	cmp #$4c
	bne L2374
	lda #$00
L23c0
	jsr LOAD
	lda $90
	and #$10
	beq L23b1
	lda $93
	beq L2374
	jmp L1ccb
                    
L23d0               
	ldx $66
	ldy $67
	lda #$00
	sta $b9
	beq L23b4
	jsr S28c0
	bcs L2404
	lda $68
	cmp $3205
	bne L2404
	jsr L26f1
	bcs L2404
	ldy #$00
L23ed
	lda $60
	jsr S1e31
	bcs L2401
	jsr STOP
	beq L2401
	jsr S289c
	jsr S2888
	bcs L23ed
L2401
	jmp L1c86
                    
L2404
	jmp L1ccb
                    
L2407
	bcs L2443
	jsr S284d
L240c
	ldx #$00
	stx $31ed
	stx $3200
L2414
	jsr S2835
	bne L2420
	cpx #$00
	bne L2420
	jmp L1c86
                    
L2420
	cmp #$20
	beq L240c
	sta $31f8,x
	inx
	cpx #$03
	bne L2414
L242c
	dex
	bmi L2446
	lda $31f8,x
	sec
	sbc #$3f
	ldy #$05
L2437
	lsr a
	ror $31ed
	ror $31ec
	dey
	bne L2437
	beq L242c
L2443 
	jmp L1ccb
                    
L2446
	ldx #$02
L2448
	lda $3200
	bne L247d
	jsr S2718
	beq L247b
	bcs L2443
	lda #$24
	sta $31ec,x
	inx
	lda $62
	bne L2443
	ldy #$04
	lda $3202
	cmp #$08
	bcc L246c
	cpy $3200
	beq L2472
L246c
	lda $61
	bne L2472
	ldy #$02
L2472
	lda #$30
L2474
	sta $31ec,x
	inx
	dey
	bne L2474
L247b
	dec $7a
L247d
	jsr S2835
	beq L2490
	cmp #$20
	beq L2448
	sta $31ec,x
	inx
	cpx #$0a
	bcc L2448
	bcs L2443
L2490
	stx $63
	ldx #$00
	stx $31fd
L2497
	ldx #$00
	stx $9f
	lda $31fd
	jsr S2685
	ldx $31f6
	stx $64
	tax
	lda $311f,x
	jsr S259e
	lda $30df,x
	jsr S259e
	ldx #$06
L24b5
	cpx #$03
	bne L24cd
	ldy $31f7
	beq L24cd
L24be
	lda $31f6
	cmp #$e8
	lda #$30
	bcs L24e5
	jsr S259b
	dey
	bne L24be
L24cd
	asl $31f6
	bcc L24e0
	lda $30d2,x
	jsr S259e
	lda $30d8,x
	beq L24e0
	jsr S259e
L24e0
	dex
	bne L24b5
	beq L24eb
L24e5
	jsr S259b
	jsr S259b
L24eb
	lda $63
	cmp $9f
	beq L24f7
	jmp L25aa
                    
L24f4
	jmp L1ccb
                    
L24f7
	ldy $31f7
	beq L252e
	lda $64
	cmp #$9d
	bne L2525
	lda $60
	sbc $66
	tax
	lda $61
	sbc $67
	bcc L2515
	bne L24f4
	cpx #$82
	bcs L24f4
	bcc L251d
L2515
	tay
	iny
	bne L2598
	cpx #$82
	bcc L2598
L251d
	dex
	dex
	txa
	ldy $31f7
	bne L2528
L2525
	lda $005f,y
L2528
	jsr S1e31
	dey
	bne L2525
L252e
	lda $31fd
	jsr S1e31
	jsr S27ef
	pha
	lda #$41
	jsr CHROUT
	lda #$20
	jsr CHROUT
	jsr S1d85
	pla
	jsr S25fe
	inc $31f7
	lda $31f7
	jsr S289e
	lda #$41
	sta $034a
	lda #$20
	sta $034b
	sta $0351
	lda $68
	jsr S281e
	stx $034c
	lda $67
	jsr S281e
	sta $034d
	stx $034e
	lda $66
	jsr S281e
	sta $034f
	stx $0350
	lda #$08
	sta $d0
	bit L2ecf
	bmi L2595
	ldx #$07
L2588
	lda $034a,x
	sta $0277,x
	dex
	bpl L2588
	lda #$08
	sta $c6
L2595
	jmp L1c86
                    
L2598
	jmp L1ccb
                    
S259b
	jsr S259e
S259e
	stx $31fb
	ldx $9f
	cmp $31ec,x
	beq L25b2
	pla
	pla
L25aa
	inc $31fd
	beq L2598
	jmp L2497
                    
L25b2
	inc $9f
	ldx $31fb
	rts
                    
L25b8
	bcs L25c2
	jsr S284d
	jsr L26f1
	bcc L25c8
L25c2
	lda #$14
	sta $60
	bne L25cd
L25c8
	jsr S285a
	bcc L25f3
L25cd
	pha
	lda #$0d
	jsr CHROUT
	jsr S1d85
	pla
	jsr STOP
	beq L25f0
	jsr S25f6
	inc $31f7
	lda $31f7
	jsr S289e
	lda $31f7
	jsr S2870
	bcs L25cd
L25f0
	jmp L1c86
                    
L25f3
	jmp L1ccb
                    
S25f6
	lda #$2e
	jsr CHROUT
	jsr S27ea
S25fe
	jsr S27d4
	jsr S27ea
	ldy #$00
	jsr S1dc4
	bcc L260f
	pla
	pla
	bcs L25f0
L260f
	jsr S2685
	pha
	ldx $31f7
	inx
L2617
	dex
	bpl L2628
	lda #$20
	jsr CHROUT
	jsr CHROUT
	jsr CHROUT
	jmp L262e
                    
L2628
	jsr S1dc4
	jsr S27e7
L262e
	iny
	cpy #$03
	bcc L2617
	pla
	ldx #$03
	jsr S26cd
	ldx #$06
L263b
	cpx #$03
	bne L2656
	ldy $31f7
	beq L2656
L2644
	lda $31f6
	cmp #$e8
	php
	jsr S1dc4
	plp
	bcs L266d
	jsr S280e
	dey
	bne L2644
L2656
	asl $31f6
	bcc L2669
	lda $30d2,x
	jsr CHROUT
	lda $30d8,x
	beq L2669
	jsr CHROUT
L2669
	dex
	bne L263b
	rts
                    
L266d
	jsr S2679
	clc
	adc #$01
	bne L2676
	inx
L2676
	jmp S27e1
                    
S2679
	ldx $67
	tay
	bpl L267f
	dex
L267f
	adc $66
	bcc L2684
	inx
L2684
	rts
                    
S2685
	tay
	lsr a
	bcc L2694
	lsr a
	bcs L26a3
	cmp #$22
	beq L26a3
	and #$07
	ora #$80
L2694
	lsr a
	tax
	lda $3081,x
	bcs L269f
	lsr a
	lsr a
	lsr a
	lsr a
L269f
	and #$0f
	bne L26a7
L26a3
	ldy #$80
	lda #$00
L26a7
	tax
	lda $30c5,x
	sta $31f6
	and #$03
	sta $31f7
	tya
	and #$8f
	tax
	tya
	ldy #$03
	cpx #$8a
	beq L26c9
L26be
	lsr a
	bcc L26c9
	lsr a
L26c2
	lsr a
	ora #$20
	dey
	bne L26c2
	iny
L26c9
	dey
	bne L26be
	rts
                    
S26cd
	tay
	lda $30df,y
	sta $63
	lda $311f,y
	sta $64
L26d8
	lda #$00
	ldy #$05
L26dc
	asl $64
	rol $63
	rol a
	dey
	bne L26dc
	adc #$3f
	jsr CHROUT
	dex
	bne L26d8
	jmp S27ea
                    
S26ef
	dec $7a
L26f1
	jsr S2718
	bcs L270c
	jsr S2833
	bne L2704
	dec $7a
	lda $3200
	bne L2713
	beq L2711
L2704
	cmp #$20
	beq L2713
	cmp #$2c
	beq L2713
L270c
	pla
	pla
	jmp L1ccb
                    
L2711
	sec
	.byte $24
L2713               
	clc
	lda $3200
	rts
                    
S2718
	lda #$00
	sta $60
	sta $61
	sta $62
	sta $3200
	txa
	pha
	tya
	pha
L2727
	jsr S2835
	bne L272f
	jmp L27c8
                    
L272f
	cmp #$20
	beq L2727
	ldx #$03
L2735
	cmp $317f,x
	beq L2740
	dex
	bpl L2735
	inx
	dec $7a
L2740
	ldy $3163,x
	lda $3167,x
	sta $3202
L2749
	jsr S2835
	beq L27c8
	sec
	sbc #$30
	bcc L27c8
	cmp #$0a
	bcc L275d
	sbc #$07
	cmp #$10
	bcs L27c8
L275d
	sta $3201
	cpy $3201
	bcc L27c6
	beq L27c6
	inc $3200
	cpy #$0a
	bne L2778
	ldx #$02
L2770
	lda $60,x
	sta $3203,x
	dex
	bpl L2770
L2778
	ldx $3202
L277b
	asl $60
	rol $61
	rol $62
	bcs L27c6
	dex
	bne L277b
	cpy #$0a
	bne L27ac
	asl $3203
	rol $3204
	rol $3205
	bcs L27c6
	lda $3203
	adc $60
	sta $60
	lda $3204
	adc $61
	sta $61
	lda $3205
	adc $62
	sta $62
	bcs L27c6
L27ac
	clc
	lda $3201
	adc $60
	sta $60
	txa
	adc $61
	sta $61
	txa
	adc $62
	sta $62
	bcs L27c6
	and #$f0
	bne L27c6
	beq L2749
L27c6
	sec
	.byte $24
L27c8
	clc
	sty $3202
	pla
	tay
	pla
	tax
	lda $3200
	rts
                    
S27d4
	lda $68
	jsr S281e
	txa
	jsr CHROUT
	lda $66
	ldx $67
S27e1
	pha
	txa
	jsr S280e
	pla
S27e7
	jsr S280e
S27ea
	lda #$20
	jmp CHROUT
                    
S27ef
	lda #$0d
	jsr CHROUT
	lda #$91
	jmp CHROUT
	
S27f9
	lda #$0d
	jmp CHROUT
                    
S27fe
	pha
	lda #$0d
	jsr CHROUT
	jsr S1d85
	lda #$20
	jsr CHROUT
	pla
	rts
                    
S280e               
	stx $31fb
	jsr S281e
	jsr CHROUT
	txa
	ldx $31fb
	jmp CHROUT
                    
S281e
	pha
	jsr S2828
	tax
	pla
	lsr a
	lsr a
	lsr a
	lsr a
S2828
	and #$0f
	cmp #$0a
	bcc L2830
	adc #$06
L2830
	adc #$30
	rts
                    
S2833
	dec $7a
S2835
	stx $31fb
	ldx $7a
	lda LTK_Command_Buffer,x
	beq L2845
	cmp #$3a
	beq L2845
	cmp #$3f
L2845
	php
	inc $7a
	ldx $31fb
	plp
	rts
                    
S284d               
	lda $60
	sta $66
	lda $61
	sta $67
	lda $62
	sta $68
	rts
                    
S285a
	sec
	lda $60
	sbc $66
	sta $60
	lda $61
	sbc $67
	sta $61
	lda $62
	sbc $68
	sta $62
	rts
                    
S286e
	lda #$01
S2870
	sta $31fb
	sec
	lda $60
	sbc $31fb
	sta $60
	lda $61
	sbc #$00
	sta $61
	lda $62
	sbc #$00
	sta $62
	rts
                    
S2888
	sec
	lda $63
	sbc #$01
	sta $63
	lda $64
	sbc #$00
	sta $64
	lda $65
	sbc #$00
	sta $65
	rts
                    
S289c
	lda #$01
S289e
	clc
	adc $66
	sta $66
	bcc L28ab
	inc $67
	bne L28ab
	inc $68
L28ab
	rts
                    
S28ac 
	sec
	lda $66
	sbc #$01
	sta $66
	lda $67
	sbc #$00
	sta $67
	lda $68
	sbc #$00
	sta $68
	rts
                    
S28c0
	bcs L28ec
	jsr S284d
	jsr L26f1
	bcs L28ec
	lda $60
	sta $3203
	lda $61
	sta $3204
	lda $62
	sta $3205
	jsr S285a
	lda $60
	sta $63
	lda $61
	sta $64
	lda $62
	sta $65
	bcc L28ec
	clc
  	.byte $24 
L28ec
	sec
	rts
                    
L28ee
	jsr S26ef
	jsr S27fe
	lda #$24
	jsr CHROUT
	lda $62
	beq L2904
	jsr S281e
	txa
	jsr CHROUT
L2904
	lda $60
	ldx $61
	jsr S27e1
	jsr S27fe
	lda #$2b
	jsr CHROUT
	jsr S2944
	lda #$00
	ldx #$08
	ldy #$03
	jsr S299a
	jsr S27fe
	lda #$26
	jsr CHROUT
	lda #$00
	ldx #$08
	ldy #$02
	jsr S2984
	jsr S27fe
	lda #$25
	jsr CHROUT
	lda #$00
	ldx #$18
	ldy #$00
	jsr S2984
	jmp L1c86
                    
S2944
	jsr S284d
	lda #$00
	ldx #$07
L294b
	sta $31ec,x
	dex
	bpl L294b
	inc $31f3
	ldy #$17
	php
	sei
	sed
L2959
	lsr $68
	ror $67
	ror $66
	bcc L2970
	clc
	ldx #$03
L2964
	lda $31f0,x
	adc $31ec,x
	sta $31ec,x
	dex
	bpl L2964
L2970
	clc
	ldx #$03
L2973
	lda $31f0,x
	adc $31f0,x
	sta $31f0,x
	dex
	bpl L2973
	dey
	bpl L2959
	plp
	rts
                    
S2984
	pha
	lda $60
	sta $31ee
	lda $61
	sta $31ed
	lda $62
	sta $31ec
	lda #$00
	sta $31ef
	pla
S299a
	sta $3200
	sty $3202
L29a0
	ldy $3202
	lda #$00
L29a5
	asl $31ef
	rol $31ee
	rol $31ed
	rol $31ec
	rol a
	dey
	bpl L29a5
	tay
	bne L29c1
	cpx #$01
	beq L29c1
	ldy $3200
	beq L29c9
L29c1
	inc $3200
	ora #$30
	jsr CHROUT
L29c9
	dex
	bne L29a0
	rts
                    
S29cd
	ldx #$00
	ldy #$02
	lda #$03
	jsr S2a40
	ldy #$5f
	lda #$0a
	jsr S2a40
	lda $7a
	jsr S2a52
	lda $90
	jsr S2a52
	lda $93
	jsr S2a52
	lda $9f
	jsr S2a52
	lda $b7
	jsr S2a52
	ldy #$b9
	lda #$04
	jsr S2a40
	ldy #$c6
	lda #$02
	jsr S2a40
	lda $d0
	jsr S2a52
	lda $d7
	jsr S2a52
	lda $0100
	jsr S2a52
	lda $01ff
	jsr S2a52
	lda $02b9
	jsr S2a52
	lda $02c8
	jsr S2a52
	ldy #$31
	lda #$02
	jsr S2a40
	lda #$b9
	sta L2a43
	lda #$4a
	sta L2a43 + 1
	lda #$03
	sta L2a43 + 2
	ldy #$00
	lda #$08
S2a40
	sta L2ae1
L2a43
	lda $0000,y
	nop
	sta $35a6,x
	inx
	iny
	dec L2ae1
	bne L2a43
	rts
                    
S2a52
	sta $35a6,x
	inx
	rts
                    
L2a57
	ldx #$00
	ldy #$02
	lda #$03
	jsr S2aca
	ldy #$5f
	lda #$0a
	jsr S2aca
	jsr S2adc
	sta $7a
	jsr S2adc
	sta $90
	jsr S2adc
	sta $93
	jsr S2adc
	sta $9f
	jsr S2adc
	sta $b7
	ldy #$b9
	lda #$04
	jsr S2aca
	ldy #$c6
	lda #$02
	jsr S2aca
	jsr S2adc
	sta $d0
	jsr S2adc
	sta $d7
	jsr S2adc
	sta $0100
	jsr S2adc
	sta $01ff
	jsr S2adc
	sta $02b9
	jsr S2adc
	sta $02c8
	ldy #$31
	lda #$02
	jsr S2aca
	lda #$99
	sta $2ad0
	lda #$4a
	sta $2ad1
	lda #$03
	sta $2ad2
	ldy #$00
	lda #$08
S2aca              
	sta L2ae1
L2acd
	lda $35a6,x
	sta $0000,y
	nop
	inx
	iny
	dec L2ae1
	bne L2acd
	rts
                    
S2adc
	lda $35a6,x
	inx
	rts
                    
L2ae1
	.byte $00 
L2ae2
	clc
	ldy $7a
	lda LTK_Command_Buffer,y
	bne L2b1c
L2aea
	ldx #$00
	stx $2ed0
	stx $2ed6
	stx L2e89
	stx L2e8a
	stx L2e8b
	stx $1fc6
	dex
	stx L2e8c
	stx L2e8d
	stx L2e8e
	stx $1fcb
	stx $1fcc
	stx $1fca
	ldx #<str_NormalMem
	ldy #>str_NormalMem ;$2f13
	jsr Print_Message
	jmp L1c86
                    
;$2b1b
	.byte $38 
L2b1c
	sei
	jsr LTK_Krn_BankOut
	lda LTK_Var_ActiveLU
	pha
	php
	ldy $7a
	lda #$00
	ldx #$02
	jsr S34de
	bcc L2b3d
L2b30
	ldx #<str_InvalidBlock
	ldy #>str_InvalidBlock ;$2f4a
	jsr Print_Message
	jsr BeepIfAllowed
	jmp L2c14
                    
L2b3d
	sta $2bb3
	sty $2ed1
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L2b75
	lda $2bb3
	bne L2b55
	txa
	jsr LTK_SetLuActive
	bcc L2b62
L2b55
	ldx #<str_InvalidLU
	ldy #>str_InvalidLU ;$2f62
	jsr Print_Message
	jsr BeepIfAllowed
	jmp L2c14
                    
L2b62
	ldy $2ed1
	iny
	lda #$00
	ldx #$02
	jsr S34de
	bcs L2b30
	sty $2ed1
	sta $2bb3
L2b75
	stx $2bb1
	lda LTK_Command_Buffer,y
	cmp #$2c
	php
	ldx #$d8
	lda #$35
	ldy #$ff
	plp
	bne L2ba7
	ldy $2ed1
	iny
	lda #$00
	ldx #$02
	jsr S34de
	bcc L2ba1
L2b94
	ldx #<str_InvalidMemAddr
	ldy #>str_InvalidMemAddr ;$2f71
	jsr Print_Message
	jsr BeepIfAllowed
	jmp L2c14
                    
L2ba1
	cmp #$35
	bcc L2b94
	ldy #$00
L2ba7
	stx $2bcc
	sta $2bcd
	sty $2ed0
	ldx #$00
	ldy #$00
	lda #$00
	sta $fc5f
	pla
	pha
	sta $2c05
	lda LTK_Var_ActiveLU
	sta $1fca
	clc
	jsr S20d3
	plp
	jsr LTK_HDDiscDriver
	.byte $d8,$35,$01
L2bcf                    
	.byte $b2,$c2,$d2
L2bd2
	sec
	jsr S20d3
	pla
	sta LTK_Var_ActiveLU
	jsr LTK_Krn_BankIn
	ldx #$ff
	stx L2e8c
	inx
	stx L2e89
	stx L2e8a
	stx L2e8b
	stx L2e8e
	stx $1fcb
	stx $1fcc
	stx $66
	stx $67
	stx $68
	inx
	stx L2e8d
	cli
	ldx #<str_BlockRead
	ldy #>str_BlockRead ;$2f2d
	lda #$00
	pha
	plp
	bcc L2c0e
	ldx #<str_BlockWritten
	ldy #>str_BlockWritten ;$2f3a
L2c0e
	jsr Print_Message
	jmp L1c86
                    
L2c14
	pla
	pla
	sta LTK_Var_ActiveLU
	jsr LTK_Krn_BankIn
	cli
	jmp L1ccb
                    
L2c20
	sei
	jsr LTK_Krn_BankOut
	lda LTK_Var_ActiveLU
	pha
	lda LTK_Var_Active_User
	pha
	ldy $7a
	lda #$00
	ldx #$02
	jsr S34de
	pha
	bcs L2c59
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L2c59
	pla
	beq L2c4f
L2c42
	ldx #<str_InvalidLU
	ldy #>str_InvalidLU ;$2f62
	jsr Print_Message
	jsr BeepIfAllowed
	jmp L2cdd
                    
L2c4f               
	txa
	iny
	sty $7a
	jsr LTK_SetLuActive
	bcs L2c42
	pha
L2c59
	pla
	ldy $7a
	lda #$00
	ldx #$02
	jsr S34de
	pha
	bcs L2c88
	lda LTK_Command_Buffer,y
	cmp #$3a
	bne L2c88
	pla
	beq L2c7d
L2c70
	ldx #<str_InvalidUser
	ldy #>str_InvalidUser ;$2f8a
	jsr Print_Message
	jsr BeepIfAllowed
	jmp L2cdd
                    
L2c7d
	cpx #$10
	bcs L2c70
	stx LTK_Var_Active_User
	iny
	sty $7a
	pha
L2c88
	pla
	jsr LTK_ClearHeaderBlock
	ldy $7a
	ldx #$00
L2c90
	lda LTK_Command_Buffer,y
	sta LTK_FileHeaderBlock,x
	beq L2c9e
	iny
	inx
	cpx #$10
	bne L2c90
L2c9e
	jsr LTK_FindFile
	bcc L2cb0
	ldx #<str_FileNotFound
	ldy #>str_FileNotFound ;$2f9b
	jsr Print_Message
	jsr BeepIfAllowed
	jmp L2cdd
                    
L2cb0
	lda #$ff
	sta $2ed6
	sta $2ed0
	sta $1fcb
	sta $1fcc
	lda LTK_Var_ActiveLU
	sta $1fca
	jsr S2d88
	pla
	sta LTK_Var_Active_User
	pla
	sta LTK_Var_ActiveLU
	jsr LTK_Krn_BankIn
	cli
	ldx #<str_FileSelected
	ldy #>str_FileSelected ;$2fc7
	jsr Print_Message
	jmp L1c86
                    
L2cdd
	pla
	sta LTK_Var_Active_User
	pla
	sta LTK_Var_ActiveLU
	jsr LTK_Krn_BankIn
	cli
	jmp L1ccb
                    
L2cec
	bit $2ed6
	bmi L2cff
L2cf1
	ldx #<str_NoFileSelected
	ldy #>str_NoFileSelected ;$2fe9
	jsr Print_Message
	jsr BeepIfAllowed
	cli
	jmp L2aea
                    
L2cff
	lda $1fca
	cmp #$ff
	beq L2cf1
	sei
	jsr LTK_Krn_BankOut
	ldx $9201
	ldy $9200
	stx $2bb1
	sty $2bb3
	clc
	jsr LTK_HDDiscDriver
	.byte $d8,$35,$01
                    
	jsr LTK_Krn_BankIn
	ldx #$ff
	stx $2ed0
	stx L2e8c
	inx
	stx $2ed6
	stx L2e89
	stx L2e8a
	stx L2e8b
	stx L2e8e
	stx $1fcb
	stx $1fcc
	stx $66
	stx $67
	stx $68
	inx
	stx L2e8d
	lda #$0d ;carriage return
	jsr CHROUT
	lda #$12
	jsr CHROUT
	lda $1fca
	pha
	and #$0f
	jsr S2d75
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	jsr S2d75
	ldx #$d8
	ldy #$35
	jsr Print_Message
	ldx #<str_HeaderSelected
	ldy #>str_HeaderSelected ;$2ffd
	jsr Print_Message
	cli
	jmp L1c86
                    
S2d75
	clc
	adc #$30
	cmp #$3a
	bcc L2d7f
	clc
	adc #$07
L2d7f
	jsr CHROUT
	lda #$3a
	jsr CHROUT
	rts
                    
S2d88
	ldx #$00
	stx L2e86
	stx L2e87
	stx L2e88
	ldy #$02
	lda $91f8
	cmp #$0b
	bcc L2dcc
	sty $2db8
	dey
	sty $2db2
	dey
	lda $91f1
	ldx $91f0
	bne L2db0
	cmp #$f1
	bcc L2dca
L2db0
	iny
	cpx #$00
	bcc L2dca
	bne L2dbd
	cmp #$00
	bcc L2dca
	beq L2dca
L2dbd
	inc $2db8
	bne L2dc5
	inc $2db2
L2dc5
	inc $2db2
	bne L2db0
L2dca
	iny
	iny
L2dcc
	sty $2ddd
	lda $91f1
	ldy $91f0
	bne L2ddb
	cmp #$02
	beq L2df6
L2ddb
	sec
	sbc #$00
	sta L2e88
	bcs L2de4
	dey
L2de4
	tya
	sta L2e87
	ldy #$09
L2dea
	asl L2e88
	rol L2e87
	rol L2e86
	dey
	bne L2dea
L2df6
	ldy $91fc
	lda $91f9
	and #$01
	bne L2e06
	cpy #$00
	bne L2e06
	lda #$02
L2e06
	pha
	tya
	clc
	adc L2e88
	sta L2e88
	pla
	adc L2e87
	sta L2e87
	bcc L2e1b
	inc L2e86
L2e1b
	lda L2e88
	sec
	sbc #$01
	sta L2e88
	lda L2e87
	sbc #$00
	sta L2e87
	lda L2e86
	sbc #$00
	sta L2e86
	lda $91fb
	ldx $91fa
	ldy $91f8
	cpy #$0b
	beq L2e56
	cpy #$0c
	beq L2e56
	cpy #$02
	beq L2e56
	lda $91f3
	ldx $91f2
	cpy #$03
	beq L2e56
	lda #$00
	tax
L2e56
	sta L2e89
	stx L2e8a
	sta $66
	stx $67
	lda #$00
	sta L2e8b
	sta $68
	lda L2e88
	clc
	adc L2e89
	tax
	lda L2e87
	adc L2e8a
	tay
	lda L2e86
	adc L2e8b
	stx L2e8c
	sty L2e8d
	sta L2e8e
	rts
                    
L2e86
	.byte $00
L2e87	
	.byte $00 
L2e88
	.byte $00 
L2e89	
	.byte $00 
L2e8a
	.byte $00 
L2e8b
	.byte $00 
L2e8c	
	.byte $ff 
L2e8d	
	.byte $ff 
L2e8e
	.byte $ff 
L2e8f               
	lda $2ed4
	bne L2eb5
	ldx #<str_PrinterOn
	ldy #>str_PrinterOn ;$3012
	jsr Print_Message
	jsr S2ed7
	bit $90
	bpl L2eaf
	ldx #<str_DeviceNotPresent
	ldy #>str_DeviceNotPresent ;$3034
	jsr Print_Message
	jsr BeepIfAllowed
	jmp L1c86
                    
L2eaf
	dec $2ed4
	jmp L1c86
                    
L2eb5
	jsr S2ef5
	inc $2ed4
	ldx #<str_PrinterOff
	ldy #>str_PrinterOff ;$3023
	jsr Print_Message
	jmp L1c86
                    
L2ec5
	ldx #<str_Help
	ldy #>str_Help ;$3206
	jsr Print_Message
	jmp L1c86
                    
L2ecf
	.byte $00,$00,$00,$00,$00,$00,$00,$00 
	
S2ed7
	lda #$00
	jsr SETNAM
	lda #$01
	ldx $2ed2
	ldy $2ed3
	jsr SETLFS
	jsr OPEN
S2eea
	ldx #$01
	jsr CHKOUT
	lda #$0d
	jsr CHROUT
	rts
                    
S2ef5
	jsr S2eea
	lda #$20
	jsr CHROUT
	lda #$0d
	jsr CHROUT
	lda #$01
	clc
	jsr CLOSE
	lda #$03
	sta $9a
	lda #$00
	sta $99
	sta $90
	rts
                    
str_NormalMem ;$2f13               
	.text "{return}{rvs on}normal memory selected{return}"
	.byte $00 
str_BlockRead ;$2f2d
	.text "{return}{rvs on}block read"
	.byte $00 
str_BlockWritten ;$2f3a               
	.text "{return}{rvs on}block written"
	.byte $00 
str_InvalidBlock ;$2f4a               
	.text "{return}{rvs on}invalid block address"
	.byte $00 
str_InvalidLU ;$2f62               
	.text "{return}{rvs on}invalid lu #"
	.byte $00 
str_InvalidMemAddr ;$2f71               
	.text "{return}{rvs on}invalid memory address"
	.byte $00 
str_InvalidUser ;$2f8a               
	.text "{return}{rvs on}invalid user #"
	.byte $00 
str_FileNotFound ;$2f9b               
	.text "{return}{rvs on}file does not exist"
	.byte $00 
str_NonExistAddr ;$2fb1               
	.text "{return}{rvs on}nonexistant address"
	.byte $00 
str_FileSelected ;$2fc7               
	.text "{return}{rvs on}file selected"
	.byte $00 
str_Aborted  ;$2fd7             
	.text "{return}{rvs on}lkmon aborted{return}{return}"
	.byte $00 
str_NoFileSelected ;$2fe9               
	.text "{return}{rvs on}no file selected{return}"
	.byte $00 
str_HeaderSelected ;$2ffd               
	.text "{rvs off}   header selected{return}"
	.byte $00 
str_PrinterOn ;$3012               
	.text "{return}{return}printer  {rvs on}on{return}{return}"
	.byte $00 
str_PrinterOff ;$3023               
	.text "{return}{return}printer  {rvs on}off{return}"
	.byte $00 
str_DeviceNotPresent ;$3034               
	.text "{return}{return}device not present !{return}"
	.byte $00 
str_Startup ;$304c               
	.text "{return}{return}{rvs on}lt. kernal monitor (v3.1){return}{return}enter a  "
	.byte $5c ;british pound sign 
	.text "  for help{return}{return}"
	.byte $00
                    
L3081                  
	.byte $40,$02,$45,$03,$d0,$08,$40,$09
	.byte $30,$22,$45,$33,$d0,$08,$40,$09
        .byte $40,$02,$45,$33,$d0,$08,$40,$09
        .byte $40,$02,$45,$b3,$d0,$08,$40,$09
        
        .byte $00,$22,$44,$33,$d0,$8c,$44,$00
        .byte $11,$22,$44,$33,$d0,$8c,$44,$9a 
        .byte $10,$22,$44,$33,$d0,$08,$40,$09
        .byte $10,$22,$44,$33,$d0,$08,$40,$09
        
        .byte $62,$13,$78,$a9
L30c5                              
	.byte $00,$21,$81,$82,$00,$00,$59,$4d
	.byte $91,$92,$86,$4a,$85,$9d,$2c,$29
	.byte $2c,$23,$28,$24,$59,$00,$58,$24
	.byte $24,$00 
	
L30df                                                            
	.byte $1c,$8a,$1c,$23,$5d,$8b,$1b,$a1
	.byte $9d,$8a,$1d,$23,$9d,$8b,$1d,$a1
	.byte $00,$29,$19,$ae,$69,$a8,$19,$23
	.byte $24,$53,$1b,$23,$24,$53,$19,$a1
	.byte $00,$1a,$5b,$5b,$a5,$69,$24,$24
	.byte $ae,$ae,$a8,$ad,$29,$00,$7c,$00
	.byte $15,$9c,$6d,$9c,$a5,$69,$29,$53
	.byte $84,$13,$34,$11,$a5,$69,$23,$a0
	
L311f
	.byte $d8,$62,$5a,$48,$26,$62,$94,$88
	.byte $54,$44,$c8,$54,$68,$44,$e8,$94
	.byte $00,$b4,$08,$84,$74,$b4,$28,$6e
	.byte $74,$f4,$cc,$4a,$72,$f2,$a4,$8a
	.byte $00,$aa,$a2,$a2,$74,$74,$74,$72
	.byte $44,$68,$b2,$32,$b2,$00,$22,$00
	.byte $1a,$1a,$26,$26,$72,$72,$88,$c8
	.byte $c4,$ca,$26,$48,$44,$44,$a2,$c8
	.byte $0d,$20,$20,$20
	
L3163
	.byte $10,$0a,$08,$02
L3167                                    
	.byte $04,$03,$03,$01,$41,$43,$44,$46
	.byte $21,$48,$4a,$4d,$4e,$54,$58,$21
	.byte $2e,$3e,$3b,$21,$21,$21,$21,$21
L317f                                                            
	.byte $24,$2b,$26,$25,$4c,$53,$21,$52
	.byte $57,$50,$47,$5c,$5f,$21,$21,$21
	.byte $21,$06,$24,$07,$22,$b7,$25,$d9
	.byte $23,$9c,$21,$c9,$22,$33,$1d,$13
	.byte $21,$10,$21,$0a,$22,$08,$1d,$9c
	.byte $21,$06,$24,$64,$21,$9c,$21,$9c
	.byte $21,$9c,$21,$9c,$21,$9c,$21,$9c
	.byte $21,$e1,$2a,$1a,$2b,$8e,$2e,$1f
	.byte $2c,$c4,$2e,$eb,$2c,$9c,$21,$9c
	.byte $21,$9c,$21,$9c,$21
                    
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00
                    
L3203               
	.byte $00,$00,$00
	
str_Help ;$3206                    
	.text "{return}a=assemble    [<bssss> - command]{return}"
	.text "c=compare mem [ bssss  beeee  bwwww ]{return}"
	.text "d=disassemble [<bssss><beeee>]{return}"
	.text "f=fill memory [ bssss  beeee  data ]{return}"
	.text "g=get a file  [<lu:><user:>filename]{return}"
	.text "h=hunt memory [ bssss  beeee  target ]{return}"
	.text "l=load file   [<,dv. #><,mem. adr>],{return}"
	.text "m=memory dump [<bssss><beeee>]{return}"
	.text "p=printer     [toggle on/off]{return}"
	.text "r=read block  [<lu:><user:>blk. adr.] *{return}"
	.text "s=save file   [ dv#  str adr  end adr]{return}"
	.text "t=xfer memory [ bssss  beeee  bdddd ]{return}"
	.text "w=write block [<lu:><user:>blk. adr.]{return}"
	.text "x=exit lkmon{return}{return}where:{return}  "
	.text "(b)=bank number <2=host adapter>{return}  "
	.text "(ssss)=starting memory address{return}  "
	.text "(eeee)=ending memory address{return}  "
	.text "(wwww)=with memory address{return}  "
	.text "(dddd)=destination memory address{return}"
	.text "* an r by itself deselects any file or{return}  "
	.text "block and defaults back to ram."
	.byte $00 
S34de
	sta L34ef + 1
	stx L34ef + 2
	lda #$00
	sta L3559
	sta $355a
	sta $355b
L34ef
	lda L34ef,y
	cmp #$30
	bcc L3547
	cmp #$3a
	bcc L350c
	ldx $3518
	cpx #$0a
	beq L3547
	cmp #$41
	bcc L3547
	cmp #$47
	bcs L3547
	sec
	sbc #$07
L350c
	ldx L3559
	beq L3530
	pha
	tya
	pha
	lda #$00
	tax
	ldy #$0a
L3519
	clc
	adc $355b
	pha
	txa
	adc $355a
	tax
	pla
	dey
	bne L3519
	sta $355b
	stx $355a
	pla
	tay
	pla
L3530
	inc L3559
	sec
	sbc #$30
	clc
	adc $355b
	sta $355b
	bcc L3544
	inc $355a
	beq L3551
L3544
	iny
	bne L34ef
L3547
	cmp #$20
	beq L3544
	clc
	ldx L3559
	bne L3552
L3551
	sec
L3552
	lda $355a
	ldx $355b
	rts
                    
L3559
	.byte $00,$00,$00 
	
BeepIfAllowed               
	lda LTK_BeepOnErrorFlag
	beq L359b
	ldy #$18
	lda #$00
L3565
	sta SID_V1_FreqLo,y
	dey
	bpl L3565
	sty SID_V1_SR
	lda #$51
	sta SID_V1_FreqHi
	sta SID_V1_Control
	iny
L3577
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_timer
	iny
	tya
	cmp #$10
	bne L3577
	ldx #$50
	jsr beep_timer
	ldy #$10
	sta SID_V1_Control
L358f
	dey
	sty SID_VolumeAndFilter
	ldx #$01
	jsr beep_timer
	tya
	bne L358f
L359b
	rts
                    
beep_timer
	dec beep_delay
	bne beep_timer
	dex
	bne beep_timer
	rts
                    
beep_delay
	.byte $00 