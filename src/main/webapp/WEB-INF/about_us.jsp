<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Про сайт</title>
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
            <li class="nav-item">
                <a class="nav-link" href="/algorithms">Алгоритми</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="/about-us">Про сайт <span class="sr-only">(current)</span></a>
            </li>
        </ul>
    </div>
</nav>

<div class="container mt-4">
    <h1 class="mb-4">Про сайт</h1>
    <p>
        <strong>Graph Visualizer</strong> — це навчальний вебзастосунок, призначений для візуалізації графів та демонстрації основних алгоритмів на них.
        Сайт створено з метою допомогти студентам, викладачам і всім охочим краще зрозуміти структуру графів та принципи роботи таких алгоритмів,
        як пошук у ширину (BFS), пошук у глибину (DFS), алгоритм Дейкстри та інші.
    </p>
    <h2 class="mt-4">Основні можливості:</h2>
    <ul>
        <li>Візуалізація різних типів графів (орієнтовані та неорієнтовані).</li>
        <li>Демонстрація алгоритмів та їх роботи на графах.</li>
        <li>Інтерактивний інтерфейс для введення даних графа.</li>
    </ul>
    <h2 class="mt-4">Як почати:</h2>
    <p>
        На вкладці "Головна" ви можете створювати та редагувати граф використовуючи реалізовані можливості, там також є детальні інструкції зі взаємодії з інтерфейсом. На вкладці "Алгоритми" ви можете обрати алгоритм, візуалізацію якого хотіли б побачити.
        Ви також можете ввести свої дані графа у відповідному полі та спостерігати за візуалізацією.
    </p>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>