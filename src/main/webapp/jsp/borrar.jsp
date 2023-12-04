<%--
  Created by IntelliJ IDEA.
  User: hector
  Date: 4/12/23
  Time: 14:03
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Objects" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%
    //CÓDIGO DE VALIDACIÓN
    boolean valida = true;
    int id = -1;

    try {
        id = Integer.parseInt(request.getParameter("id"));

    } catch (Exception ex) {
        ex.printStackTrace();
        session.setAttribute("error", "ID incorrecto");
        valida = false;
    }
    //FIN CÓDIGO DE VALIDACIÓN

    if (valida) {

        Connection conn = null;
        PreparedStatement ps = null;
        try {

            //CARGA DEL DRIVER Y PREPARACIÓN DE LA CONEXIÓN CON LA BBDD
            //						v---------UTILIZAMOS LA VERSIÓN MODERNA DE LLAMADA AL DRIVER, no deprecado
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:30306/juego", "root", "user");

            String sql = "DELETE FROM partido WHERE id = ?"; //user
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            session.setAttribute("success", "Partido borrado correctamente");

        } catch (Exception ex) {
            ex.printStackTrace();
            System.out.println(ex.getMessage());
            session.setAttribute("error", "No se ha podido borrar");

        } finally {
            //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
            //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
            try {
                ps.close();
            } catch (Exception e) { /* Ignored */ }
            try {
                conn.close();
            } catch (Exception e) { /* Ignored */ }
        }

    }
    // Devuelvo siempre a la lista para informar:
    response.sendRedirect("listado.jsp");
%>

</body>
</html>