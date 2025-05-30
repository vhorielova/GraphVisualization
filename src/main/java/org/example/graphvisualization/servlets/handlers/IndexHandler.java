package org.example.graphvisualization.servlets.handlers;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.graphvisualization.servlets.models.Edge;
import org.example.graphvisualization.servlets.models.Graph;
import org.example.graphvisualization.servlets.models.Vertex;

import java.io.IOException;
import java.util.List;

public class IndexHandler implements Handler {
    public void handleGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        List<Vertex> vertices = List.of(
                new Vertex(1, 100, 100),
                new Vertex(2, 300, 100),
                new Vertex(3, 200, 300),
                new Vertex(4, 250, 200),
                new Vertex(5, 150, 200)
        );

        List<Edge> edges = List.of(
                new Edge(1, 2),
                new Edge(1, 3),
                new Edge(1, 4),
                new Edge(1, 5),
                new Edge(2, 3),
                new Edge(2, 4),
                new Edge(2, 5),
                new Edge(3, 4),
                new Edge(3, 5),
                new Edge(4, 5)
        );
        Graph g = new Graph();
        g.setVertices(vertices);
        g.setEdges(edges);
        g.setOriented(false);
        String graphJson = new Gson().toJson(g);
        request.setAttribute("graphJson", graphJson);

        request.getRequestDispatcher("WEB-INF/index.jsp").forward(request, response);
    }

    public void handlePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        handleGet(request, response);
    }
}
