<%--@elvariable id="game" type="com.opencode.entity.Game"--%>
<%--@elvariable id="error" type="java.lang.String"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Game#${game.id}</title>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script src="<c:url value="/resources/js/jquery.min.js"/>"></script>
    <script src="<c:url value="/resources/js/bootstrap.min.js"/>"></script>
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.min.css"/>"/>
    <script>
        function sendAttempt() {
            $.ajax({});
        }

        var min = 0;
        var max = 9;

        $(document).ready(function () {

        });
    </script>
</head>
<body>
<%@include file="/resources/templates/header.jsp" %>
<div class="container">
    <div class="row">
        <c:if test="${error != null}">
            <div class="alert alert-danger">
                <p>${error}</p>
            </div>
        </c:if>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="row">
                <label>Let's play!</label>
                <br>
                <div role="form" class="btn-group-justified">
                    <div class="btn-group">
                        <div id="1" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger"
                                        disabled="disabled"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->


                    <div class="btn-group">
                        <div id="2" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger"
                                        disabled="disabled"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->


                    <div class="btn-group">
                        <div id="3" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger"
                                        disabled="disabled"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->

                    <div class="btn-group">
                        <div id="4" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger"
                                        disabled="disabled"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->
                    <button onclick="sendAttempt()" value="Try your lick"></button>
                </div>
            </div>
            <div id="answerDiv" class="row alert alert-info">
                <label for="answer">Server answer</label>
                <textarea id="answer" readonly> </textarea>
            </div>
            <div class="row">
                <label class="pull-left">Attempts</label>
                <br>
                <ul class="list-group col-md-8">
                    <c:forEach items="${game.attempts}" var="attempt" varStatus="status">
                        <li class="list-group-item text-center"><span
                                class="pull-left">#${status.index}</span>${attempt.number}</li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        <div class="col-md-6">
            <label>Unfinished games</label><span></span>
            <br>
            <ul class="list-group col-md-8">
                <c:forEach items="${list}" var="unfinished">
                    <li class="list-group-item text-center">
                        <a href="<c:url value="/game/${unfinished.id}"/>">Game#${unfinished.id}</a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
