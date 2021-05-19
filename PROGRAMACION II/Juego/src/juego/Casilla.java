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

/**
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau
 * Enlace:
 */
public class Casilla {

    //ATRIBUTO QUE PERMITE SABER SI UNA CASILLA ESTA OCUPADA O NO
    private boolean ocupada = false;
    //ATRIBUTOS QUE DETERMINAN LA POSICIÓN DE LA CASILLA(EJES (X,Y))
    private int posCasillaX;
    private int posCasillaY;
    //ATRIBUTO PARA DIBUJAR UNA CASILLA
    private Rectangle2D.Float casilla;
    //ATRIBUTO PARA DETERMINAR QUE LADOS CONTIENE UNA CASILLA
    private int[] ladosCasilla;
    //ATRIBUTO QUE CONTIENE LA LONGUITUD DEL LADO DE UNA CASILLA
    private final static int LONGUITUD_LADO_CASILLA = 40;

    public Casilla(int posCasillaX, int posCasillaY, Rectangle2D.Float casilla, int[] ladosCasilla) {
        this.posCasillaX = posCasillaX;
        this.posCasillaY = posCasillaY;
        this.casilla = casilla;
        this.ladosCasilla = ladosCasilla;
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

    //MÉTODO DE MODIFICA LA COORDENADA X DE UNA CASILLA
    public void setX(int x) {
        posCasillaX = x;
    }

    //MÉTODO DE MODIFICA LA COORDENADA Y DE UNA CASILLA
    public void setY(int y) {
        posCasillaY = y;
    }

    //MÉTODO DE DA ACCESO A LA COORDENADA X DE UNA CASILLA
    public int getX() {
        return posCasillaX;
    }

    //MÉTODO DE DA ACCESO A LA COORDENADA Y DE UNA CASILLA
    public int getY() {
        return posCasillaY;
    }

    public int[] getParedes() {
        return ladosCasilla;
    }

    //Devuelve la longuitud que tiene una casilla
    public static int getLonguitudLado() {
        return LONGUITUD_LADO_CASILLA;
    }

    //MÉTODO PARA DIBUJAR LAS CASILLA CORRESPONDIENTE AL .TXT LEIDO
    public void paint(Graphics g) {
        //Variable para comparar si el dato leido del fichero equivale a '1'
        Character uno = '1';
        //Usamos la clase Graphics para dibujar la casilla
        Graphics2D g2D = (Graphics2D) g;
        //Asignamos el color de la casilla y lo pintamos
        g2D.setColor(Color.CYAN);
        g2D.fill(casilla);
        // g2D.draw(casilla);//prueba luego borrar

        //Cada casilla se compone de 4 lados Norte[0], este[1], sur[2] y oeste[3],
        //donde si en el fichero leido hay un 0 no hay lado y 1 viceversa
        if (ladosCasilla[0] == uno) { //Norte = [0]
            //Norte = (x,y,ladoCasilla,5)
            Rectangle2D.Float casillaDibujar = new Rectangle2D.Float(posCasillaX,
                    posCasillaY, LONGUITUD_LADO_CASILLA, 5);
            g2D.setColor(Color.BLACK);
            g2D.fill(casillaDibujar);
        }
        if (ladosCasilla[1] == uno) { //Este = [1]
            //Este = (x+ladoCasilla,y,5,ladoCasilla)
            Rectangle2D.Float casillaDibujar = new Rectangle2D.Float(posCasillaX
                    + LONGUITUD_LADO_CASILLA - 5, posCasillaY, 5, LONGUITUD_LADO_CASILLA);
            g2D.setColor(Color.BLACK);
            g2D.fill(casillaDibujar);
        }
        if (ladosCasilla[2] == uno) { //Sur = [2]
            //Sur = (x,y+ladoCasilla,ladoCasilla,5)
            Rectangle2D.Float casillaDibujar = new Rectangle2D.Float(posCasillaX,
                    posCasillaY + LONGUITUD_LADO_CASILLA - 5, LONGUITUD_LADO_CASILLA, 5);
            g2D.setColor(Color.BLACK);
            g2D.fill(casillaDibujar);
        }
        if (ladosCasilla[3] == uno) { //Oeste = [3]
            //Oeste = (x,y,5,ladoCasilla)
            Rectangle2D.Float casillaDibujar = new Rectangle2D.Float(posCasillaX,
                    posCasillaY, 5, LONGUITUD_LADO_CASILLA);
            g2D.setColor(Color.BLACK);
            g2D.fill(casillaDibujar);
        }
    }
}
