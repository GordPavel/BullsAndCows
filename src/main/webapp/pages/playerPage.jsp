<%--@elvariable id="formatter" type="java.time.format.DateTimeFormatter"--%>
<%--@elvariable id="user" type="com.opencode.entity.Player"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${user.login}</title>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script src="<c:url value="/resources/js/jquery.min.js"/>"></script>
    <script src="<c:url value="/resources/js/bootstrap.min.js"/>"></script>
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.min.css"/>"/>
</head>
<body>
<%@include file="/resources/templates/header.jsp" %>
<div class="container">
    <div class="row">
        <div class="col-md-6">Date Of Registration : ${user.dateOfRegistration.format(formatter)}</div>
        <div class="col-md-6">
            <label>List Of Games</label>
            <div class="row btn-group-vertical col-md-12">
                <c:forEach items="${user.games}" var="game">
                    <div class="btn-group">
                        <button type="button" data-toggle="dropdown" class="btn btn-info dropdown-toggle">
                            <label class="pull-left">Game#${game.id},${game.dateOfGame.format(formatter)}</label>
                            <c:choose>
                                <c:when test="${game.attempts.get( game.attempts.size()-1 ).number.equals(game.guessedNumber)}">
                                    <span class="badge pull-right">${game.attempts.size()}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge pull-right">
                                        <a onclick="location.href = '${pageContext.request.contextPath}/game/${game.id}';">Continue</a>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </button>
                        <ul class="dropdown-menu">
                            <label>Attempts</label>
                            <li class="divider"></li>
                            <c:forEach items="${game.attempts}" var="attempt" varStatus="attemptStatus">
                                <li>#${attemptStatus.index+1},${attempt.number}</li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>
</body>
</html>
