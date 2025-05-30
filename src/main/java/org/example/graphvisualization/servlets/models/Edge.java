package org.example.graphvisualization.servlets.models;

public class Edge {
    private int from;
    private int to;
    private int weight = -1;

    public Edge() {
    }

    public Edge(int from, int to) {
        this.from = from;
        this.to = to;
    }

    public Edge(int from, int to, int weight) {
        this.from = from;
        this.to = to;
        this.weight = weight;
    }

    public int getFrom() {
        return from;
    }

    public void setFrom(int from) {
        this.from = from;
    }

    public int getTo() {
        return to;
    }

    public void setTo(int to) {
        this.to = to;
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }
}
