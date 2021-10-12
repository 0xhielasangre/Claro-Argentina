function captchaPWN() {
	var sourceToPwn = document.documentElement.innerHTML;
	var diccionario = {"SOBRE":"fa-envolpe","ANCLA":"fa-anchor","MOTO":"fa-motorcycle",
	"AUTO":"fa-car","CAMIÓN":"fa-truck","BANDERA":"fa-flag","LIBRO":"fa-book","TAZA":"fa-coffee",
	"PARAGUAS":"fa-umbrella","CUCHARA":"fa-spoon",
	"TIJERA":"fa-scissors","HOJAS":"fa-pagelines","CANDADO":"fa-lock","BICICLETA":"fa-bicycle",
	"ÁRBOL":"fa-tree","CORAZÓN":"fa-heart","ENCHUFE":"fa-plug","VALIJA":"fa-suitecase",
	"CÍRCULO":"fa-circle","LLAVE":"fa-key","CLIP":"fa-paperclip","LETRA":"fa-font",
	"TROFEO":"fa-thropy","ESTRELLA":"fa-star"};
	capWord = sourceToPwn.split('<strong id="cap-word" class="txt-uppercase">');
	visualCaptchaImg = capWord[1].split('<i class=fa ');
	capWord = capWord[1].split(</strong>);
	a = document.getElementsByTagName('a'):
	for (i=1;i<=4;i++) {
	visualCaptcha  = visualCaptchaImg[i].split('"');
		if(visualCaptcha[0] == diccionario[capWord[0]]){
		contiene = '/diccionario[capWord[0]]/';
		if(contiene.match(a[8+i])){
				a[8+i].className = 'captcha-active';
			}
		}
	}
}