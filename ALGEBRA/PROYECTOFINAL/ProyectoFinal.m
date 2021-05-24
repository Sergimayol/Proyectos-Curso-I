
#PROYECTO FINAL MÉTODOS DE ALGEBRA LINEAL
#CADENAS DE MARKOV, EJERCICIO 3-5)

#MATRIZ PROBABILIDAD T:
T = [1/3,0,0,1/3,0,0,0,0,0;
     0,1/3,2/3,0,2/9,0,0,0,0;
     0,1/3,1/3,0,0,0,0,0,0;
     2/3,0,0,1/3,0,0,1/3,0,0;
     0,1/3,0,0,1/3,2/3,0,2/9,0;
     0,0,0,0,2/9,1/3,0,0,0;
     0,0,0,1/3,0,0,1/3,2/9,0;
     0,0,0,0,2/9,0,1/3,1/3,2/3;
     0,0,0,0,0,0,0,2/9,1/3]
     
#MATRIZ INVERSA DE T:
invT = inv(T)

#Ejercicio 1:
[L,U,P]=lu(invT)
# b=[0;1;0;0;0;0;0;0;0]; Vector b = x0
b=[0.014859; 0.212536; 0.114613; 0.038794; 0.254171; 0.087012; 0.065584; 0.161628; 0.050725]; #Vector b = x9
b1=P*b;
y=susprog(L,b1);
x=susreg(U,y);
  disp("Etapa 10:")
  disp(x); #Mostramos el resultado de la variable "x10" por pantalla

[L,U,P]=lu(invT)
# b=[0;0;0;0;0;0;0;1;0]; #Vector b = y0
b= [0.058503; 0.104086; 0.048120; 0.122277; 0.184471; 0.061494; 0.133717; 0.212118; 0.075214]; #Vector b = y9

b1=P*b;
y=susprog(L,b1);
x=susreg(U,y);
  disp("Etapa 10:")
  disp(x); #Mostramos el resultado de la variable "y10" por pantalla

#Multiplicar resultado zona 2 de x e y: x10*y10 = 0.212536*0.104086 = 0.021956
#Multiplicar resultado zona 5 de x e y: x10*y10 = 0.254171*0.184471 = 0.045986

#Ejercicio 2:
[L,U,P]=lu(invT)
#Ponemos la columna 5 como el vector z0
# b=[0;2/9;0;0;1/3;2/9;0;2/9;0] Vector b = z0
b=[0.028363;0.169456; 0.087016;0.065603;0.233292;0.080620;0.089856;0.184324;0.061493] Vector #Vector b = z9
#Zona 3 como x0 por tanto
b1=P*b;
y=susprog(L,b1);
x=susreg(U,y);
  disp("Etapa 10:");
  disp(x); #Mostramos el resultado de la variable "z10" por pantalla
  
 #Repetimos el proceso para x0
[L,U,P]=lu(invT)
#Zona 3 como x0 por tanto
#b=[0;0;1;0;0;0;0;0;0]
b=[7.6409e-03;2.4227e-01;1.3423e-01;2.3723e-02;2.6524e-01;8.9638e-02;5.0230e-02;1.4435e-01;4.2589e-02] Vector #Vector b = x9
#Zona 3 como x0 por tanto
b1=P*b;
y=susprog(L,b1);
x=susreg(U,y);
  disp("Etapa 10:");
  disp(x); #Mostramos el resultado de la variable "x10" por pantalla

#Multiplicamos la posición 1 del vector z10 y x10
#x10*z10 = 0.031322*0.010455 = 3.2747e-04

#Ejercicio 3:
#Para responder a este apartado, tenemos que encontrar el mayor de los valores multiplicados entre x e y
#Zona 1: 0.060260*0.017884 = 1.0777e-03
#Zona 2: 0.107769*0.203736 = 0.021956
#Zona 3: 0.050735*0.109050 = 5.5327e-03
#Zona 4: 0.124333*0.044699 = 5.5576e-03
#Zona 5: 0.184319*0.249494 = 0.045986
#Zona 6: 0.061492*0.085486 = 5.2567e-03
#Zona 7: 0.132469*0.070710 = 9.3669e-03
#Zona 8: 0.206415*0.166036 = 0.034272
#Zona 9: 0.072209*0.052826 = 3.8145e-03

#Por tanto, la zona más probable es la zona 5, al ser la zona con el valor más alto.


#Ejercicio 4:
#Multiplicamos x y z para cada una de las zonas
#Zona 1: 0.031322*0.010455 = 3.2747e-04
#Zona 2: 0.166339*0.229186 = 0.038123
#Zona 3: 0.085491*0.125500 = 0.010729
#Zona 4: 0.070728*0.029745 = 2.1038e-03
#Zona 5: 0.228957*0.261006 = 0.059759
#Zona 6: 0.078716*0.088822 = 6.9917e-03 
#Zona 7: 0.092781*0.056729 = 5.2634e-03
#Zona 8: 0.184231*0.152195 = 0.028039
#Zona 9: 0.061459*0.046274 = 2.8440e-03

