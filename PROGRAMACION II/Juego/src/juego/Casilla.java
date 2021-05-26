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
import javax.swing.JFrame;
import javax.swing.JOptionPane;

/**
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau Enlace:
 */
public class Casilla {

    //ATRIBUTO QUE PERMITE SABER SI UNA CASILLA ESTA OCUPADA O NO
    private boolean ocupada;
    //ARTIBUTO
    private boolean casillaSalida;
    //ATRIBUTOS QUE DETERMINAN LA POSICIÓN DE LA CASILLA(EJES (X,Y))
    private int posCasillaX;
    private int posCasillaY;
    //ATRIBUTO PARA DIBUJAR UNA CASILLA
    private Rectangle2D.Float casilla;
    //ATRIBUTO PARA DETERMINAR QUE LADOS CONTIENE UNA CASILLA
    private int[] ladosCasilla;
    //ATRIBUTO QUE DETERMINA LA LONGITUD DEL LADO DE UNA CASILLA
    private final static int LONGITUD_LADO_CASILLA = 40;
    //ATRIBUTO QUE DTERMINA EL ANCHO DE CADA PARED DEL LABERINTO
    private final int ANCHO_MURO = 5;

    public Casilla(int posCasillaX, int posCasillaY, Rectangle2D.Float casilla, int[] ladosCasilla) {
        this.posCasillaX = posCasillaX;
        this.posCasillaY = posCasillaY;
        this.casilla = casilla; //Sobra, no hace falta
        this.ladosCasilla = ladosCasilla;
        casillaSalida = false;
        ocupada = false;
    }

    //MÉTODO QUE DEVUELVE EL ESTADO DE UNA CASILLA
    public boolean estado() {
        return ocupada;
    }

    //MÉTODO QUE CAMBIA EL ESTADO A OCUPADA DE UNA CASILLA 
    public void setCasillaOcupada() {
        ocupada = true;
    }

    //MÉTODO QUE CAMBIA EL ESTADO DE UNA CASILLA
    public void cambiarEstado() {
        ocupada = !ocupada;
    }

    //MÉTODO QUE LIBERA UNA CASILLA
    public void setCasillaLibre() {
        ocupada = false;
    }

    //MÉTODO QUE MODIFICA LA COORDENADA X DE UNA CASILLA
    public void setX(int x) {
        posCasillaX = x;
    }

    //MÉTODO QUE MODIFICA LA COORDENADA Y DE UNA CASILLA
    public void setY(int y) {
        posCasillaY = y;
    }

    //MÉTODO QUE DA ACCESO A LA COORDENADA X DE UNA CASILLA
    public int getX() {
        return posCasillaX;
    }

    //MÉTODO QUE DA ACCESO A LA COORDENADA Y DE UNA CASILLA
    public int getY() {
        return posCasillaY;
    }

    //Método que devuelve los lados que contiene una casilla
    public int getParedes(int i) {
        return ladosCasilla[i];
    }

    //Método que devuelve los lados que contiene una casilla
    public int[] getParedes() {
        return ladosCasilla;
    }

    //Devuelve la longuitud que tiene una casilla
    public static int getLongitudLado() {
        return LONGITUD_LADO_CASILLA;
    }

    //
    public void setcasillaSalida() {
        casillaSalida = true;
    }

    //Mensaje al llegar a la salida del mapa
    public void gameOver() {
        JOptionPane.showMessageDialog(null, "        HAS GANADO!!!");
        //Cerrar el juego al ganar
        System.exit(0);
    }

    //MÉTODO PARA DIBUJAR LAS CASILLA CORRESPONDIENTE AL .TXT LEIDO
    public void paintComponent(Graphics g) {
        //Variable para comparar si el dato leido del fichero equivale a '1'
        Character uno = '1';
        //Usamos la clase Graphics2D para dibujar la casilla
        Graphics2D g2D = (Graphics2D) g;
        Ficha ficha = new Ficha();
        if (ocupada) {
            ficha.setCoordX(posCasillaX + 7);
            ficha.setCoordY(posCasillaY + 7);
            ficha.paintComponent(g2D);
            if (casillaSalida) {
                gameOver();
            }
        }
        //Rectangulo2D para formar las paredes de caada casilla
        Rectangle2D.Float paredCasilla;
        //Cada casilla se compone de 4 lados Norte[0], este[1], sur[2] y oeste[3],
        //donde si en el fichero leido hay un 0 no hay lado y 1 viceversa
        if (ladosCasilla[0] == uno) { //Norte = [0]
            //Norte = (x,y,ladoCasilla,5)
            paredCasilla = new Rectangle2D.Float(posCasillaX,
                    posCasillaY, LONGITUD_LADO_CASILLA, ANCHO_MURO);
            g2D.setColor(Color.BLACK);
            g2D.fill(paredCasilla);
        }
        if (ladosCasilla[1] == uno) { //Este = [1]
            //Este = (x+ladoCasilla,y,5,ladoCasilla)
            paredCasilla = new Rectangle2D.Float(posCasillaX
                    + LONGITUD_LADO_CASILLA - ANCHO_MURO, posCasillaY,
                    ANCHO_MURO, LONGITUD_LADO_CASILLA);
            g2D.setColor(Color.BLACK);
            g2D.fill(paredCasilla);
        }
        if (ladosCasilla[2] == uno) { //Sur = [2]
            //Sur = (x,y+ladoCasilla,ladoCasilla,5)
            paredCasilla = new Rectangle2D.Float(posCasillaX,
                    posCasillaY + LONGITUD_LADO_CASILLA - ANCHO_MURO,
                    LONGITUD_LADO_CASILLA, ANCHO_MURO);
            g2D.setColor(Color.BLACK);
            g2D.fill(paredCasilla);
        }
        if (ladosCasilla[3] == uno) { //Oeste = [3]
            //Oeste = (x,y,5,ladoCasilla)
            paredCasilla = new Rectangle2D.Float(posCasillaX,
                    posCasillaY, ANCHO_MURO, LONGITUD_LADO_CASILLA);
            g2D.setColor(Color.BLACK);
            g2D.fill(paredCasilla);
        }
    }
}
