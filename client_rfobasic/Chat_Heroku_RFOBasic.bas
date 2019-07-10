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

! USING$(,"%02.0f",0)    % pour afficher 01 pour 1.

DIM rep[4]

url$ ="https://plateaux.herokuapp.com/"

List.Create S,comm

DO

  GOSUB InitScreen
  new =0

  Do

    if !link : GOSUB CheckConnection
    else     : GOSUB Consulter
    endif

    do
      gr.touch touched, x, y : pause 10
      if !background() then gr.render
    until touched | new | quit
    if new | quit then D_U.break

    while touched
      gr.touch touched, tx, ty
    repeat
    tx/=sx : ty/=sy : ch =0

    if tx>1080 & ty>100 & ty<460       % envoi sur le Channel correspondant
      ch =int((ty-100)/ec)+(ty>100)
      if !link
        GOSUB CheckConnection
      elseif ch>0 & ch<5
        Input "    Saisir le texte pour le Channel "+int$(ch)+"    ", mess$, "", IsCanceled
        if !IsCanceled & mess$<>"" then GOSUB Envoyer
      endif

    endif

  Until new
UNTIL quit
END "Bye...!"

OnBackKey:
  Dialog.message win$,"       What do you want ?", ok, " Exit ", " New ? ", " Cancel "
  new  =(ok=2) : quit =(ok=1)
Back.Resume

CheckConnection:    %  cannot do this within a function as returns improper results
Link =0
SYSTEM.OPEN
SYSTEM.WRITE "ping -w1 8.8.8.8"
!SYSTEM.WRITE "ping www.tapatalk.com"
FOR z1=1 TO 6
 PAUSE 250 : GR.MODIFY mess, "text", "Connecting to server :"+INT$(z1)+"/6" : gr.render
NEXT z1
SYSTEM.READ.READY z1
DO
 SYSTEM.READ.LINE a$
 SYSTEM.READ.READY z2
UNTIL z2=0
IF z1>0 THEN z2 =1 ELSE z2 =0      % z2=1 means connected
SYSTEM.CLOSE
if !z2
  Dialog.Message "   Pas de connection Internet !   ", "please activate...", go, "Ok", "Cancel"
else
  GrabUrl res$, url$ : pause 200 : gr.modify mess, "text", res$ : link =1
endif
RETURN

Envoyer:
 List.CLear comm
 List.Add comm, "message"
 List.Add comm, mess$
 HTTP.POST url$+"Channel"+int$(ch), comm, rep$
 t1 =clock() : do : until rep$=mess$ | clock()-t1>6000    % message acquité ou 6 secondes dépassées.
 if rep$<>mess$
   POPUP " Soucis de connection internet ? ",,-650,1
 else
   POPUP " message envoyé... ",,-650
 endif
RETURN

Consulter:       % lit et affiche le contenu des 4 Channels.
 for c=1 to 4
   rep$ ="" : t1 =clock()
   do
     GrabUrl rep$, url$+"Channel"+int$(c) : pause 100
     gr.modify rep[c], "text", rep$ : gr.render
   until rep$<>"" | clock()-t1>6000   % message lu ou 6 secondes dÃ©passÃ©es.
   if rep$="" | new | quit
     gr.modify mess, "text", " Soucis de connection internet ? "
     F_n.Break
   endif
 next
RETURN

InitScreen:
GR.CLS
ec =90 : gr.text.size 34 : gr.text.align 1
for t=1 to 4
  clr("255 255 252 204 1")
  gr_Rect(160,100+(t-1)*ec, 50, scx-400,70, 1)
  gr_Rect(1080,100+(t-1)*ec, 50, 180,70, 1)
  clr("255 255 127 39 0") : gr.text.draw nul, 15, 100+t*ec-40, "Channel"+int$(t)
  clr("255 50 50 50 1") : gr.text.draw nul, 1120, 100+t*ec-40, "Ecrire"
  clr("255 0 0 255 1") : gr.text.draw rep[t], 180, 100+t*ec-40, "..."
next
clr("255 255 250 153 1") : gr.text.align 2
gr.text.draw mess, scx/2, 50, "..."

gr.text.draw nul, scx/2, 100+6*ec-40, "bientôt ici le contenu du 'Chat'..."
Return


