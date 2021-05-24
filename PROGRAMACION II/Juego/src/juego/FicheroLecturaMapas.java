/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package juego;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

/**
 * @Autores: Sergi Mayol Matos y Alejandro Rodríguez Arguimbau
 * Enlace:
 */
public class FicheroLecturaMapas {

    private BufferedReader br;
    private FileReader fr;

    public FicheroLecturaMapas(String nombreFichero) {
        try {
            fr = new FileReader(nombreFichero);
            br = new BufferedReader(fr);
        } catch (FileNotFoundException ex) {
            System.out.println("Exception abriendo fichero:"
                    + " " + nombreFichero + " error: " + ex);
        }
    }

// Método de lectura de una linea del fichero.
    public String lectura() {
        String linea = null;
        try {
            linea = br.readLine();
        } catch (Exception error) {
            System.out.println("Error leyendo: " + error.toString());
        }
        return linea;
    }

    // Método de lectura un int del fichero. 
    public int leer() {
        int x = 0;
        try {
            x = br.read();
        } catch (IOException e) {
            System.out.println("Exception leyendo fichero error: " + e);
        }
        return x;
    }

    //Método de cierre de enlace con fichero.
    public void close() {
        try {
            fr.close(); //Cerrar FileReader
            br.close(); // Cerrar BufferedReader
        } catch (IOException ex) {
            System.out.println("Exception cerrando fichero: " + ex);
        } finally {
            try {
                fr.close();
            } catch (IOException e) {
                System.out.println("Exception cerrando fichero: " + e);
            }
        }
    }
}
