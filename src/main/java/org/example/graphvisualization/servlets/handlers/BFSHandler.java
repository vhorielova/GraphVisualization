package org.example.graphvisualization.servlets.handlers;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.graphvisualization.servlets.models.Edge;
import org.example.graphvisualization.servlets.models.Graph;
import org.example.graphvisualization.servlets.models.Vertex;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;

public class BFSHandler implements Handler {
    public static class BfsStep {
        private String type;
        private int node;
        private List<Integer> queue;

        public BfsStep(String type, int node, Queue<Integer> queue) {
            this.type = type;
            this.node = node;
            this.queue = new ArrayList<>(queue);
        }

        // Геттери і сеттери
        public String getType() { return type; }
        public int getNode() { return node; }
        public List<Integer> getQueue() { return queue; }
    }

    public void handleGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<Vertex> vertices = List.of(
                new Vertex(1, 100, 100),
                new Vertex(2, 300, 100),
                new Vertex(3, 200, 300),
                new Vertex(4, 250, 200),
                new Vertex(5, 150, 200),
                new Vertex(6, 150, 200)
        );

        List<Edge> edges = List.of(
                new Edge(1, 4),
                new Edge(1, 5),
                new Edge(2, 5),
                new Edge(3, 6),
                new Edge(2, 3),
                new Edge(3, 5),
                new Edge(2, 4)
        );
        Graph g = new Graph();
        g.setVertices(vertices);
        g.setEdges(edges);
        g.setOriented(false);
        String graphJson = new Gson().toJson(g);
        request.setAttribute("graphJson", graphJson);
        request.getRequestDispatcher("WEB-INF/bfs.jsp").forward(request, response);
    }

    public void handlePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        ObjectMapper mapper = new ObjectMapper();

        // Зчитування Graph із тіла запиту
        BufferedReader reader = request.getReader();
        Graph graph = mapper.readValue(reader, Graph.class);

        // BFS
        List<BfsStep> steps = new ArrayList<>();
        Set<Integer> visited = new HashSet<>();
        Queue<Integer> queue = new LinkedList<>();

        if (graph.getVertices().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int start = graph.getVertices().get(0).getId(); // Починаємо з першої вершини
        queue.add(start);
        visited.add(start);

        Map<Integer, List<Integer>> adj = new HashMap<>();
        for (Vertex v : graph.getVertices()) {
            adj.put(v.getId(), new ArrayList<>());
        }
        for (Edge e : graph.getEdges()) {
            adj.get(e.getFrom()).add(e.getTo());
            if (!graph.isOriented()) {
                adj.get(e.getTo()).add(e.getFrom());
            }
        }
        while (!queue.isEmpty()) {
            int current = queue.poll();
            steps.add((new BfsStep("active", current, queue)));
            for (int neighbor : adj.get(current)) {
                if (!visited.contains(neighbor)) {
                    visited.add(neighbor);
                    queue.add(neighbor);
                    steps.add((new BfsStep("next", neighbor, queue)));
                    steps.add(new BfsStep("in_queue", neighbor, queue));
                }
            }
            steps.add((new BfsStep("visited", current, queue)));
        }

        response.setContentType("application/json");
        mapper.writeValue(response.getWriter(), steps);
        response.setStatus(HttpServletResponse.SC_OK);
    }
}
