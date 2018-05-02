<%--@elvariable id="formatter" type="java.time.format.DateTimeFormatter"--%>
<%--@elvariable id="user" type="com.opencode.entity.Player"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/resources/templates/includes.jsp" %>

    <title>${user.login}</title>
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
                            <sec:authentication var="principal" property="principal"/>
                            <c:choose>
                                <c:when test="${ game.attempts.size() > 0 and game.attempts.get( game.attempts.size()-1 ).number.equals(game.guessedNumber)}">
                                    <span class="badge pull-right">${game.attempts.size()}</span>
                                </c:when>
                                <c:when test="${user.login.equals(principal.username)}">
                                    <span class="badge pull-right">
                                        <a onclick="location.href = '${pageContext.request.contextPath}/game/${game.id}';">Continue</a>
                                    </span>
                                </c:when>
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
