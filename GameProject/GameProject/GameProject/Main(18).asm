.386
.model flat, stdcall
option casemap : none

; ================ TODO - LIST ================
; ��ƣ�
; 1.�Ѷ�ϵͳ���Ѷ�Խ�� ��Խ�� ת��Խ�죨��ѡ����������

; 2.��ʼ��Ϸ��ť���֣����Լ�������ƶ���ȥ��ɫ��������ɣ�������ͨ��������ͼ������ѡ���������

; 3.���Ծ���ģʽ���޾�ģʽ����ʱģʽ����ѹģʽ������ģʽ���������޾�ģʽ�����ӣ���ʱģʽ�ﵽ�������Ի�����ģʽû�е÷ֺ����֣��������޾�һ����

; 4.������һЩС��Ĳ�ͬƤ�����ã������ͼƬ�Ϳ��ԣ�������Ҳ���ԣ�������ѡ���������

; ���룺
; 1.����������Ϸģʽ�л���������㼸����ť��

; 4.������С�������ƶ��Ķ��� ����������



; ================ ���ÿⲿ�� ================
includelib D:/masm32/lib/msvcrt.lib
include D:/masm32/include/windows.inc

includelib D:/masm32/lib/user32.lib
include D:/masm32/include/user32.inc

includelib D:/masm32/lib/kernel32.lib
include D:/masm32/include/kernel32.inc

includelib D:/masm32/lib/gdi32.lib
include D:/masm32/include/gdi32.inc

includelib D:/masm32/lib/Winmm.lib
include D:/masm32/include/Winmm.inc

includelib D:/masm32/lib/Advapi32.lib
include D:/masm32/include/Advapi32.inc

includelib D:/masm32/lib/Msimg32.lib
include D:/masm32/include/Msimg32.inc


; ================ ���ú������� ================
strlen PROTO C : dword
strcat PROTO C : dword, :dword
printf PROTO C : dword, : vararg
srand PROTO C : dword
rand PROTO C

; wsprintf proto : sbyte ptr, : sbyte ptr, : DWORD, : DWORD
; LoadImage proto : IMAGE, sbyte ptr, : DWORD, : DWORD

; ================ �Զ����ಿ�� ================

; ��ť�ඨ��
BUTTON_INFO STRUCT
start_x     dd      0
end_x       dd      0
start_y     dd      0
end_y       dd      0
BUTTON_INFO ENDS





; ================ Ԥ���岿�� ================
; ��ť����
STATUS_START             equ           1; ��ʼ����
STATUS_GAMING            equ           2; ��Ϸ����
STATUS_END               equ           3; ���㴰��


; ��겿��
MOUSE_IDLE              equ           0

; ��ɫ����
color_white       equ     0FFFFFFH
color_black       equ     0000000H
color_blue        equ     0E6E6FAH
color_background  equ     0FC9D9AH; ����ɫ������͸����ʱ����
color_yellow      equ     07B68EEH
color_pb          equ     0B0E0E6H
color_mw          equ     0F6F6F6H

; �����������ɫ�����Դ���һ������



; ����֡��Ϊ 60
gframerate         equ     60






; ��ʱ���Ĳ�ͬ״̬
Timer_Render            equ           1
Timer_Animate           equ           2
Timer_sunGenerate       equ           3
Timer_Bullet            equ           4
Timer_GameRule          equ           5





; ================ ���ݶ�(ȫ�ֱ���) ================
.DATA

; ������
menuinfo dd 0
flushflag dd 0
checkangle dd 0
startflag dd 0; �ж��Ƿ�ոյ���˿�ʼ��Ϸ�������¿�ʼ��

; �������
pin_x dd 360
pin_y dd 100
value1 dd 0
value2 dd 0
cir_value1 dd 0
cir_value2 dd 0
temp_jiaodu dd 0
totalnum dd 4
currentnum dd 0

; ��¼�����ɫ����
color_array dword 0E6E6FAH, 01E90FFH, 0FFDAB9H, 0FFC0CBH, 098FB98H
color_flag dd 0

; �ı��ٶȵı���
int_increase_angle dd 0
change_time dd 0
change_flag dd 0
top_angle dd 0
low_angle dd 0

; ��������
jiaodu real8 270.0
hudu real8 0.0
angle_value real8 180.0
cosineFmt real8 0.0
sineFmt real8 0.0
pinlenth real8 125.0
value real8 1.1
increase_angle real8 2.0
; cir_jiaodu real8 270.0
cir_cos real8 0.0
cir_sin real8 0.0
cir_hudu real8 0.0
cir_lenth real8 200.0
decrease_jiaodu real8 360.0
different_cir real8 180.0
yuanjiaodu real8 0.0
init_angle real8 270.0

; ��¼ÿ����ĽǶȵ�����
pin_angle real8 0.0, 1000 dup(0.0)

; �����Ƕ�������Ҫ�ı���
seed        dd 0; ����ֵ
random_angle dd 0
final_angle real8 0.0
temp_angle real8 0.0
abs dd 0
numberofpin dd 1
angle_change dd 0

score dd 0
pin_goal_number dd 0
get_increase_angle dd 0


Msg db "the number is %d", 0
Msg2 db "the angle is %lf", 0
loseMsg db "You Lost!", 0
Msg3 db "change_time is %d", 0
Numstr     sbyte  '0', 50 dup(0)
Numstr2     sbyte  '0', 50 dup(0)
; �������
pinX dd 100
pinY dd 100

; ��������
playmusic dd 1
soundflag dd 0

; ����ͼƬ
himg_bg  dd 0
himg_bg2  dd 0
testloop  dd 100
himg_bg7  dd 0
himg_bg9  dd 0
himg_bg13  dd 0

; ��ťͼƬ
himg_bg8  dd 0

; ʧ��ͼƬ
himg_bg3  dd 0
himg_bg5  dd 0

; ���¿�ʼͼƬ
himg_bg4  dd 0

; ����ͼƬ
himg_bg6  dd 0

;�ɹ�ҳ��
himg_bg10 dd 0

;��һ��ͼƬ
himg_bg11 dd 0

;�޾�ģʽͼƬ
himg_bg12 dd 0
endlessmodel dd 0

; ��ʼ�����
hInstance   HANDLE  0; ����ʵ�����
hdc         HDC     NULL; ��ʾ�豸�����ĵľ��
hDCMem      HDC     NULL; ˫����ʵ��������
hMainWindow HANDLE  0; �����ھ��
hbutton     HANDLE  0; ��ʼ��ť���
heap        HANDLE  0; ����Ķѿռ�
bithdc      HDC     80 DUP(NULL); �ܶ�������������ͼƬ�ʹ���
hCryptProv  HANDLE  0
gamefont    HFONT   NULL
scorefont   HFONT   NULL


; ���ʺͻ�ˢ�����������Ļ滭
hpen        HPEN    NULL
hpenxuxian  HPEN    NULL
hbrush      HBRUSH  NULL
hbrushnull  HBRUSH  NULL
hBrush      HBRUSH  NULL


; ��ͼ�ͻ��ʲ���
backgroundinfo BITMAP <>
bitmapinfo  BITMAP  <>
Paintinfo   PAINTSTRUCT <>

loseinfo  BITMAP <>
muteinfo  BITMAP <>
successinfo BITMAP <>
restartinfo BITMAP <>
cjdlinfo  BITMAP <>
gamebackgroundinfo  BITMAP <>
fuckgamebuttoninfo   BITMAP <>
backmainwindowinfo  BITMAP <>
xyginfo  BITMAP <>
endlessbuttoninfo  BITMAP <>
niubiinfo   BITMAP <>

; �ṹ��ָ��
startbutton BUTTON_INFO{ 0,0,0,0 }
mutebutton BUTTON_INFO{ 0,0,0,0 }
restartbutton BUTTON_INFO{ 0,0,0,0 }
fuckgamebutton BUTTON_INFO{ 0,0,0,0 }
backbutton  BUTTON_INFO{ 0,0,0,0 }
xyg  BUTTON_INFO{ 0,0,0,0 }
endlessbutton BUTTON_INFO{ 0,0,0,0 }

; ��궯��
MouseStatus           BYTE          MOUSE_IDLE

; ˫����λͼ
hBmpMem     HBITMAP  NULL; λͼ˫����
hPreBmp     HBITMAP  NULL; λͼ˫����

; ================ ������ ================
.const

; name of window classes
ClassName db "SimpleWinClass", 0
ButtonClassName db "ButtonClass", 0

; �ַ���
AppName   db "�������", 0
ButtonName   db "Start Button", 0




; ���ڴ�С����
mainW_width  dd  720
mainW_height dd  1080




szTestMessage db "Clicked button!", 0
format db "totalnum = %d", 0
szTest1     db "1", 0
szTest2     db "0", 0

; PinCircleWidth  dd 10; ����Ϸ���Բ�İ뾶
; PinLength       dd 100; ��ĳ���


font1      db    "Mistral", 0; ʹ�õ�����

StartText  BYTE "Start Game!", 0
Scorestr   BYTE  "�÷֣�", 0
scoretext  BYTE  "ʣ��������", 0
fucktext   BYTE  "��ѹģʽ", 0
endlesstext   BYTE  "�޾�ģʽ", 0


; ͼƬurl
url_background db "resource\image\background.bmp", 0
url_startbutton db "resource\image\scoremodel.bmp", 0
url_starttext db "resource\image\text.bmp", 0
url_lose db "resource\image\lose.bmp", 0
url_mutebutton db "resource\image\mutebutton.bmp", 0
url_restart db "resource\image\cxks.bmp", 0
url_cjdl db "resource\image\cjdl.bmp", 0
url_gamebackground db "resource\image\gamebackground.bmp", 0
url_fuckgame db "resource\image\fuckgamebutton.bmp", 0
url_backwindow db "resource\image\backwindow.bmp", 0
url_success db "resource\image\cgcg.bmp", 0
url_xyg db "resource\image\xyg.bmp", 0
url_endlessbutton db "resource\image\endlessmodel.bmp", 0
url_niubi db  "resource\image\niubi.bmp", 0

; ����
musicload db "music.wav", 0
music2 db "MouseClick", 0
musicload2 db "cjdl.wav", 0
musicfuck db "kknice.wav", 0

; ================ δ��ʼ�����ݶ� ================
; .DATA ? ; Uninitialized
; hInstance HINSTANCE ?
CommandLine LPSTR ?






; ========================================
; ================ ����� ================
; ========================================

.CODE
; ================ ���������� ================

; Todo�����ܻ����б�İ�ť �˺�����Ӧ�޸�
; �ж��Ƿ񵥻����˿�ʼ��ť�ĺ���

; ����ת�ַ����ĺ���

inttostrx proc x : dword
    pushad
    .IF x == 0
        invoke strlen, offset Numstr2
        sub eax,1
        xor edx,edx
        .WHILE eax > 0
             mov Numstr2[eax],dl
             dec eax
        .ENDW
        add edx,'0'
        xor ebx,ebx
        mov Numstr2[ebx],dl
        ret
    .ENDIF
    xor ecx, ecx; ����
    mov eax, x; ������
    .WHILE eax > 0
    xor edx, edx
    mov ebx, 10
    div ebx
    add edx, '0'
    push edx
    inc ecx
    .ENDW
    xor ebx, ebx
    .WHILE ecx > 0
    xor edx, edx
    pop edx
    mov Numstr2[ebx], dl
    inc ebx
    dec ecx
    .ENDW
    popad
    ret
inttostrx endp




inttostr proc x : dword
pushad
.IF x == 0
    invoke strlen, offset Numstr
    sub eax,1
    xor edx,edx
    .WHILE eax > 0
         mov Numstr[eax],dl
         dec eax
    .ENDW
    add edx,'0'
    xor ebx,ebx
    mov Numstr[ebx],dl
    ret
.ENDIF
xor ecx, ecx; ����
mov eax, x; ������
.WHILE eax > 0
xor edx, edx
mov ebx, 10
div ebx
add edx, '0'
push edx
inc ecx
.ENDW
xor ebx, ebx
.WHILE ecx > 0
xor edx, edx
pop edx
mov Numstr[ebx], dl
inc ebx
dec ecx
.ENDW
popad
ret
inttostr endp

; ���pin_angle�Ƕ�����ĺ���
random_array proc
loop1 :
invoke GetTickCount
mov seed, eax

; ����C�����������ɺ��� rand
invoke srand, seed
invoke rand

mov ebx, 10
div ebx

; ��������ĸ���С��1
.if edx == 0
jmp loop1
.endif
.if edx == 1
jmp loop1
.endif
mov totalnum, edx


; invoke printf, offset format, totalnum
invoke GetTickCount
mov seed, eax
invoke srand, seed
xor ecx, ecx
mov ecx, 1
.while ecx <= totalnum
; ����һ�������
push ecx
; ����C�����������ɺ��� rand
chonglai :
invoke rand
mov ebx, 360
div ebx
mov random_angle, edx
; invoke printf, offset format2, random_angle

; ���õ�������ת����Ϊ������
finit
; mov eax, random_angle
fild dword ptr[random_angle]
pop ecx
fstp[pin_angle[8 * ecx]]
push ecx
xor esi, esi
mov numberofpin, esi
.while numberofpin < ecx
    fld pin_angle[8 * ecx]
    mov esi, numberofpin
    fsub pin_angle[8 * esi]
    fabs
    fistp dword ptr[abs]
    .if abs <= 5
    jmp chonglai
    .endif
    .if abs >= 355
    jmp chonglai
    .endif
    add numberofpin, 1
    .endw
    ; invoke printf, offset format, pin_angle[8 * ecx]
    pop ecx
    add ecx, 1

    .endw
    ret
    random_array endp



    ClickedButton proc p_x : DWORD, p_y : DWORD
    startpage :
pushad
xor eax, eax
xor ebx, ebx
mov ebx, p_x
; �ص���ťλ��(���ж�)
.IF ebx > backbutton.start_x && ebx < backbutton.end_x
    mov ebx, p_y
    .IF ebx > backbutton.start_y && ebx < backbutton.end_y
    ; �����Ч
    invoke PlaySound, offset music2, NULL, SND_ASYNC
    mov eax, 0
    mov menuinfo, eax
    mov endlessmodel, 0
    invoke random_array
    invoke InvalidateRect, hMainWindow, NULL, TRUE
    invoke UpdateWindow, hMainWindow
    xor eax, eax
    mov eax, 1
    .ENDIF
    .ENDIF
; ������ťλ��(���ж�)
.IF ebx > mutebutton.start_x && ebx < mutebutton.end_x
    mov ebx, p_y
    .IF ebx > mutebutton.start_y && ebx < mutebutton.end_y
    ; �����Ч����ȡ�����ֵ�Ч��
    .IF playmusic == 1
    invoke PlaySound, offset music2, NULL, SND_ASYNC
    mov playmusic, 0
    jmp gamestartbutton
    .ENDIF

    .IF playmusic == 0
    invoke PlaySound, offset musicload, NULL, SND_ASYNC
    mov playmusic, 1
    .ENDIF
  .ENDIF
.ENDIF

    cmp menuinfo, 1
    je game
    cmp menuinfo, 2
    je lose
    cmp menuinfo, 3
    je fuckgameclick
    cmp menuinfo, 4
    je success



    ; ��ʼ��Ϸλ��
    gamestartbutton :
.IF ebx > startbutton.start_x && ebx < startbutton.end_x
        mov edx, p_y
    .IF edx > startbutton.start_y && edx < startbutton.end_y
    ; �����Ч
    
    mov eax, 1
    mov menuinfo, eax
    invoke random_array
    mov score, 0
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    invoke GetTickCount
    mov seed, eax
    invoke srand, seed
    invoke rand
    mov ebx, 5
    div ebx
    add edx, 5
    mov pin_goal_number, edx



    invoke InvalidateRect, hMainWindow, NULL, TRUE
    invoke UpdateWindow, hMainWindow
    xor eax, eax
    mov eax, 1
    .ENDIF
    .ENDIF

    ;��ʼ�޾���Ϸλ��
  .IF ebx > endlessbutton.start_x && ebx <  endlessbutton.end_x
    mov edx, p_y
    .IF edx >  endlessbutton.start_y && edx <  endlessbutton.end_y
    ; �����Ч
    mov eax, 1
    mov menuinfo, eax
    mov endlessmodel, 1
    mov score, 0
    invoke random_array
    invoke PlaySound, offset music2, NULL, SND_ASYNC
    invoke InvalidateRect, hMainWindow, NULL, TRUE
    invoke UpdateWindow, hMainWindow
    xor eax, eax
    mov eax, 1
    .ENDIF
    .ENDIF

     ;��ʼ��ѹ��Ϸλ��
.IF ebx > fuckgamebutton.start_x && ebx < fuckgamebutton.end_x
    mov edx, p_y
    .IF edx > fuckgamebutton.start_y && edx < fuckgamebutton.end_y
    ; �����Ч
    mov score,0 
    mov eax, 3
    mov menuinfo, eax
    invoke random_array
    invoke PlaySound, offset music2, NULL, SND_ASYNC
    invoke InvalidateRect, hMainWindow, NULL, TRUE
    invoke UpdateWindow, hMainWindow
    xor eax, eax
    mov eax, 1
    .ENDIF
    .ENDIF


   

    jmp outloop


fuckgameclick :
; �ⲿ���ǽ�ѹ��Ϸ����������Ч��
mov edx, totalnum
fld init_angle
fstp[pin_angle[edx * 8]]
add edx, 1
mov totalnum, edx
add score,66
.IF score > 99999-6666
    mov menuinfo, 5
.ENDIF  
invoke InvalidateRect, hMainWindow, NULL, TRUE
invoke UpdateWindow, hMainWindow
invoke PlaySound, offset musicfuck, NULL, SND_ASYNC
mov eax, totalnum
sub eax, 1
.WHILE eax > 0
fld pin_angle[eax * 8]
push eax
;invoke printf, offset Msg2, pin_angle[eax * 8]
pop eax
fistp dword ptr[checkangle]
sub eax, 1
.ENDW
popad
ret

game:
; �ⲿ������Ϸ����������Ч��
mov edx, totalnum
fld init_angle
fstp[pin_angle[edx * 8]]
add edx, 1
mov totalnum, edx
invoke InvalidateRect, hMainWindow, NULL, TRUE
invoke UpdateWindow, hMainWindow

mov eax, totalnum
sub eax, 2
.WHILE eax > 0
fld pin_angle[eax * 8]
push eax
; invoke printf, offset Msg, eax
invoke printf, offset Msg2, pin_angle[eax * 8]
;invoke printf, offset Msg2, increase_angle
pop eax
fistp dword ptr[checkangle]
;finit
;fld qword ptr [increase_angle]
;fistp dword ptr[get_increase_angle]
;mov ebx, get_increase_angle
;add checkangle,ebx
;.if checkangle > 360
;    sub checkangle, 360
;.endif

;mov ebx, get_increase_angle
;add ebx, 270
;mov top_angle, ebx
;mov ebx, 270
;sub ebx, get_increase_angle
;mov low_angle, ebx
;mov esi, top_angle
;.if checkangle > 360
;    sub checkangle, 360
;.endif
push eax
invoke printf, offset Msg, checkangle
pop eax
.if checkangle <= 275
    .if checkangle >= 265
    ; �����ж���Ϸʧ�ܣ���Ϊ�ҵ���һ���Ƕȣ�С���ٽ�ֵ
    invoke printf, offset loseMsg
    mov eax, 2
    mov menuinfo, eax
    ; invoke printf, offset Msg, checkangle
    jmp outloop
    .endif
    .endif
    sub eax, 1
    .ENDW
    add score, 1
    sub pin_goal_number, 1
    .if pin_goal_number == 0 && endlessmodel == 0
        mov eax, 4
        mov menuinfo, eax
    .endif
    invoke printf, offset Msg, pin_goal_number


    outloop:
invoke InvalidateRect, hMainWindow, NULL, TRUE
invoke UpdateWindow, hMainWindow


; invoke printf, offset szTestMessage
popad
ret

lose:
.IF ebx > restartbutton.start_x && ebx < restartbutton.end_x
    mov ebx, p_y
    .IF ebx > restartbutton.start_y && ebx < restartbutton.end_y
    mov eax,0
    mov score,eax
    ;�ж�Ӧ�ûص���һ��ģʽ
        .IF endlessmodel == 1
            mov eax, 1
            mov menuinfo, eax
            invoke random_array
    ;bug:��ѹģʽˢ�����⣨ѡ���Խ������ֻ�е�ػ���ģʽ��ˢ�·���
        .ELSE     
            invoke random_array
            mov eax, 1
            mov menuinfo, eax
            mov endlessmodel, 0
        .ENDIF
            ;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    invoke GetTickCount
    mov seed, eax
    invoke srand, seed
    invoke rand
    mov ebx, 5
    div ebx
    add edx, 5
    mov pin_goal_number, edx

    invoke PlaySound, offset music2, NULL, SND_ASYNC
    invoke InvalidateRect, hMainWindow, NULL, TRUE
    invoke UpdateWindow, hMainWindow
    xor eax, eax
    mov eax, 1
    .ENDIF
    .ENDIF
    ret

success:
.IF ebx > xyg.start_x && ebx < xyg.end_x
    mov ebx, p_y
    .IF ebx > xyg.start_y && ebx < xyg.end_y

    mov eax, 1
    mov menuinfo, eax
    invoke GetTickCount
    mov seed, eax
    invoke srand, seed
    invoke rand
    mov ebx, 5
    div ebx
    add edx, 5
    mov pin_goal_number, edx
    invoke random_array
    invoke PlaySound, offset music2, NULL, SND_ASYNC
    invoke InvalidateRect, hMainWindow, NULL, TRUE
    invoke UpdateWindow, hMainWindow
    xor eax, eax
    mov eax, 1
    .ENDIF
    .ENDIF
    ret

    ClickedButton endp


    ; Todo: ��������굥���¼��Ĵ��������ú���ֻҪ�����ֵ����ͻ���Ӧ��
    Mouse_LeftClickCallBack proc pos_x : DWORD, pos_y : DWORD
    pushad
    cmp MouseStatus, MOUSE_IDLE
    je click
    ; invoke printf, offset szTestMessage
    jmp notclickanything
    click :
; invoke printf, offset szTestMessage
invoke ClickedButton, pos_x, pos_y

test eax, eax
jz notclickanything
; ����Ӧ����ҳ����ת����
notclickanything :
popad
ret
Mouse_LeftClickCallBack endp


; ��Բ�ĺ���
DrawCircle proc  currhdc : HDC, x : DWORD, y : DWORD, r : DWORD
LOCAL sx : DWORD
LOCAL sy : DWORD
LOCAL ex : DWORD
LOCAL ey : DWORD

pushad
invoke CreatePen, PS_SOLID, 0, color_black
mov hpen, eax


; ��Բ��ʻ�һ������Բ
invoke SelectObject, currhdc, hpen

; ���������Բ�����ڶ�Ӧ��λ��
push x
pop eax
sub eax, r
mov sx, eax
push y
pop eax
sub eax, r
mov sy, eax
push x
pop eax
add eax, r
mov ex, eax
push y
pop eax
add eax, r
mov ey, eax

invoke Ellipse, currhdc, sx, sy, ex, ey
xor eax, eax
popad
ret
DrawCircle endp



; ȷ����βԲȦλ�õĺ���
cir_position proc cir_jiaodu : real8
xor edx, edx
mov edx, 360
mov pin_x, edx
xor edx, edx
mov edx, 300
mov pin_y, edx
fldpi
fmul qword ptr[cir_jiaodu]
fstp qword ptr[cir_hudu]
; invoke printf, offset Msg, cir_hudu
fld cir_hudu
fdiv qword ptr[angle_value]
fstp qword ptr[cir_hudu]
; invoke printf, offset Msg, cir_hudu
fld cir_hudu
fsincos
fstp qword ptr[cir_cos]
fstp qword ptr[cir_sin]
; invoke printf, offset Msg, cir_cos
; invoke printf, offset Msg, cir_sin
fld qword ptr[cir_lenth]
fmul qword ptr[cir_cos]
fstp qword ptr[cir_cos]
; invoke printf, offset Msg, cir_cos
fld qword ptr[cir_lenth]
fmul qword ptr[cir_sin]
fstp qword ptr[cir_sin]
; invoke printf, offset Msg, cir_sin
fld qword ptr[cir_sin]
fistp dword ptr[cir_value1]
; invoke printf, offset Msg2, cir_value1
fld qword ptr[cir_cos]
fistp dword ptr[cir_value2]
; invoke printf, offset Msg2, cir_value2
xor edx, edx
mov edx, cir_value1
add pin_y, edx
mov edx, cir_value2
add pin_x, edx
ret
cir_position endp



; �滭��ĺ�����ȷ���˴�Բ��λ��֮��Ϳ��Խ�������ĳɽǶȣ�
; �����ֱ�Ϊ���滭�����ľ�� hdc��Բ��Բ������ x, y ���Լ��뾶�ĳ��� r ���볤�ȹ̶������û�����ò���
DrawPin proc  curhdc : HDC, x : DWORD, y : DWORD, r : DWORD, ang : real8
; �ֲ��������ڴ洢��ĺ���
LOCAL sx : DWORD
LOCAL sy : DWORD
LOCAL ex : DWORD
LOCAL ey : DWORD

; invoke printf, offset Msg, currentnum
; invoke printf, offset Msg2, ang




fld ang
; invoke printf, offset Msg2, ang
fistp dword ptr[temp_jiaodu]


.if temp_jiaodu > 360
fld ang
mov edx, currentnum
fsub qword ptr[decrease_jiaodu]
fstp qword ptr[pin_angle[edx * 8]]
fld pin_angle[edx * 8]
fstp qword ptr[ang]
; invoke printf, offset Msg2, pin_angle[edx * 4]
.endif



; .if temp_jiaodu < 0
    ;    fld ang
    ;    mov edx, currentnum
    ;    fadd qword ptr[decrease_jiaodu]
    ;    fstp qword ptr[pin_angle[edx * 8]]
    ;    fld pin_angle[edx * 8]
    ;    fstp qword ptr[ang]
    ;
; .endif


fldpi
fmul qword ptr[ang]
fstp qword ptr[hudu]
fld hudu
fdiv qword ptr[angle_value]
fstp qword ptr[hudu]
; invoke printf, offset Msg, hudu

fld hudu
fsincos

fstp qword ptr[cosineFmt]
fstp qword ptr[sineFmt]
; invoke printf, offset Msg, cosineFmt
; invoke printf, offset Msg, sineFmt
fld qword ptr[pinlenth]
fmul qword ptr[cosineFmt]
fstp qword ptr[cosineFmt]
fld qword ptr[pinlenth]
fmul qword ptr sineFmt
fstp qword ptr[sineFmt]
fld qword ptr[sineFmt]
fistp dword ptr[value1]
fld qword ptr[cosineFmt]
fistp dword ptr[value2]
; invoke printf, offset Msg2, value1
; invoke printf, offset Msg2, value2


; mov ebx, curhdc

pushad
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ˢ����ɫ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xor esi, esi
mov esi, currentnum
.while esi >= 5
sub esi, 5
.endw
invoke CreateSolidBrush, color_array[4 * esi]
mov hbrush, eax
invoke SelectObject, curhdc, hbrush



; ���������Բ�����ڶ�Ӧ��λ��
push x
pop eax
sub eax, r
mov sx, eax
push y
pop eax
sub eax, r
mov sy, eax
push x
pop eax
add eax, r
mov ex, eax
push y
pop eax
add eax, r
mov ey, eax
; �����
invoke Ellipse, curhdc, sx, sy, ex, ey






invoke MoveToEx, curhdc, x, y, NULL
xor edx, edx
mov edx, value1
add y, edx
mov edx, value2
add x, edx
invoke LineTo, curhdc, x, y
xor eax, eax
; fld qword ptr[value]
; fmul qword ptr[pinlenth]
; fstp qword ptr[pinlenth]


fld ang
fadd qword ptr[increase_angle]

mov edx, currentnum
fstp qword ptr [[pin_angle + edx * 8]]

    fld qword ptr [[pin_angle + edx * 8]]
        fistp dword ptr[temp_jiaodu]
            .if temp_jiaodu > 360
            fld qword ptr [[pin_angle + edx * 8]]
            fsub qword ptr[decrease_jiaodu]
                fstp qword ptr [[pin_angle + edx * 8]]
                .endif


                    ; fld cir_jiaodu
                    ; fadd qword ptr[increase_angle]
                    ; fstp qword ptr[cir_jiaodu]
                    ; invoke printf, offset Msg, jiaodu
                    ; invoke printf, offset hurdle

                    ; ɾ����������ٻ���
                    invoke DeleteObject, hbrush
                    popad
                    ret

                    DrawPin endp


                    ; Բ������ת������ת����
                    ; RotatePins Proc






                    ; ================ ���ں����� ================

                    ; ˢ��֡�ʣ����ڻص�������Todo��
                    Timer_RenderCallBack proc hwnd : HWND
                    ; ����Ӧ�������̵���ת����



                    Timer_RenderCallBack endp





                    ; �����ڴ�������
                    WinMain proc hInst : DWORD, hPrevInst : DWORD, CmdLine : DWORD, CmdShow : DWORD
                    LOCAL wc : WNDCLASSEX; create local variables on stack
                    LOCAL msg : MSG
                    ; LOCAL hwnd : HWND

                    ; ע�ᴰ����
                    mov   wc.cbSize, SIZEOF WNDCLASSEX; fill values in members of wc
                    ; mov   wc.style, CS_HREDRAW or CS_VREDRAW
                    mov   wc.lpfnWndProc, OFFSET WndProc
                    mov   wc.cbClsExtra, NULL
                    mov   wc.cbWndExtra, NULL
                    ; mov   wc.hbrBackground, COLOR_WINDOW + 1
                    ; mov   wc.lpszMenuName, NULL
                    mov   wc.lpszClassName, OFFSET ClassName
                    ; ��������������ͼ��
                    ; invoke LoadIcon, NULL, IDI_APPLICATION
                    ; mov   wc.hIcon, eax
                    ; mov   wc.hIconSm, eax
                    ; invoke LoadCursor, NULL, IDC_ARROW
                    ; mov   wc.hCursor, eax
                    invoke RegisterClassEx, addr wc; register window class

                    ; ����������
                    invoke CreateWindowEx, \
                    0, \
                    ADDR ClassName, \
                    ADDR AppName, \
                    WS_OVERLAPPEDWINDOW AND not WS_MAXIMIZEBOX, \
                    CW_USEDEFAULT, CW_USEDEFAULT, \
                    mainW_width, mainW_height, \
                    NULL, NULL, \
                    hInstance, \
                    NULL
                    ; ���Ϻ��������ֱ��ǣ�
                    ; ����
                    ; ���ڱ���
                    ; ���� style��Ҫ�������
                    ; ����λ�� x, y
                    ; ���ڵ� Width, Height
                    ; ��������أ�����
                    ; �뱾������صĳ���ʵ��

                    mov   hMainWindow, eax
                    mov   Paintinfo.fErase, TRUE
                    ; ���������ڽ���

                    ; ��������
                    invoke CreateFont, 100, 0, 0, 0, FW_BOLD, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
                    OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, offset font1
                    mov scorefont, eax

                    ; ��������
                    invoke PlaySound, offset musicload, NULL, SND_ASYNC

                    ; ������������ʱ��
                    invoke SetTimer, hMainWindow, Timer_Render, 1000 / gframerate, NULL; �����ֱ�Ϊ��������¼����¼�����ʱ֪ͨ���������øģ�
                    invoke SetTimer, hMainWindow, Timer_Animate, 2000, NULL; ��֡�л�һ��״̬



                    ; ע��������������ͬ�ļ�ʱ��

                    invoke CryptAcquireContext, offset hCryptProv, NULL, NULL, \
                    PROV_RSA_FULL, CRYPT_VERIFYCONTEXT





                    ; ���������ش��ھ��
                    invoke GetDC, hMainWindow
                    mov hdc, eax
                    mov ecx, 60

                    CCDC:
                push ecx
                    invoke CreateCompatibleDC, hdc
                    pop ecx
                    mov bithdc[ecx * 4 - 4], eax
                    loop CCDC



                    ; ���ر���ͼ��
                    invoke LoadImage, NULL, offset url_background, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg, eax
                    invoke LoadImage, NULL, offset url_startbutton, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg2, eax

                    ; ���d�[�򱳾��D
                    invoke LoadImage, NULL, offset url_gamebackground, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg7, eax

                    ; ����ʧ��ͼ��
                    invoke LoadImage, NULL, offset url_lose, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg3, eax

                    ; �������¿�ʼͼ��
                    invoke LoadImage, NULL, offset url_restart, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg4, eax

                    invoke LoadImage, NULL, offset url_cjdl, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg5, eax

                    ; ���ؾ���ͼ��
                    invoke LoadImage, NULL, offset url_mutebutton, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg6, eax

                    ;���ذ�ťͼ
                    invoke LoadImage, NULL, offset url_fuckgame, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg8, eax
                    invoke LoadImage, NULL, offset url_endlessbutton, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg12, eax

                    ;���ط��ش���ͼ
                    invoke LoadImage, NULL, offset url_backwindow, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg9, eax

                    ; ���ش��سɹ�ͼ��
                    invoke LoadImage, NULL, offset url_success, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg10, eax

                    ; ������һ��ͼ��
                    invoke LoadImage, NULL, offset url_xyg, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg11, eax

                    ; �������ţ��ͼ��
                    invoke LoadImage, NULL, offset url_niubi, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; �˺������ⲿ�ֲ��ø�
                    mov himg_bg13, eax

                    invoke GetObject, himg_bg, sizeof(BITMAP), offset backgroundinfo
                    invoke GetObject, himg_bg2, sizeof(BITMAP), offset bitmapinfo
                    invoke GetObject, himg_bg3, sizeof(BITMAP), offset loseinfo
                    invoke GetObject, himg_bg4, sizeof(BITMAP), offset restartinfo
                    invoke GetObject, himg_bg5, sizeof(BITMAP), offset cjdlinfo
                    invoke GetObject, himg_bg6, sizeof(BITMAP), offset muteinfo
                    invoke GetObject, himg_bg7, sizeof(BITMAP), offset gamebackgroundinfo
                    invoke GetObject, himg_bg8, sizeof(BITMAP), offset fuckgamebuttoninfo
                    invoke GetObject, himg_bg9, sizeof(BITMAP), offset backmainwindowinfo
                    invoke GetObject, himg_bg10, sizeof(BITMAP), offset successinfo
                    invoke GetObject, himg_bg11, sizeof(BITMAP), offset xyginfo
                    invoke GetObject, himg_bg12, sizeof(BITMAP), offset endlessbuttoninfo
                    invoke GetObject, himg_bg13, sizeof(BITMAP), offset niubiinfo

                    invoke SelectObject, bithdc[0], himg_bg
                    invoke SelectObject, bithdc[20], himg_bg2
                    invoke SelectObject, bithdc[24], himg_bg3
                    invoke SelectObject, bithdc[4], himg_bg4
                    invoke SelectObject, bithdc[12], himg_bg5
                    invoke SelectObject, bithdc[8], himg_bg6
                    invoke SelectObject, bithdc[16], himg_bg7
                    invoke SelectObject, bithdc[28], himg_bg8
                    invoke SelectObject, bithdc[32], himg_bg9
                    invoke SelectObject, bithdc[36], himg_bg10
                    invoke SelectObject, bithdc[40], himg_bg11
                    invoke SelectObject, bithdc[44], himg_bg12
                    invoke SelectObject, bithdc[48], himg_bg13


                    ; ��ʼ�򴰿��л�ͼ
                    ; invoke BeginPaint, hMainWindow, offset Paintinfo
                    ; mov hdc, eax
                    ; mov ebx, [himg_start]
                    ; invoke SelectObject, bithdc[24], ebx

                    ; invoke GetObject, ebx, sizeof(BITMAP), offset backgroundinfo
                    ; ����Ӧ�����ؾ��ε���ɫ���ݴ�ָ����Դ�豸�����Ĵ��䵽Ŀ���豸������
                    ; invoke TransparentBlt, bithdc[0], 200, 400, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[24], \
                    ; 0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, color_white

                    ; invoke BitBlt, hdc, 0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[0], 0, 0, SRCCOPY

                    ; invoke EndPaint, hMainWindow, offset Paintinfo


                    invoke ShowWindow, hMainWindow, SW_SHOWNORMAL; display our window on desktop
                    invoke UpdateWindow, hMainWindow; refresh the client area
                    ; invoke funcA; ����������������ģ�麯������ѡ��

                    ; Enter message loop
                    .WHILE TRUE
                    invoke GetMessage, ADDR msg, NULL, 0, 0
                    .BREAK.IF(!eax)
                    invoke TranslateMessage, ADDR msg
                    invoke DispatchMessage, ADDR msg
                    .ENDW

                    mov     eax, msg.wParam; return exit code in eax
                    ret
                    WinMain endp


                    ; ���ڽ��̺���
                    WndProc proc hWnd : HWND, uMsg : UINT, wParam : WPARAM, lParam : LPARAM
                    .IF uMsg == WM_DESTROY; if the user closes our window
                    invoke PostQuitMessage, NULL; quit application


                    ; ������ͼ��Ϣ����ʼ�滭����
                    .ELSEIF uMsg == WM_PAINT
                    .if menuinfo == 5
                        je niubiwindow
                    .endif
                    .if menuinfo == 4
                    je successwindow
                    .endif
                    .if menuinfo == 3
                    je fuckgame
                    .endif
                    .if menuinfo == 2
                    je losewindow
                    .endif
                    .if menuinfo == 0
                    je mainmenu
                    .endif
                    jmp gameWindow

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            fuckgame:
                ; ���ƽ�ѹ��Ϸģʽ
                    invoke BeginPaint, hWnd, offset Paintinfo
                    ; ������Ϸ����
                    ; ˫����
                    mov hdc, eax
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; ҳ��ˢ��
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; �L�u�[�򱳾��D
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY

                     ; ���Ʒ��ش��ڰ�ť

                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                    ; ��ʼ������
                    invoke CreatePen, PS_SOLID, 0, color_black
                    mov hpen, eax
                    invoke CreateCompatibleDC, hpen

                    ; ��Բ��ʻ�һ������Բ������Ҫ�ˣ�
                    ; invoke SelectObject, hdc, hpen
                    ; invoke Ellipse, hdc, 0, 0, 150, 150

                    ; ��ˢ�ӻ�һ���룬�Ѿ�����˷�װ�����忴 DrawPin ����
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                xor edx, edx
                    add edx, 1
                    mov currentnum, edx
                    .WHILE edx != totalnum

                    mov edx, currentnum
                    .IF edx == totalnum
                    jmp nomorepins2
                    .ENDIF
                    fld pin_angle[edx * 8]
                    ; invoke printf, offset Msg2, pin_angle[edx * 8]
                    fstp jiaodu


                    fld qword ptr jiaodu
                    fadd qword ptr[different_cir]
                    fstp qword ptr[yuanjiaodu]
                    invoke cir_position, yuanjiaodu
                    fld yuanjiaodu
                    fistp dword ptr[temp_jiaodu]
                    .if temp_jiaodu > 360
                    fld yuanjiaodu
                    fsub qword ptr[decrease_jiaodu]
                    fstp qword ptr[yuanjiaodu]

                    .endif


                    invoke DrawPin, hDCMem, pin_x, pin_y, 10, jiaodu
                    mov edx, currentnum
                    add edx, 1
                    mov currentnum, edx
                    .ENDW
                    nomorepins2 :
                ; ��ʼ�ײ��������
                    invoke MoveToEx, hDCMem, 360, 700, NULL
                    invoke LineTo, hDCMem, 360, 575
                    xor esi, esi
                    mov esi, currentnum
                    ; add esi, 4
                    .while esi >= 5
                    sub esi, 5
                    .endw
                    invoke CreateSolidBrush, color_array[4 * esi]
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke Ellipse, hDCMem, 350, 690, 370, 710
                    invoke DeleteObject, hbrush
                    invoke CreatePen, PS_DASHDOTDOT, 1, color_black
                    mov hpenxuxian, eax
                    invoke SelectObject, hDCMem, hpenxuxian
                    invoke MoveToEx, hDCMem, 360, 575, NULL
                    invoke LineTo, hDCMem, 360, 250


                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                invoke SelectObject, hDCMem, hpen
                    invoke GetStockObject, NULL_BRUSH
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    ; invoke Ellipse, hdc, 0, 0, 150, 150
                    ; ����Բ
                    invoke CreateSolidBrush, color_yellow
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke Ellipse, hDCMem, 285, 225, 435, 375

                    invoke CreateSolidBrush, color_pb
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke RoundRect, hDCMem, 300, 750, 420, 850, 5, 5

                    invoke CreateFont, 30, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
                    OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, offset font1
                    mov gamefont, eax

                    invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke strlen, offset Scorestr
                    invoke TextOut, hDCMem, 325, 770, offset Scorestr, eax
                    invoke inttostr, score
                    invoke strlen, offset Numstr

                    push eax
                    mov ebx, 10
                    mul ebx
                    neg eax
                    add eax, 360
                    mov esi, eax
                    pop eax

                    invoke TextOut, hDCMem, esi, 800, offset Numstr, eax


                    invoke DeleteObject, gamefont
                    invoke DeleteObject, scorefont
                    ; invoke DeleteObject, gamefont

                    ; ��Բ

                    ; invoke DrawCircle, hDCMem, 400, 500, 75
                    ;.If flushflag == 1
                    ;    mov eax, testloop
                    ;    add eax, 1
                    ;    mov testloop, eax
                    ;    invoke DrawCircle, hDCMem, 400, 500, testloop
                    ;    mov eax, 0
                    ;    mov flushflag, eax
                    ; .IF testloop == 200
                    ;        mov testloop, 100
                    ; .ENDIF
                    ;.ENDIF

                    ; ��¼������ť����
                    mov mutebutton.start_x, 650
                    xor ecx, ecx
                    mov ecx, 650
                    add ecx, bitmapinfo.bmWidth
                    mov mutebutton.end_x, ecx

                    mov mutebutton.start_y, 10
                    xor ecx, ecx
                    mov ecx, 10
                    add ecx, bitmapinfo.bmHeight
                    mov mutebutton.end_y, ecx
                    
                    ; ���ƾ�����ť
                     invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_black
                     invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                       ;����ģʽ
                    invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke strlen, offset fucktext
                    invoke TextOut, hDCMem, 315, 200, offset fucktext, eax
                    invoke inttostr, score
                    invoke strlen, offset Numstr

                    ; xiugai
                    invoke SelectObject, hDCMem, hBrush
                    invoke DeleteObject, hBrush
                    invoke SelectObject, hDCMem, hbrush
                    invoke DeleteObject, hbrush
                    invoke BitBlt, hdc, 0, 0, 720, 1080, hDCMem, 0, 0, SRCCOPY
                    invoke SelectObject, hDCMem, hBmpMem
                    invoke DeleteDC, hDCMem
                    invoke DeleteObject, hBmpMem
                    ; xiugai

                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done


  endlessgameWindow:
                invoke BeginPaint, hWnd, offset Paintinfo

                    ; ������Ϸ����
                    ; ˫����
                    mov hdc, eax
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; ҳ��ˢ��
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; �L�u�[�򱳾��D
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY

                    ; ���Ʒ��ش��ڰ�ť
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                    ; ��ʼ������
                    invoke CreatePen, PS_SOLID, 0, color_black
                    mov hpen, eax
                    invoke CreateCompatibleDC, hpen

                    ; ��Բ��ʻ�һ������Բ������Ҫ�ˣ�
                    ; invoke SelectObject, hdc, hpen
                    ; invoke Ellipse, hdc, 0, 0, 150, 150

                    ; ��ˢ�ӻ�һ���룬�Ѿ�����˷�װ�����忴 DrawPin ����
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                xor edx, edx
                    add edx, 1
                    mov currentnum, edx
                    .WHILE edx != totalnum

                    mov edx, currentnum
                    .IF edx == totalnum
                    jmp nomorepins3
                    .ENDIF
                    fld pin_angle[edx * 8]
                    ; invoke printf, offset Msg2, pin_angle[edx * 8]
                    fstp jiaodu


                    fld qword ptr jiaodu
                    fadd qword ptr[different_cir]
                    fstp qword ptr[yuanjiaodu]
                    invoke cir_position, yuanjiaodu
                    fld yuanjiaodu
                    fistp dword ptr[temp_jiaodu]
                    .if temp_jiaodu > 360
                    fld yuanjiaodu
                    fsub qword ptr[decrease_jiaodu]
                    fstp qword ptr[yuanjiaodu]

                    .endif


                    invoke DrawPin, hDCMem, pin_x, pin_y, 10, jiaodu
                    mov edx, currentnum
                    add edx, 1
                    mov currentnum, edx
                    .ENDW
                    nomorepins3 :
                ; ��ʼ�ײ��������
                    invoke MoveToEx, hDCMem, 360, 700, NULL
                    invoke LineTo, hDCMem, 360, 575
                    xor esi, esi
                    mov esi, currentnum
                    ; add esi, 4
                    .while esi >= 5
                    sub esi, 5
                    .endw
                    invoke CreateSolidBrush, color_array[4 * esi]
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke Ellipse, hDCMem, 350, 690, 370, 710
                    invoke DeleteObject, hbrush
                    invoke CreatePen, PS_DASHDOTDOT, 1, color_black
                    mov hpenxuxian, eax
                    invoke SelectObject, hDCMem, hpenxuxian
                    invoke MoveToEx, hDCMem, 360, 575, NULL
                    invoke LineTo, hDCMem, 360, 250


                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                invoke SelectObject, hDCMem, hpen
                    invoke GetStockObject, NULL_BRUSH
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    ; invoke Ellipse, hdc, 0, 0, 150, 150
                    ; ����Բ
                    invoke CreateSolidBrush, color_yellow
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke Ellipse, hDCMem, 285, 225, 435, 375

                    invoke CreateSolidBrush, color_pb
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke RoundRect, hDCMem, 300, 750, 420, 850, 5, 5

                    invoke CreateFont, 30, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
                    OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, offset font1
                    mov gamefont, eax

                    invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke strlen, offset Scorestr
                    invoke TextOut, hDCMem, 325, 770, offset Scorestr, eax
                    invoke inttostr, score
                    invoke strlen, offset Numstr
                    

                    push eax
                    mov ebx, 10
                    mul ebx
                    neg eax
                    add eax, 360
                    mov esi, eax
                    pop eax
                    invoke TextOut, hDCMem, esi, 800, offset Numstr, eax
                    

                    ; invoke DeleteObject, gamefont

                    ; ��Բ

                    ; invoke DrawCircle, hDCMem, 400, 500, 75
                    ; .If flushflag == 1
                    ;    mov eax, testloop
                    ;    add eax, 1
                    ;    mov testloop, eax
                    ;    invoke DrawCircle, hDCMem, 400, 500, testloop
                    ;    mov eax, 0
                    ;    mov flushflag, eax
                    ;.IF testloop == 200
                    ;        mov testloop, 100
                    ;.ENDIF
                    ; .ENDIF

                    ; ��¼������ť����
                    mov mutebutton.start_x, 650
                    xor ecx, ecx
                    mov ecx, 650
                    add ecx, bitmapinfo.bmWidth
                    mov mutebutton.end_x, ecx

                    mov mutebutton.start_y, 10
                    xor ecx, ecx
                    mov ecx, 10
                    add ecx, bitmapinfo.bmHeight
                    mov mutebutton.end_y, ecx
                    ; ���ƾ�����ť
                     invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_black
                     
                    

                    ; xiugai
                    invoke SelectObject, hDCMem, hBrush
                    invoke DeleteObject, hBrush
                    invoke SelectObject, hDCMem, hbrush
                    invoke DeleteObject, hbrush


                    invoke BitBlt, hdc, 0, 0, 720, 1080, hDCMem, 0, 0, SRCCOPY
                    invoke SelectObject, hDCMem, hBmpMem

                    invoke DeleteDC, hDCMem
                    invoke DeleteObject, hBmpMem
                    ; xiugai

                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done


                    ; ����ʧ��ҳ��
            losewindow :
                ;;;;;;; ����ʧ������
                    .if soundflag == 0
                    invoke PlaySound, offset musicload2, NULL, SND_ASYNC
                    mov eax, 1
                    mov soundflag, eax
                    .endif
                    invoke BeginPaint, hWnd, offset Paintinfo
                    mov hdc, eax

                    ; ˫����
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; ҳ��ˢ��
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0


                    ; �L�u�[�򱳾��D
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY
                    ; �������¿�ʼ��ť
                    invoke BitBlt, hDCMem, restartbutton.start_x, restartbutton.start_y, restartinfo.bmWidth, restartinfo.bmHeight, bithdc[4], 10, 10, SRCCOPY
                     ; ���Ʒ��ش��ڰ�ť
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                    ; ����ʧ��ͼƬ
                    invoke BitBlt, hDCMem, 125, 200, loseinfo.bmWidth, loseinfo.bmHeight, bithdc[24], 0, 0, SRCCOPY
                    invoke BitBlt, hDCMem, 230, 450, cjdlinfo.bmWidth, cjdlinfo.bmHeight, bithdc[12], 0, 0, SRCCOPY

                    ; xiugai
                    invoke SelectObject, hDCMem, hBrush
                    invoke DeleteObject, hBrush

                    invoke BitBlt, hdc, 0, 0, 720, 1080, hDCMem, 0, 0, SRCCOPY
                    invoke SelectObject, hDCMem, hBmpMem

                    invoke DeleteDC, hDCMem
                    invoke DeleteObject, hBmpMem
                    ; xiugai

                    ; ��������
                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done



                    
                        ;;;;;;;;;;;;;;;;; ���سɹ�ҳ��;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                   niubiwindow :
                invoke BeginPaint, hWnd, offset Paintinfo
                    mov hdc, eax

                    ; ˫����
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; ҳ��ˢ��
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ;;;;;; ÿ�ؽ�������ʾ�÷�


                    ; invoke DeleteObject, gamefont
                    ; �L�u�[�򱳾��D
                    invoke BitBlt, hDCMem, -0, 0, successinfo.bmWidth, successinfo.bmHeight, bithdc[48], 0, 0, SRCCOPY
                    ; ���Ʒ��ش��ڰ�ť

                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                    0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white

                    ; ����÷�
                    invoke CreateFont, 120, 0, 0, 0, FW_BOLD, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
                    OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, offset font1
                    mov gamefont, eax

                    invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke inttostr, score
                    invoke strlen, offset Numstr

                    push eax
                    mov ebx, 10
                    mul ebx
                    neg eax
                    add eax, 360
                    mov esi, eax
                    pop eax

                    ; invoke TextOut, hDCMem, 230, 730, offset Numstr, eax
                    
                    ; xiugai
                    invoke SelectObject, hDCMem, hBrush
                    invoke DeleteObject, hBrush
                    invoke BitBlt, hdc, 0, 0, 720, 1080, hDCMem, 0, 0, SRCCOPY
                    invoke SelectObject, hDCMem, hBmpMem
                    invoke DeleteDC, hDCMem
                    invoke DeleteObject, hBmpMem
                    ; xiugai


                    ; ��������
                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done

                        successwindow :
                    invoke BeginPaint, hWnd, offset Paintinfo
                        mov hdc, eax

                        ; ˫����
                        invoke CreateCompatibleDC, hdc
                        mov hDCMem, eax
                        invoke CreateCompatibleBitmap, hdc, 720, 1080
                        mov hBmpMem, eax
                        invoke SelectObject, hDCMem, hBmpMem
                        mov hPreBmp, eax
                        ; ҳ��ˢ��
                        invoke CreateSolidBrush, color_white
                        mov hBrush, eax
                        invoke Rectangle, hDCMem, 720, 1080, 0, 0

                        ;;;;;; ÿ�ؽ�������ʾ�÷�


                        ; invoke DeleteObject, gamefont
                        ; �L�u�[�򱳾��D
                        invoke BitBlt, hDCMem, -0, 0, successinfo.bmWidth, successinfo.bmHeight, bithdc[36], 0, 0, SRCCOPY

                        ; ������һ�ذ�ť
                        invoke BitBlt, hDCMem, xyg.start_x, xyg.start_y, xyginfo.bmWidth, xyginfo.bmHeight, bithdc[40], 0, 0, SRCCOPY
                        ; �������¿�ʼ��ť
                        ; invoke BitBlt, hDCMem, restartbutton.start_x, restartbutton.start_y, restartinfo.bmWidth, restartinfo.bmHeight, bithdc[4], 10, 10, SRCCOPY
                        ; ����ʧ��ͼƬ
                        ; invoke BitBlt, hDCMem, 125, 200, loseinfo.bmWidth, loseinfo.bmHeight, bithdc[24], 0, 0, SRCCOPY
                        ; invoke BitBlt, hDCMem, 230, 450, cjdlinfo.bmWidth, cjdlinfo.bmHeight, bithdc[12], 0, 0, SRCCOPY
                        invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                        0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white

                        ; ����÷�
                        invoke CreateFont, 120, 0, 0, 0, FW_BOLD, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
                        OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, offset font1
                        mov gamefont, eax

                        invoke SelectObject, hDCMem, gamefont
                        invoke SetTextColor, hDCMem, color_black
                        invoke SetBkMode, hDCMem, TRANSPARENT
                        invoke inttostr, score
                        invoke strlen, offset Numstr

                        push eax
                        mov ebx, 10
                        mul ebx
                        neg eax
                        add eax, 360
                        mov esi, eax
                        pop eax

                        invoke TextOut, hDCMem, 230, 530, offset Numstr, eax

                        ; xiugai
                        invoke SelectObject, hDCMem, hBrush
                        invoke DeleteObject, hBrush
                        invoke BitBlt, hdc, 0, 0, 720, 1080, hDCMem, 0, 0, SRCCOPY
                        invoke SelectObject, hDCMem, hBmpMem
                        invoke DeleteDC, hDCMem
                        invoke DeleteObject, hBmpMem
                        ; xiugai


                        ; ��������
                        invoke EndPaint, hWnd, offset Paintinfo
                        jmp done


                    ; ��ʼ�򴰿��л�ͼ
                    mainmenu :
                invoke BeginPaint, hWnd, offset Paintinfo
                    mov hdc, eax

                    ; ˫����
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; ҳ��ˢ��
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; ���Ʊ���ͼƬ
                    ; invoke BitBlt, bithdc[0], 0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[236], 0, 0, SRCCOPY

                    ; ���Ʊ���ͼƬ������
                    invoke BitBlt, hDCMem, -0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[0], 0, 0, SRCCOPY

                    ; ˢ��ʧ�������Ĳ���
                    mov eax, 0
                    mov soundflag, eax

                    ;��¼������ҳ�水ť
                    mov backbutton.start_x, 10
                    xor ecx, ecx
                    mov ecx, 10
                    add ecx, backmainwindowinfo.bmWidth
                    mov backbutton.end_x, ecx

                    mov backbutton.start_y, 10
                    xor ecx, ecx
                    mov ecx, 10
                    add ecx, backmainwindowinfo.bmHeight
                    mov backbutton.end_y, ecx

                    ; ��¼��ʼ��ť����
                    mov startbutton.start_x, 175
                    xor ecx, ecx
                    mov ecx, 175
                    add ecx, bitmapinfo.bmWidth
                    mov startbutton.end_x, ecx

                    mov startbutton.start_y, 750
                    xor ecx, ecx
                    mov ecx, 750
                    add ecx, bitmapinfo.bmHeight
                    mov startbutton.end_y, ecx

                    ; ��¼��ѹ��ť����
                    mov fuckgamebutton.start_x, 175
                    xor ecx, ecx
                    mov ecx, 175
                    add ecx, bitmapinfo.bmWidth
                    mov fuckgamebutton.end_x, ecx

                    mov fuckgamebutton.start_y, 630
                    xor ecx, ecx
                    mov ecx, 630
                    add ecx, bitmapinfo.bmHeight
                    mov fuckgamebutton.end_y, ecx

                    ; ��¼�޾�ģʽ��ť����
                    mov endlessbutton.start_x, 175
                    xor ecx, ecx
                    mov ecx, 175
                    add ecx, endlessbuttoninfo.bmWidth
                    mov endlessbutton.end_x, ecx

                    mov endlessbutton.start_y, 870
                    xor ecx, ecx
                    mov ecx, 870
                    add ecx, endlessbuttoninfo.bmHeight
                    mov endlessbutton.end_y, ecx

                    ; ��¼������ť����
                    mov mutebutton.start_x, 650
                    xor ecx, ecx
                    mov ecx, 650
                    add ecx, bitmapinfo.bmWidth
                    mov mutebutton.end_x, ecx

                    mov mutebutton.start_y, 10
                    xor ecx, ecx
                    mov ecx, 10
                    add ecx, bitmapinfo.bmHeight
                    mov mutebutton.end_y, ecx

                    ; ��¼���¿�ʼ��ť����
                    mov restartbutton.start_x, 160
                    xor ecx, ecx
                    mov ecx, 160
                    add ecx, bitmapinfo.bmWidth
                    mov restartbutton.end_x, ecx

                    mov restartbutton.start_y, 700
                    xor ecx, ecx
                    mov ecx, 700
                    add ecx, bitmapinfo.bmHeight
                    mov restartbutton.end_y, ecx

                    ; ��¼��һ�ذ�ť����
                    mov xyg.start_x, 160
                    xor ecx, ecx
                    mov ecx, 160
                    add ecx, xyginfo.bmWidth
                    mov xyg.end_x, ecx

                    mov xyg.start_y, 700
                    xor ecx, ecx
                    mov ecx, 700
                    add ecx, xyginfo.bmHeight
                    mov xyg.end_y, ecx

                    ; ���ƿ�ʼ��ť
                    invoke BitBlt, hDCMem, startbutton.start_x, startbutton.start_y, bitmapinfo.bmWidth, bitmapinfo.bmHeight, bithdc[20], 0, 0, SRCCOPY

                    ; ���ƽ�ѹ��ť
                    invoke BitBlt, hDCMem, fuckgamebutton.start_x, fuckgamebutton.start_y, fuckgamebuttoninfo.bmWidth, fuckgamebuttoninfo.bmHeight, bithdc[28], 0, 0, SRCCOPY

                     ; �����޾���ť
                    invoke BitBlt, hDCMem, endlessbutton.start_x, endlessbutton.start_y, endlessbuttoninfo.bmWidth, endlessbuttoninfo.bmHeight, bithdc[44], 0, 0, SRCCOPY

                    ; ���ƾ�����ť
                    ;invoke BitBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], 0, 0, SRCCOPY

                    ;���Ʒ��ش��ڰ�ť
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white


                    ; �ú��������ڻ��Ƶ�ͬʱ���е�ɫ͸���ȣ����ڻ���ͼ�꣩
                     invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_black

                    ; xiugai
                    invoke SelectObject, hDCMem, hBrush
                    invoke DeleteObject, hBrush

                    invoke BitBlt, hdc, 0, 0, 720, 1080, hDCMem, 0, 0, SRCCOPY
                    invoke SelectObject, hDCMem, hBmpMem

                    invoke DeleteDC, hDCMem
                    invoke DeleteObject, hBmpMem
                    ; xiugai

                    ; ��������
                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done


            gameWindow:
                invoke BeginPaint, hWnd, offset Paintinfo

                    ; ������Ϸ����
                    ; ˫����
                    mov hdc, eax
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; ҳ��ˢ��
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; �L�u�[�򱳾��D
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY

                    ; ���Ʒ��ش��ڰ�ť
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white

                    ; ��ʼ������
                    invoke CreatePen, PS_SOLID, 0, color_black
                    mov hpen, eax
                    invoke CreateCompatibleDC, hpen

                    ; ��Բ��ʻ�һ������Բ������Ҫ�ˣ�
                    ; invoke SelectObject, hdc, hpen
                    ; invoke Ellipse, hdc, 0, 0, 150, 150

                    ; ��ˢ�ӻ�һ���룬�Ѿ�����˷�װ�����忴 DrawPin ����
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                xor edx, edx
                    add edx, 1
                    mov currentnum, edx
                    .WHILE edx != totalnum

                    mov edx, currentnum
                    .IF edx == totalnum
                    jmp nomorepins
                    .ENDIF
                    fld pin_angle[edx * 8]
                    ; invoke printf, offset Msg2, pin_angle[edx * 8]
                    fstp jiaodu


                    fld qword ptr jiaodu
                    fadd qword ptr[different_cir]
                    fstp qword ptr[yuanjiaodu]
                    invoke cir_position, yuanjiaodu
                    fld yuanjiaodu
                    fistp dword ptr[temp_jiaodu]
                    .if temp_jiaodu > 360
                    fld yuanjiaodu
                    fsub qword ptr[decrease_jiaodu]
                    fstp qword ptr[yuanjiaodu]

                    .endif


                    invoke DrawPin, hDCMem, pin_x, pin_y, 10, jiaodu
                    mov edx, currentnum
                    add edx, 1
                    mov currentnum, edx
                    .ENDW
                    nomorepins :
                ; ��ʼ�ײ��������
                    invoke MoveToEx, hDCMem, 360, 700, NULL
                    invoke LineTo, hDCMem, 360, 575
                    xor esi, esi
                    mov esi, currentnum
                    ; add esi, 4
                    .while esi >= 5
                    sub esi, 5
                    .endw
                    invoke CreateSolidBrush, color_array[4 * esi]
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke Ellipse, hDCMem, 350, 690, 370, 710
                    invoke DeleteObject, hbrush
                    invoke CreatePen, PS_DASHDOTDOT, 1, color_black
                    mov hpenxuxian, eax
                    invoke SelectObject, hDCMem, hpenxuxian
                    invoke MoveToEx, hDCMem, 360, 575, NULL
                    invoke LineTo, hDCMem, 360, 250


                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                invoke SelectObject, hDCMem, hpen
                    invoke GetStockObject, NULL_BRUSH
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    ; invoke Ellipse, hdc, 0, 0, 150, 150
                    ; ����Բ
                    invoke CreateSolidBrush, color_yellow
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke Ellipse, hDCMem, 285, 225, 435, 375

                    invoke CreateSolidBrush, color_pb
                    mov hbrush, eax
                    invoke SelectObject, hDCMem, hbrush
                    invoke RoundRect, hDCMem, 300, 750, 420, 850, 5, 5

                    invoke CreateFont, 30, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
                    OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, offset font1
                    mov gamefont, eax

                    invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke strlen, offset Scorestr
                    invoke TextOut, hDCMem, 325, 770, offset Scorestr, eax
                    invoke inttostr, score
                    invoke strlen, offset Numstr
                    

                    push eax
                    mov ebx, 10
                    mul ebx
                    neg eax
                    add eax, 360
                    mov esi, eax
                    pop eax
                    invoke TextOut, hDCMem, esi, 800, offset Numstr, eax
                    

                    ; invoke DeleteObject, gamefont

                    ; ��Բ

                    ; invoke DrawCircle, hDCMem, 400, 500, 75
                    ; .If flushflag == 1
                    ;    mov eax, testloop
                    ;    add eax, 1
                    ;    mov testloop, eax
                    ;    invoke DrawCircle, hDCMem, 400, 500, testloop
                    ;    mov eax, 0
                    ;    mov flushflag, eax
                    ;.IF testloop == 200
                    ;        mov testloop, 100
                    ;.ENDIF
                    ; .ENDIF

                    ; ��¼������ť����
                    mov mutebutton.start_x, 650
                    xor ecx, ecx
                    mov ecx, 650
                    add ecx, bitmapinfo.bmWidth
                    mov mutebutton.end_x, ecx

                    mov mutebutton.start_y, 10
                    xor ecx, ecx
                    mov ecx, 10
                    add ecx, bitmapinfo.bmHeight
                    mov mutebutton.end_y, ecx
                    ; ���ƾ�����ť
                     invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_black


                     .IF endlessmodel == 1
                      ;����ģʽ
                     invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke strlen, offset endlesstext
                    invoke TextOut, hDCMem, 315, 200, offset endlesstext, eax
                    invoke inttostr, score
                    invoke strlen, offset Numstr
                     .ELSE;����ģʽ
                    invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke strlen, offset scoretext
                    invoke TextOut, hDCMem, 215, 500, offset scoretext, eax
                    invoke inttostrx, pin_goal_number
                    invoke strlen, offset Numstr2
                    invoke TextOut, hDCMem, 400, 500, offset Numstr2, eax
                    .ENDIF
                    invoke DeleteObject, gamefont
                    invoke DeleteObject, scorefont
                    ; xiugai
                    invoke SelectObject, hDCMem, hBrush
                    invoke DeleteObject, hBrush
                    invoke SelectObject, hDCMem, hbrush
                    invoke DeleteObject, hbrush


                    invoke BitBlt, hdc, 0, 0, 720, 1080, hDCMem, 0, 0, SRCCOPY
                    invoke SelectObject, hDCMem, hBmpMem

                    invoke DeleteDC, hDCMem
                    invoke DeleteObject, hBmpMem
                    ; xiugai

                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done



                    ; ����������������
                    .ELSEIF uMsg == WM_LBUTTONDOWN
                    mov eax, lParam
                    shr eax, 16
                    mov ebx, lParam
                    invoke Mouse_LeftClickCallBack, bx, ax


                    ; Todo: ��ʱ����ͬ״̬�ĺ���
                    .ELSEIF uMsg == WM_TIMER
                    .IF wParam == Timer_Render
                    ; ���»��棬ˢ�£���ÿһִ֡�еĶ���������ˢ�»��棬��ת���������
                    ; invoke printf, offset szTest1
                    ; Timer_RenderCallBack, hwnd; ���Ӧ����ˢ��֡�ʵĺ���
                    mov eax, 1
                    mov flushflag, eax
                    invoke InvalidateRect, hWnd, NULL, TRUE
                    invoke UpdateWindow, hWnd
                    .ELSEIF wParam == Timer_Animate

                    .if change_time != 0
                    jmp outloop
                    .endif
                    rechange :
                invoke GetTickCount
                    mov seed, eax

                    ; ����C�����������ɺ��� rand
                    invoke srand, seed
                    invoke rand
                    mov ebx, 6
                    div ebx
                    .if edx == 0
                    jmp rechange
                    .endif
                    mov change_time, edx

                    loop2 :
                ; �ı��ٶ�
                    invoke GetTickCount
                    mov seed, eax

                    ; ����C�����������ɺ��� rand
                    invoke srand, seed
                    invoke rand
                    mov ebx, 5
                    div ebx
                    .if edx == 0
                    jmp loop2
                    .endif
                    .if change_flag == 0
                    add change_flag, 1
                    .else
                    xor esi, esi
                    mov esi, 360
                    sub esi, edx
                    mov angle_change, esi
                    mov edx, angle_change
                    sub change_flag, 1
                    .endif

                    mov int_increase_angle, edx
                    finit
                    fild dword ptr[int_increase_angle]
                    fstp qword ptr[increase_angle]
                    ; invoke printf, offset Msg3, change_time
                    ; invoke printf, offset Msg2, increase_angle
                    outloop :
                sub change_time, 1
                    ; mov increase_angle, edx
                    ; �����Զ���֡����Ŀǰ����֡���� Timer_Animate �󶨣�
                    ; invoke printf, offset szTest2

                    .ENDIF

                    .ELSE
                    invoke DefWindowProc, hWnd, uMsg, wParam, lParam; Default message processing
                    ret
                    .ENDIF
                    done :
                xor eax, eax
                    ret
                    WndProc endp



start:
                invoke GetProcessHeap
                    mov heap, eax

                    invoke GetModuleHandle, NULL; Under Win32, hmodule == hinstance mov hInstance, eax
                    mov hInstance, eax

                    ; invoke GetCommandLine
                    ; mov CommandLine, eax

                    invoke WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT; call the main function

                    invoke ExitProcess, eax; Quit
    end start
end