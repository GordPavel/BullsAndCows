<%--@elvariable id="formatter" type="java.time.format.DateTimeFormatter"--%>
<%--@elvariable id="user" type="com.opencode.entity.Player"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${user.login}</title>
</head>
<body>
<%@include file="/resources/templates/header.jsp" %>
Date Of Registration : ${user.dateOfRegistration.format(formatter)}
<div>
    List Of Games
    <c:forEach items="${user.games}" var="games">
        ${games.guessedNumber}
    </c:forEach>
</div>
</body>
</html>
