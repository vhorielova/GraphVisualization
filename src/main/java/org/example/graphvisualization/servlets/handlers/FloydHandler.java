package org.example.graphvisualization.servlets.handlers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class FloydHandler implements Handler {
    public void handleGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.getRequestDispatcher("WEB-INF/floyd.jsp").forward(request, response);
    }

    public void handlePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        handleGet(request, response);
    }
}
