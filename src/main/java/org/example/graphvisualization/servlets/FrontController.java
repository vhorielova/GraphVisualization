package org.example.graphvisualization.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.graphvisualization.servlets.handlers.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class FrontController extends HttpServlet {
    Map<String, Handler> routes = new HashMap<>();

    public void init() {
        routes.put("/", new IndexHandler());
        routes.put("/algorithms", new AlgorithmsHandler());
        routes.put("/about-us", new AboutHandler());
        routes.put("/dfs", new DFSHandler());
        routes.put("/bfs", new BFSHandler());
        routes.put("/dijkstra", new DijkstraHandler());
        routes.put("/floyd", new FloydHandler());
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String URI = String.valueOf(request.getServletPath());

        Handler handler = routes.get(URI);
        if(handler != null) {
            handler.handlePost(request, response);
        }
        else {
            throw new ServletException("No handler found for " + URI);
        }

    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String URI = String.valueOf(request.getServletPath());
        Handler handler = routes.get(URI);

        if(handler != null) {
            handler.handleGet(request, response);
        }
        else {
            throw new ServletException("No handler found for " + URI);
        }
    }

    public void destroy() {
    }
}
