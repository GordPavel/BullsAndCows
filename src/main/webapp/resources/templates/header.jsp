<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script>
    function submit() {
        $('#logout').submit();
    }
</script>
<div class="container header">
    <div class="btn-group btn-group-justified">
        <sec:authorize access="isAuthenticated()">
            <sec:authentication var="principal" property="principal"/>
            <div class="btn-group">
                <a type="button" href="<c:url value="/person/${principal.username}"/>" class="btn btn-default">
                    User page
                </a>
            </div>
        </sec:authorize>
        <sec:authorize access="isAuthenticated()">
            <div class="btn-group">
                <a type="button" href="<c:url value="/game"/>" class="btn btn-default">Game</a>
            </div>
        </sec:authorize>
        <div class="btn-group">
            <button type="button" class="btn btn-default">Players rating</button>
        </div>
        <sec:authorize access="isAuthenticated()">
            <form class="btn-group" method="post" action="<c:url value="/logout"/>" id="logout">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="button" onclick="submit()" class="btn btn-default">Log out
                </button>
            </form>
        </sec:authorize>
    </div>
</div>