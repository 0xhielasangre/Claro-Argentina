from Funciones import Funciones;
import sys;
if(len(sys.argv) == 2):
    objFunc = Funciones(sys.argv[1]);
    objFunc.exploit();
else:
    if(len(sys.argv) == 3):
        objFunc = Funciones(sys.argv[1]);
        objFunc.setTestKey(sys.argv[2]);
        objFunc.exploit();
    else:
        print("Use python main.py phoneNumber\n");
        print("Example python main.py 3834219205\n");
        print("Use python main.py phoneNumber password\n");
        print("Example python main.py 3844223399 3609\n");