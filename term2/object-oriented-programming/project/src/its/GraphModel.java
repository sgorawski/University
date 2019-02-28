package its;

import javafx.util.Pair;

import java.io.IOException;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public class GraphModel {
    // PROPERTIES
    protected HashMap<String, Vertex> adjacencyDict;
    public int numberOfVertices;
    public int numberOfEdges;

    // CONSTRUCTORS
    public GraphModel() {
        this.adjacencyDict = new HashMap<>();
        this.numberOfVertices = 0;
        this.numberOfEdges = 0;
    }

    // DATA LOADING AND SAVING
    public void readDataFromFiles(String verticesPath, String edgesPath) throws IOException {
        List<Vertex> vertices = DataParser.readVerticesFromFile(verticesPath);
        for (Vertex v: vertices
             ) {
            addVertex(v);
        }
        List<EdgeData> edges = DataParser.readEdgesFromFile(edgesPath);
        for (EdgeData edge: edges
             ) {
            addEdge(edge.getStartName(), edge.getFinishName(), edge.getCost());
        }
    }

    public void saveDataToFiles(String verticesPath, String edgesPath) throws IOException {
        DataParser.saveVerticesToFile(eachVertex(), verticesPath);
        DataParser.saveEdgesToFile(eachEdge(), edgesPath);
    }

    // VERTICES MANIPULATION METHODS
    public boolean addVertex(Vertex newVertex) {
        if (this.containsVertex(newVertex)) {
            return false;
        }
        adjacencyDict.put(newVertex.getName(), newVertex);
        numberOfVertices++;
        return true;
    }

    public boolean containsVertex(Vertex vertexToCheck) { return adjacencyDict.containsValue(vertexToCheck); }

    public boolean containsVertex(String vertexToCheckName) { return adjacencyDict.containsKey(vertexToCheckName); }

    public void removeVertex(Vertex vertexToRemove) {
        if (containsVertex(vertexToRemove)) {
            adjacencyDict.remove(vertexToRemove.getName());
            numberOfVertices--;
        }
    }

    public void removeVertex(String vertexToRemoveName) {
        if (containsVertex(vertexToRemoveName)) {
            adjacencyDict.remove(vertexToRemoveName);
            numberOfVertices--;
        }
    }

    // EDGES MANIPULATION METHODS
    public boolean addEdge(Edge newEdge) {
         if (newEdge.getStartVertex().addEdge(newEdge)) {
             numberOfEdges++;
             return true;
         }
         return false;
    }

    public boolean addEdge(String startName, String finishName, Double cost) {
        Vertex start = adjacencyDict.get(startName);
        Vertex finish = adjacencyDict.get(finishName);
        return addEdge(new Edge(start, finish, cost));
    }

    public boolean containsEdge(Edge edgeToCheck) {
        return edgeToCheck.getStartVertex().containsEdge(edgeToCheck.getFinishVertex());
    }

    public boolean containsEdge(String startName, String finishName) {
        return adjacencyDict.get(startName).containsEdge(adjacencyDict.get(finishName));
    }

    public HashMap<String, Vertex> getAdjacencyDict() { return adjacencyDict; }

    // ITERATORS
    public Collection<Vertex> eachVertex() {
        return adjacencyDict.values();
    }

    public Iterable<Edge> eachEdge() {
        return () -> new Iterator<Edge>() {
            private int currentVertexIndex = -1;
            private Object[] keys = adjacencyDict.keySet().toArray();
            private Edge[] currentArrayOfEdges = {};
            private int currentEdgeIndex = -1;
            private int checkedEdges = 0;

            @Override
            public boolean hasNext() {
                return checkedEdges < numberOfEdges;
            }

            @Override
            public Edge next() {
                currentEdgeIndex++;
                if (currentEdgeIndex >= currentArrayOfEdges.length) {
                    currentVertexIndex++;
                    currentEdgeIndex = -1;
                    currentArrayOfEdges = adjacencyDict.get(keys[currentVertexIndex]).getArrayOfEdges();
                    return next();
                }
                checkedEdges++;
                return currentArrayOfEdges[currentEdgeIndex];
            }
        };
    }
}
