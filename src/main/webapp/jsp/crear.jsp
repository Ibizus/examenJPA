<%--
  Created by IntelliJ IDEA.
  User: hector
  Date: 4/12/23
  Time: 14:06
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.sql.*" %>
<%@page import="java.util.Objects" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%
    //CÓDIGO DE VALIDACIÓN
    boolean valida = true;
    java.util.Date fechaD = null;
    String E1 = null;
    String E2 = null;
    String tipo = null;
    boolean flagValidaFecha = false;
    boolean flagValidaE1Null = false;
    boolean flagValidaE1Blank = false;
    boolean flagValidaE2Null = false;
    boolean flagValidaE2Blank = false;
    try {

        Objects.requireNonNull(request.getParameter("equipo1"));
        flagValidaE1Null = true;
        if (request.getParameter("equipo1").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaE1Blank = true;
        E1 = request.getParameter("equipo1");

        Objects.requireNonNull(request.getParameter("equipo2"));
        flagValidaE2Null = true;
        if (request.getParameter("equipo2").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaE2Blank = true;
        E2 = request.getParameter("equipo2");
        // VALIDA FECHA:
        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
        fechaD = formato.parse(request.getParameter("fecha"));
        flagValidaFecha = true;
        // RECOGE CAMPO DEL SELECT:
        tipo = request.getParameter("tipo_partido");

    } catch (Exception ex) {
        ex.printStackTrace();

        if (!flagValidaE1Null || !flagValidaE1Blank) {
            session.setAttribute("error", "Error en equipo1");
        } else if (!flagValidaE2Null || !flagValidaE2Blank) {
            session.setAttribute("error", "Error en equipo2");
        } else if (!flagValidaFecha){
            session.setAttribute("error", "Error en fecha");
        }
        valida = false;
    }
    // FIN CÓDIGO DE VALIDACIÓN DE PARÁMETROS

    // AHORA VALIDAMOS USUARIO REPETIDO:
    if (valida) {

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet resultUser = null;

        try {
            //CARGA DEL DRIVER Y PREPARACIÓN DE LA CONEXIÓN CON LA BBDD
            //						v---------UTILIZAMOS LA VERSIÓN MODERNA DE LLAMADA AL DRIVER, no deprecado
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:30306/juego", "root", "user");

            String sql = ("INSERT INTO partido (fecha, equipo1, equipo2, tipo_partido) VALUES (? , ?, ?, ?)");
            ps = conn.prepareStatement(sql);

            int idx = 1;
            ps.setDate(idx++, new java.sql.Date(fechaD.getTime()));
            ps.setString(idx++, E1);
            ps.setString(idx++, E2);
            ps.setString(idx, tipo);

            ps.executeUpdate();
            session.setAttribute("success", "Partido creado correctamente");


        } catch (Exception ex) {
            ex.printStackTrace();
            System.out.println(ex.getMessage());
        } finally {
            //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
            //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
            try {
                resultUser.close();
            } catch (Exception e) { /* Ignored */ }
            try {
                ps.close();
            } catch (Exception e) { /* Ignored */ }
            try {
                conn.close();
            } catch (Exception e) { /* Ignored */ }
        }
    }

    // Devuelvo siempre a formulario para mostrar el error o avisar de éxito:
    response.sendRedirect("listado.jsp");
%>

</body>
</html>