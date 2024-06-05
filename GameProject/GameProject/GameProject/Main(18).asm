.386
.model flat, stdcall
option casemap : none

; ================ TODO - LIST ================
; 设计：
; 1.难度系统：难度越高 针越多 转速越快（可选，尽量做）

; 2.开始游戏按钮文字（可以加入鼠标移动上去变色）（已完成，还可以通过加入贴图）（可选，最后做）

; 3.可以经典模式、无尽模式、计时模式、解压模式（经典模式针数减，无尽模式针数加，计时模式达到针数可以换球，禅模式没有得分和数字，其他和无尽一样）

; 4.可以有一些小球的不同皮肤设置（换球的图片就可以（换宝剑也可以））（可选，最后做）

; 代码：
; 1.主函数的游戏模式切换变量（多搞几个按钮）

; 4.插完针小球向上移动的动画 （尽量做）



; ================ 引用库部分 ================
includelib msvcrt.lib
include windows.inc

includelib user32.lib
include user32.inc

includelib kernel32.lib
include kernel32.inc

includelib gdi32.lib
include gdi32.inc

includelib Winmm.lib
include Winmm.inc

includelib Advapi32.lib
include Advapi32.inc

includelib Msimg32.lib
include Msimg32.inc


; ================ 引用函数部分 ================
strlen PROTO C : dword
strcat PROTO C : dword, :dword
printf PROTO C : dword, : vararg
srand PROTO C : dword
rand PROTO C

; wsprintf proto : sbyte ptr, : sbyte ptr, : DWORD, : DWORD
; LoadImage proto : IMAGE, sbyte ptr, : DWORD, : DWORD

; ================ 自定义类部分 ================

; 按钮类定义
BUTTON_INFO STRUCT
start_x     dd      0
end_x       dd      0
start_y     dd      0
end_y       dd      0
BUTTON_INFO ENDS





; ================ 预定义部分 ================
; 按钮部分
STATUS_START             equ           1; 开始窗口
STATUS_GAMING            equ           2; 游戏窗口
STATUS_END               equ           3; 结算窗口


; 鼠标部分
MOUSE_IDLE              equ           0

; 颜色部分
color_white       equ     0FFFFFFH
color_black       equ     0000000H
color_blue        equ     0E6E6FAH
color_background  equ     0FC9D9AH; 背景色，设置透明的时候用
color_yellow      equ     07B68EEH
color_pb          equ     0B0E0E6H
color_mw          equ     0F6F6F6H

; 随机到的针颜色，可以创建一个数组



; 设置帧率为 60
gframerate         equ     60






; 计时器的不同状态
Timer_Render            equ           1
Timer_Animate           equ           2
Timer_sunGenerate       equ           3
Timer_Bullet            equ           4
Timer_GameRule          equ           5





; ================ 数据段(全局变量) ================
.DATA

; 整数段
menuinfo dd 0
flushflag dd 0
checkangle dd 0
startflag dd 0; 判定是否刚刚点击了开始游戏或者重新开始？

; 针的数据
pin_x dd 360
pin_y dd 100
value1 dd 0
value2 dd 0
cir_value1 dd 0
cir_value2 dd 0
temp_jiaodu dd 0
totalnum dd 4
currentnum dd 0

; 记录针的颜色数组
color_array dword 0E6E6FAH, 01E90FFH, 0FFDAB9H, 0FFC0CBH, 098FB98H
color_flag dd 0

; 改变速度的变量
int_increase_angle dd 0
change_time dd 0
change_flag dd 0
top_angle dd 0
low_angle dd 0

; 浮点数段
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

; 记录每个针的角度的数组
pin_angle real8 0.0, 1000 dup(0.0)

; 随机针角度数组需要的变量
seed        dd 0; 种子值
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
; 针的上移
pinX dd 100
pinY dd 100

; 播放音乐
playmusic dd 1
soundflag dd 0

; 背景图片
himg_bg  dd 0
himg_bg2  dd 0
testloop  dd 100
himg_bg7  dd 0
himg_bg9  dd 0
himg_bg13  dd 0

; 按钮图片
himg_bg8  dd 0

; 失败图片
himg_bg3  dd 0
himg_bg5  dd 0

; 重新开始图片
himg_bg4  dd 0

; 静音图片
himg_bg6  dd 0

;成功页面
himg_bg10 dd 0

;下一关图片
himg_bg11 dd 0

;无尽模式图片
himg_bg12 dd 0
endlessmodel dd 0

; 初始化句柄
hInstance   HANDLE  0; 程序实例句柄
hdc         HDC     NULL; 显示设备上下文的句柄
hDCMem      HDC     NULL; 双缓冲实现所需句柄
hMainWindow HANDLE  0; 主窗口句柄
hbutton     HANDLE  0; 开始按钮句柄
heap        HANDLE  0; 申请的堆空间
bithdc      HDC     80 DUP(NULL); 很多句柄，用来操作图片和窗口
hCryptProv  HANDLE  0
gamefont    HFONT   NULL
scorefont   HFONT   NULL


; 画笔和画刷，用来完成针的绘画
hpen        HPEN    NULL
hpenxuxian  HPEN    NULL
hbrush      HBRUSH  NULL
hbrushnull  HBRUSH  NULL
hBrush      HBRUSH  NULL


; 贴图和画笔部分
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

; 结构体指针
startbutton BUTTON_INFO{ 0,0,0,0 }
mutebutton BUTTON_INFO{ 0,0,0,0 }
restartbutton BUTTON_INFO{ 0,0,0,0 }
fuckgamebutton BUTTON_INFO{ 0,0,0,0 }
backbutton  BUTTON_INFO{ 0,0,0,0 }
xyg  BUTTON_INFO{ 0,0,0,0 }
endlessbutton BUTTON_INFO{ 0,0,0,0 }

; 鼠标动作
MouseStatus           BYTE          MOUSE_IDLE

; 双缓冲位图
hBmpMem     HBITMAP  NULL; 位图双缓冲
hPreBmp     HBITMAP  NULL; 位图双缓冲

; ================ 常量段 ================
.const

; name of window classes
ClassName db "SimpleWinClass", 0
ButtonClassName db "ButtonClass", 0

; 字符串
AppName   db "见缝插针", 0
ButtonName   db "Start Button", 0




; 窗口大小参数
mainW_width  dd  720
mainW_height dd  1080




szTestMessage db "Clicked button!", 0
format db "totalnum = %d", 0
szTest1     db "1", 0
szTest2     db "0", 0

; PinCircleWidth  dd 10; 针的上方的圆的半径
; PinLength       dd 100; 针的长度


font1      db    "Mistral", 0; 使用的字体

StartText  BYTE "Start Game!", 0
Scorestr   BYTE  "得分：", 0
scoretext  BYTE  "剩余针数：", 0
fucktext   BYTE  "解压模式", 0
endlesstext   BYTE  "无尽模式", 0


; 图片url
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

; 音乐
musicload db "music.wav", 0
music2 db "MouseClick", 0
musicload2 db "cjdl.wav", 0
musicfuck db "kknice.wav", 0

; ================ 未初始化数据段 ================
; .DATA ? ; Uninitialized
; hInstance HINSTANCE ?
CommandLine LPSTR ?






; ========================================
; ================ 代码段 ================
; ========================================

.CODE
; ================ 工作函数区 ================

; Todo：可能还会有别的按钮 此函数还应修改
; 判断是否单击到了开始按钮的函数

; 整数转字符串的函数

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
    xor ecx, ecx; 计数
    mov eax, x; 被除数
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
xor ecx, ecx; 计数
mov eax, x; 被除数
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

; 随机pin_angle角度数组的函数
random_array proc
loop1 :
invoke GetTickCount
mov seed, eax

; 调用C库的随机数生成函数 rand
invoke srand, seed
invoke rand

mov ebx, 10
div ebx

; 不允许针的个数小于1
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
; 产生一个随机数
push ecx
; 调用C库的随机数生成函数 rand
chonglai :
invoke rand
mov ebx, 360
div ebx
mov random_angle, edx
; invoke printf, offset format2, random_angle

; 将得到的整数转化成为浮点数
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
; 回到按钮位置(先判断)
.IF ebx > backbutton.start_x && ebx < backbutton.end_x
    mov ebx, p_y
    .IF ebx > backbutton.start_y && ebx < backbutton.end_y
    ; 点击音效
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
; 静音按钮位置(先判断)
.IF ebx > mutebutton.start_x && ebx < mutebutton.end_x
    mov ebx, p_y
    .IF ebx > mutebutton.start_y && ebx < mutebutton.end_y
    ; 点击音效，起到取消音乐的效果
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



    ; 开始游戏位置
    gamestartbutton :
.IF ebx > startbutton.start_x && ebx < startbutton.end_x
        mov edx, p_y
    .IF edx > startbutton.start_y && edx < startbutton.end_y
    ; 点击音效
    
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

    ;开始无尽游戏位置
  .IF ebx > endlessbutton.start_x && ebx <  endlessbutton.end_x
    mov edx, p_y
    .IF edx >  endlessbutton.start_y && edx <  endlessbutton.end_y
    ; 点击音效
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

     ;开始解压游戏位置
.IF ebx > fuckgamebutton.start_x && ebx < fuckgamebutton.end_x
    mov edx, p_y
    .IF edx > fuckgamebutton.start_y && edx < fuckgamebutton.end_y
    ; 点击音效
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
; 这部分是解压游戏界面点击鼠标的效果
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
; 这部分是游戏界面点击鼠标的效果
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
    ; 这里判定游戏失败，因为找到了一个角度，小于临界值
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
    ;判断应该回到哪一个模式
        .IF endlessmodel == 1
            mov eax, 1
            mov menuinfo, eax
            invoke random_array
    ;bug:解压模式刷新问题（选择性解决），只有点回积分模式才刷新分数
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


    ; Todo: 出现了鼠标单击事件的处理函数（该函数只要鼠标出现单击就会响应）
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
; 这里应该是页面跳转函数
notclickanything :
popad
ret
Mouse_LeftClickCallBack endp


; 画圆的函数
DrawCircle proc  currhdc : HDC, x : DWORD, y : DWORD, r : DWORD
LOCAL sx : DWORD
LOCAL sy : DWORD
LOCAL ex : DWORD
LOCAL ey : DWORD

pushad
invoke CreatePen, PS_SOLID, 0, color_black
mov hpen, eax


; 用圆珠笔画一个空心圆
invoke SelectObject, currhdc, hpen

; 处理参数，圆出现在对应的位置
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



; 确定针尾圆圈位置的函数
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



; 绘画针的函数（确定了大圆的位置之后就可以将其变量改成角度）
; 参数分别为：绘画上下文句柄 hdc，圆的圆心坐标 x, y ，以及半径的长度 r ，针长度固定，因此没有设置参数
DrawPin proc  curhdc : HDC, x : DWORD, y : DWORD, r : DWORD, ang : real8
; 局部变量用于存储针的函数
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 刷子颜色;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xor esi, esi
mov esi, currentnum
.while esi >= 5
sub esi, 5
.endw
invoke CreateSolidBrush, color_array[4 * esi]
mov hbrush, eax
invoke SelectObject, curhdc, hbrush



; 处理参数，圆出现在对应的位置
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
; 画针柄
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

                    ; 删除句柄，减少缓存
                    invoke DeleteObject, hbrush
                    popad
                    ret

                    DrawPin endp


                    ; 圆不用旋转，针旋转就行
                    ; RotatePins Proc






                    ; ================ 窗口函数区 ================

                    ; 刷新帧率，窗口回调函数（Todo）
                    Timer_RenderCallBack proc hwnd : HWND
                    ; 这里应该有轮盘的旋转动画



                    Timer_RenderCallBack endp





                    ; 主窗口创建函数
                    WinMain proc hInst : DWORD, hPrevInst : DWORD, CmdLine : DWORD, CmdShow : DWORD
                    LOCAL wc : WNDCLASSEX; create local variables on stack
                    LOCAL msg : MSG
                    ; LOCAL hwnd : HWND

                    ; 注册窗口类
                    mov   wc.cbSize, SIZEOF WNDCLASSEX; fill values in members of wc
                    ; mov   wc.style, CS_HREDRAW or CS_VREDRAW
                    mov   wc.lpfnWndProc, OFFSET WndProc
                    mov   wc.cbClsExtra, NULL
                    mov   wc.cbWndExtra, NULL
                    ; mov   wc.hbrBackground, COLOR_WINDOW + 1
                    ; mov   wc.lpszMenuName, NULL
                    mov   wc.lpszClassName, OFFSET ClassName
                    ; 可以在这里设置图标
                    ; invoke LoadIcon, NULL, IDI_APPLICATION
                    ; mov   wc.hIcon, eax
                    ; mov   wc.hIconSm, eax
                    ; invoke LoadCursor, NULL, IDC_ARROW
                    ; mov   wc.hCursor, eax
                    invoke RegisterClassEx, addr wc; register window class

                    ; 创建主窗口
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
                    ; 以上函数参数分别是：
                    ; 类名
                    ; 窗口标题
                    ; 窗口 style，要求不能最大化
                    ; 窗口位置 x, y
                    ; 窗口的 Width, Height
                    ; 父窗口相关，均无
                    ; 与本窗口相关的程序实例

                    mov   hMainWindow, eax
                    mov   Paintinfo.fErase, TRUE
                    ; 创建主窗口结束

                    ; 创建字体
                    invoke CreateFont, 100, 0, 0, 0, FW_BOLD, FALSE, FALSE, FALSE, DEFAULT_CHARSET, \
                    OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, offset font1
                    mov scorefont, eax

                    ; 播放音乐
                    invoke PlaySound, offset musicload, NULL, SND_ASYNC

                    ; 创建并启动计时器
                    invoke SetTimer, hMainWindow, Timer_Render, 1000 / gframerate, NULL; 参数分别为：句柄、事件、事件、超时通知函数（不用改）
                    invoke SetTimer, hMainWindow, Timer_Animate, 2000, NULL; 两帧切换一次状态



                    ; 注：以上是两个不同的计时器

                    invoke CryptAcquireContext, offset hCryptProv, NULL, NULL, \
                    PROV_RSA_FULL, CRYPT_VERIFYCONTEXT





                    ; 检索并返回窗口句柄
                    invoke GetDC, hMainWindow
                    mov hdc, eax
                    mov ecx, 60

                    CCDC:
                push ecx
                    invoke CreateCompatibleDC, hdc
                    pop ecx
                    mov bithdc[ecx * 4 - 4], eax
                    loop CCDC



                    ; 加载背景图：
                    invoke LoadImage, NULL, offset url_background, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg, eax
                    invoke LoadImage, NULL, offset url_startbutton, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg2, eax

                    ; 加載遊戲背景圖
                    invoke LoadImage, NULL, offset url_gamebackground, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg7, eax

                    ; 加载失败图：
                    invoke LoadImage, NULL, offset url_lose, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg3, eax

                    ; 加载重新开始图：
                    invoke LoadImage, NULL, offset url_restart, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg4, eax

                    invoke LoadImage, NULL, offset url_cjdl, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg5, eax

                    ; 加载静音图：
                    invoke LoadImage, NULL, offset url_mutebutton, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg6, eax

                    ;加载按钮图
                    invoke LoadImage, NULL, offset url_fuckgame, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg8, eax
                    invoke LoadImage, NULL, offset url_endlessbutton, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg12, eax

                    ;加载返回窗口图
                    invoke LoadImage, NULL, offset url_backwindow, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg9, eax

                    ; 加载闯关成功图：
                    invoke LoadImage, NULL, offset url_success, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg10, eax

                    ; 加载下一关图：
                    invoke LoadImage, NULL, offset url_xyg, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
                    mov himg_bg11, eax

                    ; 加载最后牛逼图：
                    invoke LoadImage, NULL, offset url_niubi, \
                    IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE; 此函数的这部分不用改
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


                    ; 开始向窗口中绘图
                    ; invoke BeginPaint, hMainWindow, offset Paintinfo
                    ; mov hdc, eax
                    ; mov ebx, [himg_start]
                    ; invoke SelectObject, bithdc[24], ebx

                    ; invoke GetObject, ebx, sizeof(BITMAP), offset backgroundinfo
                    ; 将对应于像素矩形的颜色数据从指定的源设备上下文传输到目标设备上下文
                    ; invoke TransparentBlt, bithdc[0], 200, 400, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[24], \
                    ; 0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, color_white

                    ; invoke BitBlt, hdc, 0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[0], 0, 0, SRCCOPY

                    ; invoke EndPaint, hMainWindow, offset Paintinfo


                    invoke ShowWindow, hMainWindow, SW_SHOWNORMAL; display our window on desktop
                    invoke UpdateWindow, hMainWindow; refresh the client area
                    ; invoke funcA; 可以在这里引用外模块函数（可选）

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


                    ; 窗口进程函数
                    WndProc proc hWnd : HWND, uMsg : UINT, wParam : WPARAM, lParam : LPARAM
                    .IF uMsg == WM_DESTROY; if the user closes our window
                    invoke PostQuitMessage, NULL; quit application


                    ; 发出绘图信息，开始绘画窗口
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
                ; 绘制解压游戏模式
                    invoke BeginPaint, hWnd, offset Paintinfo
                    ; 绘制游戏界面
                    ; 双缓冲
                    mov hdc, eax
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; 页面刷新
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; 繪製遊戲背景圖
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY

                     ; 绘制返回窗口按钮

                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                    ; 初始化画笔
                    invoke CreatePen, PS_SOLID, 0, color_black
                    mov hpen, eax
                    invoke CreateCompatibleDC, hpen

                    ; 用圆珠笔画一个空心圆（不需要了）
                    ; invoke SelectObject, hdc, hpen
                    ; invoke Ellipse, hdc, 0, 0, 150, 150

                    ; 用刷子画一个针，已经完成了封装，具体看 DrawPin 介绍
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
                ; 初始底部针和虚线
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
                    ; 画大圆
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

                    ; 大圆

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

                    ; 记录静音按钮区域
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
                    
                    ; 绘制静音按钮
                     invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_black
                     invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                       ;标明模式
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

                    ; 绘制游戏界面
                    ; 双缓冲
                    mov hdc, eax
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; 页面刷新
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; 繪製遊戲背景圖
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY

                    ; 绘制返回窗口按钮
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                    ; 初始化画笔
                    invoke CreatePen, PS_SOLID, 0, color_black
                    mov hpen, eax
                    invoke CreateCompatibleDC, hpen

                    ; 用圆珠笔画一个空心圆（不需要了）
                    ; invoke SelectObject, hdc, hpen
                    ; invoke Ellipse, hdc, 0, 0, 150, 150

                    ; 用刷子画一个针，已经完成了封装，具体看 DrawPin 介绍
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
                ; 初始底部针和虚线
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
                    ; 画大圆
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

                    ; 大圆

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

                    ; 记录静音按钮区域
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
                    ; 绘制静音按钮
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


                    ; 绘制失败页面
            losewindow :
                ;;;;;;; 播放失败音乐
                    .if soundflag == 0
                    invoke PlaySound, offset musicload2, NULL, SND_ASYNC
                    mov eax, 1
                    mov soundflag, eax
                    .endif
                    invoke BeginPaint, hWnd, offset Paintinfo
                    mov hdc, eax

                    ; 双缓冲
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; 页面刷新
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0


                    ; 繪製遊戲背景圖
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY
                    ; 绘制重新开始按钮
                    invoke BitBlt, hDCMem, restartbutton.start_x, restartbutton.start_y, restartinfo.bmWidth, restartinfo.bmHeight, bithdc[4], 10, 10, SRCCOPY
                     ; 绘制返回窗口按钮
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white
                    ; 绘制失败图片
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

                    ; 结束绘制
                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done



                    
                        ;;;;;;;;;;;;;;;;; 闯关成功页面;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                   niubiwindow :
                invoke BeginPaint, hWnd, offset Paintinfo
                    mov hdc, eax

                    ; 双缓冲
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; 页面刷新
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ;;;;;; 每关结束后显示得分


                    ; invoke DeleteObject, gamefont
                    ; 繪製遊戲背景圖
                    invoke BitBlt, hDCMem, -0, 0, successinfo.bmWidth, successinfo.bmHeight, bithdc[48], 0, 0, SRCCOPY
                    ; 绘制返回窗口按钮

                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                    0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white

                    ; 插入得分
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


                    ; 结束绘制
                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done

                        successwindow :
                    invoke BeginPaint, hWnd, offset Paintinfo
                        mov hdc, eax

                        ; 双缓冲
                        invoke CreateCompatibleDC, hdc
                        mov hDCMem, eax
                        invoke CreateCompatibleBitmap, hdc, 720, 1080
                        mov hBmpMem, eax
                        invoke SelectObject, hDCMem, hBmpMem
                        mov hPreBmp, eax
                        ; 页面刷新
                        invoke CreateSolidBrush, color_white
                        mov hBrush, eax
                        invoke Rectangle, hDCMem, 720, 1080, 0, 0

                        ;;;;;; 每关结束后显示得分


                        ; invoke DeleteObject, gamefont
                        ; 繪製遊戲背景圖
                        invoke BitBlt, hDCMem, -0, 0, successinfo.bmWidth, successinfo.bmHeight, bithdc[36], 0, 0, SRCCOPY

                        ; 绘制下一关按钮
                        invoke BitBlt, hDCMem, xyg.start_x, xyg.start_y, xyginfo.bmWidth, xyginfo.bmHeight, bithdc[40], 0, 0, SRCCOPY
                        ; 绘制重新开始按钮
                        ; invoke BitBlt, hDCMem, restartbutton.start_x, restartbutton.start_y, restartinfo.bmWidth, restartinfo.bmHeight, bithdc[4], 10, 10, SRCCOPY
                        ; 绘制失败图片
                        ; invoke BitBlt, hDCMem, 125, 200, loseinfo.bmWidth, loseinfo.bmHeight, bithdc[24], 0, 0, SRCCOPY
                        ; invoke BitBlt, hDCMem, 230, 450, cjdlinfo.bmWidth, cjdlinfo.bmHeight, bithdc[12], 0, 0, SRCCOPY
                        invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                        0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white

                        ; 插入得分
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


                        ; 结束绘制
                        invoke EndPaint, hWnd, offset Paintinfo
                        jmp done


                    ; 开始向窗口中绘图
                    mainmenu :
                invoke BeginPaint, hWnd, offset Paintinfo
                    mov hdc, eax

                    ; 双缓冲
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; 页面刷新
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; 绘制背景图片
                    ; invoke BitBlt, bithdc[0], 0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[236], 0, 0, SRCCOPY

                    ; 绘制背景图片到窗口
                    invoke BitBlt, hDCMem, -0, 0, backgroundinfo.bmWidth, backgroundinfo.bmHeight, bithdc[0], 0, 0, SRCCOPY

                    ; 刷新失敗音樂的播放
                    mov eax, 0
                    mov soundflag, eax

                    ;记录返回主页面按钮
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

                    ; 记录开始按钮区域
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

                    ; 记录解压按钮区域
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

                    ; 记录无尽模式按钮区域
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

                    ; 记录静音按钮区域
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

                    ; 记录重新开始按钮区域
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

                    ; 记录下一关按钮区域
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

                    ; 绘制开始按钮
                    invoke BitBlt, hDCMem, startbutton.start_x, startbutton.start_y, bitmapinfo.bmWidth, bitmapinfo.bmHeight, bithdc[20], 0, 0, SRCCOPY

                    ; 绘制解压按钮
                    invoke BitBlt, hDCMem, fuckgamebutton.start_x, fuckgamebutton.start_y, fuckgamebuttoninfo.bmWidth, fuckgamebuttoninfo.bmHeight, bithdc[28], 0, 0, SRCCOPY

                     ; 绘制无尽按钮
                    invoke BitBlt, hDCMem, endlessbutton.start_x, endlessbutton.start_y, endlessbuttoninfo.bmWidth, endlessbuttoninfo.bmHeight, bithdc[44], 0, 0, SRCCOPY

                    ; 绘制静音按钮
                    ;invoke BitBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], 0, 0, SRCCOPY

                    ;绘制返回窗口按钮
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white


                    ; 该函数可以在绘制的同时具有底色透明度（用于绘制图标）
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

                    ; 结束绘制
                    invoke EndPaint, hWnd, offset Paintinfo
                    jmp done


            gameWindow:
                invoke BeginPaint, hWnd, offset Paintinfo

                    ; 绘制游戏界面
                    ; 双缓冲
                    mov hdc, eax
                    invoke CreateCompatibleDC, hdc
                    mov hDCMem, eax
                    invoke CreateCompatibleBitmap, hdc, 720, 1080
                    mov hBmpMem, eax
                    invoke SelectObject, hDCMem, hBmpMem
                    mov hPreBmp, eax
                    ; 页面刷新
                    invoke CreateSolidBrush, color_white
                    mov hBrush, eax
                    invoke Rectangle, hDCMem, 720, 1080, 0, 0

                    ; 繪製遊戲背景圖
                    invoke BitBlt, hDCMem, -0, 0, gamebackgroundinfo.bmWidth, gamebackgroundinfo.bmHeight, bithdc[16], 0, 0, SRCCOPY

                    ; 绘制返回窗口按钮
                    ;invoke BitBlt, hDCMem, backbutton.start_x, backbutton.start_y, backmainwindowinfo.bmWidth, backmainwindowinfo.bmHeight, bithdc[32], 0, 0, SRCCOPY
                    invoke TransparentBlt, hDCMem, 0, 0, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[32], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_white

                    ; 初始化画笔
                    invoke CreatePen, PS_SOLID, 0, color_black
                    mov hpen, eax
                    invoke CreateCompatibleDC, hpen

                    ; 用圆珠笔画一个空心圆（不需要了）
                    ; invoke SelectObject, hdc, hpen
                    ; invoke Ellipse, hdc, 0, 0, 150, 150

                    ; 用刷子画一个针，已经完成了封装，具体看 DrawPin 介绍
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
                ; 初始底部针和虚线
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
                    ; 画大圆
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

                    ; 大圆

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

                    ; 记录静音按钮区域
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
                    ; 绘制静音按钮
                     invoke TransparentBlt, hDCMem, mutebutton.start_x, mutebutton.start_y, muteinfo.bmWidth, muteinfo.bmHeight, bithdc[8], \
                     0, 0, muteinfo.bmWidth, muteinfo.bmHeight, color_black


                     .IF endlessmodel == 1
                      ;标明模式
                     invoke SelectObject, hDCMem, gamefont
                    invoke SetTextColor, hDCMem, color_black
                    invoke SetBkMode, hDCMem, TRANSPARENT
                    invoke strlen, offset endlesstext
                    invoke TextOut, hDCMem, 315, 200, offset endlesstext, eax
                    invoke inttostr, score
                    invoke strlen, offset Numstr
                     .ELSE;标明模式
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



                    ; 点击了鼠标左键的情况
                    .ELSEIF uMsg == WM_LBUTTONDOWN
                    mov eax, lParam
                    shr eax, 16
                    mov ebx, lParam
                    invoke Mouse_LeftClickCallBack, bx, ax


                    ; Todo: 计时器不同状态的函数
                    .ELSEIF uMsg == WM_TIMER
                    .IF wParam == Timer_Render
                    ; 更新画面，刷新（把每一帧执行的动作（例如刷新画面，旋转）划到这里）
                    ; invoke printf, offset szTest1
                    ; Timer_RenderCallBack, hwnd; 这个应该是刷新帧率的函数
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

                    ; 调用C库的随机数生成函数 rand
                    invoke srand, seed
                    invoke rand
                    mov ebx, 6
                    div ebx
                    .if edx == 0
                    jmp rechange
                    .endif
                    mov change_time, edx

                    loop2 :
                ; 改变速度
                    invoke GetTickCount
                    mov seed, eax

                    ; 调用C库的随机数生成函数 rand
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
                    ; 可以自定义帧数（目前是两帧，和 Timer_Animate 绑定）
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