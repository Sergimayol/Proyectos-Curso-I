/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package juego;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Rectangle;
import java.awt.geom.Rectangle2D;
import javax.swing.JPanel;

/*
Cada fichero contiene una fila de 1'1 y 0's donde cada cuatro núms 
es una casilla. Para ello puedo leer de linea en linea y descomponerlo 
de 4 en 4, y creando en la clase Casilla un objecto que pinte cada casilla,
donde al final juntando todas las casillas se crearía el mapa. 
IMPORTANTE!!! ==> Tengo que tener en cuenta la posición donde la ficha debe
empezar y donde está el final(Salida) del laberinto. En la primera 
línea del texto indica en número de filas, y la segunda línea el número de columnas,
finalmente las últimas dos lineas contienen donde se encuentra en final/salida del laberinto
 */
/**
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau
 * Enlace:
 */
public class Mapa extends JPanel {

    //ATRIBUTOS QUE CONTIENEN EL NÚMERO DE FILAS Y COLUMNAS DEL MAPA
    private int filas;
    private int columnas;
    //ATRIBUTOS QUE CONTIENE LA POSICIÓN DE LA SALIDA DEL LABERINTO
    private static int filaSalida;
    private static int columnaSalida;
    //ATRIBUTO QUE ALMACENA LOS 1's y 0's PARA GENERAR UNA CASILLA
    private int[] ladosCasilla;
    //ATRIBUTO QUE CONTIENE EL NUMERO DE FILAS Y COLUMNAS DEL MAPA
    private Casilla matriz[][];

    public Mapa() {
        crearMapa(Laberinto.getFicheroNombre());
    }

    //Este método permite crear el mapa del Laberinto que se ha seleccionado
    private void crearMapa(String nombreMapa) {
        try {
            //Cuando se ejecuta por primera vez el programa  el mapa por defecto
            //será "maze1.txt"
            if (nombreMapa == null) {
                nombreMapa = "maze1.txt";
            }
            //DECLARACIÓN E INTANCIACIÓN de la clase FicheroLecturaMapas, para leer del
            //fichero los datos, para generar el mapa
            FicheroLecturaMapas lecturaDatos = new FicheroLecturaMapas(nombreMapa);
            String linea;
            //Leemos la primera linea del fichero de la cual obtenemos el número 
            //de filas que contiene el mapa
            linea = lecturaDatos.lectura();
            //Pasamos su valor a numérico
            filas = Integer.parseInt(linea);
            //Leemos la siguiente linea del fichero la cual contiene el nu´número 
            //de columnas que contiene el mapa
            linea = lecturaDatos.lectura();
            //Pasamos su valor a numérico
            columnas = Integer.parseInt(linea);
            //A partor de los datos obtenidos anteriormenete ya sabemos las 
            //dimensiones del mapa a generar
            matriz = new Casilla[filas][columnas];
            //Variables para determinar la posición de cada casilla a generar
            int x, y = 0;
            //Bucle para generar el mapa
            //Mientras no se supere el 
            for (int i = 0; i < filas; i++) {
                //Cada fila se reinicia la variable x;
                x = 0;
                for (int j = 0; j < columnas; j++) {
                    //Creamos un rectangulo de fondo, en el cual dibujaremos sobre él 
                    //los lados de cada casilla
                    Rectangle2D.Float fondoCasilla = new Rectangle2D.Float(x, y,
                            Casilla.getLonguitudLado(), Casilla.getLonguitudLado());
                    ladosCasilla = new int[4];
                    //Bucle para generar los lados de cada casilla
                    for (int k = 0; k < 4; k++) {
                        int lectura = lecturaDatos.leer();
                        ladosCasilla[k] = lectura;
                    }
                    matriz[i][j] = new Casilla(x, y, fondoCasilla, ladosCasilla);
                    //Aumentamos las coordenadas de x, para que la siguiente casilla
                    //este posicionada correctamente
                    x = x + Casilla.getLonguitudLado();
                }
                //Avanzar linea de lectura
                lecturaDatos.lectura();
                //Aumentamos las coordenadas de y, para que la siguiente casilla
                //este posicionada correctamente
                y = y + Casilla.getLonguitudLado();
            }
            //Leemos las dos últimas lineas que contienen la salida del laberinto
            linea = lecturaDatos.lectura();
            filaSalida = Integer.parseInt(linea);
            linea = lecturaDatos.lectura();
            columnaSalida = Integer.parseInt(linea);
            //Cierre enlace con el fichero
            lecturaDatos.close();
        } catch (NumberFormatException error) {
            System.out.println("Error: " + error.toString());
        } catch (Exception error) {
            System.out.println("Error: " + error.toString());
        }
    }

    public static int getFilaSalida() {
        return filaSalida;
    }

    public static int getColumnaSalida() {
        return columnaSalida;
    }

//    public Rectangle getCasillafinal() {
//        return new Rectangle((Casilla.getLonguitudLado() * columnaSalida) - Casilla.getLonguitudLado(),
//                    Casilla.getLonguitudLado() * filaSalida,
//                Casilla.getLonguitudLado(), Casilla.getLonguitudLado());
//    }
    @Override
    public void paint(Graphics g) {
        try {
            for (int i = 0; i < filas; i++) {
                for (int j = 0; j < columnas; j++) {
                    matriz[i][j].paint(g);
                }
            }
            g.setColor(Color.WHITE);
            g.fillRect((Casilla.getLonguitudLado() * columnaSalida) - Casilla.getLonguitudLado(),
                    Casilla.getLonguitudLado() * filaSalida,
                    Casilla.getLonguitudLado(), Casilla.getLonguitudLado());
        } catch (Exception error) {
            System.out.println("Error dibujando mapa: " + error.toString());
            error.printStackTrace();
        }
    }
}
