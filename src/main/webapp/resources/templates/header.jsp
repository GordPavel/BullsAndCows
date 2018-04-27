<div class="container header">
    <div class="btn-group btn-group-justified">
        <div class="btn-group">
            <button type="button" class="btn btn-default">User page</button>
        </div>
        <div class="btn-group">
            <button type="button" class="btn btn-default">Game</button>
        </div>
        <div class="btn-group">
            <button type="button" class="btn btn-default">Players rating</button>
        </div>
        <sec:authorize access="isAuthenticated()">
            <div class="btn-group">
                <button type="button" class="btn btn-default">Log out</button>
            </div>
        </sec:authorize>
    </div>
</div>