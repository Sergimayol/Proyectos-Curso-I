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
import java.awt.Graphics;
import java.awt.HeadlessException;
import java.awt.Image;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.logging.Level;
import java.util.logging.Logger;
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
    //Atributo Laberinto el cual contendrá el mapa y la ficha
   // Laberinto lab;
    //Atributo String que contiene el nombre del mapa que se va a dibujar
    private static String fichero;
    //Atributo Mapa que contiene mapa que se va a dibujar
    private AreaDibujoLaberinto dibujo;
    //
    private Ficha ficha = new Ficha();
    private Mapa mapa = new Mapa();

    public static void main(String[] args) {
        new Laberinto().inicio();
    }
    
    //Mensaje al llegar a la salids del mapa
    public void gameOver() {
        JOptionPane.showMessageDialog(this, "        HAS GANADO!!!");
        //Cerrar el juego al ganar, ya que sino se quedaría en bucle
        System.exit(0);
    }

    //Método inicial del programa
    private void inicio() {
        while (true) {
            dibujo.repaint();
            try {
                Thread.sleep(10);
            } catch (InterruptedException ex) {
                Logger.getLogger(Laberinto.class.getName()).log(Level.SEVERE, null, ex);
            }            
        }
    }

    //Constructor el cual contiene las configuraciones del JFrame 
    //y el metodo principal, además de tener el foco principal para el movimiento
    //de la ficha
    public Laberinto() {
        addKeyListener(new KeyListener() {
            @Override
            public void keyTyped(KeyEvent e) {
            }

            @Override
            public void keyReleased(KeyEvent e) {

            }

            @Override
            public void keyPressed(KeyEvent e) {
                ficha.teclaPresionada(e);
            }
        });
        setFocusable(true);

        //Añadimos un titulo a la ventana
        setTitle("Laberinto");
        //La ventana no podrá redimensionarse
        // setResizable(false);
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
        //la ventana estará situada en el centro(418,680 resizable true)
        setBounds(anchopant / 3, altpant / 4, 418, 680); //Posible añado de +200,0 para meter estadisticas
        //Activar el cierre interactivo del contenedor JFrame ventana para finalizar
        //ejecución
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        //Asignación al objeto Container panelContenidos DEL PANEL JContentPane 
        //del JFrame 
        panelContenidos = getContentPane();
        //asignación administrador de Layout BordeLayout al panel de contenidos
        //del JFrame
        panelContenidos.setLayout(new BorderLayout());

        //Metodo encargado de la gestion de la interface
        metodoPrincipal();

        //Activar visualización contenedor JFrame ventana
        setVisible(true);
    }

    //Devuelve el nombre del fichero que contiene el mapa
    public static String getFicheroNombre() {
        return fichero;
    }

    //Este método es el encargado de la gestion de botones y de la adicion 
    //del mapa al JFrame
    private void metodoPrincipal() {
        //MANIPULADOR EVENTOS COMPONENTES JMenu 
        ActionListener gestorEventosMapa = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent evento) {
                switch (evento.getActionCommand()) {
                    case "Seleccionar Laberinto":
                        //Seleccion del mapa que sea desea jugar
                        seleccionarLaberinto();
                        //dibujo = new AreaDibujoLaberinto();
                        mapa = new Mapa();
                        ficha = new Ficha();
                        System.out.println("MAPA SELECCIONADO: " + fichero);
                        break;
                    case "Reiniciar":
                        //dibujo = new AreaDibujoLaberinto();
                        ficha = new Ficha();
                        System.out.println("MAPA: " + fichero + " HA SIDO REINICIADO");
                        break;
                    case "Salir":
                        //Sale de la aplicación con el cierre de la ventana y la 
                        //finalización de la ejecución
                        System.exit(0);
                        break;
                }
                //dibujo.repaint();
            }
        };

        //CONFIGURACIÓN CONTENEDOR JPanel contenedor del panelMenu
        JPanel panelMenu = new JPanel();
        panelMenu.setBackground(Color.LIGHT_GRAY);

        //DECLARACIÓN COMPONENTE JMenuBar (barra de menu)
        JMenuBar barraMenu = new JMenuBar();

        //DECLARACIÓN Y CONFIGURACIÓN COMPONENTES JMENUS DE LA BARRA DE MENU
        JMenu opciones = new JMenu("OPCIONES");

        //DECLARACIÓN OPCIONES JMenuItem
        seleccionLab = new JMenuItem("Seleccionar Laberinto");
        reiniciar = new JMenuItem("Reiniciar");
        salir = new JMenuItem("Salir");

        //Asociación componente JMenuItem, con gestor de evento gestorEventoMenuBar
        seleccionLab.addActionListener(gestorEventosMapa);
        reiniciar.addActionListener(gestorEventosMapa);
        salir.addActionListener(gestorEventosMapa);

        //Asignación componentes JMenuItem con su correspondiente JMenu
        opciones.add(seleccionLab);
        opciones.add(reiniciar);
        opciones.add(salir);

        //Introducción de la componentes JMenu en el JMenuBar
        barraMenu.add(opciones);
        //Introducción de la componentes JMenuBar en el JPanel
        panelMenu.add(barraMenu);

        //INSTANCIACIÓN DE LA CLASE AreaDibujoLaberinto
        dibujo = new AreaDibujoLaberinto();

        //Adicion del mapa y barraMenu al JPanel panelContenidos
        panelContenidos.add(panelMenu, BorderLayout.NORTH);
        panelContenidos.add(dibujo, BorderLayout.CENTER);
    }

    //Este método permite seleccionar el fichero
    private void seleccionarLaberinto() {
        //DECLARACIÓN Y CONFIGURACIÓN JFileChooser
        JFileChooser ventanaSeleccion = new JFileChooser();
        //HACEMOS QUE LO ÚNICO QUE SE VEAN SEA LOS .txt Y ARCHIVOS DE TEXTO
        FileNameExtensionFilter filtro
                = new FileNameExtensionFilter("archivos de texto", "txt");
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

    //Clase encargada de dibujar el mapa y la ficha 
    public class AreaDibujoLaberinto extends JPanel {

        //private Mapa mapa;
        public AreaDibujoLaberinto() {
            //mapa = new Mapa();
            //ficha = new Ficha();
        }

        @Override
        public void paintComponent(Graphics g) {
            mapa.paintComponent(g);
            ficha.paintComponent(g);
        }
    }
}
