<%--
  Created by IntelliJ IDEA.
  User: hector
  Date: 4/12/23
  Time: 13:50
  To change this template use File | Settings | File Templates.
--%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="../css/style.css" />
</head>
<body>
<div class="container">
    <%
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:30306/juego","root", "user");
            Statement s = conn.createStatement();

            ResultSet listado = s.executeQuery ("SELECT * FROM partido");
    %>
    <table>
        <tr><th>Fecha</th><th>Equipo1</th><th>puntos E1</th><th>Equipo 2</th><th>Puntos E2</th><th>Tipo</th></tr>
        <%
            while (listado.next()) {
        %>
        <tr>
            <td>
                <%= listado.getString("fecha")%>
            </td>
            <td>
                <%= listado.getString("equipo1")%>
            </td>
            <td>
                <%= listado.getString("puntos_equipo1")%>
            </td>
            <td>
                <%= listado.getString("equipo2")%>
            </td>
            <td>
                <%= listado.getString("puntos_equipo1")%>
            </td>
            <td>
                <%= listado.getString("tipo_partido")%>
            </td>
            <td>
                <form method="post" action="editar.jsp">
                    <input type="hidden" name="id" value="<%=listado.getString("id") %>"/>
                    <input type="submit" value="editar">
                </form>
            </td>
            <td>
                <form method="post" action="borrar.jsp">
                    <input type="hidden" name="id" value="<%=listado.getString("id") %>"/>
                    <input type="submit" value="borrar">
                </form>
            </td>
        </tr>
        <%
            } // while
            conn.close();
        %>
    </table>
    <%
        //                                                 v---- RECOGER MENSAJE DE ERROR DEL ÁMBITO request
        String error = (String)session.getAttribute("error");
        String success = (String)session.getAttribute("success");
//            v---- SI ESTÁ PRESENTE INFORMAR DEL ERROR
        if (error != null || success != null) {
            String ErrorAlertClass = "class=\"alert alert-danger alert-dismissible fade show\"";
            String SuccessAlertClass = "class=\"alert alert-success alert-dismissible fade show\"";

    %>
    <div class="row mt-2">
        <div class="col-4 align-self-center">
            <div <%= (error!=null)?ErrorAlertClass:SuccessAlertClass%>>
                <strong><%= (error!=null)?"Error!":"Hecho!"%></strong> <%= (error!=null)?error:success%>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </div>
    <%
                session.removeAttribute("error");
                session.removeAttribute("success");
            }
        }catch (Exception e){
            e.printStackTrace();
            System.out.println(e.getMessage());
        }
    %>
    <form method="post" action="crear.jsp">
        <div class="row mt-2">
            <div class="col-6">
                <input type="date" name="fecha" placeholder="Fecha"/>
            </div>
            <div class="col-6">
                <input type="text" name="equipo1" placeholder="Equipo1"/>
            </div>
            <div class="col-6">
                <input type="text" name="equipo2" placeholder="Equipo2"/>
            </div>
            <div>
                <select name="tipo_partido">
                    <option value="amistoso">Amistoso</option>
                    <option value="oficial">Oficial</option>
                </select>
            </div>
        </div>
        <div class="row mt-2">
            <div class="col align-self-center">
                <input class="btn btn-primary align-self-center" type="submit" value="Crear Nuevo Partido"></i>
            </div>
        </div>
    </form>
</div>
</body>
</html>