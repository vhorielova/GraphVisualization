<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Дейкстра</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.14/ace.js"></script>
    <style>
        #graphCanvas {
            border: 1px solid #ccc;
        }
        #editor {
            border: 1px solid #ccc;
            height: 200px;
            width: 100%;
            padding: 10px;
            font-family: monospace;
            background-color: #fafafa;
            overflow-y: auto;
            white-space: pre-wrap;
            outline: none;
        }
        .placeholder {
            min-height: 200px;
            border: 1px solid #ccc;
            border-radius: 0.25rem;
            padding: 15px;
            background-color: #f8f9fa;
            color: #6c757d;
            display: flex;
            justify-content: center;
            align-items: center;
            font-style: italic;
        }
    </style>
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
                <a class="nav-link" href="${request.getContext()}/algorithms">Алгоритми <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/about-us">Про сайт</a>
            </li>
        </ul>
    </div>
</nav>
<div class="container mt-4" style="max-width: 1300px;">
    <div class="row g-4">
        <div class="col-lg-5">
            <div class="btn-group mb-3" role="group">
                <button id="btnDirected" class="btn btn-outline-success">Орієнтований</button>
                <button id="btnUndirected" class="btn btn-success">Неорієнтований</button>
            </div>
            <div class="btn-group mb-3" role="group">
                <button id="btnForces" class="btn btn-primary">Сили</button>
                <button id="btnStatic" class="btn btn-outline-primary">Статика</button>
            </div>
            <canvas id="graphCanvas" width="500" height="600" class="border"></canvas>
        </div>
        <div class="col-lg-4 d-flex flex-column">
            <label for="editor" class="form-label fw-bold">Граф:</label>
            <div id="editor" contenteditable="true" class="border p-2" style="height: 600px; background-color: #fafafa; overflow-y: auto;">
                1 0
            </div>
        </div>
        <div class="col-lg-3 d-flex flex-column">
            <label class="form-label fw-bold">Алгоритм Дейкстри</label>

            <!-- Animation controls -->
            <div class="mb-2">
                <button id="run" class="btn btn-primary btn-sm">Запустити візуалізацію</button>
                <button id="reset" class="btn btn-secondary btn-sm">Скинути</button>
            </div>

            <div class="border p-2" style="height: 100%">
                <p>На цій сторінці ви можете задати граф та побачити візуалізацію алгоритму Дейкстри на ньому.</p>
                <p>Початковою вершиною вважається та, яка першою задана в текстовому редакторі.</p>
                <p>Після натискання на кнопку "Запустити візуалізацію" ви можете спостерігати виконання алгоритму підсвічуванням вершин у графічному редакторі.</p>
                <ul>
                    <li>Якщо вершина зелена, то алгоритм наразі обробляє цю вершину, вона є активною.</li>
                    <li>Якщо вершина червона, то це знайдений сусід активної вершини, для неї перевіряється або оновлюється відстань, вона додається в чергу з пріоритетами.</li>
                    <li>Якщо вершина сіра, то вона вже відвідана.</li>
                </ul>
            </div>
        </div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    const canvas = document.getElementById("graphCanvas");
    const ctx = canvas.getContext("2d");

    let dijkstraSteps = [];
    let currentStep = 0;
    let dijkstraInterval = null;
    let animationSpeed = 1000; // milliseconds

    let animation = false;

    const WIDTH = canvas.width;
    const HEIGHT = canvas.height;
    const NODE_RADIUS = 20;

    let isDirected = false;

    document.getElementById("btnDirected").addEventListener("click", () => {
        isDirected = true;
        updateButtonStyles();
    });

    document.getElementById("btnUndirected").addEventListener("click", () => {
        isDirected = false;
        updateButtonStyles();
    });

    function updateButtonStyles() {
        document.getElementById("btnDirected").classList.toggle("btn-success", isDirected);
        document.getElementById("btnDirected").classList.toggle("btn-outline-success", !isDirected);
        document.getElementById("btnUndirected").classList.toggle("btn-success", !isDirected);
        document.getElementById("btnUndirected").classList.toggle("btn-outline-success", isDirected);
    }

    let forcesEnabled = true;

    document.getElementById("btnForces").addEventListener("click", () => {
        forcesEnabled = true;
        updateForceButtonStyles();
    });

    document.getElementById("btnStatic").addEventListener("click", () => {
        forcesEnabled = false;
        updateForceButtonStyles();
    });

    function updateForceButtonStyles() {
        document.getElementById("btnForces").classList.toggle("btn-primary", forcesEnabled);
        document.getElementById("btnForces").classList.toggle("btn-outline-primary", !forcesEnabled);
        document.getElementById("btnStatic").classList.toggle("btn-primary", !forcesEnabled);
        document.getElementById("btnStatic").classList.toggle("btn-outline-primary", forcesEnabled);
    }

    const graph = JSON.parse('<%= request.getAttribute("graphJson") %>');
    console.log(graph)
    let nodes = graph.vertices;
    let edges = graph.edges;
    let nodeMap = new Map();
    nodes.forEach((node, index) => {
        nodeMap.set(node.id, index);
    });

    // Initialize nodes with Dijkstra-specific properties
    nodes.forEach(n => {
        n.visited = false;
        n.active = false;
        n.checking = false;
        n.distance = Infinity;
        n.previousNode = null;
    });
    edges.forEach(n => n.waiting = false);

    console.log(nodes);
    console.log(edges);
    console.log(nodeMap);

    // відстань між вузлами
    const repulsion = 5000;
    const attractionAlpha = 0.1;
    const damping = 0.85;
    const k = 0.75 * Math.sqrt((WIDTH * HEIGHT) / nodes.length);

    // --- Перетягування мишкою ---
    let draggingNode = null;
    let offsetX = 0, offsetY = 0;

    canvas.addEventListener("mousedown", (e) => {
        const rect = canvas.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        for (const node of nodes) {
            const dx = x - node.x;
            const dy = y - node.y;
            if (dx * dx + dy * dy < NODE_RADIUS * NODE_RADIUS) {
                draggingNode = node;
                offsetX = dx;
                offsetY = dy;
                node.vx = 0;
                node.vy = 0;
                break;
            }
        }
    });

    canvas.addEventListener("mousemove", (e) => {
        if (draggingNode) {
            const rect = canvas.getBoundingClientRect();
            draggingNode.x = e.clientX - rect.left - offsetX;
            draggingNode.y = e.clientY - rect.top - offsetY;
        }
    });

    canvas.addEventListener("mouseup", () => draggingNode = null);
    canvas.addEventListener("mouseleave", () => draggingNode = null);

    // Головний алгоритм
    function applyForces() {
        for (const node of nodes) {
            node.fx = 0;
            node.fy = 0;
        }

        // Відштовхування
        for (let i = 0; i < nodes.length; i++) {
            for (let j = i + 1; j < nodes.length; j++) {
                const a = nodes[i];
                const b = nodes[j];
                let dx = b.x - a.x;
                let dy = b.y - a.y;
                let dist = Math.sqrt(dx * dx + dy * dy) + 0.01;

                let force = repulsion / (dist * dist);
                let fx = force * dx / dist;
                let fy = force * dy / dist;

                a.fx -= fx;
                a.fy -= fy;
                b.fx += fx;
                b.fy += fy;
            }
        }

        // Притягання
        for (const edge of edges) {
            const a = nodes[nodeMap.get(edge.from)];
            const b = nodes[nodeMap.get(edge.to)];
            let dx = b.x - a.x;
            let dy = b.y - a.y;
            let dist = Math.sqrt(dx * dx + dy * dy) + 0.01;

            let force = (dist - k) * attractionAlpha;
            let fx = force * dx / dist;
            let fy = force * dy / dist;

            a.fx += fx;
            a.fy += fy;
            b.fx -= fx;
            b.fy -= fy;
        }

        const centerX = WIDTH / 2;
        const centerY = HEIGHT / 2;
        const centeringStrength = 0.01; // сила тяжіння до центру

        for (const node of nodes) {
            let dx = centerX - node.x;
            let dy = centerY - node.y;

            node.fx += dx * centeringStrength;
            node.fy += dy * centeringStrength;
        }


        // Оновлення положення
        for (const node of nodes) {
            if (node === draggingNode) continue;

            node.vx = (node.vx + node.fx) * damping;
            node.vy = (node.vy + node.fy) * damping;
            node.x += node.vx;
            node.y += node.vy;

            // Обмеження в межах canvas
            node.x = Math.max(NODE_RADIUS, Math.min(WIDTH - NODE_RADIUS, node.x));
            node.y = Math.max(NODE_RADIUS, Math.min(HEIGHT - NODE_RADIUS, node.y));
        }
    }

    // --- Малювання ---
    function draw() {
        ctx.clearRect(0, 0, WIDTH, HEIGHT);

        // Ребра
        for (const edge of edges) {
            ctx.strokeStyle = edge.traversed ? "#00f" : "#aaa";
            ctx.lineWidth = edge.highlighted ? 3 : 1;
            const a = nodes[nodeMap.get(edge.from)];
            const b = nodes[nodeMap.get(edge.to)];
            ctx.beginPath();
            ctx.moveTo(a.x, a.y);
            ctx.lineTo(b.x, b.y);
            ctx.stroke();

            // Weight display - more prominent for Dijkstra
            if (edge.weight !== undefined && edge.weight !== -1) {
                const midX = (a.x + b.x) / 2;
                const midY = (a.y + b.y) / 2;

                // Background circle for weight
                ctx.beginPath();
                ctx.arc(midX, midY, 12, 0, Math.PI * 2);
                ctx.fillStyle = edge.highlighted ? "#ffeb3b" : "#ffffff";
                ctx.fill();
                ctx.strokeStyle = "#000";
                ctx.lineWidth = 1;
                ctx.stroke();

                ctx.fillStyle = "black";
                ctx.font = "12px Arial";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillText(edge.weight, midX, midY);
            }

            if (isDirected) {
                const dx = b.x - a.x;
                const dy = b.y - a.y;
                const angle = Math.atan2(dy, dx);
                const arrowLength = 10;
                const arrowAngle = Math.PI / 8;

                const arrowX = b.x - NODE_RADIUS * Math.cos(angle);
                const arrowY = b.y - NODE_RADIUS * Math.sin(angle);

                ctx.beginPath();
                ctx.moveTo(arrowX, arrowY);
                ctx.lineTo(arrowX - arrowLength * Math.cos(angle - arrowAngle),
                    arrowY - arrowLength * Math.sin(angle - arrowAngle));
                ctx.lineTo(arrowX - arrowLength * Math.cos(angle + arrowAngle),
                    arrowY - arrowLength * Math.sin(angle + arrowAngle));
                ctx.closePath();
                ctx.fillStyle = "#aaa";
                ctx.fill();
            }
        }

        // Вершини
        for (const node of nodes) {
            ctx.beginPath();
            ctx.arc(node.x, node.y, NODE_RADIUS, 0, Math.PI * 2);
            ctx.fillStyle = "#ffffff";
            ctx.fill();

            // Different colors for Dijkstra states
            if(node.active){
                ctx.strokeStyle = "#00ae09";
                ctx.lineWidth = 3;
            }
            else if(node.checking){
                ctx.strokeStyle = "#d60000";
                ctx.lineWidth = 3;
            }
            else if(node.visited){
                ctx.strokeStyle = "#9a9a9a";
                ctx.lineWidth = 2;
            }
            else{
                ctx.strokeStyle = "#000000";
                ctx.lineWidth = 1;
            }
            ctx.stroke();

            ctx.fillStyle = "#000000";
            ctx.font = "14px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(node.id, node.x, node.y);

            const distanceText = node.distance === Infinity ? "∞" : node.distance.toString();
            const distanceY = node.y - NODE_RADIUS - 15;

            ctx.font = "12px Arial";
            const textMetrics = ctx.measureText(distanceText);
            const rectWidth = textMetrics.width + 8;
            const rectHeight = 16;
            const rectX = node.x - rectWidth / 2;
            const rectY = distanceY - rectHeight / 2;

            let bgColor = "#ffffff";
            if (node.active) {
                bgColor = "#e8f5e8"; // Light green
            } else if (node.checking) {
                bgColor = "#fff9c4"; // Light yellow
            } else if (node.visited) {
                bgColor = "#f0f0f0"; // Light gray
            }

            ctx.fillStyle = bgColor;
            ctx.fillRect(rectX, rectY, rectWidth, rectHeight);

            ctx.strokeStyle = "#333";
            ctx.lineWidth = 1;
            ctx.strokeRect(rectX, rectY, rectWidth, rectHeight);

            ctx.fillStyle = node.distance === Infinity ? "#999" : "#000";
            ctx.font = "bold 12px Arial";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(distanceText, node.x, distanceY);
        }
    }

    const editor = ace.edit("editor");
    editor.setTheme("ace/theme/dawn");
    editor.session.setMode("ace/mode/plain_text");

    // створюємо текст із вершин і ребер
    const vertexLines = nodes.map(n => n.id.toString());
    const edgeLines = edges.map(e => e.from.toString()+" "+e.to.toString()+" "+(e.weight || 1));
    const initialGraphText = [...vertexLines, ...edgeLines].join('\n');

    console.log(initialGraphText);

    editor.setValue(initialGraphText, -1);

    editor.session.on('change', function () {
        const lines = editor.getValue().split('\n');
        const nodeSet = new Set();
        const newEdges = [];

        for (const line of lines) {
            const parts = line.trim().split(/\s+/);
            if(parts[0]<"1" || parts[0]>"9"){
                continue;
            }
            if (parts.length === 1 && parts[0] !== "") {
                const nodeId = parseInt(parts[0]);
                if (!isNaN(nodeId)) nodeSet.add(nodeId);
            } else if (parts.length === 2 || parts.length === 3) {
                if(parts[1]<"1" || parts[1]>"9"){
                    continue;
                }
                if(parts.length === 3 && ((parts[2]<"0" || parts[2]>"9") && !(parts[2][0] === "-" && (parts[2][1]>"0" || parts[2][1]<"9")))){
                    continue;
                }
                let from = parseInt(parts[0]);
                let to = parseInt(parts[1]);
                let weight = parseInt(parts[2]);
                if(isNaN(weight)){
                    weight = 1; // Default weight for Dijkstra
                }
                if (!isNaN(from) && !isNaN(to)) {
                    nodeSet.add(from);
                    nodeSet.add(to);
                    newEdges.push({ from, to, weight });
                }
            }
        }

        console.log(nodeSet);
        console.log(newEdges);

        const oldNodeMap = new Map();
        for (const node of nodes) {
            oldNodeMap.set(node.id, {
                x: node.x,
                y: node.y,
                vx: node.vx,
                vy: node.vy
            });
        }

        // Створюємо нові вершини, використовуючи збережені координати, якщо є
        nodes = [];
        for (const id of nodeSet) {
            const old = oldNodeMap.get(id);
            nodes.push({
                id,
                x: old?.x ?? Math.random() * WIDTH,
                y: old?.y ?? Math.random() * HEIGHT,
                vx: old?.vx ?? 0,
                vy: old?.vy ?? 0,
                visited: false,
                active: false,
                checking: false,
                distance: Infinity,
                previousNode: null
            });
        }

        edges = [...newEdges];

        nodeMap = new Map();
        nodes.forEach((node, index) => {
            nodeMap.set(node.id, index);
        });
    });

    let isAnimating = false;
    let stepIndex = 0;

    // Main run button
    document.getElementById("run").addEventListener("click", async () => {
        const graphData = {
            vertices: nodes.map(n => ({ id: n.id, x: n.x, y: n.y })),
            edges: edges.map(e => ({ from: e.from, to: e.to, weight: e.weight })),
            oriented: isDirected
        };

        if (nodes.length === 0) {
            alert("Граф порожній!");
            return;
        }

        // Reset all node states before starting
        resetNodeStates();

        try {
            const response = await fetch("/dijkstra", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(graphData)
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            dijkstraSteps = await response.json();
            console.log("Dijkstra steps received:", dijkstraSteps);

            // Start the animation
            stepIndex = 0;
            isAnimating = true;
            document.getElementById("run").disabled = true;
            document.getElementById("reset").disabled = false;

            animateDijkstraSteps();
        } catch (error) {
            console.error("Error running Dijkstra:", error);
            alert("Помилка при виконанні алгоритму Дейкстри");
        }
    });

    // Reset button
    document.getElementById("reset").addEventListener("click", () => {
        resetAnimation();
    });

    function resetNodeStates() {
        nodes.forEach(n => {
            n.visited = false;
            n.active = false;
            n.checking = false;
            n.distance = Infinity;
            n.previousNode = null;
        });
        edges.forEach(e => {
            e.highlighted = false;
            e.traversed = false;
        });
    }

    function resetAnimation() {
        isAnimating = false;
        stepIndex = 0;
        dijkstraSteps = [];

        if (dijkstraInterval) {
            clearTimeout(dijkstraInterval);
            dijkstraInterval = null;
        }

        resetNodeStates();

        document.getElementById("run").disabled = false;
        document.getElementById("reset").disabled = true;
    }

    function animateDijkstraSteps() {
        if (!isAnimating) return;

        if (stepIndex >= dijkstraSteps.length) {
            isAnimating = false;
            document.getElementById("run").disabled = false;

            // Reset after 3 seconds
            setTimeout(() => {
                resetNodeStates();
            }, 3000);
            return;
        }

        const step = dijkstraSteps[stepIndex];
        console.log("Processing step:", step);

        processStep(step);
        stepIndex++;

        dijkstraInterval = setTimeout(() => {
            animateDijkstraSteps();
        }, animationSpeed);
    }

    function processStep(step) {
        // Reset previous states
        nodes.forEach(node => {
            node.active = false;
            node.checking = false;
        });
        edges.forEach(edge => {
            edge.highlighted = false;
        });

        // Update distances from step
        if (step.distances) {
            Object.keys(step.distances).forEach(nodeId => {
                const node = nodes.find(n => n.id == nodeId);
                if (node) {
                    node.distance = step.distances[nodeId];
                }
            });
        }

        const targetNode = nodes.find(n => n.id === step.node);

        switch (step.type) {
            case "start":
                if (targetNode) {
                    targetNode.distance = 0;
                    targetNode.active = true;
                }
                break;

            case "select":
                if (targetNode) {
                    targetNode.active = true;
                }
                break;

            case "check":
                if (targetNode) {
                    targetNode.checking = true;
                }
                // Highlight the edge being checked
                const checkEdge = edges.find(e =>
                    (e.from === step.previousNode && e.to === step.node) ||
                    (!isDirected && e.from === step.node && e.to === step.previousNode)
                );
                if (checkEdge) {
                    checkEdge.highlighted = true;
                }
                break;

            case "update":
                if (targetNode) {
                    targetNode.checking = true;
                    targetNode.distance = step.distance;
                }
                break;

            case "visited":
                if (targetNode) {
                    targetNode.visited = true;
                    targetNode.active = false;
                    targetNode.checking = false;
                }
                break;
        }
    }

    function animate() {
        if (forcesEnabled) {
            applyForces();
        }
        draw();
        requestAnimationFrame(animate);
    }

    // Initialize
    animate();
</script>
</body>
</html>