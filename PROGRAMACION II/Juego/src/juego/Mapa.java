/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package juego;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.util.Random;
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
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau Enlace:
 */
public class Mapa extends JPanel {

    //ATRIBUTO QUE CONTIENE EL NÚMERO DE FILAS DEL MAPA
    private static int filas;
    //ATRIBUTO QUE CONTIENE EL NÚMERO DE COLUMNAS DEL MAPA
    private static int columnas;
    //ATRIBUTO QUE CONTIENE LA FILA DE SALIDA DEL LABERINTO
    private static int filaSalida;
    //ATRIBUTO QUE CONTIENE LA COLUMNA DE SALIDA DEL LABERINTO
    private static int columnaSalida;
    //ATRIBUTO QUE ALMACENA LOS 1's y 0's PARA GENERAR UNA CASILLA
    private int[] ladosCasilla;
    //ATRIBUTO QUE CONTIENE EL NUMERO DE FILAS Y COLUMNAS DEL MAPA
    private Casilla matriz[][];
    //ATRIBUTO QUE CONTIENE LAS COORDENADAS X DE UNA CASILLA
    private static int randomX;
    //ATRIBUTO QUE CONTIENE LAS COORDENADAS Y DE UNA CASILLA
    private static int randomY;

    //CONSTRUCTOR
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
            //Leemos la primera linea del fichero de la cual obtenemos el número 
            //de filas que contiene el mapa y pasamos su valor a numérico
            filas = Integer.parseInt(lecturaDatos.lectura());
            //Leemos la siguiente linea del fichero la cual contiene el nu´número 
            //de columnas que contiene el mapa y pasamos su valor a numérico
            columnas = Integer.parseInt(lecturaDatos.lectura());
            //A partor de los datos obtenidos anteriormenete ya sabemos las 
            //dimensiones del mapa a generar
            matriz = new Casilla[filas][columnas];
            //Variables para determinar la posición de cada casilla a generar
            int x, y = 0;
            //Bucle para generar el mapa
            for (int i = 0; i < filas; i++) {
                //Cada fila se reinicia la variable x;
                x = 0;
                for (int j = 0; j < columnas; j++) {
                    //Creamos un rectangulo de fondo, en el cual dibujaremos sobre él 
                    //los lados de cada casilla
                    Rectangle2D.Float fondoCasilla = new Rectangle2D.Float(x, y,
                            Casilla.getLongitudLado(), Casilla.getLongitudLado());
                    ladosCasilla = new int[4];
                    //Bucle para generar los lados de cada casilla
                    for (int k = 0; k < 4; k++) {
                        ladosCasilla[k] = lecturaDatos.leer();;
                    }
                    matriz[i][j] = new Casilla(x, y, fondoCasilla, ladosCasilla);
                    //Aumentamos las coordenadas de x, para que la siguiente casilla
                    //este posicionada correctamente
                    x = x + Casilla.getLongitudLado();
                }
                //Avanzar linea de lectura
                lecturaDatos.lectura();
                //Aumentamos las coordenadas de y, para que la siguiente casilla
                //este posicionada correctamente
                y = y + Casilla.getLongitudLado();
            }
            //Leemos las dos últimas lineas que contienen la salida del laberinto
            filaSalida = Integer.parseInt(lecturaDatos.lectura());
            columnaSalida = Integer.parseInt(lecturaDatos.lectura());
            //Cierre enlace con el fichero
            lecturaDatos.close();
            //Aginación de la casilla de salida
            setPosAleatoriaFicha();
            setCasillaSalida();
        } catch (NumberFormatException error) {
            System.out.println("Error: " + error.toString());
            error.printStackTrace();
        } catch (Exception error) {
            System.out.println("Error: " + error.toString());
            error.printStackTrace();
        }
    }

//    public static int getFilaSalida() {
//        return filaSalida;
//    }

//    public static int getColumnaSalida() {
//        return columnaSalida;
//    }

    public static int getFilas() {
        return filas;
    }

    public static int getColumnas() {
        return columnas;
    }

//    //Método que devuelve las coordenadas de X de una casilla al azar
//    public static int getRandomX() {
//        return randomX;
//    }

//    //Método que devuelve las coordenadas de X de una casilla al azar
//    public static int getRandomY() {
//        return randomY;
//    }

//    //Método
//    public int[] paredes(int i, int j) {
//        return matriz[i][j].getParedes();
//    }
    
    //
    public Casilla getMatriz(int i, int j){
        return matriz[i][j];
    }

    //
    private void setPosAleatoriaFicha() {
        //Variable tipo random para determinar una posición aleatoria de la ficha
        //al iniciar un mapa
        Random posicion = new Random();
        //Variable que contendrá una fila aleatoria entre 0 y el número de filas
        //que contenga el mapa
        int p = posicion.nextInt(filas);
        //Se crea un nuevo random para poder determinar de forma aleatoria la
        //columna
        posicion = new Random();
        //Variable que contendrá una columna aleatoria entre 0 y el número de 
        //columnas que contenga el mapa
        int q = posicion.nextInt(columnas);
        //
        matriz[p][q].setCasillaOcupada();
    }

    //
    private void setCasillaSalida() {
        matriz[filaSalida][columnaSalida - 1].setcasillaSalida();
    }

    //Método que devuelve la casilla de salida del Laberinto
    public static Rectangle2D getCasillaSalida() {
        return new Rectangle2D.Float((Casilla.getLongitudLado() * columnaSalida) - Casilla.getLongitudLado(),
                Casilla.getLongitudLado() * filaSalida,
                Casilla.getLongitudLado(), Casilla.getLongitudLado());
    }

    //Método que permite dibujar el mapa del Laberinto
    @Override
    public void paintComponent(Graphics g) {
        try {
            Graphics2D g2D = (Graphics2D) g;
            //Pintar el un rectangulo que será el fondo del mapa, desde la posición
            //0,0 y con dimensión ancho = num de columnas * la longuitud de una casilla
            // y el alto = num de filas * la longuitud de una casilla
            g2D.setColor(Color.PINK);
            g2D.fillRect(0, 0, columnas * Casilla.getLongitudLado(),
                    filas * Casilla.getLongitudLado());
            //Dibujar la casilla de salida del laberinto
            g2D.setColor(Color.LIGHT_GRAY);
            g2D.fill(getCasillaSalida());
            //Bucle para pintar el laberinto
            for (int i = 0; i < filas; i++) {
                for (int j = 0; j < columnas; j++) {
                    matriz[i][j].paintComponent(g2D);
                }
            }
        } catch (Exception error) {
            System.out.println("Error dibujando mapa: " + error.toString());
            error.printStackTrace();
        }
    }
}
