<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
<head>
    <%@include file="/resources/templates/includes.jsp" %>

    <title>Login</title>
    <script>
        function loginOrRegistration() {
            var isLogin = $('#loginForm').css('visibility') === 'visible';
            $('.registration').css('visibility', isLogin ? 'visible' : 'hidden');
            $('.signIn').css('visibility', (!isLogin) ? 'visible' : 'hidden');
            $('#change').text(isLogin ? 'Sign in' : 'Sign up');
        }
    </script>
    <style>
        .registration {
            visibility: hidden;
        }
    </style>
</head>
<body>
<%@include file="/resources/templates/header.jsp" %>
<div class="container">
    <div class="row">
        <c:if test="${registrationSuccess != null}">
            <div class="alert alert-success">
                <p>${registrationSuccess}</p>
            </div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <p>Invalid username and password.</p>
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-success">
                <p>You have been log out successfully</p>
            </div>
        </c:if>
    </div>
    <div class="row">
        <div id="loginForm" class="col-md-6 signIn" style="visibility: visible">
            <div class="wrap">
                <c:url var="loginUrl" value="/login"/>
                <form id="signIn" action="${loginUrl}" method="post" role="form">
                    <h2 class="form-signin-heading">Sign in</h2>
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
                    <div class="checkbox">
                        <input type="checkbox" name="remember-me" class="form-check-input" id="dropdownCheck2">
                        <label class="form-check-label" for="dropdownCheck2">Remember me</label>
                    </div>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                </form>
            </div>
        </div>

        <div class="col-md-6 registration">
            <div class="wrap">
                <c:url var="registrationUrl" value="/registration"/>
                <%--@elvariable id="registrationForm" type="com.opencode.controller.RegistrationForm"--%>
                <form:form id="signUp" method="POST" action="${registrationUrl}" modelAttribute="registrationForm"
                           class="form-signin" role="form">
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
                </form:form>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6 signIn">
            <button type="submit" form="signIn" class="btn btn-lg btn-primary btn-block">Sign in</button>
        </div>
        <div class="col-md-6 registration">
            <button type="submit" form="signUp" class="btn btn-lg btn-primary btn-block">Sign up</button>
        </div>
    </div>
    <div class="row">
        <label class="form-check-label" for="change">Are you new here? </label>
        <button id="change" type="button" onclick="loginOrRegistration()">Sign Up</button>
    </div>
</div>
</body>
</html>