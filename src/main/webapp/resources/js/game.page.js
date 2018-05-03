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