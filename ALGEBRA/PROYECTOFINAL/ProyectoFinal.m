
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
b=[0;1;0;0;0;0;0;0;0]; #Vector b = x0
b1=P*b;
y=susprog(L,b1);
x=susreg(U,y);
for i=10   #Son 10 etapas, por tanto nos interesa la décima iteración
  disp(x); #Mostramos el resultado de la variable "x10" por pantalla
endfor

[L,U,P]=lu(invT)
b=[0;0;0;0;0;0;0;1;0]; #Vector b = y0
b1=P*b;
y=susprog(L,b1);
x=susreg(U,y);
for i=10   #Son 10 etapas, por tanto nos interesa la décima iteración
  disp(x); #Mostramos el resultado de la variable "y10" por pantalla
endfor

#Multiplicar resultado zona 2 de x e y
#Multiplicar resultado zona 5 de x e y

#Ejercicio 2:
#Ponemos la columna 5 como el vector z0
#Zona 3 como x0 por tanto
b=[0;0;1;0;0;0;0;0;0]
#Finalmente multiplicamos el resultado de la zona 1 de x e y

#Ejercicio 3:
#Para responder a este apartado, tenemos que encontrar el mayor de los valores multiplicados entre x e y

#Ejercicio 4:
#Multiplicamos x y z para cada una de las zonas
