<%--@elvariable id="formatter" type="java.time.format.DateTimeFormatter"--%>
<%--@elvariable id="user" type="com.opencode.entity.Player"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>${user.login}</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.min.css"/>"/>
</head>
<body>
<%@include file="/resources/templates/header.jsp" %>
Date Of Registration : ${user.dateOfRegistration.format(formatter)}
<div>
    List Of Games
    <div class="btn-group-vertical">
        <c:forEach items="${user.games}" var="game">
            <div class="btn-group">
                <button type="button" data-toggle="dropdown"
                        class="btn btn-info dropdown-toggle">${game.guessedNumber},${game.dateOfGame.format(formatter)}<span
                        class="caret"></span></button>
                <!-- Выпадающее меню -->
                <ul class="dropdown-menu">
                    <!-- Пункты меню -->
                    <c:set var="attempts" value="1"/>
                    <c:forEach items="${game.attempts}" var="attempt">
                        <li>#${attempts},${attempt.number}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
