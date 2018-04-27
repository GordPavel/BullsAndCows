<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Login</title>

    <sec:authorize access="isAuthenticated()">
        <% response.sendRedirect( "/person" ); %>
    </sec:authorize>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.min.css"/>"/>
</head>
<body>
<%@include file="/resources/templates/header.jsp" %>
<div class="container">
    <div class="row">
        <div class="col-md-6">
            <div class="wrap">
                <c:url var="loginUrl" value="/login"/>
                <form id="signIn" action="${loginUrl}" method="post">
                    <h2 class="form-signin-heading">Sign in</h2>
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <p>Invalid username and password.</p>
                        </div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success">
                            <p>You have been logged out successfully.</p>
                        </div>
                    </c:if>
                    <div class="form-group">
                        <label for="username">Nickname</label>
                        <input type="text" class="form-control" id="username" name="login" placeholder="Enter Username"
                               required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="pass"
                               placeholder="Enter Password" required>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="dropdownCheck2">
                        <label class="form-check-label" for="dropdownCheck2">Remember me</label>
                    </div>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <%--<button type="submit" class="btn btn-lg btn-primary btn-block">Sign in</button>--%>
                </form> 
            </div>
        </div>

        <div class="col-md-6">
            <div class="wrap">
                <c:url var="registrationUrl" value="/registration"/>
                <form:form id="signUp" method="POST" action="${registrationUrl}" modelAttribute="registrationForm"
                           class="form-signin">
                    <c:if test="${registrationSuccess != null}">
                        <div class="alert alert-success">
                            <p>${registrationSuccess}</p>
                        </div>
                    </c:if>
                    <h2 class="form-signin-heading">Create your account</h2>
                    <spring:bind path="login">
                        <div class="form-group ${status.error ? 'has-error' : ''}">
                            <label for="regUsername">Nickname</label>
                            <form:input id="regUsername" type="text" path="login" class="form-control"
                                        placeholder="Enter Username"/>
                            <form:errors path="login"/>
                        </div>
                    </spring:bind>

                    <spring:bind path="password">
                        <div class="form-group ${status.error ? 'has-error' : ''}">
                            <label for="regPassword">Password</label>
                            <form:input id="regPassword" type="password" path="password" class="form-control"
                                        placeholder="Enter Password"/>
                            <form:errors path="password"/>
                        </div>
                    </spring:bind>

                    <spring:bind path="passwordConfirm">
                        <div class="form-group ${status.error ? 'has-error' : ''}">
                            <label for="regConfirm">Password</label>
                            <form:input id="regConfirm" type="password" path="passwordConfirm" class="form-control"
                                        placeholder="Confirm your password"/>
                            <form:errors path="passwordConfirm"/>
                        </div>
                    </spring:bind>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <%--<button class="btn btn-lg btn-primary btn-block" type="submit">Sign up</button>--%>
                </form:form>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6"><button type="submit" form="signIn" class="btn btn-lg btn-primary btn-block">Sign in</button></div>
        <div class="col-md-6"><button type="submit" form="signUp" class="btn btn-lg btn-primary btn-block">Registration</button></div>
    </div>
</div>
</body>
</html>