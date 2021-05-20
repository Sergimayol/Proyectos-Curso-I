#PROBLEMA 2
#MATRIZ

B = [1,0,1,2,0;
     0,sqrt(3),1,4,0;
     3,3,2,3,sqrt(3);
     sqrt(2),1,2,sqrt(7),5;
     2,4,0,2,1]

#APARTADO 1)
disp("APARTADO 1")
disp("\n")
#Utilizando una descomposición PAQ = LU, demostrad que B es una base de R^5.
[P,Q,L,U] = PAQ_LUFact(B);

disp("MATRIZ L")
disp(L)
disp("\n")

disp("MATRIZ U")
disp(U)
disp("\n")

disp("MATRIZ PERMUTACION P")
disp(P)
disp("\n")

disp("MATRIZ PERMUTACION Q")
disp(Q)
disp("\n")

disp("DETERMINANTE DE U")
disp(det(U))
disp("\n")

#APARTADO 2)
disp("APARTADO 2")
disp("\n")
[L2, U2, p2] = PA_LUFact(B);

disp("MATRZI L")
disp(L2)
disp("\n")

disp("MATRIZ U")
disp(U2)
disp("\n")

P2 = generarMatrizPermutacion(p2, true);

disp("VECTOR PERMUTACION FILAS")
disp(p2)
disp("\n")

disp("MATRIZ PERMUTACION P")
disp(P2)
disp("\n")

disp("DETERMINANTE DE U")
disp(det(U2))
disp("\n")


#APARTADO 3)
[L,U,P]=lu(B)

b = [1;1;1;1;1];

b1=P*b;

y=susprog(L,b1);
x=susreg(U,y);

disp("LA SOLUCION DEL SISTEMA PA-LU ES:")
disp(x)
disp("\n")












