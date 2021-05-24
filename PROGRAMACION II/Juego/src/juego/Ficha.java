/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package juego;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.event.KeyEvent;
import java.awt.geom.Rectangle2D;

/**
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau Enlace:
 */
public class Ficha {

    //ATRIBUTOS QUE DEFINEN LA POSICIÓN DE LA FICHA
    private int x = 5;
    private int y = 5;
    //ATRIBUTO QUE DEFINE EL ANCHO Y ALTO DE LA FICHA
    private final int DIAMETRO_FICHA = 25;
    //ATRIBUTO QUE DEFINE CUANTOS PIXELES SE DESPLAZA LA FICHA
    private final int DESPLAZAMINETO_FICHA = 5;

    //CONSTURTOR VACIO
    public Ficha() {

    }

    public void paintComponent(Graphics g) {
        //Utilizamos Graphics2D para la visualización
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        //FICHA
        g2d.setColor(Color.RED);
        g2d.fillOval(x, y, DIAMETRO_FICHA, DIAMETRO_FICHA);
        //CONTORNO FICHA
        g2d.setColor(Color.BLACK);
        g2d.drawOval(x, y, DIAMETRO_FICHA, DIAMETRO_FICHA);
    }

    public void teclaPresionada(KeyEvent ke) {
        if (!casillaSalida()) {
            if ((ke.getKeyCode() == KeyEvent.VK_LEFT)
                    || (ke.getKeyCode() == KeyEvent.VK_A)) {
                // System.out.println("IZQUIERDA");
                //Mover ficha izquierda(-X)
                x = x - DESPLAZAMINETO_FICHA;
            }
            if ((ke.getKeyCode() == KeyEvent.VK_RIGHT)
                    || (ke.getKeyCode() == KeyEvent.VK_D)) {
                //System.out.println("DERECHA");
                //Mover ficha derecha(+X)
                x = x + DESPLAZAMINETO_FICHA;
            }
            if ((ke.getKeyCode() == KeyEvent.VK_UP)
                    || (ke.getKeyCode() == KeyEvent.VK_W)) {
                //System.out.println("ARRIBA");
                //Mover ficha arriba(+Y)
                y = y - DESPLAZAMINETO_FICHA;
            }
            if ((ke.getKeyCode() == KeyEvent.VK_DOWN)
                    || (ke.getKeyCode() == KeyEvent.VK_S)) {
                //System.out.println("ABAJO");
                //Mover ficha abajo(-Y)
                y = y + DESPLAZAMINETO_FICHA;
            }
        } else {
            Laberinto lab = new Laberinto();
            lab.setVisible(false);
            lab.gameOver();
        }
    }
 
     //Método que devuelve un rectángulo del tamaño de la ficha para comprobrar
    //si colisiona con otro rectángulo
    private Rectangle2D hitBoxFicha(){
        return new Rectangle2D.Float(x, y, DIAMETRO_FICHA, DIAMETRO_FICHA);
    }
    
    //Método que tiene la función de devolver si se la ficha ha cochado 
    //con un rectángulo
    private boolean casillaSalida() {
        return hitBoxFicha().intersects(Mapa.getCasillaSalida());
    }

//    //Devuelve un las dimensiones de la casilla de salida
//    private Rectangle getBounds() {
//        return new Rectangle((Casilla.getLonguitudLado() * Mapa.getColumnaSalida())
//                - Casilla.getLonguitudLado(), Casilla.getLonguitudLado() * Mapa.getFilaSalida(),
//                Casilla.getLonguitudLado(), Casilla.getLonguitudLado());
//    }
}
