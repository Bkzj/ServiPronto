"""ServiPronto commercial concept. Original illustrations are embedded, not edited."""
from pathlib import Path
import math
import json
from xml.sax.saxutils import escape
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase.pdfdoc import PDFString
from reportlab.lib.colors import HexColor, Color
from reportlab.platypus import Paragraph
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.utils import ImageReader
from PIL import Image
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / 'output/pdf/ServiPronto-venta-de-idea.pdf'
QA = ROOT / 'tmp/pdfs'
ASSETS = Path('C:/Users/nouso/OneDrive/Escritorio/ServiPronto')
LOGO = ASSETS / 'Castor/Logo ServiPronto.png'
PRO = ASSETS / 'Proveedores'
W, H = 1080, 675
BLUE, NAVY, ORANGE = '#145D97', '#112E49', '#FF7C24'
INK, MUTED, PALE, CREAM, WHITE = '#17354F', '#556D80', '#EAF3FA', '#FFF2E4', '#FFFFFF'
GREEN, LINE = '#24795A', '#D7E4EC'
FONTS = Path('C:/Windows/Fonts')
for name, filename in [('Round', 'ARLRDBD.TTF'), ('Body', 'segoeui.ttf'), ('Bold', 'segoeuib.ttf'), ('Comic', 'comic.ttf')]:
    pdfmetrics.registerFont(TTFont(name, str(FONTS / filename)))
pdfmetrics.registerFontFamily('Body', normal='Body', bold='Bold', italic='Body', boldItalic='Bold')
OUT.parent.mkdir(parents=True, exist_ok=True)
QA.mkdir(parents=True, exist_ok=True)
c = canvas.Canvas(str(OUT), pagesize=(W,H), pageCompression=1)
c.setTitle('ServiPronto')
c.setAuthor('ServiPronto')
c.setSubject('Una mano para resolver. Presentación comercial de la idea.')
c.setCreator('ServiPronto')
c._doc.Catalog.Lang = PDFString('es-AR')
page = 0
text_bounds = []

def col(value): return HexColor(value)

def rect(x,y,w,h,fill,stroke=None,lw=1):
    c.setFillColor(col(fill)); c.setStrokeColor(col(stroke or fill)); c.setLineWidth(lw)
    c.rect(x,H-y-h,w,h,fill=1,stroke=bool(stroke))

def shape_path(x,y,w,h,r=22):
    """Quintic corner samples with zero curvature at straight-edge joins."""
    r=min(r,w/2,h/2)
    controls=[(r,0),(.65*r,0),(.25*r,0),(0,.25*r),(0,.65*r),(0,r)]
    corner=[]
    for i in range(25):
        t=i/24
        corner.append(tuple(sum(math.comb(5,k)*(1-t)**(5-k)*t**k*controls[k][a] for k in range(6)) for a in (0,1)))
    p=c.beginPath()
    # top-left corner traverses from top toward left; traverse perimeter counterclockwise.
    pts=[(x+u,y+v) for u,v in corner]
    pts += [(x+u,y+h-v) for u,v in reversed(corner)]
    pts += [(x+w-u,y+h-v) for u,v in corner]
    pts += [(x+w-u,y+v) for u,v in reversed(corner)]
    p.moveTo(pts[0][0],H-pts[0][1])
    for xx,yy in pts[1:]: p.lineTo(xx,H-yy)
    p.close()
    return p

def box(x,y,w,h,fill=WHITE,r=22,stroke=None,lw=1):
    c.setFillColor(col(fill)); c.setStrokeColor(col(stroke or fill)); c.setLineWidth(lw)
    c.drawPath(shape_path(x,y,w,h,r),fill=1,stroke=bool(stroke))

def circle(x,y,r,fill,stroke=None,lw=1):
    c.setFillColor(col(fill)); c.setStrokeColor(col(stroke or fill)); c.setLineWidth(lw)
    c.circle(x,H-y,r,fill=1,stroke=bool(stroke))

def line(x1,y1,x2,y2,color=LINE,lw=1,dash=None):
    c.saveState();c.setStrokeColor(col(color));c.setLineWidth(lw)
    if dash:c.setDash(*dash)
    c.line(x1,H-y1,x2,H-y2);c.restoreState()

def txt(s,x,y,size=20,font='Body',color=INK,w=None,leading=None,align='left'):
    leading=leading or size*1.2
    if w is None:
        for i,part in enumerate(s.split('\n')):
            width=pdfmetrics.stringWidth(part,font,size)
            xx=x-width/2 if align=='center' else x-width if align=='right' else x
            c.setFont(font,size);c.setFillColor(col(color));c.drawString(xx,H-y-size*.83-i*leading,part)
            text_bounds.append((page,part,round(xx,2),round(y+i*leading,2),round(width,2),round(leading,2)))
        return len(s.split('\n'))*leading
    p=Paragraph(escape(s).replace('\n','<br/>'), ParagraphStyle('p',fontName=font,fontSize=size,leading=leading,textColor=col(color),alignment={'left':0,'center':1,'right':2}[align]))
    _,height=p.wrap(w,H)
    p.drawOn(c,x,H-y-height)
    text_bounds.append((page,s,round(x,2),round(y,2),round(w,2),round(height,2)))
    return height

def pill(s,x,y,fill=PALE,color=BLUE,size=13,h=30,w=None):
    w=w or pdfmetrics.stringWidth(s,'Bold',size)+26
    box(x,y,w,h,fill,r=h/2);txt(s,x+w/2,y+(h-size)/2-1,size,'Bold',color,align='center')
    return w

def photo(path,x,y,w,h,region=None,r=0):
    """Crop only the PDF viewport; preserve the raster source unchanged."""
    path=Path(path)
    with Image.open(path) as im: iw,ih=im.size
    region=region or (0,0,1,1)
    a,b,d,e=region; rw,rh=(d-a)*iw,(e-b)*ih
    scale=max(w/rw,h/rh)
    dw,dh=iw*scale,ih*scale
    dx=x+(w-rw*scale)/2-a*dw
    dy=y+(h-rh*scale)/2-b*dh
    c.saveState()
    if r:c.clipPath(shape_path(x,y,w,h,r),stroke=0,fill=0)
    else:
        p=c.beginPath();p.rect(x,H-y-h,w,h);c.clipPath(p,stroke=0,fill=0)
    c.drawImage(str(path),dx,H-dy-dh,dw,dh,mask='auto')
    c.restoreState()

def jorge(x,y,size=160): photo(LOGO,x,y,size,size,(.22,.245,.78,.78))

def bubble(s,x,y,w,h,fill=WHITE,color=INK,tail='left',size=20,stroke=NAVY):
    box(x,y,w,h,fill,r=22,stroke=stroke,lw=1.6)
    c.setFillColor(col(fill));c.setStrokeColor(col(stroke));c.setLineWidth(1.6)
    p=c.beginPath()
    if tail=='upper-left':
        p.moveTo(x+24,H-y-1);p.lineTo(x-17,H-y+20);p.lineTo(x+52,H-y-1)
    elif tail=='top':
        p.moveTo(x+w*.55,H-y-1);p.lineTo(x+w*.65,H-y+23);p.lineTo(x+w*.64,H-y-1)
    elif tail=='left':
        p.moveTo(x+28,H-y-h+1);p.lineTo(x+13,H-y-h-17);p.lineTo(x+55,H-y-h+1)
    else:
        p.moveTo(x+w-55,H-y-h+1);p.lineTo(x+w-13,H-y-h-17);p.lineTo(x+w-28,H-y-h+1)
    c.drawPath(p,stroke=1,fill=1)
    if tail=='upper-left':
        line(x+25,y,x+51,y,fill,3)
    elif tail=='top':
        line(x+w*.55+1,y,x+w*.64-1,y,fill,3)
    else:
        line(x+29 if tail=='left' else x+w-54,y+h,x+54 if tail=='left' else x+w-29,y+h,fill,3)
    ht=txt(s,x+20,y+17,size,'Comic',color,w=w-40,leading=size*1.3)
    assert ht <= h-26, (page,s,ht,h)

def arrow(x1,y1,x2,y2,color=BLUE,lw=2):
    line(x1,y1,x2,y2,color,lw)
    angle=math.atan2(y2-y1,x2-x1)
    for delta in (-.55,.55):
        a=angle+math.pi+delta;line(x2,y2,x2+9*math.cos(a),y2+9*math.sin(a),color,lw)

def icon(kind,x,y,size=30,color=BLUE):
    c.saveState();c.setStrokeColor(col(color));c.setFillColor(col(color));c.setLineWidth(2)
    if kind=='home':
        p=c.beginPath();p.moveTo(x,H-y-size*.42);p.lineTo(x+size*.5,H-y);p.lineTo(x+size,H-y-size*.42);c.drawPath(p)
        c.rect(x+size*.17,H-y-size*.93,size*.66,size*.52,stroke=1,fill=0)
    elif kind=='check':
        p=c.beginPath();p.moveTo(x,H-y-size*.48);p.lineTo(x+size*.35,H-y-size*.8);p.lineTo(x+size,H-y-size*.1);c.drawPath(p)
    elif kind=='search':
        c.circle(x+size*.37,H-y-size*.37,size*.28,stroke=1,fill=0);line(x+size*.58,y+size*.58,x+size*.9,y+size*.9,color,2)
    elif kind=='person':
        c.circle(x+size*.5,H-y-size*.24,size*.18,stroke=1,fill=0)
        p=c.beginPath();p.moveTo(x+size*.12,H-y-size*.95);p.curveTo(x+size*.12,H-y-size*.48,x+size*.88,H-y-size*.48,x+size*.88,H-y-size*.95);c.drawPath(p)
    elif kind=='calendar':
        c.roundRect(x,H-y-size*.9,size,size*.8,3,stroke=1,fill=0)
        line(x,y+size*.34,x+size,y+size*.34,color,2)
        for a in (.25,.75):line(x+a*size,y,x+a*size,y+size*.2,color,2)
    elif kind=='heart':
        p=c.beginPath();p.moveTo(x+size*.5,H-y-size*.95);p.curveTo(x-size*.2,H-y-size*.45,x+size*.05,H-y-size*.02,x+size*.5,H-y-size*.25);p.curveTo(x+size*.95,H-y-size*.02,x+size*1.2,H-y-size*.45,x+size*.5,H-y-size*.95);c.drawPath(p)
    elif kind=='chat':
        c.roundRect(x,H-y-size*.75,size,size*.65,4,stroke=1,fill=0)
        line(x+size*.2,y+size*.75,x+size*.1,y+size*.97,color,2)
        line(x+size*.1,y+size*.97,x+size*.45,y+size*.75,color,2)
    elif kind=='shield':
        p=c.beginPath();p.moveTo(x+size*.5,H-y);p.lineTo(x+size,H-y-size*.16);p.curveTo(x+size,H-y-size*.7,x+size*.7,H-y-size*.9,x+size*.5,H-y-size);p.curveTo(x+size*.3,H-y-size*.9,x,H-y-size*.7,x,H-y-size*.16);p.close();c.drawPath(p)
    elif kind=='clock':
        c.circle(x+size/2,H-y-size/2,size*.46,stroke=1,fill=0);line(x+size/2,y+size/2,x+size/2,y+size*.23,color,2);line(x+size/2,y+size/2,x+size*.74,y+size*.64,color,2)
    c.restoreState()

def wordmark(x,y,size=18,dark=False):
    label=c.beginText(x,H-y-size*.83)
    label.setFont('Round',size)
    label.setFillColor(col(WHITE if dark else BLUE));label.textOut('Servi')
    label.setFillColor(col(ORANGE));label.textOut('Pronto')
    c.drawText(label)
    text_bounds.append((page,'ServiPronto',x,y,pdfmetrics.stringWidth('ServiPronto','Round',size),size*1.2))

def start(section,bg=WHITE,brand=True):
    global page
    page+=1;rect(0,0,W,H,bg)
    dark=bg in (NAVY,BLUE)
    c.bookmarkPage(f'page-{page}');c.addOutlineEntry(section,f'page-{page}',level=0)
    if brand:wordmark(64,31,17,dark)
    circle(985,647,3,ORANGE)
    txt(f'{page:02}',1016,640,10,'Bold','#AAC4D9' if dark else MUTED,align='right')

def end():c.showPage()

def headline(s,y=89,size=48,color=NAVY,w=945):txt(s,64,y,size,'Round',color,w=w,leading=size*1.08)

def footer_note(s,color=MUTED):txt(s,64,640,9,'Body',color,w=865,leading=11)

def button(s,x,y,w=160,fill=BLUE,color=WHITE):box(x,y,w,38,fill,16);txt(s,x+w/2,y+11,13,'Bold',color,align='center')

def phone(x,y,w=250,h=445):
    box(x+6,y+8,w,h,'#D8E6EF',36)
    box(x,y,w,h,NAVY,36)
    box(x+6,y+6,w-12,h-12,WHITE,31)
    box(x+w/2-36,y+12,72,14,NAVY,7)
    return x+18,y+38,w-36,h-60

# 01 - ServiPronto is the title, not a small logo above a slogan.
start('ServiPronto',brand=False)
txt('SERVICIOS PARA EL HOGAR',66,94,12,'Bold',MUTED)
wordmark(59,148,87)
txt('Una mano\npara resolver.',65,282,48,'Round',NAVY,leading=55)
txt('Encontrá profesionales.\nContratá con claridad.\nSentite acompañado.',67,428,22,'Body',INK,leading=32)
jorge(633,240,363)
bubble('Hola, soy Jorge.\n¿Qué necesitás resolver?',630,114,372,98,CREAM,size=21)
pill('Pensado para Tandil',65,566,PALE,BLUE,13)
footer_note('Presentación de la idea')
end()

# 02 - Problem, framed as a motivating scenario rather than fabricated research.
start('El problema',PALE)
headline('El problema no termina\ncuando conseguís un número.',size=46)
txt('Todavía falta saber quién puede ir, cuánto cobra y en quién confiar.',66,211,21,w=940)
box(64,277,598,287,WHITE,30)
bubble('¿Conocés un plomero?',89,301,292,66,CREAM,size=18)
bubble('Te aviso cuándo puedo.',316,390,317,66,PALE,size=18,tail='right')
bubble('¿Y cuánto sale la visita?',89,479,303,66,WHITE,size=18)
txt('Y quien trabaja\ntambién pierde tiempo.',708,296,27,'Round',BLUE,leading=35)
txt('Consultas sin contexto.\nHorarios que se cruzan.\nVisitas que no se concretan.',710,414,20,'Body',INK,leading=34)
end()

# 03 - App concept, manual and assisted entry points.
start('La solución')
headline('Encontrá. Elegí.\nResolvé.',size=53,w=620)
px,py,pw,ph=phone(725,127,276,475)
txt('¿Qué necesitás?',px,py+10,21,'Round',BLUE)
box(px,py+46,pw,38,PALE,15);icon('search',px+11,py+57,17)
txt('Buscar un servicio',px+36,py+56,12,'Body',MUTED)
box(px,py+100,pw,72,CREAM,18)
txt('Tu casa, al día',px+13,py+112,17,'Round',INK)
txt('Servicios para cada momento',px+13,py+140,11,'Body',MUTED)
txt('Servicios destacados',px,py+191,15,'Bold',INK)
for i,(name,img,reg) in enumerate([
    ('Plomería','Plomero Icon.png',(.41,.14,.79,.64)),
    ('Limpieza','Limpieza Icon.png',(.25,.12,.78,.74)),
    ('Clases','Particular Icon.png',(.47,.28,.89,.71))]):
    xx=px+i*81
    photo(PRO/img,xx,py+217,73,76,reg,r=14)
    txt(name,xx+36,py+302,10,'Bold',INK,align='center')
line(px,py+347,px+pw,py+347,LINE)
for i,(name,ic) in enumerate([('Inicio','home'),('Explorar','search'),('Jorge',None),('Actividad','calendar'),('Perfil','person')]):
    xx=px+pw*(i+.5)/5
    if ic:icon(ic,xx-8,py+364,16,BLUE if i==0 else MUTED)
    else:
        circle(xx,py+368,23,ORANGE);circle(xx,py+368,19,WHITE);jorge(xx-17,py+351,34)
    txt(name,xx,py+393,7.5,'Bold' if i==2 else 'Body',BLUE if i==2 else MUTED,align='center')
icon('search',66,300,31)
txt('Buscá por tu cuenta.',119,293,28,'Round',BLUE)
txt('Categorías, perfiles y disponibilidad.\nElegí con información antes de solicitar.',120,335,20,'Body',INK,leading=29)
icon('chat',66,440,31,color=ORANGE)
txt('O hablá con Jorge.',119,432,28,'Round',BLUE)
txt('Contale qué pasa. Te ayuda a entender\nqué servicio pedir y cómo avanzar.',120,474,20,'Body',INK,leading=29)
txt('Dos caminos. La misma tranquilidad para decidir.',66,575,18,'Bold',BLUE,w=610)
end()

# 04 - Brand identity, expressed commercially rather than as a style guide.
start('Una marca con oficio',NAVY)
headline('Una marca con oficio.\nUna voz cercana.',size=49,color=WHITE)
box(64,259,371,339,WHITE,40)
jorge(101,284,295)
txt('Jorge es el castor\nde ServiPronto.',485,273,35,'Round',WHITE,leading=43)
txt('Tiene la energía de quien se pone a trabajar\ny la calidez de quien te da una mano.',488,384,22,'Body','#D8E9F7',leading=32)
for x,word in [(488,'Reconocible.'),(749,'Amable.')]:
    txt(word,x,482,28,'Round',ORANGE)
txt('El azul del uniforme. El naranja del casco.\nLa misma identidad, en cada servicio.',488,541,19,'Body',WHITE,leading=29)
end()

# 05 - Proactivity shown as an in-context suggestion, never an automatic booking.
start('Jorge toma la iniciativa')
headline('Jorge no espera\nque sepas cómo seguir.',size=46,w=645)
txt('Es nuestro asistente de IA. Si te trabás,\nse acerca con una pregunta o una alternativa.',67,230,21,'Body',INK,leading=31)
for yy,ic,title in [(341,'search','Una búsqueda sin resultados.'),(400,'chat','Una categoría que no conocés.'),(459,'calendar','Un presupuesto difícil de armar.')]:
    icon(ic,68,yy+1,25,ORANGE)
    txt(title,113,yy,20,'Bold',INK)
txt('Proactivo para ayudar.\nVos seguís decidiendo.',67,551,25,'Round',BLUE,leading=32)
px,py,pw,ph=phone(729,121,273,477)
txt('Plomería',px,py+11,23,'Round',BLUE)
pill('Hoy · Por la tarde',px,py+56,PALE,BLUE,12,h=31,w=pw)
icon('search',px+92,py+123,48,MUTED)
txt('Sin opciones\nen ese horario',px+pw/2,py+194,21,'Round',BLUE,align='center',leading=29)
txt('Podés ajustar tu búsqueda.',px+pw/2,py+267,12,'Body',MUTED,align='center')
button('Cambiar horario',px,py+319,pw)
box(609,475,77,77,WHITE,24)
jorge(613,479,69)
bubble('¿Querés que busquemos\npara otro horario?',679,534,331,87,CREAM,size=18,tail='upper-left')
end()

# 06 - A short comic: understand, contextualize, and prepare a decision.
start('Jorge en acción',CREAM)
headline('Contale qué pasa.\nLo ordenan juntos.',size=45)
panels=[(64,239,303,339),(388,239,303,339),(712,239,304,339)]
for idx,(x,y,w,h) in enumerate(panels):
    box(x,y,w,h,WHITE,27,stroke='#E5D5C5',lw=1)
    jorge(x+19,y+242,77)
bubble('No sé quién arregla\nesta pérdida.',84,264,259,83,PALE,size=17,tail='right')
bubble('Te ayudo. ¿Podés\nmandarme una foto?',101,383,244,84,CREAM,size=17)
bubble('Sí, acá se ve\nde dónde sale.',408,264,259,83,PALE,size=17,tail='right')
bubble('Gracias. ¿En qué\ndirección sería?',425,383,244,84,CREAM,size=17)
bubble('Es en casa de\nmi mamá, en Tandil.',732,264,259,83,PALE,size=17,tail='right')
bubble('Busquemos opciones\nque atiendan ahí.',749,383,244,84,CREAM,size=17)
txt('Vos revisás el perfil y confirmás. El profesional acepta la solicitud.',64,605,19,'Bold',BLUE,w=950)
end()

# 05 - Trust, profile-style evidence without invented ratings.
start('La confianza')
headline('Elegir con información\ncambia la experiencia.',size=46)
box(64,232,388,363,PALE,30)
photo(PRO/'Plomero Icon.png',89,255,102,106,(.40,.12,.80,.52),r=24)
txt('Perfil profesional',211,266,21,'Round',BLUE)
txt('Plomería · Tandil',212,298,14,'Body',MUTED)
pill('Aprobado',211,325,WHITE,GREEN,11,h=27)
txt('Conocé a quién vas a recibir.',89,388,19,'Bold',INK,w=337)
for i,s in enumerate(['Tareas y trabajos anteriores','Reseñas por aspectos','Cobertura y disponibilidad']):
    icon('check',90,437+i*43,18,GREEN);txt(s,121,434+i*43,17,'Body',INK)
for yy,ic,title,body in [
    (252,'shield','Perfiles revisados','Identidad, experiencia y credenciales relevantes para cada tarea.'),
    (373,'check','Condiciones claras','Alcance e importes antes de aceptar. Adicionales con tu aprobación.'),
    (494,'chat','Comunicación cuidada','Chat interno, teléfonos ocultos y un canal para resolver incidentes.')]:
    icon(ic,508,yy+3,31,ORANGE)
    txt(title,564,yy,27,'Round',BLUE,w=448)
    txt(body,565,yy+46,18,'Body',INK,w=444,leading=25)
end()

# 06 - Provider dashboard.
start('Para quien trabaja',CREAM)
headline('Más oficio.\nMenos ida y vuelta.',size=49,w=530)
txt('Que la app también sea\nuna herramienta de trabajo.',66,232,23,'Body',INK,leading=32)
for i,s in enumerate(['Elegí tu radio y tus tarifas.','Organizá agenda y oportunidades.','Prepará presupuestos con Jorge.','Concentrá trabajos y cobros.']):
    circle(72,350+i*52,4,ORANGE);txt(s,93,337+i*52,20,'Bold',INK)
box(599,124,417,438,WHITE,30)
txt('Tu jornada',625,151,28,'Round',BLUE)
pill('Disponible',854,153,PALE,GREEN,12,h=29)
for i,(hour,job,state) in enumerate([('09:00','Visita de plomería','Confirmada'),('11:30','Preparar presupuesto','Pendiente'),('15:00','Continuación de trabajo','Programada')]):
    yy=218+i*89
    txt(hour,626,yy,18,'Bold',BLUE)
    txt(job,704,yy,17,'Bold',INK,w=273)
    txt(state,705,yy+30,14,'Body',MUTED)
    if i<2:line(626,yy+63,987,yy+63,LINE)
button('Ver oportunidades',627,499,360,ORANGE,INK)
txt('Tu tiempo también tiene valor.',66,570,23,'Round',BLUE)
end()

# 07 - Family hiring.
start('La contratación familiar')
headline('También para cuidar\na quienes querés.',size=47)
txt('Contratá para un familiar, aunque estés en otra ciudad.',66,213,21,'Body',INK,w=950)
box(64,282,337,268,PALE,28)
icon('person',202,311,55,BLUE)
txt('Vos contratás.',231,394,27,'Round',BLUE,align='center')
txt('Elegís, coordinás y pagás.',231,450,18,'Body',INK,align='center')
box(678,282,338,268,CREAM,28)
icon('home',819,311,55,ORANGE)
txt('Tu familiar recibe.',847,394,27,'Round',BLUE,align='center')
txt('Sin obligación de instalar la app.',847,450,17,'Body',INK,align='center')
arrow(416,436,662,436,BLUE,2)
jorge(481,473,116)
bubble('Busco cerca\nde su casa.',419,287,242,92,WHITE,size=21)
txt('Menos barreras para la gente grande. Más tranquilidad para la familia.',64,604,20,'Bold',BLUE,w=950)
end()

# 08 - Catalog, use original portrait crops and no repeated descriptions.
start('El catálogo',PALE)
headline('Una necesidad distinta.\nEl mismo lugar para resolverla.',size=40)
categories=[
    ('Plomería','Plomero Icon.png',(.40,.12,.80,.52)),
    ('Electricidad','Electricista Icon.png',(.44,.13,.84,.53)),
    ('Gas y calefacción','Gasista Icon.png',(.37,.08,.87,.58)),
    ('Limpieza','Limpieza Icon.png',(.27,.08,.79,.60)),
    ('Jardinería','Jardinero Icon.png',(.29,.08,.82,.61)),
    ('Mudanzas y fletes','Mudanza Icon.png',(.36,.10,.78,.52)),
    ('Clases particulares','Particular Icon.png',(.44,.26,.90,.72)),
    ('Reparación técnica','General Icon.png',(.39,.17,.77,.55)),
]
for i,(title,img,reg) in enumerate(categories):
    x=64+(i%4)*243;y=212+(i//4)*177
    box(x,y,223,164,WHITE,24)
    photo(PRO/img,x+56,y+10,111,111,reg,r=17)
    txt(title,x+111.5,y+136,16,'Bold',INK,align='center')
for x,title in [(64,'Aire acondicionado'),(389,'Cámaras y seguridad'),(714,'Mecánica a domicilio')]:
    box(x,572,303,39,WHITE,16);txt(title,x+151.5,582,16,'Bold',BLUE,align='center')
end()

# 11 - Repeat value and payments, without operational fine print.
start('Por qué volver',BLUE)
headline('Un buen servicio\npuede ser el comienzo.',size=44,color=WHITE,w=620)
txt('Volvé a elegir a quien ya conocés,\nsin empezar otra vez de cero.',67,222,23,'Body',WHITE,leading=33)
box(690,116,312,285,WHITE,35)
jorge(732,145,224)
bubble('¿Querés volver a pedirle\na quien ya te ayudó?',610,434,392,99,CREAM,size=21,tail='top')
for yy,title in [(344,'Tu profesional, guardado.'),(399,'Tus acuerdos, a mano.'),(454,'La próxima visita, organizada.')]:
    txt(title,66,yy,25,'Round',WHITE)
txt('Pagos dentro de la app, con Mercado Pago.',66,560,21,'Bold',WHITE)
txt('Visitas, clases o trabajos por etapas: cada servicio con sus condiciones.',66,600,17,'Body','#D8E9F7',w=925)
end()

# 12 - Commercial potential, not internal progress or a pricing announcement.
start('El modelo de negocio')
headline('Más conexiones útiles.\nMás valor compartido.',size=47)
txt('Un modelo comercial alrededor de los servicios y de la comunidad local.',66,212,21,'Body',INK,w=930)
for x,num,title,body,fill in [
    (64,'01','Comisiones','Por consultas y contrataciones, con condiciones según el servicio.',PALE),
    (389,'02','Publicidad local','Comercios y promociones que encuentran un espacio propio.',CREAM),
    (714,'03','Premium','Funciones adicionales para quienes necesitan más de la app.',PALE)]:
    box(x,285,303,229,fill,28)
    txt(num,x+23,309,16,'Round',ORANGE)
    txt(title,x+24,356,25,'Round',BLUE,w=256)
    txt(body,x+25,415,18,'Body',INK,w=251,leading=26)
txt('La reputación se gana. No se compra.',64,557,27,'Round',BLUE)
txt('La publicidad tiene su lugar, separado del ranking de profesionales.',65,601,18,'Body',INK,w=950)
footer_note('Modelo de ingresos propuesto: comisiones y premium como vías futuras.')
end()

# 13 - Sales close. No development status, fabricated traction, or contact details.
start('Una mano más cerca',CREAM,brand=False)
wordmark(61,90,72)
txt('Una mano\nmás cerca.',65,217,61,'Round',NAVY,leading=67)
txt('Hogares que necesitan resolver.\nProfesionales que quieren trabajar.\nUna marca que los conecta.',68,394,22,'Body',INK,leading=33)
txt('¿Le damos una mano a Tandil?',66,564,28,'Round',BLUE)
box(663,183,353,350,WHITE,42)
jorge(687,211,305)
bubble('Vos contame.\nVamos paso a paso.',658,63,358,102,WHITE,size=24)
footer_note('Presentación de concepto. Pantallas y conversaciones ilustrativas.')
end()

c.save()
reader=PdfReader(str(OUT))
assert len(reader.pages)==13
violations=[]
for p,s,x,y,w,h in text_bounds:
    if x < -1 or y < -1 or x+w > W+1 or y+h > H+1:
        violations.append((p,s,x,y,w,h))
assert not violations, violations
for p in reader.pages:
    assert p.extract_text().strip()
all_text=' '.join(p.extract_text() for p in reader.pages)
for forbidden in ['OpenAI','Gemini','Flutter','NestJS','PostgreSQL','Spec Kit','arquitectura','ingenieros','documentados','BETA CERRADA']:
    assert forbidden.casefold() not in all_text.casefold(), forbidden
assert 'ServiPronto' in reader.pages[0].extract_text()
assert 'proactivo' in all_text.casefold()
(QA/'layout-audit.json').write_text(json.dumps({'pages':len(reader.pages),'text_blocks':len(text_bounds),'bounds_errors':violations,'bounds':text_bounds},ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'pdf':str(OUT),'pages':len(reader.pages),'bytes':OUT.stat().st_size,'text_bounds_errors':0},ensure_ascii=False))
