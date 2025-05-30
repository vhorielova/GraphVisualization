package org.example.graphvisualization.servlets.models;

import java.util.List;

public class Graph {
    private List<Vertex> vertices;
    private List<Edge> edges;
    private boolean isOriented;

    public Graph() {
    }

    public List<Vertex> getVertices() {
        return vertices;
    }

    public void setVertices(List<Vertex> vertices) {
        this.vertices = vertices;
    }

    public List<Edge> getEdges() {
        return edges;
    }

    public void setEdges(List<Edge> edges) {
        this.edges = edges;
    }

    public boolean isOriented() {
        return isOriented;
    }

    public void setOriented(boolean oriented) {
        isOriented = oriented;
    }
}
