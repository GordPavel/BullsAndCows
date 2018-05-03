<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <%@include file="/resources/templates/includes.jsp" %>
    <title>HTTP Status 404 – Not Found</title>
    <style type="text/css">
        h1 {
            font-family: Tahoma, Arial, sans-serif;
            color: white;
            background-color: #525D76;
            font-size: 22px;
        }

        h2 {
            font-family: Tahoma, Arial, sans-serif;
            color: white;
            background-color: #525D76;
            font-size: 16px;
        }

        h3 {
            font-family: Tahoma, Arial, sans-serif;
            color: white;
            background-color: #525D76;
            font-size: 14px;
        }

        body {
            font-family: Tahoma, Arial, sans-serif;
            color: black;
            background-color: white;
        }

        b {
            font-family: Tahoma, Arial, sans-serif;
            color: white;
            background-color: #525D76;
        }

        p {
            font-family: Tahoma, Arial, sans-serif;
            background: white;
            color: black;
            font-size: 12px;
        }

        a {
            color: black;
        }

        a.name {
            color: black;
        }

        .line {
            height: 1px;
            background-color: #525D76;
            border: none;
        }</style>
</head>
<body>
<%@include file="/resources/templates/header.jsp" %>
<h1>404 – Not Found</h1>
<hr class="line"/>
<c:choose>
    <c:when test="${error == null}">
        <p><b>Type</b> Status Report</p>
        <p><b>Description</b>Something went wrong. Don't try to cheat my app please :)</p>
    </c:when>
    <c:otherwise>
        <p><b>Type</b> Illegal player's nickname</p>
        <p><b>Description</b>${error}</p>
        <p>Don't try to cheat my app please :)</p>
    </c:otherwise>
</c:choose>
<hr class="line"/>
</body>
</html>
