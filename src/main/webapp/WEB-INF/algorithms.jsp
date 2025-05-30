<%--
  Created by IntelliJ IDEA.
  User: vhorielova
  Date: 21.05.2025
  Time: 00:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Algorithms</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">Візуалізація графів</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="/">Головна</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="/algorithms">Алгоритми <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/about-us">Про сайт</a>
            </li>
        </ul>
    </div>
</nav>
<div class="container mt-4">
    <h2>Алгоритми</h2>
    <ul class="list-group">
        <li class="list-group-item"><a href="/dfs">Пошук в глибину</a></li>
        <li class="list-group-item"><a href="/bfs">Пошук в ширину</a></li>
        <li class="list-group-item"><a href="/dijkstra">Алгоритм Дейкстри</a></li>
        <li class="list-group-item"><a href="/floyd">Алгоритм Флойда-Уоршелла</a></li>
    </ul>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
