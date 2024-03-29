<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix ="c" %>
<html lang="fr">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="icon" href="img/favicon.ico">

        <title>SopCov - Recherche de Trajets</title>

        <!-- Bootstrap core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom styles for this template -->
        <link href="css/style.css" rel="stylesheet">

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->



        <style>
            .popover {
                max-width: none;
            }
            html, body, #map-canvas0 {
                height: 100%;
                margin: 0px;
                padding: 0px
            }
            #panel {
                position: absolute;
                top: 5px;
                left: 50%;
                margin-left: -180px;
                z-index: 5;
                background-color: #fff;
                padding: 5px;
                border: 1px solid #999;
            }
        </style>
        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
        <script>

            var getMap = function (opts) {
                var src = "http://maps.googleapis.com/maps/api/staticmap?",
                        params = $.extend({
                            center: 'New York, NY',
                            zoom: 14,
                            size: '512x512',
                            maptype: 'roadmap',
                            sensor: false
                        }, opts),
                        query = [];

                $.each(params, function (k, v) {
                    query.push(k + '=' + encodeURIComponent(v));
                });

                src += query.join('&');
                return '<img src="' + src + '" />';
            }

            var content = getMap({center: 'Fritz-Walter Stadion, Kaiserslautern'});
            $('#example').popover({html: true, content: content, placement: 'bottom'})
        </script>
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
                                    <li><a href="userWelcome.jsp"> Page Principale</a></li>
                                    <li class="active"><a href="#">Trajets</a></li>
                                    <li><a href="/SopCov/EditProfile.do"> Profil</a></li>
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
                                <h3 class="panel-title">Trouvez votre trajet</h3>
                            </div>
                            <div class=" modeltype"> <!--panel-body -->
                                <nav class="navbar navbar-default">
                                    <div class="container-fluid">
                                        <!-- Brand and toggle get grouped for better mobile display -->
                                        <div class="navbar-header">
                                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                                                <span class="sr-only">Afficher la navigation</span>
                                                <span class="icon-bar"></span>
                                                <span class="icon-bar"></span>
                                                <span class="icon-bar"></span>
                                            </button>
                                            <a class="navbar-brand" href="#">Critères</a>
                                        </div>

                                        <!-- Collect the nav links, forms, and other content for toggling -->
                                        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                                            <!--ul class="nav navbar-nav">
                                                <li class="dropdown">
                                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Villes <span class="caret"></span></a>
                                                    <ul class="dropdown-menu" role="menu">
                                                        <li><a href="#">Toulouse</a></li>
                                                        <li><a href="#">Colomiers</a></li>      
                                                        <li><a href="#"></a></li>
                                                    </ul>
                                                </li>
                                                <li class="dropdown">
                                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Sites <span class="caret"></span></a>
                                                    <ul class="dropdown-menu" role="menu">
                                                        <li><a href="#">Toulouse Colomiers 1</a></li>
                                                        <li><a href="#">Toulouse Colomiers 2</a></li>
                                                        <li><a href="#">Toulouse Les Ramassiers</a></li>
                                                        <li><a href="#"></a></li>
                                                    </ul>
                                                </li>
                                            </ul-->
                                            <form class="navbar-form navbar-right"  action="/SopCov/SearchRoute" role="search">
                                                <select class="form-control" name="commune">
                                                    <c:forEach var="com" items="${Communes}" varStatus="loop">
                                                         <option value="${com.code_postal}">${com.commune},${com.code_postal}</option>
                                                    </c:forEach>
                                                </select>
                                                
                                                <select class="form-control" name="lieu_travail">
                                                    <option value="Sopra_Group_Ent1">Sopra_Group_Ent1</option>
                                                    <option value="Sopra_Group_Ent2">Sopra_Group_Ent2</option>
                                                </select>
                                                <button type="submit" class="btn btn-success">Rechercher</button>
                                            </form>
                                        </div><!-- /.navbar-collapse -->
                                    </div><!-- /.container-fluid -->
                                </nav>
                                <div class="col">
                                    <div class="row-sm-6 row-md-4">

                                        <c:forEach var="driver" items="${drivers}" varStatus="loop">
                                            <div class="panel panel-primary boxshadow">
                                                <div class="panel-heading"><a href="#" id="example" >${driver.commune} > ${driver.lieu_travail_nom}</a></div>
                                                <div class="panel-body">
                                                    <div class="row">
                                                        <div class="col-md-7">
                                                            <h4 class="media-heading">${driver.nom}  ${driver.prenom}</h4>
                                                            <p>
                                                                <span class="label label-success">Départ</span> ${driver.adresse}, ${driver.code_postal} ${driver.commune}<br/>
                                                                <span class="label label-warning">Arrivée</span> ${driver.lieu_travail_adresse} <br/>
                                                                <span class="label label-info">Tel :  </span>  ${driver.tel}<br/>
                                                            
                                                                <span class="label label-info">Horaire Aller</span>  ${driver.heure_depart}
                                                                <span class="label label-info">Horaire Retour</span> ${driver.heure_retour}<br/>
                                                                
                                                                <span class="label label-info">J. de Travail : </span>  ${driver.jours_travail}<br/>
                                                                <span class="label label-warning">Places disponibles</span> 1/4
                                                            </p>
                                                        </div>
                                                        <div class="col-md-5">
                                                            <img src="https://maps.googleapis.com/maps/api/staticmap?center=${driver.commune}&zoom=11&size=600x400&maptype=roadmap&markers=color:blue|label:A|${driver.lieu_travail_adresse}&markers=color:red|label:B|${driver.adresse},${driver.commune}&path=${driver.lieu_travail_adresse}|${driver.adresse},${driver.commune}" class="img-responsive gmpreview" alt="google map preview">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </c:forEach>
                                    </div>
                                </div>                                

                            </div>
                        </div>
                    </div>
                    <div class="mastfoot">
                        <div class="inner">
                            <p>Application de covoiturage dÃ©veloppÃ© pour <a href="http://www.sopra.com/">Sopra</a>, par <a href="http://www.insa-toulouse.fr">INSA Toulouse</a>.</p>
                        </div>
                    </div>

                </div>

            </div>

        </div>
        <div class="container">

            <!-- Bootstrap core JavaScript
            ================================================== -->
            <!-- Placed at the end of the document so the pages load faster -->
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
            <script src="js/bootstrap.min.js"></script>
            <script src="../../assets/js/docs.min.js"></script>
            <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
            <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
            <script>
            $('.dropdown-inverse li > a').click(function (e) {
                $('.btnStatus').text(this.innerHTML);
            });
            </script>
    </body>
</html>
