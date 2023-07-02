

package com.mycompany.proyecto_lenguajedb;

import Conexiones.ConexionOracle;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PROYECTO_LENGUAJEDB {

    public static void main(String[] args) {
        String sSQL ="";
        ConexionOracle conexion = new ConexionOracle();
        
        try{
            sSQL = "SELECT * FROM PROVEEDOR";
           Connection con = conexion.conectar();
           Statement cn = con.createStatement();
           ResultSet res = cn.executeQuery(sSQL);
           
           while (res.next()) {
               System.out.println("-----------------");
               System.out.println(res.getInt("ID_Vendedor"));
               System.out.println(res.getString("Nombre"));
               System.out.println(res.getString("telefono"));
               System.out.println(res.getString("direccion"));
           }
        }catch (SQLException e){
            System.out.println(e);
        }
    }
}
