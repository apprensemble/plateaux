REM test com via https://plateaux.herokuapp.com/abande   fait par Thierry Vogel   @Cassiope34 0619

FN.DEF clr( c$ )   %  format: alpha R V B mode
  gr.color val(word$(c$,1)), val(word$(c$,2)), val(word$(c$,3)), val(word$(c$,4)), val(word$(c$,5))
FN.END

FN.DEF gr_Rect(x,y, c, lx,ly, fill)     %  make rectangle with rounded corners.
GR.ARC nul, x, y, x+c, y+c, -90, -90, fill     % top left
GR.ARC nul, x+lx-c,y, x+lx, y+c, -90, 90, fill   % top right
GR.ARC nul, x, y+ly-c,x+c, y+ly, -180, -90, fill   % bottom left
GR.ARC nul, x+lx-c, y+ly-c, x+lx, y+ly, 0, 90, fill  % bottom right
if !fill
  GR.LINE r1, x+c/2, y, x+lx-c/2, y     % left
  GR.LINE r2, x, y+c/2, x, y+ly-c/2     % up
  GR.LINE r3, x+c/2, y+ly, x+lx-c/2, y+ly  % right
  GR.LINE r4, x+lx, y+c/2, x+lx, y+ly-c/2  % down
else
  c*=0.4
  gr.rect nul, x+c, y, x+lx-c, y+ly
  gr.rect nul, x, y+c, x+lx, y+ly-c
endif
FN.END

GR.OPEN 255,90,140,80,0,0    %  landscape
gr.screen w,h : scx =1280 : scy =800 : sx =w/scx : sy =h/scy : gr.scale sx, sy

! USING$(,"%02.0f",0)  % pour afficher 01 pour 1.

url$ ="https://plateaux.herokuapp.com/abande/"

GOSUB Wifi
List.Create S,comm

DO

  new =0
  GOSUB InitScreen

  Do

    do
      gr.touch touched, x, y : pause 10
      if !background() then gr.render
    until touched | new | quit
    if new | quit then D_U.break
    x/=sx : y/=sy

    while touched
      gr.touch touched, tx, ty
    repeat
    tx/=sx : ty/=sy

    if tx>400 & tx<400+480 & ty>200 & ty<260        % envoi
      Input "    Saisir le texte     ", mess$, "", IsCanceled
      if !IsCanceled
        GOSUB Envoyer
      endif

    elseif tx>400 & tx<400+480 & ty>400 & ty<460    % consulte
      GOSUB Consulter
      gr.modify mess, "text", "reÃ§u : "+res$

    endif

  Until new
UNTIL quit
END "Bye...!"

OnBackKey:
  Dialog.message win$,"       What do you want ?", ok, " Exit ", " New ? ", " Cancel "
  new  =(ok=2) : quit =(ok=1)
Back.Resume

WiFi:
go =0 : link =0
do
  SOCKET.MyIP myip$
  if myip$ = "" then Dialog.Message "WiFi not active","please activate...",go,"Ok","Cancel"
until len(myip$) | go=2
if len(myip$) then link =1
RETURN

Envoyer:
 List.CLear comm
 List.Add comm, "Message"
 List.Add comm, "{\"message\":"+mess$+"}"
 HTTP.POST url$, comm, rep$
 pause 200
 if len(rep$) then popup "  message envoyé...  "
RETURN

Consulter:
 GrabUrl res$, url$
 pause 200
RETURN

InitScreen:
GR.CLS
gr.set.stroke 4
clr("255 255 127 39 0")
gr_Rect(400,200, 50, 480,60, 0)
gr_Rect(400,400, 50, 480,60, 0)
gr.set.stroke 2
clr("255 0 255 74 1")
gr.text.align 2 : gr.text.size 40
gr.text.draw nul, scx/2, 242, "Envoyer un message"
gr.text.draw nul, scx/2, 442, "Lire le message"
clr("255 255 250 153 1")
gr.text.draw mess, scx/2, 600, "..."
Return

