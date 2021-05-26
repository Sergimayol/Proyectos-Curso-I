/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package juego;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.KeyEvent;
import java.awt.geom.Rectangle2D;

/**
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau Enlace:
 */
public class Ficha {

    //ATRIBUTO QUE DEFINE LA POSICIÓN X DE LA FICHA
    private int x;
    //ATRIBUTO QUE DEFINE LA POSICIÓN Y DE LA FICHA
    private int y;
    //ATRIBUTO QUE DEFINE EL ANCHO Y ALTO DE LA FICHA
    private final int DIAMETRO_FICHA = 25;

    //CONSTURTOR 
    public Ficha() {

    }

    //Método que permite dibujar la ficha sobre el mapa
    public void paintComponent(Graphics g) {
        //Utilizamos Graphics2D para la visualización
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
        //FICHA
        g2d.setColor(Color.RED);
        g2d.fillOval(x, y, DIAMETRO_FICHA, DIAMETRO_FICHA);
        //CONTORNO FICHA
        g2d.setColor(Color.BLACK);
        g2d.drawOval(x, y, DIAMETRO_FICHA, DIAMETRO_FICHA);
    }

    //Método que indica las coordenadas de X de la ficha, a partir del parámetro
    //del método
    public void setCoordX(int x) {
        this.x = x;
    }

    //Método que indica las coordenadas de Y de la ficha, a partir del parámetro
    //del método
    public void setCoordY(int y) {
        this.y = y;
    }
}
