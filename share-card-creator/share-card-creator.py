#!/usr/bin/env python3


card="""
{
    "cards":[
        {"guests":[
            {"x":304, "y":83 , "width":257 , "height":281 }
        ],
        "xtext":628
        },
        
        { "guests":[
            {"x":309, "y":53 , "width":252 , "height":260 },
            {"x":309, "y":364 , "width":252 , "height":260 }
        ],
        "xtext":624
        },
        
        { "guests":[
            {"x":59,  "y":233 , "width":199 , "height":208 },
            {"x":303, "y":105 , "width":199 , "height":208 },
            {"x":303, "y":358 , "width":199 , "height":208 }
        ],
        "xtext":573
        },
        
        { "guests":[
            {"x":249,  "y":171 , "width":177 , "height":185 },
            {"x":249,  "y":401 , "width":177 , "height":185 },
            {"x":469,  "y":91 ,  "width":177 , "height":185 },
            {"x":469,  "y":322 , "width":177 , "height":185 }
        ],
        "xtext":700
        }
    ]
}
"""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


import os,re,math,sys,getopt,glob,shutil,subprocess,math
import json
from pathlib import Path


def multiPlatformExec(bash):    
    #Modified the scritp for run on linux and mac.
    is_windows = sys.platform.lower().startswith('win')
    is_mac = sys.platform.lower().startswith('darwin')   
    
    if (is_windows):
        return bash
        #return (bash.replace("("," ^( ")).replace(")"," ^) ").replace("{","!").replace("}","!").replace("%","%%")
        #return (bash.replace("("," ^( ")).replace(")"," ^) ").replace("\n"," ").replace("{","!").replace("}","!").replace("%","%%")
    if (is_mac):
        #return bash
        return bash.replace("("," \\( ").replace(")"," \\) ").replace("\n"," \\\n").replace("!","\\!").replace("{","\\!").replace("}","\\!").replace("#","\\#")
        #return bash.replace("("," \\( ").replace(")"," \\) ").replace("\n"," \\\n").replace("!","\\!").replace("{","!").replace("}","!").replace("#","\\#")
    else:
        return bash.replace("magick","convert").replace("("," \\( ").replace(")"," \\) ").replace("\n"," \\\n").replace("!","\\!").replace("{","\\!").replace("}","\\!").replace("#","\\#")
        #return bash.replace("magick","convert").replace("("," \\( ").replace(")"," \\) ").replace("\n"," \\\n").replace("!","\\!").replace("{","\\!").replace("}","\\!").replace("#","\\#")
        #return (bash.replace("magick","convert").replace("("," \\( ")).replace(")"," \\) ").replace("\n"," \\\n").replace("!","\\!").replace("{","!").replace("}","!").replace("#","\\#")

def createTextImgByIMCmd(imText, rect=None , name="tmp-text.png", cropped=True): # rect={width, height}
    #Create a text image used for calculation purposes
    iscroped=" -trim " if cropped else " "
    if rect!=None:
        size=f""" -size {rect["width"]}x{rect["height"]} """
    else: 
        size=" "
    bash=f"""magick  -quality 100 -background transparent {size} {imText} {iscroped} {name}"""
    subprocess.call( multiPlatformExec(bash), shell=True) 
        
def getImgSize(path_img): 
    #Get widthxheight of any image
    for i in ['"' + path_img + '"', path_img ]: #dir with quotes , dir without quotes
        try:    
            size_cmd=f"""magick {i} -format "%wx%h" info:"""
            size_=subprocess.run(size_cmd ,  stdout=subprocess.PIPE,  shell=True)
            size_=size_.stdout.decode('utf-8').split("x")
            return {"width":int(size_[0]), "height":int(size_[1])}
        except Exception as e:
            print( "There was an exception running getImgSize " + size_cmd )

def getIMCmdAndFontSize(IMcmd, fontsize_start , fontsize_finish=15, ideal_dim=[-1,-1] ):    
    # Calculate the fontsize that better fits on an rect (ideal_dim)
    # For this it will create a temp text image
    asc=1    
    if ( fontsize_start>fontsize_finish ):
        asc=-1        
    fontsize=fontsize_start
    last_fontsize=fontsize
    while ( (fontsize >= fontsize_finish)==(asc==-1)  ):    
        IMcmd=IMcmd.replace("-pointsize "+ str(last_fontsize),  "-pointsize "+ str(fontsize) )
        
        createTextImgByIMCmd( IMcmd )
        textsize = getImgSize( getAbsolutePath("tmp-text.png")  )
        if ( ideal_dim[1]!=-1 and (textsize["height"]<=ideal_dim[1])==(asc==-1)  ): break
        if ( ideal_dim[0]!=-1 and (textsize["width"]<=ideal_dim[0])==(asc==-1)  ): break
        
        last_fontsize=fontsize
        fontsize+=1*asc
    
    return {"fontsize":fontsize, "cmd":IMcmd , "textsize":textsize }

def start(params):
    
    #After set the parameters , will create the elements of the template
    #photos, title, guest and playbutton
    
    jsoncard=json.loads(card)["cards"];
    
    # Test    
    # # title="""Maarten Dalmijn on avoiding the six most common agile spring planing mistake"""
    # title="""There is no matrix - Organizing teams for the digital era with Luis Goncalves, Founder of Evolution for All"""    
    # guests="Dr. Jhon Farlik, Sara Williams & Edward Norton"    
    # photos="guest/1.jpg,guest/4.jpg,guest/2.jpg,guest/3.jpg" # if not defined then glob images and look for sequence 1.png..n.png or 1.jpg..n.jpg    
    # #photos="guest/1.jpg" # if not defined then glob images and look for sequence 1.png..n.png or 1.jpg..n.jpg    
    # card_file="card.png"
    # template=""
    # fonts=["./fonts/ProximaNovaA-Bold.ttf","fonts/ProximaNovaA-Light.ttf"]    
    # required params
    
    title=params['title']
    guests=params['guests']
    photos=params['photos']
    
    #optional params
    
    card_file=params['card_file']    
    template=params['template']
    fonts=params['fonts']
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    title={"width":448 ,"height":324,"x":0,"y":0 , "text": title}
    guests={"width":448 ,"height":46,"x":0,"y":0 , "text": guests}

    count=0
    
    for i in (getFixArrFromStr(photos)): # get a photo array trimmed from string
        photos_arr.append(getAbsolutePath(i))
    
    len_imgs_guest=  len(photos_arr)    
    
    if (template==None or template==""): #set tempate
        template="templates/%s.png"%(len_imgs_guest)  
    template=getAbsolutePath(template)
    
    if (card_file==None or card_file==""): #set card file 
        card_file="card.png"
    card_file=getAbsolutePath(card_file)
    createDirIfNotExist(card_file)
            
    if (fonts==None or fonts==""): #set fonts
        fonts=["fonts/ProximaNovaA-Bold.ttf","fonts/ProximaNovaA-Regular.ttf"]
    else:
        fonts=getFixArrFromStr(fonts)
    
    playbtn_path=(getAbsolutePath(os.path.dirname(template))+"/"+ "play.png").replace("\\","/")
    
    templateSize=(getImgSize(template)) 
    
    cards=""
    title["x"] =  jsoncard[len_imgs_guest-1]["xtext"]
    guests["x"] =  title["x"]
    card_data = jsoncard[len_imgs_guest-1]["guests"]
    
    sep_title_guest=31

    # - - - - - - - - - - - - -
    # PHOTOS
    #   Create the image magick code for the photo crop and positioning.
    # - - - - - - - - - - - - -
    
    wh={"width":0,"height":0}
    for i in range(0,len_imgs_guest):        
        x=card_data[i]["x"]
        y=card_data[i]["y"]
        wh["width"]=int(card_data[i]["width"])
        wh["height"]=int(card_data[i]["height"])
        path=photos_arr[i]
        img_size = getImgSize(path)
        new_size = {"width":(img_size["width"]),"height":(img_size["height"]) }
        img_size_wh="width" if (img_size["width"]>img_size["height"]) else "height"        
        resize_factor = ( (wh[img_size_wh]+0.0) / (img_size[img_size_wh]+0.0)  )
        new_size["width"]=math.ceil(new_size["width"]* resize_factor)
        new_size["height"]=math.ceil(new_size["height"] * resize_factor)
        
        resize_and_crop=f""" -geometry {wh["width"]}!x{wh["height"]}!+{x}+{y} """ #still dont crop
        if (new_size["width"]>=wh["width"] and new_size["height"]>=wh["height"]):
            #do cropped
            resize_and_crop=f""" -geometry {new_size["width"]}!x{new_size["height"]}! -gravity center -crop {wh["width"]}!x{wh["height"]}! -gravity Undefined  -geometry +{x}+{y}  """
            
        cards+=f""" ( {path} {resize_and_crop}  ) -composite  """ 
        
    # - - - - - - - - - - - - -
    # TITLE aka content
    # This will create a temporaly 
    # Image text to calc , height and title's position
    # It will get an Imagemagick script with this info.
    # - - - - - - - - - - - - -
    
    maxfontsize = fontsize = 45 #22pt
    
    title_text=title["text"].replace('"','\\"')
    
    title_cmd = f"""-quality 100 -interline-spacing  12  -fill #FFFFFF -background transparent  -font {fonts[0]} -pointsize {fontsize} -size {title["width"]}!x{templateSize["height"]}! """
    title_cmd = (title_cmd + ' caption:"{title_text}" ').replace("{title_text}",title_text)
    title_cmd_fontsize = getIMCmdAndFontSize(title_cmd, maxfontsize , 15 , [-1,title["height"] ]  )
    
    title_size=title_cmd_fontsize["textsize"]
    
    # - - - - - - - - - - - - -
    # PODCAST TITLE aka content
    # This will create a temporaly 
    # Image text to calc , height and podcast title's position
    # It will get an Imagemagick script with this info.
    # - - - - - - - - - - - - -
    
    maxfontsize = fontsize = 24 #22pt
    
    podcast_cmd = f"""-quality 100 -interline-spacing  12  -kerning 2 -fill #F49F1C -background transparent  -font {fonts[0]} -pointsize {fontsize} -size {title["width"]}!x{templateSize["height"]}! """
    podcast_cmd = (podcast_cmd + ' caption:"PODCAST" ')
    podcast_cmd_fontsize = getIMCmdAndFontSize(podcast_cmd, maxfontsize , 15 , [ -1 , title["height"] ]  )
    
    podcast_size=podcast_cmd_fontsize["textsize"]
    
    # - - - - - - - - - - - - -
    # GUEST.
    # This will create a temporaly 
    # Image text to calc , height and podcast guest's position
    # It will get an Imagemagick script with this info.
    # - - - - - - - - - - - - -
    
    maxfontsize = fontsize = 19 #
    
    guest_text=guests["text"].replace('"','\\"')
    
    guest_cmd = f"""-quality 100 -interline-spacing 2 -fill #FFFFFF -background transparent  -font {fonts[0]} -pointsize {fontsize} -size {title["width"]}!x{templateSize["height"]}! """
    guest_cmd = (guest_cmd + ' caption:"{guest_text}" ').replace("{guest_text}", '\\        '+guest_text) #empty space its invisible with
    guest_cmd_fontsize = getIMCmdAndFontSize(guest_cmd, maxfontsize , 15 , [-1,title["height"] ]  )
    
    fontsize_small=int(fontsize)
    
    #guest_cmd_fontsize["cmd"]= (f""" -fill #FFFFFF -font {fonts[1]} -pointsize {fontsize_small}  label:"with"  """) + guest_cmd_fontsize["cmd"]
    guest_cmd_fontsize["cmd"]=' ( ' + guest_cmd_fontsize["cmd"] + ' ) ' + (f"""( -fill #FFFFFF -font {fonts[1]} -pointsize {fontsize_small}  label:"with"  ) -composite """) 
    
    guest_size=guest_cmd_fontsize["textsize"]
    
    # - - - - - - - - - - - - -
    # PLAY
    # - - - - - - - - - - - - -
    
    play_btn_x=title['x']-40
    play_btn_size=getImgSize( playbtn_path )
    
    # - - - - - - - - - - - - -
    # CALC. dimensions an positions. also
    # SET the finals Imagemagick commands 
    # - - - - - - - - - - - - -
    
    podcast_y_spc=40
    playbtn_y_spc=12
    
    height_title_sep_guest= ( title_size["height"] + sep_title_guest + guest_size["height"] )
    title["y"] = (templateSize["height"] - height_title_sep_guest   )*.5 #center
    guests["y"] = (title["y"] + sep_title_guest + title_size["height"] )
    podcasty = title["y"] - podcast_y_spc - podcast_cmd_fontsize["textsize"]["height"]
    play_btn_y = (guests["y"] + guest_size["height"] + playbtn_y_spc)
    play_btn_resize=""
    if (templateSize["height"]-play_btn_y <  play_btn_size["height"] ):
        newWH=(templateSize["height"]-playbtn_y_spc)-play_btn_y
        play_btn_resize=f""" -resize {newWH}!x{newWH}! """
    
    podcasttext = ' ( ' + podcast_cmd_fontsize["cmd"] + f"""  -geometry +{title["x"]}+{podcasty} ) -composite """
    
    titletext = ' ( ' + title_cmd_fontsize["cmd"] + f""" -geometry +{title["x"]}+{title["y"]} ) -composite """
    
    guesttext = ' ( ' + guest_cmd_fontsize["cmd"] + f"""   -geometry +{guests["x"]}+{guests["y"]} ) -composite """
    
    playtext= f""" ( "{playbtn_path}" -background transparent -geometry +{play_btn_x}+{play_btn_y} {play_btn_resize} ) -composite """
   
   
    # - - - - - - - - - - - - -
    # Bash
    # - - - - - - - - - - - - -
    
    os.remove("tmp-text.png")
    
    bash=f"""magick -quality 100 {template} {cards}  {titletext} {guesttext} {podcasttext}  {playtext} {card_file}"""
    
    subprocess.call( multiPlatformExec(bash) , shell=True)
    
# - - - - - - - - - - - - - - - - - - - -
#  UTILS.
# - - - - - - - - - - - - - - - - - - - -   
    
def getAbsolutePath(path):
    return os.path.abspath(path)

def createDirIfNotExist(path):    
    absolute_dir=os.path.dirname(os.path.realpath(path))
    if not os.path.exists(absolute_dir):
        Path(absolute_dir).mkdir(parents=True, exist_ok=True)
        
def getFixArrFromStr(str_, separator=","): 
    #get and trimmed array from a string with a separator
    arr=str_.split(separator)    
    data=[]
    for i in arr:
        data.append(i.strip())
    return data 

# - - - - - - - - - - - - - - - - - - - -
#  INIT.
# - - - - - - - - - - - - - - - - - - - -

def getCLIParameters(argv):
    #Process the parameters
    paramArr=["help", "title", "guests", "photos", "card_file", "template", "fonts"]
    params={ "title":None ,  "guests":None , "photos":None, "card_file":"card.png", "template":"", "fonts":""}
    for k in params.keys():
        paramArr.append(k+'=')
    
    try:
        opts, args = getopt.getopt(argv,"h",paramArr)
        for opt in opts:
            print(opt)
            print(opt[1:])
            print(opt[2:])
            if opt in ('h','help'):
                print(
                    "\n--title: The podcast title \n"+
                    "\n--guests: The guests names follow by commas i.e Dr Yen Gates,Alan Parker & Louis C.K \n"+
                    "\n--photos: The path of the guest list follow by commas i.e  \n"+                    
                    "\n--card_file: The path where the image will be save , default is card.png \n"+
                    "\n--template: The path of the template to use if not defined it will use the relative dir template/{num_guest}.png \n"
                    "\n--fonts: The path of the fonts to use , follow by commas, if not defined it will used these: 'fonts/ProximaNovaA-Bold.ttf,fonts/ProximaNovaA-Light.ttf' \n"
                )
                sys.exit()
            elif opt in params.keys():
                params[opt[1:]]=opt[2:]
    except Exception as e:
       print("Invalid parameter ")
       print(e)
       sys.exit()
       
    return params

def main(argv):
    params=getCLIParameters(argv)
    start(params)
    
if __name__ == "__main__": main(sys.argv[1:])