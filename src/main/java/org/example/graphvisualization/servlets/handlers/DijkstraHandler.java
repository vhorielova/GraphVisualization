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

public class DijkstraHandler implements Handler {

    public static class DijkstraStep {
        private String type;
        private int node;
        private int distance;
        private Map<Integer, Integer> distances;
        private List<Integer> unvisited;
        private Integer previousNode;

        public DijkstraStep(String type, int node, int distance, Map<Integer, Integer> distances,
                            Set<Integer> unvisited, Integer previousNode) {
            this.type = type;
            this.node = node;
            this.distance = distance;
            this.distances = new HashMap<>(distances);
            this.unvisited = new ArrayList<>(unvisited);
            this.previousNode = previousNode;
        }

        public String getType() { return type; }
        public int getNode() { return node; }
        public int getDistance() { return distance; }
        public Map<Integer, Integer> getDistances() { return distances; }
        public List<Integer> getUnvisited() { return unvisited; }
        public Integer getPreviousNode() { return previousNode; }
    }

    public void handleGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<Vertex> vertices = List.of(
                new Vertex(1, 100, 100),
                new Vertex(2, 300, 100),
                new Vertex(3, 200, 300),
                new Vertex(4, 250, 200),
                new Vertex(5, 150, 200),
                new Vertex(6, 350, 250)
        );

        List<Edge> edges = List.of(
                new Edge(1, 2, 4),
                new Edge(1, 3, 2),
                new Edge(2, 3, 1),
                new Edge(2, 4, 5),
                new Edge(3, 4, 8),
                new Edge(3, 5, 10),
                new Edge(4, 5, 2),
                new Edge(4, 6, 6),
                new Edge(5, 6, 3)
        );

        Graph g = new Graph();
        g.setVertices(vertices);
        g.setEdges(edges);
        g.setOriented(false);
        String graphJson = new Gson().toJson(g);
        request.setAttribute("graphJson", graphJson);
        request.getRequestDispatcher("WEB-INF/dijkstra.jsp").forward(request, response);
    }

    public void handlePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        ObjectMapper mapper = new ObjectMapper();

        BufferedReader reader = request.getReader();
        Graph graph = mapper.readValue(reader, Graph.class);

        List<DijkstraStep> steps = new ArrayList<>();

        if (graph.getVertices().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int start = graph.getVertices().get(0).getId();

        Map<Integer, List<Edge>> adj = new HashMap<>();
        for (Vertex v : graph.getVertices()) {
            adj.put(v.getId(), new ArrayList<>());
        }

        for (Edge e : graph.getEdges()) {
            adj.get(e.getFrom()).add(new Edge(e.getFrom(), e.getTo(), e.getWeight()));
            if (!graph.isOriented()) {
                adj.get(e.getTo()).add(new Edge(e.getTo(), e.getFrom(), e.getWeight()));
            }
        }

        Map<Integer, Integer> distances = new HashMap<>();
        Set<Integer> unvisited = new HashSet<>();
        Map<Integer, Integer> previous = new HashMap<>();

        for (Vertex v : graph.getVertices()) {
            distances.put(v.getId(), Integer.MAX_VALUE);
            unvisited.add(v.getId());
        }

        distances.put(start, 0);
        steps.add(new DijkstraStep("start", start, 0, distances, unvisited, null));

        while (!unvisited.isEmpty()) {
            int current = -1;
            int minDistance = Integer.MAX_VALUE;

            for (int nodeId : unvisited) {
                if (distances.get(nodeId) < minDistance) {
                    minDistance = distances.get(nodeId);
                    current = nodeId;
                }
            }

            if (current == -1 || minDistance == Integer.MAX_VALUE) {
                break;
            }

            steps.add(new DijkstraStep("select", current, distances.get(current), distances, unvisited, null));

            for (Edge edge : adj.get(current)) {
                int neighbor = edge.getTo();
                int weight = edge.getWeight();

                if (unvisited.contains(neighbor)) {
                    int newDistance = distances.get(current) + weight;

                    steps.add(new DijkstraStep("check", neighbor, newDistance, distances, unvisited, current));

                    if (newDistance < distances.get(neighbor)) {
                        distances.put(neighbor, newDistance);
                        previous.put(neighbor, current);
                        steps.add(new DijkstraStep("update", neighbor, newDistance, distances, unvisited, current));
                    }
                }
            }

            unvisited.remove(current);
            steps.add(new DijkstraStep("visited", current, distances.get(current), distances, unvisited, null));
        }

        response.setContentType("application/json");
        mapper.writeValue(response.getWriter(), steps);
        response.setStatus(HttpServletResponse.SC_OK);
    }
}