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

public class DFSHandler implements Handler {
    public static class DfsStep {
        private String type;
        private int node;
        private List<Integer> stack;

        public DfsStep(String type, int node, Stack<Integer> stack) {
            this.type = type;
            this.node = node;
            this.stack = new ArrayList<>(stack);
        }

        public String getType() { return type; }
        public int getNode() { return node; }
        public List<Integer> getStack() { return stack; }
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
        request.getRequestDispatcher("WEB-INF/dfs.jsp").forward(request, response);
    }

    public void handlePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        ObjectMapper mapper = new ObjectMapper();

        BufferedReader reader = request.getReader();
        Graph graph = mapper.readValue(reader, Graph.class);

        List<DfsStep> steps = new ArrayList<>();
        Set<Integer> visited = new HashSet<>();
        Stack<Integer> stack = new Stack<>();

        if (graph.getVertices().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int start = graph.getVertices().get(0).getId();

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

        stack.push(start);

        while (!stack.isEmpty()) {
            int current = stack.pop();

            if (!visited.contains(current)) {
                steps.add(new DfsStep("active", current, stack));
                visited.add(current);

                List<Integer> neighbors = adj.get(current);
                for (int i = neighbors.size() - 1; i >= 0; i--) {
                    int neighbor = neighbors.get(i);
                    if (!visited.contains(neighbor)) {
                        stack.push(neighbor);
                    }
                }
                steps.add(new DfsStep("visited", current, stack));
            }
        }

        response.setContentType("application/json");
        mapper.writeValue(response.getWriter(), steps);
        response.setStatus(HttpServletResponse.SC_OK);
    }
}