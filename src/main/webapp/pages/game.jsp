<%--@elvariable id="game" type="com.opencode.entity.Game"--%>
<%--@elvariable id="error" type="java.lang.String"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="/resources/templates/includes.jsp" %>
    <title>Game#${game.id}</title>

    <meta id="_csrf_token" value="${_csrf.token}"/>
    <script>
        function serverAnswer(attempt, guessed) {
            if (attempt === guessed) return 'Ты победил!';
            var bulls = 0;
            var cows = 0;
            var attemptArray = attempt.split("");
            var guessedArray = guessed.split("");
            attemptArray.map(function (value, index) {
                return {first: value, second: guessedArray[index]};
            }).forEach(function (value) {
                if (value.first === value.second) bulls++;
                else if (guessed.includes(value.first)) cows++;
            });
            return bulls + 'Б' + cows + 'К';
        }

        function sendAttempt() {
            var newAttempt = ($('#1').text() + $('#2').text() + $('#3').text() + $('#4').text());

            function getAttemptTemplate(attemptNumber, answer = serverAnswer(attemptNumber, "${game.guessedNumber}")) {
                var index = parseInt($('#attempts').children().last().children().first().text());
                if (isNaN(index)) index = 0;
                return '                        <tr>' +
                    '                            <th scope="row">' + (index + 1) + '</th>\n' +
                    '                            <td>' + attemptNumber + '</td>\n' +
                    '                            <td id="answer' + index + '">' + answer + '</td>\n' +
                    '                        </tr>';
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/newAttempt",
                type: 'POST',
                headers: {
                    "X-CSRF-TOKEN": $('#_csrf_token').attr('value')
                },
                data: JSON.stringify({
                    gameId: "${game.id}",
                    attempt: newAttempt
                }),
                contentType: "text/plain",
                success: function (data) {
                    if (data === 'Ты победил!') {
                        $('#game').css('visibility', 'hidden');
                        $('#send').css('visibility', 'hidden');
                    }
                    $('#attempts').append(getAttemptTemplate(newAttempt, data));
                    $('#answer').text(data);
                },
                error: function (xhr) {
                    $('#answer').text(xhr.responseText);
                }
            });
        }

        var min = 0;
        var max = 9;

        $(document).ready(function () {
            [
                <c:forEach items="${game.attempts}" var="attempt">
                "${attempt.number}",
                </c:forEach>
            ].map(function (value) {
                return serverAnswer(value, "${game.guessedNumber}");
            }).forEach(function (value, index) {
                $('#answer' + index).text(value);
            });

            $('.btn.minus').on('click', function (event) {
                var num = $(event.target).attr('number');
                var element = $('#' + num);
                var val = element.text();
                if (val > min) {
                    if (parseInt(val) <= max) {
                        $(event.target).parent().next().children().removeAttr('disabled');
                    }
                    element.text(val - 1);
                    if (parseInt(element.text()) === min) {
                        $(event.target).attr('disabled', 'disabled');
                    } else {
                        $(event.target).removeAttr('disabled');
                    }
                }
            });

            $('.btn.plus').on('click', function (event) {
                var num = $(event.target).attr('number');
                var element = $('#' + num);
                var val = element.text();
                if (val < max) {
                    if (parseInt(val) >= min) {
                        $(event.target).parent().prev().children().removeAttr('disabled');
                    }
                    element.text(parseInt(val) + 1);
                    if (parseInt(element.text()) === max) {
                        $(event.target).attr('disabled', 'disabled');
                    } else {
                        $(event.target).removeAttr('disabled');
                    }
                }
            });
        });
    </script>

    <style>
        .btn-group-justified, .btn-group-justified > .btn-group {
            width: 100%;
        }
    </style>
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
            <div id="game" class="row">
                <label>Let's play!</label>
                <br>
                <div role="form" class="btn-group-justified">
                    <div class="btn-group">
                        <div id="1" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger minus" disabled="disabled"
                                        number="1"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success plus" number="1">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->


                    <div class="btn-group">
                        <div id="2" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger minus"
                                        disabled="disabled" number="2"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success plus" number="2">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->


                    <div class="btn-group">
                        <div id="3" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger minus"
                                        disabled="disabled" number="3"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success plus" number="3">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->

                    <div class="btn-group">
                        <div id="4" class="form-control text-center">0</div>

                        <div class="btn-group-justified btn-block" role="group" aria-label="plus-minus">
                            <div class="btn-group">
                                <button type="button" class="btn btn-danger minus"
                                        disabled="disabled" number="4"><span class="glyphicon glyphicon-minus"></span>
                                </button>
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-success plus" number="4">
                                    <span class="glyphicon glyphicon-plus"></span></button>
                            </div>
                        </div><!-- end button group -->
                    </div> <!-- end column -->
                </div>
            </div>
            <div id="answerDiv" class="row alert alert-info">
                <div class="row">
                    <label for="answer">Server answer</label>
                    <button id="send" class="pull-right" onclick="sendAttempt()">Try your luck</button>
                </div>
                <textarea id="answer" class="row col-md-12 col-sm-12"
                          style="height: 50px;resize: vertical; min-height: 50px;max-height: 150px"
                          readonly> </textarea>
            </div>
            <div class="row">
                <label class="pull-left">Attempts</label>
                <br>
                <table class="table col-md-8">
                    <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Attempt</th>
                        <th scope="col">Answer</th>
                    </tr>
                    </thead>
                    <tbody id="attempts">
                    <c:forEach items="${game.attempts}" var="attempt" varStatus="status">
                        <tr>
                            <th scope="row">${status.index+1}</th>
                            <td>${attempt.number}</td>
                            <td id="answer${status.index}"></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
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
