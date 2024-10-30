ASSUME CS:CODE,DS:DATA,ES:EXTRA
DATA SEGMENT
    M1 DB 10 ,13, "ENTER STRING(DELIMITER: `): $"
    M2 DB 10, 13, "NUMBER OF VOWELS: $"
    M3 DB 10, 13, "NUMBER OF DIGITS: $"
    M4 DB 10, 13, "NUMBER OF CONSONANTS: $"
    INSTR DB "Hello123"
    MAXLEN DB 0AH
    DELIM DB "`"
    VCNT DB 00H
    DGCNT DB 00H
    CNCNT DB 00H
DATA ENDS
EXTRA SEGMENT
    VWSTR DB "aeiouAEIOU"
    DGSTR DB "0123456789"
EXTRA ENDS
PRTMSG MACRO MESSAGE
    LEA DX, MESSAGE
    MOV AH, 09
    INT 21H
    ENDM
PRTCNT MACRO COUNT
    MOV DL, COUNT
    ADD DL, 30H
    MOV AH, 02
    INT 21H
    ENDM
CODE SEGMENT
    START: MOV AX, DATA
    MOV DS, AX
    MOV AX, EXTRA
    MOV ES, AX
    LEA SI, INSTR
    PRTMSG M1
    MOV BX, 00
    MOV CH, 00H
    MOV CL, MAXLEN
    MOV AH, 01
    GETC: INT 21H
    CMP AL, DELIM
    JE ENDGET
    INC BL
    MOV [SI], AL
    INC SI
    LOOP GETC
    ENDGET: CLD
    LEA SI, INSTR
    CHKA: MOV AX, [SI]
    INC SI
    MOV CL, 0AH
    LEA DI, VWSTR
    REPNZ SCASB
    JNE CHKD
    INC VCNT
    JMP ENDC
    CHKD: MOV CL, 0AH
    LEA DI, DGSTR
    REPNZ SCASB
    JNE CHKC
    INC DGCNT
    JMP ENDC
    CHKC: INC CNCNT
    ENDC: MOV CL, BL
    DEC BX
    LOOP CHKA
    PRTMSG M2
    PRTCNT VCNT
    PRTMSG M3
    PRTCNT DGCNT
    PRTMSG M4
    PRTCNT CNCNT
    MOV AH, 4CH
    INT 21H
    CODE ENDS
END START
