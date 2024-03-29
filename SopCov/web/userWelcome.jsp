<%-- 
    Document   : userWelcome
    Created on : 9 janv. 2015, 02:05:27
    Author     : Ayoub
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="icon" href="img/favicon.ico">

        <title>SopCov - Page d'utilisateur</title>

        <!-- Bootstrap core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="css/style.css" rel="stylesheet">

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
    </head>

    <body>

        <%!
            String login = "";
            String email = "";
            String pswd = "";
            boolean admin = false;
            HttpSession s = null;
        %>
        <%
            s = request.getSession();
            if (s != null && !s.isNew() && s.getAttribute("email") != null && s.getAttribute("password") != null) {
                email = (String) s.getAttribute("email");
                login = email.split("@")[0];
                pswd = (String) s.getAttribute("password");
                admin = (Boolean) s.getAttribute("admin");
            }
            else {
                throw new RuntimeException("Accès interdit, vous n'êtes pas loggé!");
            }
        %>

        <div class="site-wrapper">

            <div class="site-wrapper-inner">

                <div class="cover-container">

                    <div class="masthead clearfix">
                        <div class="inner">
                            <h3 class="masthead-brand">SopCov</h3>
                            <nav>
                                <ul class="nav masthead-nav">
                                    <li class="active"><a href="#">Page Principale</a></li>
                                    <li><a href="/SopCov/ShowCovoiturage">Trajets</a></li>
                                    <li><a href="/SopCov/EditProfile.do">Profil</a></li>
                                        <% if (admin) {%>
                                    <li><a href="management.jsp">Administration</a></li>
                                        <% }%>
                                    <li><a href="/SopCov/SignOutServlet.do">Se déconnecter</a></li>
                                </ul>
                            </nav>
                        </div>
                    </div>

                    <div class="inner cover">
                        <div class="panel panel-default noshadow">
                            <div class="panel-heading">
                                <h3 class="panel-title">Bienvenue <%=login%> !</h3>
                            </div>
                            <div class="panel-body modeltype">

                                <center>
                                    <h3>
                                        Vous pouvez dès à présent voir les trajets disponibles ou modifier votre profil.
                                    </h3>
                                </center>
                                <div class="pull-left">
                                    <div style="width:100%">
                                        <img src="img/trajet.JPG" width="300" height="150" alt="Mon Image">
                                    </div>
                                    <center>
                                        <a href="/SopCov/ShowCovoiturage" class="btn btn-success">Rechercher Trajet</a>
                                    </center>
                                </div>
                                <div class="pull-right">

                                    <div style="width:100%">
                                        <img src="img/edit.JPG" width="300" height="150" alt="Mon Image 2">
                                    </div>
                                    <center>
                                        <a href="/SopCov/EditProfile.do" class="btn btn-success">Modifier Profil</a>
                                    </center>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="mastfoot">
                        <div class="inner">
                            <p>Application de covoiturage développé pour <a href="http://www.sopra.com/">Sopra</a>, par <a href="http://www.insa-toulouse.fr">INSA Toulouse</a>.</p>
                        </div>
                    </div>

                </div>

            </div>

        </div>

        <!-- Bootstrap core JavaScript
        ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="../../assets/js/docs.min.js"></script>
        <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
        <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
    </body>
</html>
