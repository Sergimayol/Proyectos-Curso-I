/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package juego;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.Color;
import java.awt.HeadlessException;
import java.awt.Image;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.File;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau Enlace:
 */
public class Laberinto extends JFrame {

    //DECLARACIÓN OBJETO Container PARA REPRESENTAR EL PANEL DE
    //CONTENIDOS DEL OBJETO JFrame
    private Container panelContenidos;
    //DECLARACIÓN JMenuItem
    private JMenuItem seleccionLab;
    private JMenuItem reiniciar;
    private JMenuItem salir;
    //Atributo String que contiene el nombre del mapa que se va a dibujar
    private static String fichero;
    //Atributo Mapa que contiene mapa que se va a dibujar
    private Mapa mapa;
    //
    private int filas;
    //
    private int columnas;

    public static void main(String[] args) {
        new Laberinto();
    }

    //Constructor el cual contiene las configuraciones del JFrame y el método  
    //principal, además de tener el foco principal para el movimiento
    //de la ficha
    public Laberinto() {
        addKeyListener(new gestorDesplazamientoFicha());
        setFocusable(true);

        //
        configuracionJFrame();

        //
        inicio();

        //Metodo encargado de la gestion de la interface
        metodoPrincipal();

        //
        repaint();

        //Activar visualización contenedor JFrame ventana
        setVisible(true);
    }

    //Método inicial del programa
    private void inicio() {
        mapa = new Mapa();
        filas = Mapa.getFilas();
        columnas = Mapa.getColumnas();
        panelContenidos.add(mapa, BorderLayout.CENTER);
    }

    private void configuracionJFrame() {
        //Añadimos un titulo a la ventana
        setTitle("Laberinto");
        //La ventana no podrá redimensionarse
        setResizable(false);
        //Alamacena en la variable nuestro sistema nativo de ventanas
        Toolkit pantalla = Toolkit.getDefaultToolkit();
        //Añadimos un icono a la ventana
        Image Icono = pantalla.getImage("lab.png");
        setIconImage(Icono);
        //Tamañano de la pantalla del usuario
        Dimension tampant = pantalla.getScreenSize();
        //Obtener el alto de resolución de pantalla
        int altpant = tampant.height;
        //Obtener el ancho de resolución de pantalla
        int anchopant = tampant.width;
        //Localización(x,y) + tamaño(ancho,alto). De esta manera siempre
        //la ventana estará situada en el centro
        setBounds(anchopant / 3, altpant / 4, 406, 658);
        //Activar el cierre interactivo del contenedor JFrame ventana para finalizar
        //ejecución
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        //Asignación al objeto Container panelContenidos DEL PANEL JContentPane 
        //del JFrame 
        panelContenidos = getContentPane();
        //asignación administrador de Layout BordeLayout al panel de contenidos
        //del JFrame
        panelContenidos.setLayout(new BorderLayout());
    }

    //Este método es el encargado de la gestion de acciones de los botones del 
    //menuBar y de la configuración y adición del mapa y la ficha al JFrame
    private void metodoPrincipal() {
        //CONFIGURACIÓN CONTENEDOR JPanel contenedor del panelMenu
        JPanel panelMenu = new JPanel();
        panelMenu.setBackground(Color.LIGHT_GRAY);
        panelMenu.setLayout(new BorderLayout());

        //DECLARACIÓN COMPONENTE JMenuBar (barra de menu)
        JMenuBar barraMenu = new JMenuBar();

        //DECLARACIÓN Y CONFIGURACIÓN COMPONENTES JMENUS DE LA BARRA DE MENU
        JMenu opciones = new JMenu("Opciones");

        //DECLARACIÓN OPCIONES JMenuItem
        seleccionLab = new JMenuItem("Seleccionar laberinto");
        reiniciar = new JMenuItem("Reiniciar laberinto");
        salir = new JMenuItem("Salir");

        //Asociación componente JMenuItem, con gestor de evento gestorEventoMenuBar
        seleccionLab.addActionListener(new gestorEventosMenu());
        reiniciar.addActionListener(new gestorEventosMenu());
        salir.addActionListener(new gestorEventosMenu());

        //Asignación componentes JMenuItem con su correspondiente JMenu
        opciones.add(seleccionLab);
        opciones.add(reiniciar);
        opciones.add(salir);

        //Introducción de la componentes JMenu en el JMenuBar
        barraMenu.add(opciones);
        //Introducción de la componentes JMenuBar en el JPanel
        panelMenu.add(barraMenu, BorderLayout.SOUTH);

        //Adicion del mapa y barraMenu al JPanel panelContenidos
        panelContenidos.add(panelMenu, BorderLayout.NORTH);
    }

    //Devuelve el nombre del fichero que contiene el mapa
    public static String getFicheroNombre() {
        return fichero;
    }

    //Este método permite seleccionar el fichero
    private void seleccionarLaberinto() {
        //DECLARACIÓN Y CONFIGURACIÓN JFileChooser
        JFileChooser ventanaSeleccion = new JFileChooser();
        //HACEMOS QUE LO ÚNICO QUE SE VEAN SEA LOS .txt Y ARCHIVOS DE TEXTO
        FileNameExtensionFilter filtro
                = new FileNameExtensionFilter("Archivos de texto", "txt");
        //
        File path = new File(System.getProperty("user.dir"));
        //
        ventanaSeleccion.setCurrentDirectory(path);
        //Se añade el filtro a la JFileChooser
        ventanaSeleccion.setFileFilter(filtro);
        try {
            int x = ventanaSeleccion.showOpenDialog(ventanaSeleccion);
            fichero = null;
            if (x == JFileChooser.APPROVE_OPTION) {
                fichero = ventanaSeleccion.getSelectedFile().getName();
            }
        } catch (HeadlessException error) {
            System.out.println("Error 1: " + error.toString());
        } catch (Exception error) {
            System.out.println("Error 2: " + error.toString());
        }
    }

    //
    public class gestorDesplazamientoFicha implements KeyListener {

        @Override
        public void keyTyped(KeyEvent ke) {
        }

        @Override
        public void keyPressed(KeyEvent ke) {
            try {
                boolean cambio = false;
                Character cero = '0';
                for (int i = 0; i < filas; i++) {
                    for (int j = 0; j < columnas; j++) {
                        if (mapa.getMatriz(i, j).estado()) {
                            if (((ke.getKeyCode() == KeyEvent.VK_LEFT)
                                    || (ke.getKeyCode() == KeyEvent.VK_A))
                                    && j != 0) {
//                                System.out.println("IZQUIERDA");
                                if (mapa.getMatriz(i, j).getParedes(3) == cero) {
                                    mapa.getMatriz(i, j - 1).setCasillaOcupada();
                                    mapa.getMatriz(i, j).setCasillaLibre();
                                }
                                cambio = true;
                            }
                            if (((ke.getKeyCode() == KeyEvent.VK_RIGHT)
                                    || (ke.getKeyCode() == KeyEvent.VK_D))
                                    && j != columnas) {
//                                System.out.println("DERECHA");
                                if (mapa.getMatriz(i, j).getParedes(1) == cero) {
                                    mapa.getMatriz(i, j + 1).setCasillaOcupada();
                                    mapa.getMatriz(i, j).setCasillaLibre();
                                }
                                cambio = true;
                            }
                            if (((ke.getKeyCode() == KeyEvent.VK_UP)
                                    || (ke.getKeyCode() == KeyEvent.VK_W))
                                    && i != 0) {
//                                System.out.println("ARRIBA");
                                if (mapa.getMatriz(i, j).getParedes(0) == cero) {
                                    mapa.getMatriz(i - 1, j).setCasillaOcupada();
                                    mapa.getMatriz(i, j).setCasillaLibre();
                                }
                                cambio = true;
                            }
                            if (((ke.getKeyCode() == KeyEvent.VK_DOWN)
                                    || (ke.getKeyCode() == KeyEvent.VK_S))
                                    && i != filas) {
//                                System.out.println("ABAJO");
                                if (mapa.getMatriz(i, j).getParedes(2) == cero) {
                                    mapa.getMatriz(i + 1, j).setCasillaOcupada();
                                    mapa.getMatriz(i, j).setCasillaLibre();
                                }
                                cambio = true;
                            }
                            //Añadimos un break para que no se ejecute varias veces
                            //una misma instrucción
                            break;
                        }
                    }
                    //si ha habido ya un cambio se finaliza el tratamiento
                    if (cambio) {
                        break;
                    }
                }
                repaint();
            } catch (Exception error) {
                System.out.println("Error: " + error.toString());
                error.printStackTrace();
            }
        }

        @Override
        public void keyReleased(KeyEvent ke) {
        }
    }

    //MANIPULADOR EVENTOS COMPONENTES JMenu
    private class gestorEventosMenu implements ActionListener {

        @Override
        public void actionPerformed(ActionEvent evento) {
            switch (evento.getActionCommand()) {
                case "Seleccionar laberinto":
                    //Seleccion del mapa que sea desea jugar
                    seleccionarLaberinto();
                    mapa.setVisible(false);
                    inicio();
                    break;
                case "Reiniciar":
                    mapa.setVisible(false);
                    inicio();
                    break;
                case "Salir":
                    //Sale de la aplicación con el cierre de la ventana y la 
                    //finalización de la ejecución
                    System.exit(0);
                    break;
            }
        }
    }
}
